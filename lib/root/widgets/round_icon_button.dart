import 'package:flutter/material.dart';

/// A reusable circular button that scales down when pressed.
/// Fully customizable with defaults that match the style of the FavoriteButton.
class RoundIconButton extends StatefulWidget {
  final Widget? icon;
  final VoidCallback? onTap;
  final double size;
  final Color backgroundColor;
  final Duration duration;
  final double pressedScale;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const RoundIconButton({
    super.key,
    this.icon,
    this.onTap,
    this.size = 46.0,
    this.backgroundColor = const Color(0x59000000),
    this.duration = const Duration(milliseconds: 100),
    this.pressedScale = 0.9,
    this.padding,
    this.margin,
  });

  @override
  State<RoundIconButton> createState() => _RoundIconButtonState();
}

class _RoundIconButtonState extends State<RoundIconButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      value: 1.0,
    );
    _scale = Tween<double>(
      begin: widget.pressedScale,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onTap != null) {
      _controller.reverse();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.onTap != null) {
      _controller.forward();
    }
  }

  void _onTapCancel() {
    if (widget.onTap != null) {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget button = GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: widget.size,
          height: widget.size,
          padding: widget.padding,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.backgroundColor,
          ),
          child: widget.icon != null ? Center(child: widget.icon) : null,
        ),
      ),
    );

    if (widget.margin != null) {
      button = Padding(padding: widget.margin!, child: button);
    }

    // UnconstrainedBox ensures the button is exactly `size` x `size`
    // regardless of parent constraints (like AppBar leading slots),
    // making margins and padding behave predictably.
    return UnconstrainedBox(child: button);
  }
}
