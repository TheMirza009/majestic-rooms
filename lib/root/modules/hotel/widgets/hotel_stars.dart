
import 'package:flutter/material.dart';
import 'package:majestic_rooms/core/theme/custom_colors.dart';

class HotelStars extends StatelessWidget {
  final double rating;

  const HotelStars({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
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
      ],
    );
  }
}
