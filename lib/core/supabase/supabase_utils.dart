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
  Future<AuthResponse> signInWithEmailPassword(String email, String password) async {
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
}


