import 'package:flutter/material.dart';

class AppliedFormControl extends ThemeExtension<AppliedFormControl> {
  final Color active;
  final Color inactive;
  final Color activeForeground;
  final Color inactiveForeground;
  final Color colorBackground;
  final Color foregroundOnColorBackground;

  const AppliedFormControl({
    this.active = Colors.red,
    this.inactive = Colors.red,
    this.activeForeground = Colors.red,
    this.inactiveForeground = Colors.red,
    this.colorBackground = Colors.red,
    this.foregroundOnColorBackground = Colors.red,
  });

  @override
  ThemeExtension<AppliedFormControl> copyWith({
    Color? active,
    Color? inactive,
    Color? activeForeground,
    Color? inactiveForeground,
    Color? colorBackground,
    Color? foregroundOnColorBackground,
  }) {
    return AppliedFormControl(
      active: active ?? this.active,
      inactive: inactive ?? this.inactive,
      activeForeground: activeForeground ?? this.activeForeground,
      inactiveForeground: inactiveForeground ?? this.inactiveForeground,
      colorBackground: colorBackground ?? this.colorBackground,
      foregroundOnColorBackground:
          foregroundOnColorBackground ?? this.foregroundOnColorBackground,
    );
  }

  @override
  ThemeExtension<AppliedFormControl> lerp(
    covariant ThemeExtension<AppliedFormControl>? other,
    double t,
  ) {
    if (other is! AppliedFormControl) {
      return this;
    }
    return AppliedFormControl(
      active: Color.lerp(active, other.active, t) ?? Colors.red,
      inactive: Color.lerp(inactive, other.inactive, t) ?? Colors.red,
      activeForeground:
          Color.lerp(activeForeground, other.activeForeground, t) ?? Colors.red,
      inactiveForeground:
          Color.lerp(inactiveForeground, other.inactiveForeground, t) ??
          Colors.red,
      colorBackground:
          Color.lerp(colorBackground, other.colorBackground, t) ?? Colors.red,
      foregroundOnColorBackground:
          Color.lerp(
            foregroundOnColorBackground,
            other.foregroundOnColorBackground,
            t,
          ) ??
          Colors.red,
    );
  }
}
