import 'package:majestic_rooms/core/theme/custom_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:majestic_rooms/core/theme/theme_context_extension.dart';
import 'package:majestic_rooms/root/modules/tabs/explore/explore_controller.dart';

class CityAvatar extends StatelessWidget {
  final City city;
  final bool isLoading;
  final double size;

  const CityAvatar({
    super.key,
    required this.city,
    required this.isLoading,
    this.size = 64,
  });

  // ── Control Panel ─────────────────────────────────────────────────────────
  static const Duration _fadeDuration = Duration(milliseconds: 350);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: CustomColors.cardSubtleBg,
      ),
      child: AnimatedSwitcher(
        duration: _fadeDuration,
        child: isLoading ? _buildLoader() : _buildImage(context),
      ),
    );
  }

  Widget _buildLoader() => const Center(
    key: ValueKey('loader'),
    child: SizedBox(
      width: 24,
      height: 24,
      child: CircularProgressIndicator(strokeWidth: 2),
    ),
  );

  Widget _buildImage(BuildContext context) => CachedNetworkImage(
    key: ValueKey(city.imageURL),
    imageUrl: city.imageURL,
    width: size,
    height: size,
    fit: BoxFit.cover,
    errorWidget: (_, _, _) => Center(
      child: Icon(
        Icons.location_city_rounded,
        size: 28,
        color: context.textMutedColor,
      ),
    ),
  );
}
