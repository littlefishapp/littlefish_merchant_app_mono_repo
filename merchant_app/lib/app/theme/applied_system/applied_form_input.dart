import 'package:flutter/material.dart';

class AppliedFormInput extends ThemeExtension<AppliedFormInput> {
  final Color borderDefault;
  final Color borderFocused;
  final Color borderDisabled;
  final Color borderInverseDefault;
  final Color borderInverseFocused;
  final Color borderInverseDisabled;
  final Color textDefault;
  final Color textPlaceholder;
  final Color textDisabled;
  final Color inverseTextDefault;
  final Color inverseTextPlaceholder;
  final Color inverseTextDisabled;

  const AppliedFormInput({
    this.borderDefault = Colors.red,
    this.borderFocused = Colors.red,
    this.borderDisabled = Colors.red,
    this.borderInverseDefault = Colors.red,
    this.borderInverseFocused = Colors.red,
    this.borderInverseDisabled = Colors.red,
    this.textDefault = Colors.red,
    this.textPlaceholder = Colors.red,
    this.textDisabled = Colors.red,
    this.inverseTextDefault = Colors.red,
    this.inverseTextPlaceholder = Colors.red,
    this.inverseTextDisabled = Colors.red,
  });

  @override
  ThemeExtension<AppliedFormInput> copyWith({
    Color? borderDefault,
    Color? borderFocused,
    Color? borderDisabled,
    Color? borderInverseDefault,
    Color? borderInverseFocused,
    Color? borderInverseDisabled,
    Color? textDefault,
    Color? textPlaceholder,
    Color? textDisabled,
    Color? inverseTextDefault,
    Color? inverseTextPlaceholder,
    Color? inverseTextDisabled,
  }) {
    return AppliedFormInput(
      borderDefault: borderDefault ?? this.borderDefault,
      borderFocused: borderFocused ?? this.borderFocused,
      borderDisabled: borderDisabled ?? this.borderDisabled,
      borderInverseDefault: borderInverseDefault ?? this.borderInverseDefault,
      borderInverseFocused: borderInverseFocused ?? this.borderInverseFocused,
      borderInverseDisabled:
          borderInverseDisabled ?? this.borderInverseDisabled,
      textDefault: textDefault ?? this.textDefault,
      textPlaceholder: textPlaceholder ?? this.textPlaceholder,
      textDisabled: textDisabled ?? this.textDisabled,
      inverseTextDefault: inverseTextDefault ?? this.inverseTextDefault,
      inverseTextPlaceholder:
          inverseTextPlaceholder ?? this.inverseTextPlaceholder,
      inverseTextDisabled: inverseTextDisabled ?? this.inverseTextDisabled,
    );
  }

  @override
  ThemeExtension<AppliedFormInput> lerp(
    covariant ThemeExtension<AppliedFormInput>? other,
    double t,
  ) {
    if (other is! AppliedFormInput) {
      return this;
    }
    return AppliedFormInput(
      borderDefault:
          Color.lerp(borderDefault, other.borderDefault, t) ?? Colors.red,
      borderFocused:
          Color.lerp(borderFocused, other.borderFocused, t) ?? Colors.red,
      borderDisabled:
          Color.lerp(borderDisabled, other.borderDisabled, t) ?? Colors.red,
      borderInverseDefault:
          Color.lerp(borderInverseDefault, other.borderInverseDefault, t) ??
          Colors.red,
      borderInverseFocused:
          Color.lerp(borderInverseFocused, other.borderInverseFocused, t) ??
          Colors.red,
      borderInverseDisabled:
          Color.lerp(borderInverseDisabled, other.borderInverseDisabled, t) ??
          Colors.red,
      textDefault: Color.lerp(textDefault, other.textDefault, t) ?? Colors.red,
      textPlaceholder:
          Color.lerp(textPlaceholder, other.textPlaceholder, t) ?? Colors.red,
      textDisabled:
          Color.lerp(textDisabled, other.textDisabled, t) ?? Colors.red,
      inverseTextDefault:
          Color.lerp(inverseTextDefault, other.inverseTextDefault, t) ??
          Colors.red,
      inverseTextPlaceholder:
          Color.lerp(inverseTextPlaceholder, other.inverseTextPlaceholder, t) ??
          Colors.red,
      inverseTextDisabled:
          Color.lerp(inverseTextDisabled, other.inverseTextDisabled, t) ??
          Colors.red,
    );
  }
}
