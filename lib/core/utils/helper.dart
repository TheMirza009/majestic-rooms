import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:majestic_rooms/core/base/common_controller.dart';
import 'package:majestic_rooms/core/theme/custom_colors.dart';
import 'package:majestic_rooms/core/utils/constants.dart';
import 'package:majestic_rooms/root/widgets/confirm_logout_dialog.dart';

bool get kIsWindows => Platform.isWindows;

class Utils {

  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: CustomColors.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  // ── GetX snackbars ────────────────────────────────────────────────────────

  /// Bottom-anchored GetX snackbar. No context required.
  ///
  /// [mainButtonText] + [onMainButtonTap] render a right-side action button.
  /// [onMainButtonTap] defaults to [Get.back] when only [mainButtonText] is set.
  static void showBottomSnackBar(
    String title,
    String message, {
    String? mainButtonText,
    VoidCallback? onMainButtonTap,
    Widget? icon,
    Duration animationDuration = const Duration(milliseconds: 500),
    double barBlur = 0.2,
    EdgeInsets margin = const EdgeInsets.only(bottom: 8, left: 8, right: 8),
  }) {
    final button = mainButtonText != null
        ? TextButton(
            onPressed: onMainButtonTap ?? Get.back,
            child: Text(mainButtonText),
          )
        : null;

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      icon: icon,
      mainButton: button,
      animationDuration: animationDuration,
      barBlur: barBlur,
      margin: margin,
    );
  }

  /// [showBottomSnackBar] with a green check icon — use for successful actions.
  static void showBottomSnackBarSuccess(
    String title,
    String message, {
    String? mainButtonText,
    VoidCallback? onMainButtonTap,
    Duration animationDuration = const Duration(milliseconds: 500),
    double barBlur = 0.2,
    EdgeInsets margin = const EdgeInsets.only(bottom: 8, left: 8, right: 8),
  }) {
    showBottomSnackBar(
      title,
      message,
      icon: const Icon(Icons.check_circle_outline, color: Colors.green),
      mainButtonText: mainButtonText,
      onMainButtonTap: onMainButtonTap,
      animationDuration: animationDuration,
      barBlur: barBlur,
      margin: margin,
    );
  }

  /// [showBottomSnackBar] with a red error icon — use for failures.
  static void showBottomSnackBarError(
    String title,
    String message, {
    String? mainButtonText,
    VoidCallback? onMainButtonTap,
    Duration animationDuration = const Duration(milliseconds: 500),
    double barBlur = 0.2,
    EdgeInsets margin = const EdgeInsets.only(bottom: 8, left: 8, right: 8),
  }) {
    showBottomSnackBar(
      title,
      message,
      icon: const Icon(Icons.error_outline, color: CustomColors.brandRed),
      mainButtonText: mainButtonText ?? "Close",
      onMainButtonTap: onMainButtonTap ?? () => Get.back(),
      animationDuration: animationDuration,
      barBlur: barBlur,
      margin: margin,
    );
  }

  // ── Dialogs ───────────────────────────────────────────────────────────────

  static Future<void> logoutDialog() async {
    await showDialog(
      context: Get.context!,
      barrierDismissible: true,
      builder: (_) => ConfirmLogoutDialog(
        controller: Get.find<CommonController>(),
      ),
    );
  }

  static Future<void> showAboutDialog() async {
    await showAdaptiveDialog(
      context: Get.context!,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog.adaptive(
          title: const Text('About'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'App Name: ${Constants.appName}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('Version: ${Constants.appVersion}'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}