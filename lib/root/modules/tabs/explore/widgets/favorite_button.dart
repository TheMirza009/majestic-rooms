import 'package:flutter/material.dart';

class FavoriteButton extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;

  const FavoriteButton({super.key, required this.value, this.onChanged});

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton>
    with SingleTickerProviderStateMixin {
  // ── Control Panel ─────────────────────────────────────────────────────────
  static const Duration _bounceDuration = Duration(milliseconds: 350);
  static const double _size = 46;
  static const double _iconSize = 28;
  static const Color _bgColor = Color(0x59000000);
  static const Color _idleColor = Colors.white;
  static const Color _activeColor = Color(0xFFE63946);

  // ── Animation only — boolean truth lives in the parent ───────────────────
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    initializeAnimation();
  }

  void initializeAnimation() {
    _controller = AnimationController(vsync: this, duration: _bounceDuration);
    _scale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 1.3,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.3,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.elasticOut)),
        weight: 60,
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    _controller.forward(from: 0);
    widget.onChanged?.call(!widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: Container(
        width: _size,
        height: _size,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: _bgColor,
        ),
        child: ScaleTransition(
          scale: _scale,
          child: Icon(
            widget.value ? Icons.favorite : Icons.favorite_border,
            color: widget.value ? _activeColor : _idleColor,
            size: _iconSize,
          ),
        ),
      ),
    );
  }
}
