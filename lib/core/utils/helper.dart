import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:majestic_rooms/core/base/common_controller.dart';
import 'package:majestic_rooms/core/theme/custom_colors.dart';
import 'package:majestic_rooms/core/theme/theme_context_extension.dart';
import 'package:majestic_rooms/core/utils/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:majestic_rooms/root/widgets/confirm_logout_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

bool get kIsWindows => Platform.isWindows;

class Utils {
  static Future<void> launchWebUrl(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        showToast('could_not_open_link'.tr);
      }
    } catch (e) {
      showToast('could_not_open_link'.tr);
    }
  }

  static Future<void> launchEmail(String email) async {
    final Uri emailLaunchUri = Uri(scheme: 'mailto', path: email);
    try {
      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(emailLaunchUri, mode: LaunchMode.externalApplication);
      } else {
        showToast('no_email_app_found'.tr);
      }
    } catch (e) {
      showToast('no_email_app_found'.tr);
    }
  }

  static Future<void> launchPhone(String phone) async {
    final String cleanPhone = phone.replaceAll(' ', '');
    final Uri phoneLaunchUri = Uri(scheme: 'tel', path: cleanPhone);
    try {
      if (await canLaunchUrl(phoneLaunchUri)) {
        await launchUrl(phoneLaunchUri, mode: LaunchMode.externalApplication);
      } else {
        showToast('no_phone_app_found'.tr);
      }
    } catch (e) {
      showToast('no_phone_app_found'.tr);
    }
  }

  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: context.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  static void showToast(String message) {
    if (kIsWindows) {
      Get.rawSnackbar(
        message: message,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        mainButton: IconButton(
          icon: const Icon(Icons.clear, color: Colors.white),
          onPressed: () {
            if (Get.isSnackbarOpen) {
              Get.closeCurrentSnackbar();
            }
          },
        ),
      );
    } else {
      Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_SHORT);
    }
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
      icon: Icon(
        Icons.error_outline,
        color: Get.context?.primaryColor ?? CustomColors.brandRed,
      ),
      mainButtonText: mainButtonText ?? 'Close'.tr,
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
      builder: (_) =>
          ConfirmLogoutDialog(controller: Get.find<CommonController>()),
    );
  }

  static Future<void> showAboutDialog() async {
    await showAdaptiveDialog(
      context: Get.context!,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog.adaptive(
          title: Text('About'.tr),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'app_name_text'.trParams({'appName': Constants.appName}),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Version: @version'.trParams({'version': Constants.appVersion}),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'.tr),
            ),
          ],
        );
      },
    );
  }
}
