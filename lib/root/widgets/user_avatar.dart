import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:majestic_rooms/core/theme/custom_colors.dart';

/// Self-contained circular avatar with a built-in fallback and loading state.
/// Used by both ProfileBar and ProfileScreen so the two renders are pixel-
/// identical, which is what makes the flight animation between them seamless.
class UserAvatar extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final String? heroTag;

  const UserAvatar({super.key, required this.imageUrl, required this.size, this.heroTag});

  static const Color _fallbackBg = CustomColors.surfaceWhite;

  @override
  Widget build(BuildContext context) {
    Widget avatar = ClipOval(
      child: SizedBox.square(
        dimension: size,
        child: (imageUrl == null || imageUrl!.isEmpty)
            ? ColoredBox(
                color: _fallbackBg,
                child: Icon(Icons.person, size: size * 0.5, color: CustomColors.textMuted),
              )
            : CachedNetworkImage(
                imageUrl: imageUrl!,
                width: size,
                height: size,
                fit: BoxFit.cover,
                placeholder: (context, url) => ColoredBox(
                  color: _fallbackBg,
                  child: Center(
                    child: SizedBox.square(
                      dimension: size * 0.3,
                      child: const CircularProgressIndicator(color: CustomColors.premiumAmber),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => ColoredBox(
                  color: CustomColors.cardSubtleBg,
                  child: Icon(Icons.person, size: size * 0.5, color: CustomColors.textMuted),
                ),
              ),
      ),
    );

    if (heroTag != null) {
      return Hero(tag: heroTag!, child: avatar);
    }
    return avatar;
  }
}