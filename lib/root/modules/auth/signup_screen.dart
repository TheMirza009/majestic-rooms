import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:majestic_rooms/core/extensions/context_extensions.dart';
import 'package:majestic_rooms/core/theme/custom_colors.dart';
import 'package:majestic_rooms/core/theme/image_assets.dart';
import 'package:majestic_rooms/root/modules/auth/login_controller.dart';
import 'package:majestic_rooms/root/widgets/custom_button.dart';
import 'package:majestic_rooms/root/widgets/entry_field.dart';

class SignupScreen extends GetView<LoginController> {
  const SignupScreen({super.key});

  // ── Control Panel ─────────────────────────────────────────────────────────
  // All tuneable values live here. No need to dig into method bodies to adjust.

  // Spacing & Sizes
  static const _logoHeight   = 120.0;
  static const _buttonHeight = 48.0;
  static const _borderRadius = 8.0;
  static const _paddingH     = 24.0;
  static const _gapLarge     = 32.0;
  static const _gapMedium    = 24.0;
  static const _gapSmall     = 8.0;
  static const _gapSmallx2     = 16.0;
  static const _fieldHeight  = 46.0;
  static const _fieldPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 12);

  // Compact layout — below this width the logo gets breathing room on all sides.
  static const _compactBreakpoint  = 600.0;
  static const _logoCompactPadding = EdgeInsets.all(32);

  // Text Styles
  static const _labelStyle   = TextStyle(
    fontSize: 14,
    height: 2,
    fontWeight: FontWeight.w500,
    color: CustomColors.textDark,
  );

  static const _linkStyle    = TextStyle(
    fontSize: 14,
    color: CustomColors.linkColor,
    decoration: TextDecoration.underline,
  );

  static const _btnTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: CustomColors.brandWhite,
  );

  static const _titleStyle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: CustomColors.textDark,
  );

  // ── Handlers ──────────────────────────────────────────────────────────────

  void _onSignUp() {
    if (!controller.signupFormKey.currentState!.validate()) return;
    controller.signInWithEmail();
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.brandWhite,
      appBar: AppBar(title: Text("Create new account"), centerTitle: false,),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: _paddingH),
          child: Form(
            key: controller.signupFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: _gapSmall),

                // LOGO
                // Padding(
                //   padding: context.screenWidth < _compactBreakpoint
                //       ? _logoCompactPadding
                //       : EdgeInsets.zero,
                //   child: Center(
                //     child: Image.asset(
                //       ImageAssets.logoBlack,
                //       height: context.screenWidth < _compactBreakpoint ? _logoHeight / 1.3 : _logoHeight,
                //       errorBuilder: (_, __, ___) => SizedBox(
                //         height: context.screenWidth < _compactBreakpoint ? _logoHeight / 1.3 : _logoHeight,
                //         child: const Center(
                //           child: Text(
                //             'MajesticRooms Logo',
                //             style: TextStyle(fontSize: 24, fontStyle: FontStyle.italic),
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                const SizedBox(height: _gapSmall),

                // SIGN UP TITLE
                // const Center(
                //   child: Text('Create your account', style: _titleStyle),
                // ),
                // const SizedBox(height: _gapLarge * 1.5),

                // EMAIL INPUT
                LabeledEntryField(
                  gap: 2,
                  controller: controller.emailController,
                  labelText: 'Email Address',
                  labelStyle: _labelStyle,
                  hintText: 'your@email.com',
                  keyboardType: TextInputType.emailAddress,
                  borderColor: CustomColors.borderColor,
                  borderRadius: _borderRadius,
                  fieldHeight: _fieldHeight,
                  contentPadding: _fieldPadding,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter your email';
                    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value)) return 'Please enter a valid email address';
                    return null;
                  },
                ),
                const SizedBox(height: _gapSmallx2),

                // PASSWORD INPUT
                Obx(() => LabeledEntryField(
                  gap: 2,
                  controller: controller.passwordController,
                  labelText: 'Password',
                  labelStyle: _labelStyle,
                  hintText: 'Enter your password',
                  obscure: !controller.isPasswordVisible.value,
                  borderColor: CustomColors.borderColor,
                  borderRadius: _borderRadius,
                  fieldHeight: _fieldHeight,
                  contentPadding: _fieldPadding,
                  iconAsSuffix: IconButton(
                    icon: Icon(
                      controller.isPasswordVisible.value
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 18,
                      color: CustomColors.hintColor,
                    ),
                    onPressed: controller.togglePasswordVisibility,
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Please enter your password' : null,
                )),
                const SizedBox(height: _gapSmallx2),

                // RE-ENTER PASSWORD INPUT
                Obx(() => LabeledEntryField(
                  gap: 2,
                  controller: controller.confirmPasswordController,
                  labelText: 'Re-enter Password',
                  labelStyle: _labelStyle,
                  hintText: 'Confirm your password',
                  obscure: !controller.isPasswordVisible.value,
                  borderColor: CustomColors.borderColor,
                  borderRadius: _borderRadius,
                  fieldHeight: _fieldHeight,
                  contentPadding: _fieldPadding,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please confirm your password';
                    if (value != controller.passwordController.text) return 'Passwords do not match';
                    return null;
                  },
                )),
                const SizedBox(height: _gapLarge * 1.5),

                // SIGN UP BUTTON
                Obx(() => SizedBox(
                  height: _buttonHeight,
                  child: CustomButton(
                    text: controller.isLoading.value ? 'Creating account...' : 'Sign up with Email',
                    toUpperCaseText: false,
                    textStyle: _btnTextStyle,
                    btnColor: CustomColors.brandRed,
                    borderRadius: _borderRadius,
                    enabled: !controller.isLoading.value,
                    trailingIcon: controller.isLoading.value
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: CustomColors.brandWhite,
                            ),
                          )
                        : const Icon(
                            Icons.arrow_forward,
                            color: CustomColors.brandWhite,
                            size: 20,
                          ),
                    onTap: _onSignUp,
                  ),
                )),
                const SizedBox(height: _gapSmall),

                // SIGN IN LINK
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account? '),
                    TextButton(
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      onPressed: () => Get.back<void>(),
                      child: const Text(
                        'Sign in',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: CustomColors.brandRed,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}