class InformationalNeutralDesignSystem {
  final String icon;
  final String text;
  final String border;
  final String surface;

  const InformationalNeutralDesignSystem({
    this.icon = '',
    this.text = '',
    this.border = '',
    this.surface = '',
  });

  InformationalNeutralDesignSystem copyWith({
    String? icon,
    String? text,
    String? border,
    String? surface,
  }) {
    return InformationalNeutralDesignSystem(
      icon: icon ?? this.icon,
      text: text ?? this.text,
      border: border ?? this.border,
      surface: surface ?? this.surface,
    );
  }

  factory InformationalNeutralDesignSystem.fromJson(Map<String, dynamic> json) {
    return InformationalNeutralDesignSystem(
      icon: json['icon'] ?? '',
      text: json['text'] ?? '',
      border: json['border'] ?? '',
      surface: json['surface'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'icon': icon,
    'text': text,
    'border': border,
    'surface': surface,
  };
}
