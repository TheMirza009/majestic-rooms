import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:majestic_rooms/core/routes/app_routes.dart';
import 'package:majestic_rooms/core/supabase/supabase_utils.dart';
import 'package:majestic_rooms/core/data/models/booking.dart';
import 'package:majestic_rooms/core/data/models/hotel.dart';
import 'package:majestic_rooms/core/data/dummy_hotels.dart';
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
      
      savedHotels.clear();
      for (final slug in savedSlugs) {
        final hotel = kDummyHotels.firstWhere(
          (h) => h.slug == slug || h.id == slug,
          orElse: () => Hotel(id: slug, slug: slug, name: 'Unknown Hotel', city: 'Unknown', images: [], rooms: []),
        );
        // Only add if it's a real dummy hotel to avoid corrupt data
        if (hotel.name != 'Unknown Hotel') {
          savedHotels.add(hotel);
        }
      }
    } catch (e) {
      debugPrint('❌ [CommonController] Failed to load saved hotels: $e');
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

  @override
  void onClose() {
    _authSubscription?.cancel();
    super.onClose();
  }
}
