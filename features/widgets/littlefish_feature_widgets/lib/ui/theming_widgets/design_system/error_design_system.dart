class ErrorDesignSystem {
  final String primary;
  final String emphasized;
  final String deEmphasized;
  final String deEmphasized2;
  final String deEmphasized3;

  const ErrorDesignSystem({
    this.primary = '',
    this.emphasized = '',
    this.deEmphasized = '',
    this.deEmphasized2 = '',
    this.deEmphasized3 = '',
  });

  factory ErrorDesignSystem.fromJson(Map<String, dynamic> json) =>
      ErrorDesignSystem(
        primary: json['primary'] ?? '',
        emphasized: json['emphasized'] ?? '',
        deEmphasized: json['deEmphasized1'] ?? '',
        deEmphasized2: json['deEmphasized2'] ?? '',
        deEmphasized3: json['deEmphasized3'] ?? '',
      );

  Map<String, dynamic> toJson() => {
    'primary': primary,
    'emphasized': emphasized,
    'deEmphasized': deEmphasized,
    'deEmphasized2': deEmphasized2,
    'deEmphasized3': deEmphasized3,
  };
}
