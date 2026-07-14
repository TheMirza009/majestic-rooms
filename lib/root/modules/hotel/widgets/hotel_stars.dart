import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:majestic_rooms/core/theme/theme_context_extension.dart';

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
              Icon(Icons.star, color: context.secondaryColor, size: 20)
            else if (i == rating.floor())
              Stack(
                children: [
                  Icon(Icons.star, color: context.hintColor, size: 20),
                  ClipRect(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      widthFactor: ((rating * 10).toInt() % 10) / 10.0,
                      child: Icon(
                        Icons.star,
                        color: context.secondaryColor,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              )
            else
              Icon(Icons.star_border, color: context.secondaryColor, size: 20),
          if (reviewCount != null) ...[
            const SizedBox(width: 8),
            Text(
              reviewCount == 1
                  ? 'review_count'.trParams({'count': reviewCount.toString()})
                  : 'reviews_count'.trParams({'count': reviewCount.toString()}),
              style: TextStyle(
                color: context.textMutedColor,
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
