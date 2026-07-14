import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:majestic_rooms/root/modules/home/widgets/glass_nav_item.dart';

class GlassBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const GlassBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  // ── Control Panel ────────────────────────────────────────────────────────
  static const double _trayBlurSigma = 20; // Cupertino frosted-glass depth
  static const double _trayRadius = 40;
  static const Color _trayBg = Color.fromARGB(85, 0, 0, 0);
  static const Color _trayBorder = Color(0x1AFFFFFF); // specular highlight rim

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(_trayRadius)),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: _trayBlurSigma,
                sigmaY: _trayBlurSigma,
              ),
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  color: _trayBg,
                  borderRadius: BorderRadius.all(Radius.circular(_trayRadius)),
                  border: Border(
                    top: BorderSide(color: _trayBorder, width: 1.5),
                    right: BorderSide(color: _trayBorder, width: 1.5),
                    bottom: BorderSide(color: _trayBorder, width: 1.5),
                    left: BorderSide(color: _trayBorder, width: 1.5),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  child: Row(
                    spacing: 16,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // EXPLORE
                      GlassNavItem(
                        icon: Icons.search_rounded,
                        label: 'Explore'.tr,
                        isActive: currentIndex == 0,
                        onTap: () => onTap(0),
                      ),

                      // SAVED
                      GlassNavItem(
                        icon: Icons.favorite_outline,
                        label: 'Saved'.tr,
                        isActive: currentIndex == 1,
                        onTap: () => onTap(1),
                      ),

                      // BOOKINGS
                      GlassNavItem(
                        icon: Icons.bookmark_outline,
                        label: 'Bookings'.tr,
                        isActive: currentIndex == 2,
                        onTap: () => onTap(2),
                      ),

                      // PROFILE
                      GlassNavItem(
                        icon: Icons.person_outline_rounded,
                        label: 'Profile'.tr,
                        isActive: currentIndex == 3,
                        onTap: () => onTap(3),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
