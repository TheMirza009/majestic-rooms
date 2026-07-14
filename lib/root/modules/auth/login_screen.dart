import 'package:majestic_rooms/core/theme/custom_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:majestic_rooms/core/extensions/context_extensions.dart';
import 'package:majestic_rooms/core/routes/app_routes.dart';
import 'package:majestic_rooms/core/theme/theme_context_extension.dart';
import 'package:majestic_rooms/core/theme/image_assets.dart';
import 'package:majestic_rooms/root/modules/auth/login_controller.dart';
import 'package:majestic_rooms/root/modules/auth/signup_screen.dart';
import 'package:majestic_rooms/root/widgets/custom_button.dart';
import 'package:majestic_rooms/root/widgets/entry_field.dart';
import 'package:flutter/services.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  // ── Control Panel ─────────────────────────────────────────────────────────
  // All tuneable values live here. No need to dig into method bodies to adjust.

  // Spacing & Sizes
  static const _logoHeight = 120.0;
  static const _buttonHeight = 48.0;
  static const _borderRadius = 8.0;
  static const _paddingH = 24.0;
  static const _gapLarge = 32.0;
  static const _gapMedium = 24.0;
  static const _gapSmall = 8.0;
  static const _gapSmallx2 = 16.0;
  static const _fieldHeight = 46.0;
  static const _fieldPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 12,
  );

  // Compact layout — below this width the logo gets breathing room on all sides.
  static const _compactBreakpoint = 600.0;
  static const _logoCompactPadding = EdgeInsets.all(32);

  // Text Styles
  static TextStyle _labelStyle(BuildContext context) => TextStyle(
    fontSize: 14,
    height: 2,
    fontWeight: FontWeight.w500,
    color: CustomColors.textDark,
  );

  static TextStyle _linkStyle(BuildContext context) => TextStyle(
    fontSize: 14,
    color: CustomColors.linkColor,
    decoration: TextDecoration.underline,
  );

  static TextStyle _btnTextStyle(BuildContext context) => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: CustomColors.brandWhite,
  );

  static TextStyle _btnTextDark(BuildContext context) => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: CustomColors.textDark,
  );

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.brandWhite,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: _paddingH),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: _gapLarge * 2),

                // LOGO
                Padding(
                  padding: context.screenWidth < _compactBreakpoint
                      ? _logoCompactPadding
                      : EdgeInsets.zero,
                  child: Center(
                    child: Image.asset(
                      ImageAssets.logoBlack,
                      height: context.screenWidth < _compactBreakpoint
                          ? _logoHeight / 1.3
                          : _logoHeight,
                      errorBuilder: (_, __, ___) => SizedBox(
                        height: context.screenWidth < _compactBreakpoint
                            ? _logoHeight / 1.3
                            : _logoHeight,
                        child: Center(
                          child: Text(
                            'MajesticRooms Logo',
                            style: TextStyle(
                              fontSize: 24,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: _gapLarge * 1.5),

                // EMAIL INPUT
                LabeledEntryField(
                  gap: 0,
                  controller: controller.emailController,
                  labelText: 'Email Address',
                  labelStyle: _labelStyle(context),
                  hintText: 'your@email.com',
                  keyboardType: TextInputType.emailAddress,
                  borderColor: context.borderColor,
                  borderRadius: _borderRadius,
                  fieldHeight: _fieldHeight,
                  contentPadding: _fieldPadding,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Please enter your email';
                    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value))
                      return 'Please enter a valid email address';
                    return null;
                  },
                ),
                const SizedBox(height: _gapSmall + 4),

                // PASSWORD INPUT
                Obx(
                  () => LabeledEntryField(
                    gap: 0,
                    controller: controller.passwordController,
                    labelText: 'Password',
                    labelStyle: _labelStyle(context),
                    hintText: 'Enter your password',
                    obscure: !controller.isPasswordVisible.value,
                    borderColor: context.borderColor,
                    borderRadius: _borderRadius,
                    fieldHeight: _fieldHeight,
                    contentPadding: _fieldPadding,
                    iconAsSuffix: IconButton(
                      icon: Icon(
                        controller.isPasswordVisible.value
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 18,
                        color: context.hintColor,
                      ),
                      onPressed: controller.togglePasswordVisibility,
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter your password'
                        : null,
                  ),
                ),
                const SizedBox(height: _gapSmall),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 8,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () {
                      // TODO: Implement forgot password navigation
                    },
                    child: Text(
                      'Forgot Password?',
                      style: _linkStyle(context),
                    ),
                  ),
                ),
                const SizedBox(height: _gapMedium),

                // SIGN IN BUTTON
                Obx(
                  () => SizedBox(
                    height: _buttonHeight,
                    child: CustomButton(
                      text: controller.isLoading.value
                          ? 'Signing in...'
                          : 'Sign in with Email',
                      toUpperCaseText: false,
                      textStyle: _btnTextStyle(context),
                      btnColor: context.primaryColor,
                      borderRadius: _borderRadius,
                      enabled: !controller.isLoading.value,
                      trailingIcon: controller.isLoading.value
                          ? SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: CustomColors.brandWhite,
                              ),
                            )
                          : Icon(
                              Icons.arrow_forward,
                              color: CustomColors.brandWhite,
                              size: 20,
                            ),
                      onTap: controller.signInWithEmail,
                    ),
                  ),
                ),
                const SizedBox(height: _gapLarge),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    TextButton(
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      onPressed: () => Navigator.push(
                        context,
                        CupertinoPageRoute(builder: (_) => SignupScreen()),
                      ),
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: context.primaryColor,
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
