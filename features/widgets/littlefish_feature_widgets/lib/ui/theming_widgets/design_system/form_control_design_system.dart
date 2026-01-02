class FormControlDesignSystem {
  final String active;
  final String inactive;
  final String activeForeground;
  final String inactiveForeground;
  final String colourBg;
  final String fgOnColourBg;

  const FormControlDesignSystem({
    this.active = '',
    this.inactive = '',
    this.activeForeground = '',
    this.inactiveForeground = '',
    this.colourBg = '',
    this.fgOnColourBg = '',
  });

  FormControlDesignSystem copyWith({
    String? inactive,
    String? active,
    String? activeForeground,
    String? inactiveForeground,
    String? colourBg,
    String? fgOnColourBg,
  }) {
    return FormControlDesignSystem(
      inactive: inactive ?? this.inactive,
      active: active ?? this.active,
      activeForeground: activeForeground ?? this.activeForeground,
      inactiveForeground: inactiveForeground ?? this.inactiveForeground,
      colourBg: colourBg ?? this.colourBg,
      fgOnColourBg: fgOnColourBg ?? this.fgOnColourBg,
    );
  }

  factory FormControlDesignSystem.fromJson(Map<String, dynamic> json) =>
      FormControlDesignSystem(
        active: json['active'] ?? '',
        inactive: json['inactive'] ?? '',
        activeForeground: json['active-foreground'] ?? '',
        inactiveForeground: json['inactive-foreground'] ?? '',
        colourBg: json['colourBg'] ?? '',
        fgOnColourBg: json['fgOnColourBg'] ?? '',
      );

  Map<String, dynamic> toJson() => {
    'active': active,
    'inactive': inactive,
    'active-foreground': activeForeground,
    'inactive-foreground': inactiveForeground,
    'colourBg': colourBg,
    'fgOnColourBg': fgOnColourBg,
  };
}
