import 'package:flutter/material.dart';
import 'package:majestic_rooms/core/theme/app_dimens_extension.dart';
import 'package:majestic_rooms/core/theme/custom_colors.dart';

extension ThemeContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;
  AppDimensExtension get dimens => theme.extension<AppDimensExtension>()!;

  // Semantic mappings routing to native Theme data
  Color get primaryColor => colorScheme.primary;
  Color get secondaryColor => colorScheme.secondary;
  Color get surfaceColor => colorScheme.surface;
  Color get scaffoldBackgroundColor => theme.scaffoldBackgroundColor;

  // Typography Colors
  Color get textMainColor => colorScheme.onSurface;
  Color get textMutedColor => colorScheme.onSurfaceVariant;
  Color get textLightColor => colorScheme.onPrimary;

  // Utilities
  Color get borderColor => colorScheme.outline;
  Color get hintColor => theme.hintColor;
  Color get successColor => CustomColors.successColor; 

  // Specific brand colors that don't fit perfectly in standard semantic slots
  // (We use CustomColors directly as a fallback for these)
  Color get whatsappGreen => CustomColors.whatsappGreen;

  Color get tertiaryColor => colorScheme.tertiary;
  Color get errorColor => colorScheme.error;
}
