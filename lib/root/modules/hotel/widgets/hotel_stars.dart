
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:majestic_rooms/core/theme/custom_colors.dart';

class HotelStars extends StatelessWidget {
  final double rating;
  final int? reviewCount;
  final VoidCallback? onTap;

  const HotelStars({
    super.key,
    required this.rating,
    this.reviewCount,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < 5; i++)
            if (i < rating.floor())
              const Icon(Icons.star, color: CustomColors.luxuryGold, size: 20)
            else if (i == rating.floor())
              Stack(
                children: [
                  const Icon(Icons.star, color: CustomColors.hintColor, size: 20),
                  ClipRect(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      widthFactor: ((rating * 10).toInt() % 10) / 10.0,
                      child: const Icon(Icons.star, color: CustomColors.luxuryGold, size: 20),
                    ),
                  ),
                ],
              )
            else
              const Icon(Icons.star_border, color: CustomColors.luxuryGold, size: 20),
          if (reviewCount != null) ...[
            const SizedBox(width: 8),
            Text(
              reviewCount == 1 
                  ? 'review_count'.trParams({'count': reviewCount.toString()}) 
                  : 'reviews_count'.trParams({'count': reviewCount.toString()}),
              style: const TextStyle(
                color: CustomColors.textMuted,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
