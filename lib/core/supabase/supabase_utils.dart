import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseUtils {
  static final _client = Supabase.instance.client;

  User? get currentUser => _client.auth.currentUser;

  Stream<AuthState> get onAuthStateChange => _client.auth.onAuthStateChange;

  /// Opens Google OAuth in an external browser.
  /// Returns true if the browser launched successfully.
  /// The session is set asynchronously — listen to [onAuthStateChange] for [AuthChangeEvent.signedIn].
  Future<bool> signInWithGoogle() async {
    try {
      return await _client.auth.signInWithOAuth(
        OAuthProvider.google,
        authScreenLaunchMode: LaunchMode.externalApplication,
      );
    } catch (e) {
      throw Exception('Error signing in with Google: $e');
    }
  }

  /// Signs in with email and password. Throws [AuthException] on failure.
  Future<AuthResponse> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (e) {
      throw Exception('Error signing out: $e');
    }
  }

  void printUserStates() {
    debugPrint("💠 Current User: ${currentUser?.email}");
  }

  /// Fetches hotels along with their images, rooms (rates), and facilities.
  /// (Not currently live - wire up in ExploreController later)
  Future<List<Map<String, dynamic>>> fetchHotels() async {
    try {
      final response = await _client
          .from('hotel')
          .select('''
            *,
            hotel_images (url, description, sort_order),
            hotel_rooms (price_per_night),
            hotel_facility (
              facility (id, name, slug, icon)
            )
          ''')
          .eq('is_active', true);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Error fetching hotels: $e');
    }
  }
}
