
import 'package:flutter/material.dart';
import 'package:majestic_rooms/core/theme/custom_colors.dart';
import 'package:majestic_rooms/root/modules/tabs/explore/explore_controller.dart';
import 'package:majestic_rooms/root/modules/tabs/explore/widgets/city_avatar.dart';

class CityChips extends StatelessWidget {
  final List<String>      categories;
  final List<City>        cities;
  final Set<int>          selectedIndices;
  final bool              isLoading;
  final ValueChanged<int> onSelected;

  const CityChips({
    super.key, 
    required this.categories,
    required this.cities,
    required this.selectedIndices,
    required this.isLoading,
    required this.onSelected,
  });

  @override
  // ── Control Panel ──────────────────────────────────────────────────────
  static const Duration _animDuration  = Duration(milliseconds: 200);
  static const Curve    _animCurve     = Curves.easeInOut;
  static const Color    _activeBg      = CustomColors.brandBlack;
  static const Color    _inactiveBg    = CustomColors.surfaceWhite;
  static const Color    _activeText    = CustomColors.textLight;
  static const Color    _inactiveText  = CustomColors.textMuted;
  static const Color    _borderColor   = Color.fromRGBO(231, 231, 231, 1);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(categories.length, (i) {
          final isSelected = selectedIndices.contains(i);
          return Padding(
            padding: EdgeInsets.only(right: i < categories.length - 1 ? 8 : 0),
            child: GestureDetector(
              onTap: () => onSelected(i),
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
                    if (cities.isNotEmpty)
                      CityAvatar(
                        city: cities[i],
                        isLoading: isLoading,
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
                        child: Text(categories[i]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
