import 'package:flutter/material.dart';

class AppliedSurface extends ThemeExtension<AppliedSurface> {
  final Color primary;
  final Color primaryHeader;
  final Color secondary;
  final Color contrast;
  final Color heavyContrast;
  final Color inverse;
  final Color brand;
  final Color brandSubTitle;
  final Color success;
  final Color successSubTitle;
  final Color successEmphasized;
  final Color warning;
  final Color warningSubTitle;
  final Color warningEmphasized;
  final Color error;
  final Color errorSubTitle;
  final Color errorEmphasized;
  final Color positive;
  final Color positiveSubTitle;
  final Color positiveEmphasized;

  const AppliedSurface({
    this.primary = Colors.red,
    this.primaryHeader = Colors.red,
    this.secondary = Colors.red,
    this.contrast = Colors.red,
    this.heavyContrast = Colors.red,
    this.inverse = Colors.red,
    this.brand = Colors.red,
    this.brandSubTitle = Colors.red,
    this.success = Colors.red,
    this.successSubTitle = Colors.red,
    this.successEmphasized = Colors.red,
    this.warning = Colors.red,
    this.warningSubTitle = Colors.red,
    this.warningEmphasized = Colors.red,
    this.error = Colors.red,
    this.errorSubTitle = Colors.red,
    this.errorEmphasized = Colors.red,
    this.positive = Colors.red,
    this.positiveSubTitle = Colors.red,
    this.positiveEmphasized = Colors.red,
  });

  @override
  ThemeExtension<AppliedSurface> copyWith({
    Color? primary,
    Color? primaryHeader,
    Color? secondary,
    Color? contrast,
    Color? heavyContrast,
    Color? inverse,
    Color? brand,
    Color? brandSubTitle,
    Color? success,
    Color? successSubTitle,
    Color? successEmphasized,
    Color? warning,
    Color? warningSubTitle,
    Color? warningEmphasized,
    Color? error,
    Color? errorSubTitle,
    Color? errorEmphasized,
    Color? positive,
    Color? positiveSubTitle,
    Color? positiveEmphasized,
  }) {
    return AppliedSurface(
      primary: primary ?? this.primary,
      primaryHeader: primaryHeader ?? this.primaryHeader,
      secondary: secondary ?? this.secondary,
      contrast: contrast ?? this.contrast,
      heavyContrast: heavyContrast ?? this.heavyContrast,
      inverse: inverse ?? this.inverse,
      brand: brand ?? this.brand,
      brandSubTitle: brandSubTitle ?? this.brandSubTitle,
      success: success ?? this.success,
      successSubTitle: successSubTitle ?? this.successSubTitle,
      successEmphasized: successEmphasized ?? this.successEmphasized,
      warning: warning ?? this.warning,
      warningSubTitle: warningSubTitle ?? this.warningSubTitle,
      warningEmphasized: warningSubTitle ?? this.warningEmphasized,
      error: error ?? this.error,
      errorSubTitle: errorSubTitle ?? this.errorSubTitle,
      errorEmphasized: errorEmphasized ?? this.errorEmphasized,
      positive: positive ?? this.positive,
      positiveSubTitle: positiveSubTitle ?? this.errorSubTitle,
      positiveEmphasized: errorEmphasized ?? this.errorEmphasized,
    );
  }

  @override
  ThemeExtension<AppliedSurface> lerp(
    covariant ThemeExtension<AppliedSurface>? other,
    double t,
  ) {
    if (other is! AppliedSurface) {
      return this;
    }
    return AppliedSurface(
      primary: Color.lerp(primary, other.primary, t) ?? Colors.red,
      primaryHeader:
          Color.lerp(primaryHeader, other.primaryHeader, t) ?? Colors.red,
      secondary: Color.lerp(secondary, other.secondary, t) ?? Colors.red,
      contrast: Color.lerp(contrast, other.contrast, t) ?? Colors.red,
      heavyContrast:
          Color.lerp(heavyContrast, other.heavyContrast, t) ?? Colors.red,
      inverse: Color.lerp(inverse, other.inverse, t) ?? Colors.red,
      brand: Color.lerp(brand, other.brand, t) ?? Colors.red,
      brandSubTitle:
          Color.lerp(brandSubTitle, other.brandSubTitle, t) ?? Colors.red,
      success: Color.lerp(success, other.success, t) ?? Colors.red,
      successSubTitle:
          Color.lerp(successSubTitle, other.successSubTitle, t) ?? Colors.red,
      successEmphasized:
          Color.lerp(successEmphasized, other.successEmphasized, t) ??
          Colors.red,
      warning: Color.lerp(warning, other.warning, t) ?? Colors.red,
      warningSubTitle:
          Color.lerp(warningSubTitle, other.warningSubTitle, t) ?? Colors.red,
      warningEmphasized:
          Color.lerp(warningEmphasized, other.warningEmphasized, t) ??
          Colors.red,
      error: Color.lerp(error, other.error, t) ?? Colors.red,
      errorSubTitle:
          Color.lerp(errorSubTitle, other.errorSubTitle, t) ?? Colors.red,
      errorEmphasized:
          Color.lerp(errorEmphasized, other.errorEmphasized, t) ?? Colors.red,
      positive: Color.lerp(positive, other.positive, t) ?? Colors.red,
      positiveSubTitle:
          Color.lerp(positiveSubTitle, other.positiveSubTitle, t) ?? Colors.red,
      positiveEmphasized:
          Color.lerp(positiveEmphasized, other.positiveEmphasized, t) ??
          Colors.red,
    );
  }
}
