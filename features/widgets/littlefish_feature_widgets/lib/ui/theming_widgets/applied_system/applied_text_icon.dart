import 'package:flutter/material.dart';

class AppliedTextIcon extends ThemeExtension<AppliedTextIcon> {
  final Color primary;
  final Color primaryHeader;
  final Color secondary;
  final Color emphasized;
  final Color deEmphasized;
  final Color disabled;
  final Color inversePrimary;
  final Color inverseSecondary;
  final Color inverseEmphasized;
  final Color inverseDeEmphasized;
  final Color inverseDisabled;
  final Color brand;
  final Color success;
  final Color successAlt;
  final Color error;
  final Color errorAlt;
  final Color accent;
  final Color accentAlt;
  final Color warning;
  final Color warningAlt;
  final Color positive;
  final Color positiveAlt;

  const AppliedTextIcon({
    this.primary = Colors.red,
    this.primaryHeader = Colors.red,
    this.secondary = Colors.red,
    this.emphasized = Colors.red,
    this.deEmphasized = Colors.red,
    this.disabled = Colors.red,
    this.inversePrimary = Colors.red,
    this.inverseSecondary = Colors.red,
    this.inverseEmphasized = Colors.red,
    this.inverseDeEmphasized = Colors.red,
    this.inverseDisabled = Colors.red,
    this.brand = Colors.red,
    this.success = Colors.red,
    this.successAlt = Colors.red,
    this.error = Colors.red,
    this.errorAlt = Colors.red,
    this.accent = Colors.red,
    this.accentAlt = Colors.red,
    this.warning = Colors.red,
    this.warningAlt = Colors.red,
    this.positive = Colors.red,
    this.positiveAlt = Colors.red,
  });

  @override
  ThemeExtension<AppliedTextIcon> copyWith({
    Color? primary,
    Color? primaryHeader,
    Color? secondary,
    Color? emphasized,
    Color? deEmphasized,
    Color? disabled,
    Color? inversePrimary,
    Color? inverseSecondary,
    Color? inverseEmphasized,
    Color? inverseDeEmphasized,
    Color? inverseDisabled,
    Color? brand,
    Color? success,
    Color? successAlt,
    Color? error,
    Color? errorAlt,
    Color? accent,
    Color? accentAlt,
    Color? warning,
    Color? warningAlt,
    Color? positive,
    Color? positiveAlt,
  }) {
    return AppliedTextIcon(
      primary: primary ?? this.primary,
      primaryHeader: primaryHeader ?? this.primaryHeader,
      secondary: secondary ?? this.secondary,
      emphasized: emphasized ?? this.emphasized,
      deEmphasized: deEmphasized ?? this.deEmphasized,
      disabled: disabled ?? this.disabled,
      inversePrimary: inversePrimary ?? this.inversePrimary,
      inverseSecondary: inverseSecondary ?? this.inverseSecondary,
      inverseEmphasized: inverseEmphasized ?? this.inverseEmphasized,
      inverseDeEmphasized: inverseDeEmphasized ?? this.inverseDeEmphasized,
      inverseDisabled: inverseDisabled ?? this.inverseDisabled,
      brand: brand ?? this.brand,
      success: success ?? this.success,
      successAlt: successAlt ?? this.successAlt,
      error: error ?? this.error,
      errorAlt: errorAlt ?? this.errorAlt,
      accent: accent ?? this.accent,
      accentAlt: accentAlt ?? this.accentAlt,
      warning: warning ?? this.warning,
      warningAlt: warningAlt ?? this.warningAlt,
      positive: positive ?? this.positive,
      positiveAlt: positiveAlt ?? this.positiveAlt,
    );
  }

  @override
  ThemeExtension<AppliedTextIcon> lerp(
    covariant ThemeExtension<AppliedTextIcon>? other,
    double t,
  ) {
    if (other is! AppliedTextIcon) {
      return this;
    }
    return AppliedTextIcon(
      primary: Color.lerp(primary, other.primary, t) ?? Colors.red,
      primaryHeader:
          Color.lerp(primaryHeader, other.primaryHeader, t) ?? Colors.red,
      secondary: Color.lerp(secondary, other.secondary, t) ?? Colors.red,
      emphasized: Color.lerp(emphasized, other.emphasized, t) ?? Colors.red,
      deEmphasized:
          Color.lerp(deEmphasized, other.deEmphasized, t) ?? Colors.red,
      disabled: Color.lerp(disabled, other.disabled, t) ?? Colors.red,
      inversePrimary:
          Color.lerp(inversePrimary, other.inversePrimary, t) ?? Colors.red,
      inverseSecondary:
          Color.lerp(inverseSecondary, other.inverseSecondary, t) ?? Colors.red,
      inverseEmphasized:
          Color.lerp(inverseEmphasized, other.inverseEmphasized, t) ??
          Colors.red,
      inverseDeEmphasized:
          Color.lerp(inverseDeEmphasized, other.inverseDeEmphasized, t) ??
          Colors.red,
      inverseDisabled:
          Color.lerp(inverseDisabled, other.inverseDisabled, t) ?? Colors.red,
      brand: Color.lerp(brand, other.brand, t) ?? Colors.red,
      success: Color.lerp(success, other.success, t) ?? Colors.red,
      successAlt: Color.lerp(successAlt, other.successAlt, t) ?? Colors.red,
      error: Color.lerp(error, other.error, t) ?? Colors.red,
      errorAlt: Color.lerp(errorAlt, other.errorAlt, t) ?? Colors.red,
      accent: Color.lerp(accent, other.accent, t) ?? Colors.red,
      accentAlt: Color.lerp(accentAlt, other.accentAlt, t) ?? Colors.red,
      warning: Color.lerp(warning, other.warning, t) ?? Colors.red,
      warningAlt: Color.lerp(warningAlt, other.warningAlt, t) ?? Colors.red,
      positive: Color.lerp(positive, other.positive, t) ?? Colors.red,
      positiveAlt: Color.lerp(positiveAlt, other.positiveAlt, t) ?? Colors.red,
    );
  }
}
