import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:majestic_rooms/core/routes/app_routes.dart';
import 'package:majestic_rooms/core/supabase/supabase_utils.dart';
import 'package:majestic_rooms/core/data/models/hotel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
    _authSubscription = _supabase.onAuthStateChange.listen(
      (authState) => currentUser.value = authState.session?.user,
    );
    _supabase.printUserStates();
  }

  // ── App States ─────────────────────────────────────────────────────────────

  final RxList<Hotel> savedHotels = <Hotel>[].obs;

  void toggleHotelSave(Hotel hotel) {
    if (savedHotels.contains(hotel)) {
      savedHotels.remove(hotel);
    } else {
      savedHotels.add(hotel);
    }
  }

  // ── Actions ────────────────────────────────────────────────────────────────

  Future<void> logOutUser() async {
    debugPrint('🚪 [Auth] Signing out user: ${currentUser.value?.email}');
    try {
      await _supabase.signOut();
      debugPrint('✅ [Auth] Sign-out successful');
      Get.offAllNamed(AppRoutes.login);
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
