
import 'package:flutter/material.dart';

class GlassNavItem extends StatelessWidget {
  final IconData      icon;
  final String        label;
  final bool          isActive;
  final VoidCallback  onTap;

  const GlassNavItem({
    super.key, 
    required this.icon,
    required this.label,
    this.isActive = false,
    required this.onTap,
  });

  // ── Control Panel ──────────────────────────────────────────────────────
  static const double    _height           = 48;
  static const double    _radius           = 24;
  static const double    _activePaddingH   = 16;
  static const double    _inactivePaddingH = 12;
  static const Color     _activeBg         = Color.fromARGB(255, 189, 58, 60);
  static const Color     _inactiveBg       = Color.fromARGB(41, 255, 255, 255); // frosted glass circle
  static const Color     _inactiveBorder   = Color(0x33FFFFFF);
  static const Color     _activeIconColor  = Colors.white;
  static const Color     _inactiveIconColor = Color(0xB3FFFFFF);
  static const double    _activeIconSize   = 26;
  static const double    _inactiveIconSize = 24;
  static const Duration  _animDuration     = Duration(milliseconds: 300);
  static const Curve     _animCurve        = Curves.easeInOut;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: _animDuration,
        curve: _animCurve,
        height: _height,
        padding: EdgeInsets.symmetric(
          horizontal: isActive ? _activePaddingH : _inactivePaddingH,
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? _activeBg : _inactiveBg,
          borderRadius: BorderRadius.circular(_radius),
          border: Border.all(
            color: isActive ? Colors.transparent : _inactiveBorder,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? _activeIconColor : _inactiveIconColor,
              size: isActive ? _activeIconSize : _inactiveIconSize,
            ),
            ClipRect(
              child: AnimatedAlign(
                duration: _animDuration,
                curve: _animCurve,
                alignment: Alignment.centerLeft,
                widthFactor: isActive ? 1.0 : 0.0,
                child: Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: _activeIconColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
