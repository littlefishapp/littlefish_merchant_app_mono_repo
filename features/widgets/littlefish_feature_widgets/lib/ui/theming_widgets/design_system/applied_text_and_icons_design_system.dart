class AppliedTextAndIconsDesignSystem {
  final String primary;
  final String primaryHeader;
  final String secondary;
  final String emphasized;
  final String deEmphasized;
  final String disabled;
  final String inversePrimary;
  final String inverseSecondary;
  final String inverseEmphasized;
  final String inverseDeEmphasized;
  final String inverseDisabled;
  final String brand;
  final String success;
  final String successAlt;
  final String error;
  final String errorAlt;
  final String accent;
  final String accentAlt;
  final String warning;
  final String warningAlt;
  final String positive;
  final String positiveAlt;

  const AppliedTextAndIconsDesignSystem({
    this.primary = '',
    this.primaryHeader = '',
    this.secondary = '',
    this.emphasized = '',
    this.deEmphasized = '',
    this.disabled = '',
    this.inversePrimary = '',
    this.inverseSecondary = '',
    this.inverseEmphasized = '',
    this.inverseDeEmphasized = '',
    this.inverseDisabled = '',
    this.brand = '',
    this.success = '',
    this.successAlt = '',
    this.error = '',
    this.errorAlt = '',
    this.accent = '',
    this.accentAlt = '',
    this.warning = '',
    this.warningAlt = '',
    this.positive = '',
    this.positiveAlt = '',
  });

  AppliedTextAndIconsDesignSystem copyWith({
    String? primary,
    String? primaryHeader,
    String? secondary,
    String? emphasized,
    String? deEmphasized,
    String? disabled,
    String? inversePrimary,
    String? inverseSecondary,
    String? inverseEmphasized,
    String? inverseDeEmphasized,
    String? inverseDisabled,
    String? brand,
    String? success,
    String? successAlt,
    String? error,
    String? errorAlt,
    String? accent,
    String? accentAlt,
    String? warning,
    String? warningAlt,
    String? positive,
    String? positiveAlt,
  }) {
    return AppliedTextAndIconsDesignSystem(
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
      warning: warningAlt ?? this.warning,
      warningAlt: warningAlt ?? this.warningAlt,
      positive: positive ?? this.positive,
      positiveAlt: positiveAlt ?? this.positiveAlt,
    );
  }

  factory AppliedTextAndIconsDesignSystem.fromJson(Map<String, dynamic> json) {
    return AppliedTextAndIconsDesignSystem(
      primary: json['primary'] ?? '',
      primaryHeader: json['primaryHeader'] ?? '',
      secondary: json['secondary'] ?? '',
      emphasized: json['emphasized'] ?? '',
      deEmphasized: json['deEmphasized'] ?? '',
      disabled: json['disabled'] ?? '',
      inversePrimary: json['inversePrimary'] ?? '',
      inverseSecondary: json['inverseSecondary'] ?? '',
      inverseEmphasized: json['inverseEmphasized'] ?? '',
      inverseDeEmphasized: json['inverseDeEmphasized'] ?? '',
      inverseDisabled: json['inverseDisabled'] ?? '',
      brand: json['brand'] ?? '',
      success: json['success'] ?? '',
      successAlt: json['successAlt'] ?? '',
      error: json['error'] ?? '',
      errorAlt: json['errorAlt'] ?? '',
      accent: json['accent'] ?? '',
      accentAlt: json['accentAlt'] ?? '',
      warning: json['warning'] ?? '',
      warningAlt: json['warningAlt'] ?? '',
      positive: json['positive'] ?? '',
      positiveAlt: json['positiveAlt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'primary': primary,
    'primaryHeader': primaryHeader,
    'secondary': secondary,
    'emphasized': emphasized,
    'deEmphasized': deEmphasized,
    'disabled': disabled,
    'inversePrimary': inversePrimary,
    'inverseSecondary': inverseSecondary,
    'inverseEmphasized': inverseEmphasized,
    'inverseDeEmphasized': inverseDeEmphasized,
    'inverseDisabled': inverseDisabled,
    'brand': brand,
    'success': success,
    'successAlt': successAlt,
    'error': error,
    'errorAlt': errorAlt,
    'accent': accent,
    'accentAlt': accentAlt,
    'warning': warning,
    'warningAlt': warningAlt,
    'positive': positive,
    'positiveAlt': positiveAlt,
  };
}
