class FormInputDesignSystem {
  final String borderDefault;
  final String borderFocused;
  final String borderDisabled;
  final String borderInverseDefault;
  final String borderInverseFocused;
  final String borderInverseDisabled;
  final String textDefault;
  final String textPlaceholder;
  final String textDisabled;
  final String inverseTextDefault;
  final String inverseTextPlaceholder;
  final String inverseTextDisabled;

  const FormInputDesignSystem({
    this.borderDefault = '',
    this.borderFocused = '',
    this.borderDisabled = '',
    this.borderInverseDefault = '',
    this.borderInverseFocused = '',
    this.borderInverseDisabled = '',
    this.textDefault = '',
    this.textPlaceholder = '',
    this.textDisabled = '',
    this.inverseTextDefault = '',
    this.inverseTextPlaceholder = '',
    this.inverseTextDisabled = '',
  });

  FormInputDesignSystem copyWith({
    String? borderDefault,
    String? borderFocused,
    String? borderDisabled,
    String? borderInverseDefault,
    String? borderInverseFocused,
    String? borderInverseDisabled,
    String? textDefault,
    String? textPlaceholder,
    String? textDisabled,
    String? inverseTextDefault,
    String? inverseTextPlaceholder,
    String? inverseTextDisabled,
  }) {
    return FormInputDesignSystem(
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

  factory FormInputDesignSystem.fromJson(Map<String, dynamic> json) =>
      FormInputDesignSystem(
        borderDefault: json['borderDefault'] ?? '',
        borderFocused: json['borderFocused'] ?? '',
        borderDisabled: json['borderDisabled'] ?? '',
        borderInverseDefault: json['borderInverse-default'] ?? '',
        borderInverseFocused: json['borderInverse-focused'] ?? '',
        borderInverseDisabled: json['borderInverse-disabled'] ?? '',
        textDefault: json['textDefault'] ?? '',
        textPlaceholder: json['textPlaceholder'] ?? '',
        textDisabled: json['textDisabled'] ?? '',
        inverseTextDefault: json['inverseTextDefault'] ?? '',
        inverseTextPlaceholder: json['inverseTextPlaceholder'] ?? '',
        inverseTextDisabled: json['inverseTextDisabled'] ?? '',
      );

  Map<String, dynamic> toJson() => {
    'borderDefault': borderDefault,
    'borderFocused': borderFocused,
    'borderDisabled': borderDisabled,
    'borderInverse-default': borderInverseDefault,
    'borderInverse-focused': borderInverseFocused,
    'borderInverse-disabled': borderInverseDisabled,
    'textDefault': textDefault,
    'textPlaceholder': textPlaceholder,
    'textDisabled': textDisabled,
    'inverseTextDefault': inverseTextDefault,
    'inverseTextPlaceholder': inverseTextPlaceholder,
    'inverseTextDisabled': inverseTextDisabled,
  };
}
