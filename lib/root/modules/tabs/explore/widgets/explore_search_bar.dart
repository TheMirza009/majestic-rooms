import 'package:majestic_rooms/core/theme/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:majestic_rooms/core/theme/theme_context_extension.dart';
import 'package:majestic_rooms/core/theme/vector_strings.dart';
import 'package:majestic_rooms/root/widgets/field_clear_button.dart';

class ExploreSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onSearchTap;
  final VoidCallback? onFilterTap;
  final Widget? suffixIcon;
  final bool showSuffixIcon;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final bool isSearching;
  final bool isFilterOn;

  const ExploreSearchBar({
    super.key,
    required this.controller,
    this.onSearchTap,
    this.onFilterTap,
    this.suffixIcon,
    this.showSuffixIcon = true,
    this.hintText,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.isSearching = false,
    this.isFilterOn = true,
  });

  // ── Control Panel ──────────────────────────────────────────────────────
  static const double _radius = 50;

  @override
  Widget build(BuildContext context) {
    final _fill = context.surfaceColor;
    final _border = context.borderColor;
    final _focusBorder = CustomColors.brandBlack;

    return TextField(
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        hintText: hintText ?? 'Search hotels, resorts...'.tr,
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 4),
          child: IconButton(
            onPressed: isSearching ? null : onSearchTap,
            icon: isSearching
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(
                    Icons.search_rounded,
                    color: isSearching ? Colors.grey.shade400 : null,
                  ),
          ),
        ),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FieldClearButton(
              controller: controller,
              iconColor: isSearching
                  ? Colors.grey.shade400
                  : CustomColors.linkColor,
              onClear: () {
                if (isSearching) return;
                controller.clear();
                onClear?.call();
              },
            ),
            if (showSuffixIcon)
              suffixIcon ??
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: IconButton(
                      onPressed: isSearching ? null : onFilterTap,
                      icon: isFilterOn
                          ? Icon(
                              Icons.tune_rounded,
                              color: isSearching ? Colors.grey.shade400 : null,
                            )
                          : Builder(
                              builder: (ctx) => SvgPicture.string(
                                VectorStrings.tuneOff,
                                width: 24,
                                height: 24,
                                colorFilter: ColorFilter.mode(
                                  isSearching
                                      ? Colors.grey.shade400
                                      : IconTheme.of(ctx).color ?? Colors.black,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                    ),
                  ),
          ],
        ),
        filled: true,
        fillColor: _fill,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radius),
          borderSide: BorderSide(color: _border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radius),
          borderSide: BorderSide(color: _border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radius),
          borderSide: BorderSide(color: _focusBorder, width: 1.5),
        ),
      ),
    );
  }
}
