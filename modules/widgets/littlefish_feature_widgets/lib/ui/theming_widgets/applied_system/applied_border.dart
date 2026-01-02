import 'package:flutter/material.dart';

class AppliedBorder extends ThemeExtension<AppliedBorder> {
  final Color primary;
  final Color emphasized;
  final Color disabled;
  final Color inversePrimary;
  final Color inverseEmphasized;
  final Color inverseDisabled;
  final Color error;
  final Color warning;
  final Color success;
  final Color brand;

  const AppliedBorder({
    this.primary = Colors.black,
    this.emphasized = Colors.blueAccent,
    this.disabled = Colors.orange,
    this.inversePrimary = Colors.green,
    this.inverseEmphasized = Colors.blue,
    this.inverseDisabled = Colors.yellow,
    this.error = Colors.purple,
    this.warning = Colors.lime,
    this.success = Colors.red,
    this.brand = Colors.yellow,
  });

  @override
  ThemeExtension<AppliedBorder> copyWith({
    Color? primary,
    Color? emphasized,
    Color? disabled,
    Color? inversePrimary,
    Color? inverseEmphasized,
    Color? inverseDisabled,
    Color? error,
    Color? warning,
    Color? success,
    Color? brand,
    Color? brandEmphasized,
  }) {
    return AppliedBorder(
      primary: primary ?? this.primary,
      emphasized: emphasized ?? this.emphasized,
      disabled: disabled ?? this.disabled,
      inversePrimary: inversePrimary ?? this.inversePrimary,
      inverseEmphasized: inverseEmphasized ?? this.inverseEmphasized,
      inverseDisabled: inverseDisabled ?? this.inverseDisabled,
      error: error ?? this.error,
      warning: warning ?? this.warning,
      success: success ?? this.success,
      brand: brand ?? this.brand,
    );
  }

  @override
  ThemeExtension<AppliedBorder> lerp(
    covariant ThemeExtension<AppliedBorder>? other,
    double t,
  ) {
    if (other is! AppliedBorder) {
      return this;
    }
    return AppliedBorder(
      primary: Color.lerp(primary, other.primary, t) ?? Colors.red,
      emphasized: Color.lerp(emphasized, other.emphasized, t) ?? Colors.red,
      disabled: Color.lerp(disabled, other.disabled, t) ?? Colors.red,
      inversePrimary:
          Color.lerp(inversePrimary, other.inversePrimary, t) ?? Colors.red,
      inverseEmphasized:
          Color.lerp(inverseEmphasized, other.inverseEmphasized, t) ??
          Colors.red,
      inverseDisabled:
          Color.lerp(inverseDisabled, other.inverseDisabled, t) ?? Colors.red,
      error: Color.lerp(error, other.error, t) ?? Colors.red,
      warning: Color.lerp(warning, other.warning, t) ?? Colors.red,
      success: Color.lerp(success, other.success, t) ?? Colors.red,
      brand: Color.lerp(brand, other.brand, t) ?? Colors.red,
    );
  }
}
