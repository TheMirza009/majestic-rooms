import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

extension ResponsiveGrid on BuildContext {
  static const double baseWidth = 1920.0;
  static const double baseHeight = 1080.0;
  double get screenHeight => MediaQuery.sizeOf(this).height;
  double get screenWidth => MediaQuery.sizeOf(this).width;

  double get gridMaxCrossAxisExtent {
    final width = MediaQuery.of(this).size.width;
    if (width > 1400) return 700;
    if (width > 1200) return 500;
    if (width > 1000) return 400;
    if (width > 700) return 350;
    if (width > 500) return 300;
    return 250;
  }

  double get gridMainAxisExtent {
    final height = MediaQuery.of(this).size.height;
    if (height > 1000) return 250;
    if (height > 800) return 200;
    if (height > 600) return 180;
    return 150;
  }

  double get gridMaxCrossAxisExtentPercentage {
    final width = MediaQuery.of(this).size.width;
    final double percentage = 700.0 / baseWidth; // 26.04%
    return (width * percentage).clamp(500, 700);
  }

  double get gridMainAxisExtentPercentage {
    final height = MediaQuery.of(this).size.height;
    final double percentage = 250.0 / baseHeight; // 18.52%
    return (height * percentage).clamp(140, 250);
  }

  double get responsiveFontSize {
    final width = this.screenWidth;

    if (width < 600) {
      return 10; // Mobile
    } else if (width < 1000) {
      return 12; // Tablet
    } else if (width < 1200) {
      return 13; // Small desktop
    } else {
      return 14; // Large desktop (default)
    }
  }
}

extension DeviceTypeExtension on BuildContext {
  bool get isTablet => MediaQuery.of(this).size.shortestSide >= 600;

  bool get isMobileWidth => MediaQuery.of(this).size.shortestSide < 600;
}

extension EscapePopExtension on BuildContext {
  Widget withEscapeToPop(Widget child, {VoidCallback? onEscape}) {
    return Shortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.escape): const _EscapeIntent(),
      },
      child: Actions(
        actions: {
          _EscapeIntent: CallbackAction<_EscapeIntent>(
            onInvoke: (_EscapeIntent intent) {
              if (onEscape != null) {
                onEscape();
              } else {
                Navigator.of(this).pop();
              }
              return null;
            },
          ),
        },
        child: Focus(autofocus: true, child: child),
      ),
    );
  }
}

class _EscapeIntent extends Intent {
  const _EscapeIntent();
}
