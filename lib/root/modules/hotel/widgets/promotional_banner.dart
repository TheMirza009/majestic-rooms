import 'package:flutter/material.dart';
import 'package:majestic_rooms/core/theme/theme_context_extension.dart';
import 'package:majestic_rooms/core/data/models/promotion.dart';
import 'package:get/get.dart';

class PromotionalBanner extends StatelessWidget {
  final Promotion promotion;

  const PromotionalBanner({super.key, required this.promotion});

  @override
  Widget build(BuildContext context) {
    if (promotion.isActive != true) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 24.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: context.primaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: context.primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.primaryColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.local_offer_rounded,
              color: context.primaryColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${'Special Offer!'.tr} ${promotion.discountPercent != null ? 'discount_off'.trParams({'discount': promotion.discountPercent.toString()}) : ''}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: context.primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'use_code'.trParams({'code': promotion.code}),
                  style: TextStyle(
                    fontSize: 14,
                    color: context.textMainColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (promotion.validTo != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'valid_until'.trParams({'date': promotion.validTo!}),
                    style: TextStyle(
                      fontSize: 12,
                      color: context.textMutedColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
