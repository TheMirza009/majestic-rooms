import 'package:flutter/material.dart';
import 'package:majestic_rooms/core/theme/custom_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: 'Fustat',
      primaryColor: CustomColors.brandRed,
      scaffoldBackgroundColor: CustomColors.bgLight,

      colorScheme: const ColorScheme.light(
        primary: CustomColors.brandRed,
        secondary: CustomColors.luxuryGold,
        tertiary: CustomColors.premiumAmber,
        surface: CustomColors.surfaceWhite,
        onPrimary: CustomColors.textLight,
        onSecondary: CustomColors.primaryDark,
        onSurface: CustomColors.textMain,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: CustomColors.brandBlack,
        elevation: 0,
        centerTitle: true,
      ),

      cardTheme: const CardThemeData(
        color: CustomColors.surfaceWhite,
        elevation: 2,
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: CustomColors.luxuryGold,
          foregroundColor: CustomColors.primaryDark,
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      dividerTheme: const DividerThemeData(
        color: CustomColors.cardSubtleBg,
        thickness: 1,
      ),

      textTheme: const TextTheme(
        displayLarge:   TextStyle(color: CustomColors.textMain,  fontWeight: FontWeight.bold, fontSize: 32),
        headlineMedium: TextStyle(color: CustomColors.textMain,  fontWeight: FontWeight.w600, fontSize: 24),
        bodyLarge:      TextStyle(color: CustomColors.textMain,  fontSize: 16, height: 1.5),
        bodyMedium:     TextStyle(color: CustomColors.textMuted, fontSize: 14, height: 1.4),
      ),
    );
  }
}
