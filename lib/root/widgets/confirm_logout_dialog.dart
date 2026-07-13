import 'package:flutter/material.dart';
import 'package:majestic_rooms/core/base/common_controller.dart';
import 'package:majestic_rooms/core/theme/custom_colors.dart';
import 'package:get/get.dart';

class ConfirmLogoutDialog extends StatelessWidget {
  final CommonController controller;

  const ConfirmLogoutDialog({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 400,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        decoration: BoxDecoration(
          color: CustomColors.brandWhite,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ICON
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: CustomColors.brandRed.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.exit_to_app,
                color: CustomColors.brandRed,
                size: 28,
              ),
            ),
            const SizedBox(height: 16),

            // TITLE
            Text(
              'Are you sure you want to logout?'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black.withValues(alpha: 0.8),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),

            // SUBTITLE
            Text(
              'You will be taken back to the login screen.'.tr,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black.withValues(alpha: 0.55),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),

            // BUTTONS
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'.tr, style: const TextStyle(fontWeight: FontWeight.w800)),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    controller.logOutUser();
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: CustomColors.brandRed,
                  ),
                  child: Text('Logout'.tr, style: const TextStyle(fontWeight: FontWeight.w800)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
