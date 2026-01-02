import 'package:flutter/material.dart';

class AppliedButton extends ThemeExtension<AppliedButton> {
  final Color primaryDefault;
  final Color primaryActive;
  final Color primaryDisabled;
  final Color primaryHover;
  final Color primaryTertiary;
  final Color dangerDefault;
  final Color dangerActive;
  final Color dangerDisabled;
  final Color dangerHover;
  final Color dangerTertiary;
  final Color neutralDefault;
  final Color neutralActive;
  final Color neutralDisabled;
  final Color neutralHover;
  final Color neutralTertiary;

  const AppliedButton({
    this.primaryDefault = Colors.red,
    this.primaryActive = Colors.red,
    this.primaryDisabled = Colors.red,
    this.primaryHover = Colors.red,
    this.primaryTertiary = Colors.red,
    this.dangerDefault = Colors.red,
    this.dangerActive = Colors.red,
    this.dangerDisabled = Colors.red,
    this.dangerHover = Colors.red,
    this.dangerTertiary = Colors.red,
    this.neutralDefault = Colors.red,
    this.neutralActive = Colors.red,
    this.neutralDisabled = Colors.red,
    this.neutralHover = Colors.red,
    this.neutralTertiary = Colors.red,
  });

  @override
  ThemeExtension<AppliedButton> copyWith({
    Color? primaryDefault,
    Color? primaryActive,
    Color? primaryDisabled,
    Color? primaryHover,
    Color? primaryTertiary,
    Color? dangerDefault,
    Color? dangerActive,
    Color? dangerDisabled,
    Color? dangerHover,
    Color? dangerTertiary,
    Color? neutralDefault,
    Color? neutralActive,
    Color? neutralDisabled,
    Color? neutralHover,
    Color? neutralTertiary,
  }) {
    return AppliedButton(
      primaryDefault: primaryDefault ?? this.primaryDefault,
      primaryActive: primaryActive ?? this.primaryActive,
      primaryDisabled: primaryDisabled ?? this.primaryDisabled,
      primaryHover: primaryHover ?? this.primaryHover,
      primaryTertiary: primaryTertiary ?? this.primaryTertiary,
      dangerDefault: dangerDefault ?? this.dangerDefault,
      dangerActive: dangerActive ?? this.dangerActive,
      dangerDisabled: dangerDisabled ?? this.dangerDisabled,
      dangerHover: dangerHover ?? this.dangerHover,
      dangerTertiary: dangerTertiary ?? this.dangerTertiary,
      neutralDefault: neutralDefault ?? this.neutralDefault,
      neutralActive: neutralActive ?? this.neutralActive,
      neutralDisabled: neutralDisabled ?? this.neutralDisabled,
      neutralHover: neutralHover ?? this.neutralHover,
      neutralTertiary: neutralTertiary ?? this.neutralTertiary,
    );
  }

  @override
  ThemeExtension<AppliedButton> lerp(
    covariant ThemeExtension<AppliedButton>? other,
    double t,
  ) {
    if (other is! AppliedButton) {
      return this;
    }
    return AppliedButton(
      primaryDefault:
          Color.lerp(primaryDefault, other.primaryDefault, t) ?? Colors.red,
      primaryActive:
          Color.lerp(primaryActive, other.primaryActive, t) ?? Colors.red,
      primaryDisabled:
          Color.lerp(primaryDisabled, other.primaryDisabled, t) ?? Colors.red,
      primaryHover:
          Color.lerp(primaryHover, other.primaryHover, t) ?? Colors.red,
      primaryTertiary:
          Color.lerp(primaryTertiary, other.primaryTertiary, t) ?? Colors.red,
      dangerDefault:
          Color.lerp(dangerDefault, other.dangerDefault, t) ?? Colors.red,
      dangerActive:
          Color.lerp(dangerActive, other.dangerActive, t) ?? Colors.red,
      dangerDisabled:
          Color.lerp(dangerDisabled, other.dangerDisabled, t) ?? Colors.red,
      dangerHover: Color.lerp(dangerHover, other.dangerHover, t) ?? Colors.red,
      dangerTertiary:
          Color.lerp(dangerTertiary, other.dangerTertiary, t) ?? Colors.red,
      neutralDefault:
          Color.lerp(neutralDefault, other.neutralDefault, t) ?? Colors.red,
      neutralActive:
          Color.lerp(neutralActive, other.neutralActive, t) ?? Colors.red,
      neutralDisabled:
          Color.lerp(neutralDisabled, other.neutralDisabled, t) ?? Colors.red,
      neutralHover:
          Color.lerp(neutralHover, other.neutralHover, t) ?? Colors.red,
      neutralTertiary:
          Color.lerp(neutralTertiary, other.neutralTertiary, t) ?? Colors.red,
    );
  }
}
