import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:majestic_rooms/core/routes/app_routes.dart';
import 'package:majestic_rooms/core/supabase/supabase_utils.dart';
import 'package:majestic_rooms/core/data/models/booking.dart';
import 'package:majestic_rooms/core/data/models/hotel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// App-wide state shared across every module.
///
/// Scope is deliberately minimal — only the authenticated user and the auth
/// state subscription live here. Anything module- or screen-specific belongs in
/// its own controller, never here. Keep this lean to avoid a God object.
class CommonController extends GetxController {
  final _supabase = SupabaseUtils();

  /// The currently authenticated user, or null when signed out.
  final Rxn<User> currentUser = Rxn<User>();

  StreamSubscription<AuthState>? _authSubscription;

  bool get isLoggedIn => currentUser.value != null;

  // ── Control Panel ──────────────────────────────────────────────────────────
  /// Supabase JWT-expired error code (PostgREST 303).
  static const String _jwtExpiredCode = 'PGRST303';

  @override
  void onInit() {
    super.onInit();
    currentUser.value = _supabase.currentUser;
    _initData();

    _authSubscription = _supabase.onAuthStateChange.listen((authState) {
      currentUser.value = authState.session?.user;
      
      // Auto-logout: if the session expires in the background or the user
      // is deleted/signed out remotely, force them back to the login screen.
      if (authState.event == AuthChangeEvent.signedOut ||
          authState.event == AuthChangeEvent.userDeleted) {
        savedHotels.clear();
        bookings.clear();
        Get.offAllNamed(AppRoutes.login);
      } else if (authState.event == AuthChangeEvent.signedIn) {
        _initData();
      }
    });
    _supabase.printUserStates();
  }

  Future<void> _initData() async {
    await _loadSavedHotels();
    if (isLoggedIn) {
      await fetchBookings();
    }
  }

  Future<void> _loadSavedHotels() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedSlugs = prefs.getStringList('saved_hotels') ?? [];
      
      if (savedSlugs.isEmpty) {
        savedHotels.clear();
        return;
      }
      
      final response = await Supabase.instance.client
          .from('hotel')
          .select('*, hotel_images(*), hotel_rooms(*, room_images(*)), hotel_facility(facility(*)), promotion(*)')
          .inFilter('slug', savedSlugs);
          
      final List<dynamic> data = response;
      final fetchedHotels = data.map((json) => Hotel.fromJson(json as Map<String, dynamic>)).toList();
      
      // Preserve the order of savedSlugs if possible, or just assign them
      savedHotels.assignAll(fetchedHotels);
    } catch (e) {
      debugPrint('❌ [CommonController] Failed to load saved hotels: $e');
      if (_isJwtExpired(e)) showSessionExpiredDialog();
    }
  }

  Future<void> _saveSavedHotels() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final slugs = savedHotels.map((h) => h.slug ?? h.id).toList();
      await prefs.setStringList('saved_hotels', slugs);
    } catch (e) {
      debugPrint('❌ [CommonController] Failed to save hotels: $e');
    }
  }

  // ── App States ─────────────────────────────────────────────────────────────

  /// Active currency symbol. Read by [formatPrice] throughout the app.
  /// Change this from Settings whenever that screen is built.
  final RxString currencySymbol = r'$'.obs;

  final RxList<Hotel> savedHotels = <Hotel>[].obs;

  void toggleHotelSave(Hotel hotel) {
    if (savedHotels.contains(hotel)) {
      savedHotels.remove(hotel);
    } else {
      savedHotels.add(hotel);
    }
    _saveSavedHotels();
  }

  final RxList<BookingModel> bookings = <BookingModel>[].obs;

  void addBooking(BookingModel booking) {
    bookings.add(booking);
    // Local state add is immediate; the server is authoritative on refresh
  }

  Future<void> fetchBookings() async {
    final user = currentUser.value;
    if (user == null) return;

    try {
      debugPrint('Fetching bookings from Supabase for account: ${user.id}');
      final response = await Supabase.instance.client
          .from('booking')
          .select('*, booking_detail(*), hotel(*, hotel_images(*))')
          .eq('account_id', user.id)
          .order('booking_date', ascending: false);

      final List<dynamic> data = response;
      final fetchedBookings = data.map((json) => BookingModel.fromJson(json as Map<String, dynamic>)).toList();
      
      bookings.assignAll(fetchedBookings);
    } catch (e) {
      debugPrint('❌ [CommonController] Failed to fetch bookings: $e');
      if (_isJwtExpired(e)) showSessionExpiredDialog();
    }
  }

  // ── Actions ────────────────────────────────────────────────────────────────

  Future<void> logOutUser() async {
    debugPrint('🚪 [Auth] Signing out user: ${currentUser.value?.email}');
    try {
      await _supabase.signOut();
      debugPrint('✅ [Auth] Sign-out successful');
    } catch (e) {
      debugPrint('❌ [Auth] Sign-out failed: $e');
    }
  }

  // ── Session ────────────────────────────────────────────────────────────────

  /// Returns true if [error] is a Supabase JWT-expired (PGRST303) error.
  bool _isJwtExpired(Object error) {
    if (error is PostgrestException) {
      return error.code == _jwtExpiredCode ||
          (error.message.toLowerCase().contains('jwt expired'));
    }
    return error.toString().toLowerCase().contains('jwt expired');
  }

  /// Shows a Material Expressive session-expired dialog. Safe to call from any
  /// isolate-adjacent context because it uses [Get.dialog] (no BuildContext).
  ///
  /// Dismissed only via the "Sign In Again" CTA, which signs the user out and
  /// navigates to the login screen.
  void showSessionExpiredDialog() {
    // Avoid stacking multiple dialogs if already shown.
    if (Get.isDialogOpen ?? false) return;

    Get.dialog(
      barrierDismissible: false,
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 32),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ICON
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0F0),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  Icons.lock_clock_outlined,
                  size: 36,
                  color: Color(0xFF7A2021),
                ),
              ),
              const SizedBox(height: 20),

              // TITLE
              const Text(
                'Session Expired',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Fustat',
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 8),

              // BODY
              const Text(
                'Your login session has expired. Please sign in again to continue.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  fontFamily: 'Fustat',
                  color: Color(0xFF666666),
                ),
              ),
              const SizedBox(height: 28),

              // CTA
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () async {
                    Get.back(); // close dialog
                    await logOutUser();
                    savedHotels.clear();
                    bookings.clear();
                    Get.offAllNamed(AppRoutes.login);
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF7A2021),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Fustat',
                    ),
                  ),
                  child: const Text('Sign In Again'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void onClose() {
    _authSubscription?.cancel();
    super.onClose();
  }
}
