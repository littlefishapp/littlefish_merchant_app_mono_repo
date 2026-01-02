import 'package:flutter/material.dart';

class AppliedInformational extends ThemeExtension<AppliedInformational> {
  final Color defaultIcon;
  final Color defaultText;
  final Color defaultBorder;
  final Color defaultSurface;
  final Color successIcon;
  final Color successText;
  final Color successBorder;
  final Color successSurface;
  final Color warningIcon;
  final Color warningText;
  final Color warningBorder;
  final Color warningSurface;
  final Color errorIcon;
  final Color errorText;
  final Color errorBorder;
  final Color errorSurface;
  final Color neutralIcon;
  final Color neutralText;
  final Color neutralBorder;
  final Color neutralSurface;

  const AppliedInformational({
    this.defaultIcon = Colors.red,
    this.defaultText = Colors.red,
    this.defaultBorder = Colors.red,
    this.defaultSurface = Colors.red,
    this.successIcon = Colors.red,
    this.successText = Colors.red,
    this.successBorder = Colors.red,
    this.successSurface = Colors.red,
    this.warningIcon = Colors.red,
    this.warningText = Colors.red,
    this.warningBorder = Colors.red,
    this.warningSurface = Colors.red,
    this.errorIcon = Colors.red,
    this.errorText = Colors.red,
    this.errorBorder = Colors.red,
    this.errorSurface = Colors.red,
    this.neutralIcon = Colors.red,
    this.neutralText = Colors.red,
    this.neutralBorder = Colors.red,
    this.neutralSurface = Colors.red,
  });

  @override
  ThemeExtension<AppliedInformational> copyWith({
    Color? defaultIcon,
    Color? defaultText,
    Color? defaultBorder,
    Color? defaultSurface,
    Color? successIcon,
    Color? successText,
    Color? successBorder,
    Color? successSurface,
    Color? warningIcon,
    Color? warningText,
    Color? warningBorder,
    Color? warningSurface,
    Color? errorIcon,
    Color? errorText,
    Color? errorBorder,
    Color? errorSurface,
    Color? neutralIcon,
    Color? neutralText,
    Color? neutralBorder,
    Color? neutralSurface,
  }) {
    return AppliedInformational(
      defaultIcon: defaultIcon ?? this.defaultIcon,
      defaultText: defaultText ?? this.defaultText,
      defaultBorder: defaultBorder ?? this.defaultBorder,
      defaultSurface: defaultSurface ?? this.defaultSurface,
      successIcon: successIcon ?? this.successIcon,
      successText: successText ?? this.successText,
      successBorder: successBorder ?? this.successBorder,
      successSurface: successSurface ?? this.successSurface,
      warningIcon: warningIcon ?? this.warningIcon,
      warningText: warningText ?? this.warningText,
      warningBorder: warningBorder ?? this.warningBorder,
      warningSurface: warningSurface ?? this.warningSurface,
      errorIcon: errorIcon ?? this.errorIcon,
      errorText: errorText ?? this.errorText,
      errorBorder: errorBorder ?? this.errorBorder,
      errorSurface: errorSurface ?? this.errorSurface,
      neutralIcon: neutralIcon ?? this.neutralIcon,
      neutralText: neutralText ?? this.neutralText,
      neutralBorder: neutralBorder ?? this.neutralBorder,
      neutralSurface: neutralSurface ?? this.neutralSurface,
    );
  }

  @override
  ThemeExtension<AppliedInformational> lerp(
    covariant ThemeExtension<AppliedInformational>? other,
    double t,
  ) {
    if (other is! AppliedInformational) {
      return this;
    }
    return AppliedInformational(
      defaultIcon: Color.lerp(defaultIcon, other.defaultIcon, t) ?? Colors.red,
      defaultText: Color.lerp(defaultText, other.defaultText, t) ?? Colors.red,
      defaultBorder:
          Color.lerp(defaultBorder, other.defaultBorder, t) ?? Colors.red,
      defaultSurface:
          Color.lerp(defaultSurface, other.defaultSurface, t) ?? Colors.red,
      successIcon: Color.lerp(successIcon, other.successIcon, t) ?? Colors.red,
      successText: Color.lerp(successText, other.successText, t) ?? Colors.red,
      successBorder:
          Color.lerp(successBorder, other.successBorder, t) ?? Colors.red,
      successSurface:
          Color.lerp(successSurface, other.successSurface, t) ?? Colors.red,
      warningIcon: Color.lerp(warningIcon, other.warningIcon, t) ?? Colors.red,
      warningText: Color.lerp(warningText, other.warningText, t) ?? Colors.red,
      warningBorder:
          Color.lerp(warningBorder, other.warningBorder, t) ?? Colors.red,
      warningSurface:
          Color.lerp(warningSurface, other.warningSurface, t) ?? Colors.red,
      errorIcon: Color.lerp(errorIcon, other.errorIcon, t) ?? Colors.red,
      errorText: Color.lerp(errorText, other.errorText, t) ?? Colors.red,
      errorBorder: Color.lerp(errorBorder, other.errorBorder, t) ?? Colors.red,
      errorSurface:
          Color.lerp(errorSurface, other.errorSurface, t) ?? Colors.red,
      neutralIcon: Color.lerp(neutralIcon, other.neutralIcon, t) ?? Colors.red,
      neutralText: Color.lerp(neutralText, other.neutralText, t) ?? Colors.red,
      neutralBorder:
          Color.lerp(neutralBorder, other.neutralBorder, t) ?? Colors.red,
      neutralSurface:
          Color.lerp(neutralSurface, other.neutralSurface, t) ?? Colors.red,
    );
  }
}
