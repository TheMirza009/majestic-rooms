import 'package:majestic_rooms/core/theme/custom_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:majestic_rooms/core/theme/theme_context_extension.dart';

/// Self-contained circular avatar with a built-in fallback and loading state.
/// Used by both ProfileBar and ProfileScreen so the two renders are pixel-
/// identical, which is what makes the flight animation between them seamless.
class UserAvatar extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final String? heroTag;

  const UserAvatar({
    super.key,
    required this.imageUrl,
    required this.size,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final _fallbackBg = context.surfaceColor;

    Widget avatar = ClipOval(
      child: SizedBox.square(
        dimension: size,
        child: (imageUrl == null || imageUrl!.isEmpty)
            ? ColoredBox(
                color: _fallbackBg,
                child: Icon(
                  Icons.person,
                  size: size * 0.5,
                  color: context.textMutedColor,
                ),
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
                      child: CircularProgressIndicator(
                        color: context.tertiaryColor,
                      ),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => ColoredBox(
                  color: CustomColors.cardSubtleBg,
                  child: Icon(
                    Icons.person,
                    size: size * 0.5,
                    color: context.textMutedColor,
                  ),
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
