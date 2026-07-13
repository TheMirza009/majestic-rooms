import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:majestic_rooms/core/routes/app_routes.dart';
import 'package:majestic_rooms/core/supabase/supabase_utils.dart';
import 'package:majestic_rooms/core/utils/helper.dart';
import 'package:majestic_rooms/root/modules/home/home_screen.dart';
import 'package:majestic_rooms/core/routes/app_pages.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginController extends GetxController {
  final _supabase = SupabaseUtils();

  // ── Form state ─────────────────────────────────────────────────────────────
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final signupFormKey = GlobalKey<FormState>();

  // ── UI state ───────────────────────────────────────────────────────────────
  final isPasswordVisible = false.obs;
  final isLoading = false.obs;

  void togglePasswordVisibility() => isPasswordVisible.toggle();

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  // ── Actions ────────────────────────────────────────────────────────────────

  void signInWithEmail() {
    if (!formKey.currentState!.validate()) return;
    _signInWithEmail();
  }

  Future<void> _signInWithEmail() async {
    isLoading.value = true;
    final email = emailController.text.trim();
    debugPrint('🔐 [Login] Attempting sign-in for: $email');
    try {
      final response = await _supabase.signInWithEmailPassword(
        email,
        passwordController.text,
      );
      debugPrint('✅ [Login] Sign-in successful — uid: ${response.user?.id}');
      Get.offAllNamed(AppRoutes.home);
    } on AuthException catch (e) {
      debugPrint(
        '❌ [Login] AuthException: ${e.message} (status: ${e.statusCode})',
      );
      Utils.showBottomSnackBarError('Sign In Failed'.tr, e.message);
    } catch (e) {
      debugPrint('💥 [Login] Unexpected error: $e');
      Utils.showBottomSnackBarError(
        'Sign In Failed'.tr,
        'An unexpected error occurred.',
      );
    } finally {
      isLoading.value = false;
    }
  }
}
