import 'package:flutter/material.dart';
import 'package:majestic_rooms/core/theme/custom_colors.dart';

class FieldClearButton extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onClear;
  final Widget? icon;
  final Color iconColor;
  final double size;

  const FieldClearButton({
    super.key,
    required this.controller,
    required this.onClear,
    this.icon,
    this.iconColor = CustomColors.linkColor,
    this.size = 30,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: ValueListenableBuilder(
        valueListenable: controller,
        builder: (context, value, child) {
          return IgnorePointer(
            ignoring: value.text.isEmpty,
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: onClear,
              icon: AnimatedScale(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOutBack,
                scale: value.text.isEmpty ? 0.0 : 1.0,
                child: icon ?? Icon(Icons.clear, color: iconColor, size: size),
              ),
            ),
          );
        },
      ),
    );
  }
}