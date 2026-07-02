import 'package:flutter/material.dart';
import 'package:majestic_rooms/core/theme/custom_colors.dart';
import 'package:majestic_rooms/core/data/models/promotion.dart';

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
        color: CustomColors.brandRed.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: CustomColors.brandRed.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: CustomColors.brandRed.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.local_offer_rounded,
              color: CustomColors.brandRed,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Special Offer! ${promotion.discountPercent != null ? '${promotion.discountPercent}% OFF' : ''}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: CustomColors.brandRed,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Use code "${promotion.code}" at checkout.',
                  style: const TextStyle(
                    fontSize: 14,
                    color: CustomColors.textMain,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (promotion.validTo != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Valid until ${promotion.validTo}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: CustomColors.textMuted,
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
