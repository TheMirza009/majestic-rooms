import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:majestic_rooms/core/theme/custom_colors.dart';

class LicenceBanner extends StatelessWidget {
  final String? licenceNo;
  const LicenceBanner({super.key, this.licenceNo});

  @override
  Widget build(BuildContext context) {
    final bool hasLicence = licenceNo?.isNotEmpty ?? false;

    return Transform.scale(
      scale: 0.9,
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: hasLicence
              ? CustomColors.luxuryGold.withOpacity(0.15)
              : CustomColors.brandRed.withOpacity(0.10),
          border: Border.all(
            width: 1.15,
            color: hasLicence
                ? CustomColors.luxuryGold
                : CustomColors.brandRed.withAlpha(150),
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              hasLicence ? Icons.verified_rounded : Icons.info_outline_rounded,
              color: hasLicence ? CustomColors.luxuryGold : CustomColors.brandRed,
            ),
            const SizedBox(width: 12),
            Text(
              hasLicence
                  ? 'licence_no'.trParams({'no': licenceNo!})
                  : 'No licence number provided'.tr,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: hasLicence ? CustomColors.linkColor : CustomColors.brandRed,
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}
