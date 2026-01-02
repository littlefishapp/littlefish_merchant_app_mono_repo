class AppliedSurfaceDesignSystem {
  final String primary;
  final String primaryHeader;
  final String secondary;
  final String contrast;
  final String heavyContrast;
  final String inverse;
  final String brand;
  final String brandSubtitle;
  final String success;
  final String successSubtitle;
  final String successEmphasized;
  final String warning;
  final String warningSubtitle;
  final String warningEmphasized;
  final String error;
  final String errorSubtitle;
  final String errorEmphasized;
  final String positive;
  final String positiveSubtitle;
  final String positiveEmphasized;

  const AppliedSurfaceDesignSystem({
    this.primary = '',
    this.primaryHeader = '',
    this.secondary = '',
    this.contrast = '',
    this.heavyContrast = '',
    this.inverse = '',
    this.brand = '',
    this.brandSubtitle = '',
    this.success = '',
    this.successSubtitle = '',
    this.successEmphasized = '',
    this.warning = '',
    this.warningSubtitle = '',
    this.warningEmphasized = '',
    this.error = '',
    this.errorSubtitle = '',
    this.errorEmphasized = '',
    this.positive = '',
    this.positiveSubtitle = '',
    this.positiveEmphasized = '',
  });

  AppliedSurfaceDesignSystem copyWith({
    String? primary,
    String? primaryHeader,
    String? secondary,
    String? contrast,
    String? heavyContrast,
    String? inverse,
    String? brand,
    String? brandSubtitle,
    String? success,
    String? successSubtitle,
    String? successEmphasized,
    String? warning,
    String? warningSubtitle,
    String? warningEmphasized,
    String? error,
    String? errorSubtitle,
    String? errorEmphasized,
    String? positive,
    String? positiveSubtitle,
    String? positiveEmphasized,
  }) {
    return AppliedSurfaceDesignSystem(
      primary: primary ?? this.primary,
      primaryHeader: primaryHeader ?? this.primaryHeader,
      secondary: secondary ?? this.secondary,
      contrast: contrast ?? this.contrast,
      heavyContrast: heavyContrast ?? this.heavyContrast,
      inverse: inverse ?? this.inverse,
      brand: brand ?? this.brand,
      brandSubtitle: brandSubtitle ?? this.brandSubtitle,
      success: success ?? this.success,
      successSubtitle: successSubtitle ?? this.successSubtitle,
      successEmphasized: successEmphasized ?? this.successEmphasized,
      warning: warning ?? this.warning,
      warningSubtitle: warningSubtitle ?? this.warningSubtitle,
      warningEmphasized: warningEmphasized ?? this.warningEmphasized,
      error: error ?? this.error,
      errorSubtitle: errorSubtitle ?? this.errorSubtitle,
      errorEmphasized: errorEmphasized ?? this.errorEmphasized,
      positive: positive ?? this.positive,
      positiveSubtitle: positiveSubtitle ?? this.positiveSubtitle,
      positiveEmphasized: positiveEmphasized ?? this.positiveEmphasized,
    );
  }

  factory AppliedSurfaceDesignSystem.fromJson(Map<String, dynamic> json) {
    return AppliedSurfaceDesignSystem(
      primary: json['primary'] ?? '',
      primaryHeader: json['primaryHeader'] ?? '',
      secondary: json['secondary'] ?? '',
      contrast: json['contrast'] ?? '',
      heavyContrast: json['heavyContrast'] ?? '',
      inverse: json['inverse'] ?? '',
      brand: json['brand'] ?? '',
      brandSubtitle: json['brandSubtitle'] ?? '',
      success: json['success'] ?? '',
      successSubtitle: json['successSubtitle'] ?? '',
      successEmphasized: json['successEmphasized'] ?? '',
      warning: json['warning'] ?? '',
      warningSubtitle: json['warningSubtitle'] ?? '',
      warningEmphasized: json['warningEmphasized'] ?? '',
      error: json['error'] ?? '',
      errorSubtitle: json['errorSubtitle'] ?? '',
      errorEmphasized: json['errorEmphasized'] ?? '',
      positive: json['positive'] ?? '',
      positiveSubtitle: json['positiveSubtitle'] ?? '',
      positiveEmphasized: json['positiveEmphasized'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'primary': primary,
    'primaryHeader': primaryHeader,
    'secondary': secondary,
    'contrast': contrast,
    'heavyContrast': heavyContrast,
    'inverse': inverse,
    'brand': brand,
    'brandSubtitle': brandSubtitle,
    'success': success,
    'successSubtitle': successSubtitle,
    'successEmphasized': successEmphasized,
    'warning': warning,
    'warningSubtitle': warningSubtitle,
    'warningEmphasized': warningEmphasized,
    'error': error,
    'errorSubtitle': errorSubtitle,
    'errorEmphasized': errorEmphasized,
    'positive': positive,
    'positiveSubtitle': positiveSubtitle,
    'positiveEmphasized': positiveEmphasized,
  };
}
