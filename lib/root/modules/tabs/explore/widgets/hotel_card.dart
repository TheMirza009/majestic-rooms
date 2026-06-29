import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:majestic_rooms/core/theme/custom_colors.dart';
import 'package:majestic_rooms/root/modules/tabs/explore/models/hotel.dart';
import 'package:majestic_rooms/root/modules/tabs/explore/widgets/favorite_button.dart';

class HotelCard extends StatelessWidget {
  final Hotel hotel;
  final bool initialSaveValue;
  final Function(bool) onSaveTap;

  const HotelCard({
    super.key,
    required this.hotel,
    this.initialSaveValue = false,
    required this.onSaveTap,
  });

  // ── Control Panel ─────────────────────────────────────────────────────────
  static const double _aspectRatio = 3 / 4; // flip to 3 / 4 for a portrait card
  static const double _radius = 30;
  static const double _inset = 12; // margin + padding around overlays
  static const Duration _fadeDuration = Duration(milliseconds: 350);

  static const Color _detailBg = Color(0xB3000000); // translucent dark panel
  static const Color _placeholderBg = CustomColors.cardSubtleBg; // shown until/if image fails
  static const Color _starColor = CustomColors.luxuryGold;

  static const TextStyle _nameStyle = TextStyle(
    color: CustomColors.textLight,
    fontWeight: FontWeight.w700,
    fontSize: 15,
    fontFamily: 'Fustat',
  );
  static const TextStyle _metaStyle = TextStyle(
    color: Color(0xCCFFFFFF),
    fontSize: 12,
    fontFamily: 'Fustat',
  );
  static const TextStyle _rateStyle = TextStyle(
    color: CustomColors.textLight,
    fontWeight: FontWeight.w700,
    fontSize: 16,
    fontFamily: 'Fustat',
  );
  static const TextStyle _unitStyle = TextStyle(
    color: Color(0xCCFFFFFF),
    fontSize: 11,
    fontFamily: 'Fustat',
  );

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: _aspectRatio,
      child: AnimatedSwitcher(
        duration: _fadeDuration,
        child: Container(
          key: ValueKey(hotel.imageUrl),
          decoration: BoxDecoration(
            color: _placeholderBg,
            borderRadius: BorderRadius.circular(_radius),
            image: DecorationImage(
              image: CachedNetworkImageProvider(hotel.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // FAVORITE
              Positioned(
                top: _inset,
                right: _inset,
                child: FavoriteButton(
                  value: initialSaveValue,
                  onChanged: onSaveTap,
                ),
              ),

              // DETAILS
              Align(
                alignment: Alignment.bottomCenter,
                child: FractionallySizedBox(
                  heightFactor: 0.25,
                  child: Padding(
                    padding: const EdgeInsets.all(_inset),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: _detailBg,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Row(
                          children: [
                            // NAME + ADDRESS + RATING · CITY
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    hotel.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: _nameStyle,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    hotel.address,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: _metaStyle,
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star_rounded,
                                        size: 13,
                                        color: _starColor,
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        hotel.rating.toStringAsFixed(1),
                                        style: _metaStyle,
                                      ),
                                      const Text('  ·  ', style: _metaStyle),
                                      Flexible(
                                        child: Text(
                                          hotel.city,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: _metaStyle,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // RATE / NIGHT
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('\$${hotel.rate}', style: _rateStyle),
                                const Text('/night', style: _unitStyle),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
