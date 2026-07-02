import 'package:flutter/material.dart';
import 'package:majestic_rooms/core/theme/custom_colors.dart';

const _kRadius = BorderRadius.all(Radius.circular(20));
const _kShadow = [
  BoxShadow(
    color: Color(0x0D000000),
    blurRadius: 8,
    offset: Offset(0, 2),
  ),
];

/// A card shell with the standard booking summary surface — white bg,
/// 20-radius corners, and a subtle drop shadow.
class SummaryCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const SummaryCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: const BoxDecoration(
        color: CustomColors.surfaceWhite,
        borderRadius: _kRadius,
        boxShadow: _kShadow,
      ),
      child: child,
    );
  }
}
