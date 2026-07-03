import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:majestic_rooms/core/theme/custom_colors.dart';
import 'package:majestic_rooms/root/modules/tabs/profile/user_controller.dart';
import 'package:majestic_rooms/root/widgets/entry_field.dart';

class UpdatePasswordScreen extends StatefulWidget {
  const UpdatePasswordScreen({super.key});

  @override
  State<UpdatePasswordScreen> createState() => UpdatePasswordScreenState();
}

class UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  // ── Control Panel ──────────────────────────────────────────────────────
  static const Duration animationDuration = Duration(milliseconds: 250);
  static const double fieldSpacing = 20;
  static const double cardRadius = 16;
  static const int minPasswordLength = 6; // identical threshold to the original validator

  final UserController userController = Get.find<UserController>();

  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool obscureCurrent = true;
  bool obscureNew = true;
  bool obscureConfirm = true;

  double passwordStrength = 0; // 0..1, purely cosmetic — does not affect validation

  @override
  void initState() {
    super.initState();
    newPasswordController.addListener(onNewPasswordChanged);
  }

  @override
  void dispose() {
    newPasswordController.removeListener(onNewPasswordChanged);
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F7F9),
        surfaceTintColor: const Color(0xFFF7F7F9),
        elevation: 0,
        centerTitle: true,
        title: const Text('Update Password', style: TextStyle(fontWeight: FontWeight.bold)),
        leadingWidth: 70,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.maybePop(context),
        ),
      ),
      body: Obx(() {
        final bool isLoading = userController.isLoading.value;
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: Form(
              key: formKey,
              child: AnimatedOpacity(
                duration: animationDuration,
                opacity: isLoading ? 0.5 : 1,
                child: IgnorePointer(
                  ignoring: isLoading,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      // HEADER
                      Center(
                        child: Container(
                          height: 72,
                          width: 72,
                          decoration: BoxDecoration(
                            color: CustomColors.brandRed.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.lock_rounded, color: CustomColors.brandRed, size: 32),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Choose a strong password',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Use a long, random password you don't use anywhere else to keep your account secure.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: CustomColors.textMuted, fontSize: 14, height: 1.4),
                      ),
                      const SizedBox(height: 32),

                      // CURRENT PASSWORD
                      fieldCard(
                        child: LabeledEntryField(
                          controller: currentPasswordController,
                          labelText: 'Current Password',
                          hintText: 'Enter current password',
                          obscure: obscureCurrent,
                          suffix: IconButton(
                            icon: Icon(obscureCurrent ? Icons.visibility_off : Icons.visibility, color: CustomColors.textMuted),
                            onPressed: () => setState(() => obscureCurrent = !obscureCurrent),
                          ),
                          validator: (String? val) {
                            if (val == null || val.isEmpty) return 'Current password is required';
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: fieldSpacing),

                      // NEW PASSWORD & CONFIRM PASSWORD
                      fieldCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            LabeledEntryField(
                              controller: newPasswordController,
                              labelText: 'New Password',
                              hintText: 'Enter new password',
                              obscure: obscureNew,
                              suffix: IconButton(
                                icon: Icon(obscureNew ? Icons.visibility_off : Icons.visibility, color: CustomColors.textMuted),
                                onPressed: () => setState(() => obscureNew = !obscureNew),
                              ),
                              validator: (String? val) {
                                if (val == null || val.isEmpty) return 'New password is required';
                                if (val.length < minPasswordLength) return 'Must be at least 6 characters';
                                return null;
                              },
                            ),
                            AnimatedSize(
                              duration: animationDuration,
                              curve: Curves.easeInOut,
                              alignment: Alignment.topCenter,
                              child: newPasswordController.text.isEmpty
                                  ? const SizedBox(width: double.infinity)
                                  : Padding(
                                      padding: const EdgeInsets.only(top: 12),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: <Widget>[
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(4),
                                            child: TweenAnimationBuilder<double>(
                                              duration: animationDuration,
                                              curve: Curves.easeInOut,
                                              tween: Tween<double>(begin: 0, end: passwordStrength),
                                              builder: (BuildContext context, double value, Widget? child) => LinearProgressIndicator(
                                                value: value,
                                                minHeight: 6,
                                                backgroundColor: const Color(0xFFEDEDED),
                                                color: strengthColor(passwordStrength),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          AnimatedSwitcher(
                                            duration: animationDuration,
                                            child: Text(
                                              strengthLabel(passwordStrength),
                                              key: ValueKey<String>(strengthLabel(passwordStrength)),
                                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: strengthColor(passwordStrength)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                            const SizedBox(height: fieldSpacing),
                            LabeledEntryField(
                              controller: confirmPasswordController,
                              labelText: 'Confirm New Password',
                              hintText: 'Re-type new password',
                              obscure: obscureConfirm,
                              suffix: IconButton(
                                icon: Icon(obscureConfirm ? Icons.visibility_off : Icons.visibility, color: CustomColors.textMuted),
                                onPressed: () => setState(() => obscureConfirm = !obscureConfirm),
                              ),
                              validator: (String? val) {
                                if (val != newPasswordController.text) return 'Passwords do not match';
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),

                      // SUBMIT BUTTON
                      SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: CustomColors.brandRed,
                            disabledBackgroundColor: CustomColors.brandRed.withValues(alpha: 0.6),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          child: AnimatedSwitcher(
                            duration: animationDuration,
                            child: isLoading
                                ? const SizedBox(
                                    key: ValueKey<String>('loading'),
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white),
                                  )
                                : const Text(
                                    'Update Password',
                                    key: ValueKey<String>('label'),
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  // Wraps a field (or field + meter) in the elevated white card used throughout this screen.
  Widget fieldCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(cardRadius),
        boxShadow: <BoxShadow>[
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: child,
    );
  }

  // Recomputes the (purely cosmetic) strength meter as the user types.
  void onNewPasswordChanged() {
    setState(() => passwordStrength = strengthOf(newPasswordController.text));
  }

  // Cosmetic-only heuristic: length + character variety. Does not affect validation.
  double strengthOf(String value) {
    if (value.isEmpty) return 0;
    int score = 0;
    if (value.length >= minPasswordLength) score++;
    if (value.length >= 10) score++;
    if (RegExp(r'[0-9]').hasMatch(value)) score++;
    if (RegExp(r'[A-Z]').hasMatch(value)) score++;
    if (RegExp(r'[^A-Za-z0-9]').hasMatch(value)) score++;
    return score / 5;
  }

  Color strengthColor(double strength) {
    if (strength < 0.4) return const Color(0xFFE5484D);
    if (strength < 0.7) return const Color(0xFFF5A623);
    return const Color(0xFF2E9E5B);
  }

  String strengthLabel(double strength) {
    if (strength < 0.4) return 'Weak';
    if (strength < 0.7) return 'Medium';
    return 'Strong';
  }

  // Validates, submits, then pops with a success confirmation.
  void submit() async {
    if (!formKey.currentState!.validate()) return;

    // Note: Supabase updateUser doesn't strictly require current password
    // unless secure session is expired, but we validate it exists in UI to match standard UX.
    await userController.updatePassword(newPasswordController.text);
    if (!mounted) return;
    Navigator.pop(context);
    Get.snackbar(
      'Password updated',
      'Your password has been changed successfully.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: CustomColors.brandRed,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }
}