import 'package:flutter/material.dart';

class AppliedNavigation extends ThemeExtension<AppliedNavigation> {
  final Color defaultIcon;
  final Color defaultText;
  final Color activeIcon;
  final Color activeText;
  final Color defaultBackground;
  final Color activeBackground;

  const AppliedNavigation({
    this.defaultIcon = Colors.red,
    this.defaultText = Colors.red,
    this.activeIcon = Colors.red,
    this.activeText = Colors.red,
    this.defaultBackground = Colors.red,
    this.activeBackground = Colors.red,
  });

  @override
  ThemeExtension<AppliedNavigation> copyWith({
    Color? defaultIcon,
    Color? defaultText,
    Color? activeIcon,
    Color? activeText,
    Color? defaultBackground,
    Color? activeBackground,
  }) {
    return AppliedNavigation(
      defaultIcon: defaultIcon ?? this.defaultIcon,
      defaultText: defaultText ?? this.defaultText,
      activeIcon: activeIcon ?? this.activeIcon,
      activeText: activeText ?? this.activeText,
      defaultBackground: defaultBackground ?? this.defaultBackground,
      activeBackground: activeBackground ?? this.activeBackground,
    );
  }

  @override
  ThemeExtension<AppliedNavigation> lerp(
    covariant ThemeExtension<AppliedNavigation>? other,
    double t,
  ) {
    if (other is! AppliedNavigation) {
      return this;
    }
    return AppliedNavigation(
      defaultIcon: Color.lerp(defaultIcon, other.defaultIcon, t) ?? Colors.red,
      defaultText: Color.lerp(defaultText, other.defaultText, t) ?? Colors.red,
      activeIcon: Color.lerp(activeIcon, other.activeIcon, t) ?? Colors.red,
      activeText: Color.lerp(activeText, other.activeText, t) ?? Colors.red,
      defaultBackground:
          Color.lerp(defaultBackground, other.defaultBackground, t) ??
          Colors.red,
      activeBackground:
          Color.lerp(activeBackground, other.activeBackground, t) ?? Colors.red,
    );
  }
}
