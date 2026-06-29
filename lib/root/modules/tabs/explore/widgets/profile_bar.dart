import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:majestic_rooms/core/theme/custom_colors.dart';
import 'package:majestic_rooms/root/modules/home/home_controller.dart';

class ProfileBar extends StatelessWidget {
  final String? imageUrl;
  final VoidCallback? onNotificationsTap;

  const ProfileBar({super.key, this.imageUrl, this.onNotificationsTap});

  static const double _size    = 42;
  static const Color  _bgColor = CustomColors.surfaceWhite;

  static const Widget _fallback = ColoredBox(
    color: _bgColor,
    child: Center(
      child: Icon(Icons.person_rounded, size: 18, color: CustomColors.textMuted),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        // PROFILE
        Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(100),
          child: InkWell(
            borderRadius: BorderRadius.circular(100),
            onTap: () => Get.find<HomeController>().navigateTo(3),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Row(
                spacing: 12,
                children: [
                  SizedBox.square(
                    dimension: _size,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: imageUrl != null
                          ? Image.network(
                              imageUrl!,
                              width: _size,
                              height: _size,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => _fallback,
                            )
                          : _fallback,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome back  ', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: CustomColors.textMuted, height: 1.2)),
                      Text('John Doe', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: CustomColors.brandBlack, fontWeight: FontWeight.w700, height: 1.2)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        IconButton(
          style: IconButton.styleFrom(
            backgroundColor: CustomColors.surfaceWhite,
            padding: EdgeInsets.zero,
            iconSize: 25,
          ),
          onPressed: onNotificationsTap,
          icon: Icon(
            Icons.notifications_outlined,
            color: CustomColors.textMuted,
            size: 22,
          ),
        )
      ],
    );
  }
}
