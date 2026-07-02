import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

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
    final sourceRect  = sourceBox.localToGlobal(Offset.zero) & sourceBox.size;
    final overlay     = Overlay.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final homeCtrl    = Get.find<HomeController>();

    isFlying.value = true;
    homeCtrl.navigateTo(3);

    // Insert overlay at source position immediately — no blank frames between
    // the ProfileBar avatar hiding (isFlying=true) and the overlay appearing.
    final animCtrl = AnimationController(vsync: this, duration: _flightDuration);
    Rect liveRect  = sourceRect;

    late OverlayEntry entry;
    entry = OverlayEntry(builder: (_) {
      return Positioned.fromRect(
        rect: liveRect,
        child: IgnorePointer(child: UserAvatar(imageUrl: avatarUrl, size: liveRect.width)),
      );
    });
    overlay.insert(entry);

    try {
      // Settle until ProfileScreen is mounted and screenAvatarKey has a context.
      if (_cachedDestinationRect == null) {
        for (int i = 0; i < _maxSettleFrames; i++) {
          await SchedulerBinding.instance.endOfFrame;
          final destBox = screenAvatarKey.currentContext?.findRenderObject() as RenderBox?;
          if (destBox != null && destBox.attached) {
            final destRect     = destBox.localToGlobal(Offset.zero) & destBox.size;
            // % screenWidth is only correct when measured at page == 0 (integer rest).
            // Mid-animation the page is fractional, so subtract the remaining
            // scroll distance to get the avatar's final resting X coordinate.
            final pagePosition = homeCtrl.pageController.page ?? 3.0;
            _cachedDestinationRect = Rect.fromLTWH(
              destRect.left - (3.0 - pagePosition) * screenWidth,
              destRect.top,
              destRect.width,
              destRect.height,
            );
            break;
          }
        }
      }

      final destinationRect = _cachedDestinationRect;
      if (destinationRect == null) return;

      final rectTween = RectTween(begin: sourceRect, end: destinationRect);
      final curved    = CurvedAnimation(parent: animCtrl, curve: Curves.easeInOutCubic);
      animCtrl.addListener(() {
        final baseRect = rectTween.evaluate(curved)!;
        
        // Use a sine wave based on the animation value to create a "bump".
        // math.sin(x * pi) starts at 0, peaks at 1 in the middle (0.5), and ends at 0.
        // We multiply by a factor (e.g., 15.0) to dictate how many pixels it inflates by.
        final inflation = math.sin(animCtrl.value * math.pi) * 15.0;
        liveRect = baseRect.inflate(inflation);

        entry.markNeedsBuild();
      });

      await animCtrl.forward();
    } finally {
      entry.remove();
      animCtrl.dispose();
      isFlying.value = false;
    }
  }
}