import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:majestic_rooms/root/modules/home/home_controller.dart';
import 'package:majestic_rooms/root/widgets/user_avatar.dart';

/// Drives the flying-avatar pseudo-hero animation between ProfileBar and
/// ProfileScreen. A real Hero can't be used here since both widgets live
/// inside the same PageView rather than separate Navigator routes.
class ProfileAvatarFlightController extends GetxController with GetTickerProviderStateMixin {
  // ── Control Panel ────────────────────────────────────────────────────────
  static const Duration _flightDuration  = Duration(milliseconds: 450);
  static const int      _maxSettleFrames = 30; // ~0.5s safety cap, first flight only

  // ── Fields ───────────────────────────────────────────────────────────────
  final GlobalKey barAvatarKey    = GlobalKey();
  final GlobalKey screenAvatarKey = GlobalKey();
  final isFlying = false.obs;

  // ProfileScreen's avatar rect is layout-static (fixed padding, fixed
  // size), so once observed once it can be reused on every later flight.
  // This matters because PageView only lays out pages near the current
  // index — jumping multiple pages away (e.g. tab 0 -> tab 3) leaves
  // ProfileScreen unattached for most of the transition, so chasing its
  // live position mid-swipe isn't reliable. A fixed target sidesteps that.
  Rect? _cachedDestinationRect;

  // ── Flight ───────────────────────────────────────────────────────────────
  Future<void> flyToProfile(BuildContext context, String? avatarUrl) async {
    if (isFlying.value) return;

    final sourceBox = barAvatarKey.currentContext?.findRenderObject() as RenderBox?;
    if (sourceBox == null || !sourceBox.attached) {
      Get.find<HomeController>().navigateTo(3);
      return;
    }
    final sourceRect = sourceBox.localToGlobal(Offset.zero) & sourceBox.size;
    final overlay     = Overlay.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;

    isFlying.value = true;
    Get.find<HomeController>().navigateTo(3);

    try {
      if (_cachedDestinationRect == null) {
        // Since we added cacheExtent to HomeScreen, ProfileScreen is already
        // built and laid out, but it's sitting off-screen to the right. 
        // We can instantly calculate its final resting position by taking 
        // its current global X coordinate modulo the screen width.
        final destBox = screenAvatarKey.currentContext?.findRenderObject() as RenderBox?;
        if (destBox != null && destBox.attached) {
          final currentRect = destBox.localToGlobal(Offset.zero) & destBox.size;
          _cachedDestinationRect = Rect.fromLTWH(
            currentRect.left % screenWidth,
            currentRect.top,
            currentRect.width,
            currentRect.height,
          );
        }
      }

      final destinationRect = _cachedDestinationRect;
      if (destinationRect == null) return;

      await _runFlight(overlay, sourceRect, destinationRect, avatarUrl);
    } finally {
      isFlying.value = false;
    }
  }

  Future<void> _runFlight(OverlayState overlay, Rect sourceRect, Rect destinationRect, String? avatarUrl) async {
    final animController = AnimationController(vsync: this, duration: _flightDuration);
    final rectTween       = RectTween(begin: sourceRect, end: destinationRect);
    final curved          = CurvedAnimation(parent: animController, curve: Curves.easeInOutCubic);

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) {
        final rect = rectTween.evaluate(curved)!;
        return Positioned.fromRect(
          rect: rect,
          child: IgnorePointer(
            child: UserAvatar(imageUrl: avatarUrl, size: rect.width),
          ),
        );
      },
    );

    animController.addListener(() => entry.markNeedsBuild());
    overlay.insert(entry);

    await animController.forward();

    entry.remove();
    animController.dispose();
  }
}