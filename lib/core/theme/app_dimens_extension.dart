import 'package:flutter/material.dart';
import 'dart:ui';

class AppDimensExtension extends ThemeExtension<AppDimensExtension> {
  // Radiuses
  final double radiusSmall;
  final double radiusMedium;
  final double radiusLarge;
  final double radiusExtraLarge;
  final double radiusCircular;

  // Paddings
  final EdgeInsets paddingSmall;
  final EdgeInsets paddingMedium;
  final EdgeInsets paddingLarge;

  // Durations
  final Duration durationFast;
  final Duration durationMedium;
  final Duration durationSlow;

  const AppDimensExtension({
    required this.radiusSmall,
    required this.radiusMedium,
    required this.radiusLarge,
    required this.radiusExtraLarge,
    required this.radiusCircular,
    required this.paddingSmall,
    required this.paddingMedium,
    required this.paddingLarge,
    required this.durationFast,
    required this.durationMedium,
    required this.durationSlow,
  });

  factory AppDimensExtension.light() {
    return const AppDimensExtension(
      radiusSmall: 8.0,
      radiusMedium: 12.0,
      radiusLarge: 16.0,
      radiusExtraLarge: 24.0,
      radiusCircular: 50.0,
      paddingSmall: EdgeInsets.all(8.0),
      paddingMedium: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      paddingLarge: EdgeInsets.all(24.0),
      durationFast: Duration(milliseconds: 150),
      durationMedium: Duration(milliseconds: 300),
      durationSlow: Duration(milliseconds: 500),
    );
  }

  @override
  AppDimensExtension copyWith({
    double? radiusSmall,
    double? radiusMedium,
    double? radiusLarge,
    double? radiusExtraLarge,
    double? radiusCircular,
    EdgeInsets? paddingSmall,
    EdgeInsets? paddingMedium,
    EdgeInsets? paddingLarge,
    Duration? durationFast,
    Duration? durationMedium,
    Duration? durationSlow,
  }) {
    return AppDimensExtension(
      radiusSmall: radiusSmall ?? this.radiusSmall,
      radiusMedium: radiusMedium ?? this.radiusMedium,
      radiusLarge: radiusLarge ?? this.radiusLarge,
      radiusExtraLarge: radiusExtraLarge ?? this.radiusExtraLarge,
      radiusCircular: radiusCircular ?? this.radiusCircular,
      paddingSmall: paddingSmall ?? this.paddingSmall,
      paddingMedium: paddingMedium ?? this.paddingMedium,
      paddingLarge: paddingLarge ?? this.paddingLarge,
      durationFast: durationFast ?? this.durationFast,
      durationMedium: durationMedium ?? this.durationMedium,
      durationSlow: durationSlow ?? this.durationSlow,
    );
  }

  @override
  AppDimensExtension lerp(ThemeExtension<AppDimensExtension>? other, double t) {
    if (other is! AppDimensExtension) {
      return this;
    }
    return AppDimensExtension(
      radiusSmall: lerpDouble(radiusSmall, other.radiusSmall, t) ?? radiusSmall,
      radiusMedium:
          lerpDouble(radiusMedium, other.radiusMedium, t) ?? radiusMedium,
      radiusLarge: lerpDouble(radiusLarge, other.radiusLarge, t) ?? radiusLarge,
      radiusExtraLarge:
          lerpDouble(radiusExtraLarge, other.radiusExtraLarge, t) ??
          radiusExtraLarge,
      radiusCircular:
          lerpDouble(radiusCircular, other.radiusCircular, t) ?? radiusCircular,
      paddingSmall:
          EdgeInsets.lerp(paddingSmall, other.paddingSmall, t) ?? paddingSmall,
      paddingMedium:
          EdgeInsets.lerp(paddingMedium, other.paddingMedium, t) ??
          paddingMedium,
      paddingLarge:
          EdgeInsets.lerp(paddingLarge, other.paddingLarge, t) ?? paddingLarge,
      durationFast:
          durationFast, // Durations don't lerp natively easily, usually static
      durationMedium: durationMedium,
      durationSlow: durationSlow,
    );
  }
}
