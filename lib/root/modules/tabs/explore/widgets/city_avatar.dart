import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:majestic_rooms/core/theme/custom_colors.dart';
import 'package:majestic_rooms/root/modules/tabs/explore/explore_controller.dart';

class CityAvatar extends StatelessWidget {
  final City   city;
  final bool   isLoading;
  final double size;

  const CityAvatar({super.key, required this.city, required this.isLoading, this.size = 64});

  // ── Control Panel ─────────────────────────────────────────────────────────
  static const Duration _fadeDuration = Duration(milliseconds: 350);
  static const Color    _bgColor      = CustomColors.cardSubtleBg;
  static const Color    _iconColor    = CustomColors.textMuted;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: _bgColor,
      ),
      child: AnimatedSwitcher(
        duration: _fadeDuration,
        child: isLoading ? _buildLoader() : _buildImage(),
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

  Widget _buildImage() => CachedNetworkImage(
        key: ValueKey(city.imageURL),
        imageUrl: city.imageURL,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorWidget: (_, _, _) => const Center(
          child: Icon(Icons.location_city_rounded, size: 28, color: _iconColor),
        ),
      );
}
