class WarningDesignSystem {
  final String primary;
  final String emphasized;
  final String deEmphasized;
  final String deEmphasized2;
  final String deEmphasized3;

  const WarningDesignSystem({
    this.primary = '',
    this.emphasized = '',
    this.deEmphasized = '',
    this.deEmphasized2 = '',
    this.deEmphasized3 = '',
  });

  factory WarningDesignSystem.fromJson(Map<String, dynamic> json) =>
      WarningDesignSystem(
        primary: json['primary'] as String,
        emphasized: json['emphasized'] as String,
        deEmphasized: json['deEmphasized1'] as String,
        deEmphasized2: json['deEmphasized2'] as String,
        deEmphasized3: json['deEmphasized3'] as String,
      );

  Map<String, dynamic> toJson() => {
    'primary': primary,
    'emphasized': emphasized,
    'deEmphasized': deEmphasized,
    'deEmphasized2': deEmphasized2,
    'deEmphasized3': deEmphasized3,
  };
}
