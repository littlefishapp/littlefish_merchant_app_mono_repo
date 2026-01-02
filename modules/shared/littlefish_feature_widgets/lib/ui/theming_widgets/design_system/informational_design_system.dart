class InformationalDesignSystem {
  final String primary;
  final String primaryInverse;
  final String secondary;
  final String emphasized;
  final String deEmphasized1;
  final String deEmphasized2;
  final String deEmphasized3;

  const InformationalDesignSystem({
    this.primary = '',
    this.primaryInverse = '',
    this.secondary = '',
    this.emphasized = '',
    this.deEmphasized1 = '',
    this.deEmphasized2 = '',
    this.deEmphasized3 = '',
  });

  factory InformationalDesignSystem.fromJson(Map<String, dynamic> json) =>
      InformationalDesignSystem(
        primary: json['primary'] ?? '',
        primaryInverse: json['primaryInverse'] ?? '',
        secondary: json['secondary'] ?? '',
        emphasized: json['emphasized'] ?? '',
        deEmphasized1: json['deEmphasized1'] ?? '',
        deEmphasized2: json['deEmphasized2'] ?? '',
        deEmphasized3: json['deEmphasized3'] ?? '',
      );

  Map<String, dynamic> toJson() => {
    'primary': primary,
    'primaryInverse': primaryInverse,
    'secondary': secondary,
    'emphasized': emphasized,
    'deEmphasized1': deEmphasized1,
    'deEmphasized2': deEmphasized2,
    'deEmphasized3': deEmphasized3,
  };
}
