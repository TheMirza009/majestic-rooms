
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:majestic_rooms/core/theme/custom_colors.dart';
import 'package:majestic_rooms/root/modules/tabs/explore/explore_controller.dart';
import 'package:majestic_rooms/root/modules/tabs/explore/widgets/city_avatar.dart';

class CityChips extends StatefulWidget {
  final List<String>      categories;
  final List<City>        cities;
  final Set<int>          selectedIndices;
  final bool              isLoading;
  /// When true, chips are greyed out and taps are ignored (e.g. while a search is in flight).
  final bool              isLocked;
  final ValueChanged<int> onSelected;

  const CityChips({
    super.key, 
    required this.categories,
    required this.cities,
    required this.selectedIndices,
    required this.isLoading,
    this.isLocked = false,
    required this.onSelected,
  });

  @override
  State<CityChips> createState() => _CityChipsState();
}

class _CityChipsState extends State<CityChips> {
  // ── Control Panel ──────────────────────────────────────────────────────
  static const Duration _animDuration  = Duration(milliseconds: 200);
  static const Curve    _animCurve     = Curves.easeInOut;
  static const Color    _activeBg      = CustomColors.brandBlack;
  static const Color    _inactiveBg    = CustomColors.surfaceWhite;
  static const Color    _activeText    = CustomColors.textLight;
  static const Color    _inactiveText  = CustomColors.textMuted;
  static const Color    _borderColor   = Color.fromRGBO(231, 231, 231, 1);

  final Map<int, GlobalKey> _chipKeys = {};

  GlobalKey _getKey(int index) {
    return _chipKeys.putIfAbsent(index, () => GlobalKey());
  }

  void _handleTap(int index) {
    widget.onSelected(index);
    
    // Animate scroll to bring chip into view
    final context = _chipKeys[index]?.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: 0.5,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(widget.categories.length, (i) {
          final isSelected = widget.selectedIndices.contains(i);
          return Padding(
            key: _getKey(i),
            padding: EdgeInsets.only(right: i < widget.categories.length - 1 ? 8 : 0),
            child: Opacity(
              opacity: widget.isLocked ? 0.4 : 1.0,
              child: GestureDetector(
                onTap: widget.isLocked ? null : () => _handleTap(i),
                child: AnimatedContainer(
                  duration: _animDuration,
                  curve: _animCurve,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected ? _activeBg : _inactiveBg,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color:_borderColor)
                  ),
                  child: Row(
                    spacing: 8,
                    children: [
                      if (widget.cities.isNotEmpty)
                        CityAvatar(
                          city: widget.cities[i],
                          isLoading: widget.isLoading,
                          size: 28,
                        ),
                      AnimatedDefaultTextStyle(
                        duration: _animDuration,
                        curve: _animCurve,
                        style: TextStyle(
                          color: isSelected ? _activeText : _inactiveText,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          fontFamily: 'Fustat',
                          fontSize: 14,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(widget.categories[i].tr),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
