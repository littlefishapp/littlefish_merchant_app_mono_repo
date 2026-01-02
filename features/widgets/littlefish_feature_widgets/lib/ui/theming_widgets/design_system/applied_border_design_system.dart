class AppliedBorderDesignSystem {
  final String primary;
  final String emphasized;
  final String disabled;
  final String inversePrimary;
  final String inverseEmphasized;
  final String inverseDisabled;
  final String error;
  final String warning;
  final String success;
  final String brand;

  const AppliedBorderDesignSystem({
    this.primary = '',
    this.emphasized = '',
    this.disabled = '',
    this.inversePrimary = '',
    this.inverseEmphasized = '',
    this.inverseDisabled = '',
    this.error = '',
    this.warning = '',
    this.success = '',
    this.brand = '',
  });

  AppliedBorderDesignSystem copyWith({
    String? primary,
    String? emphasized,
    String? disabled,
    String? inversePrimary,
    String? inverseEmphasized,
    String? inverseDisabled,
    String? error,
    String? warning,
    String? success,
    String? brand,
  }) {
    return AppliedBorderDesignSystem(
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

  factory AppliedBorderDesignSystem.fromJson(Map<String, dynamic> json) =>
      AppliedBorderDesignSystem(
        primary: json['primary'] ?? '',
        emphasized: json['emphasized'] ?? '',
        disabled: json['disabled'] ?? '',
        inversePrimary: json['inversePrimary'] ?? '',
        inverseEmphasized: json['inverseEmphasized'] ?? '',
        inverseDisabled: json['inverseDisabled'] ?? '',
        error: json['error'] ?? '',
        warning: json['warning'] ?? '',
        success: json['success'] ?? '',
        brand: json['brand'] ?? '',
      );

  Map<String, dynamic> toJson() => {
    'primary': primary,
    'emphasized': emphasized,
    'disabled': disabled,
    'inversePrimary': inversePrimary,
    'inverseEmphasized': inverseEmphasized,
    'inverseDisabled': inverseDisabled,
    'error': error,
    'warning': warning,
    'success': success,
    'brand': brand,
  };
}
