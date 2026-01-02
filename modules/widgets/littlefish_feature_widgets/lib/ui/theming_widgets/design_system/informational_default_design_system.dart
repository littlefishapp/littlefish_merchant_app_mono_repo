class InformationalDefaultDesignSystem {
  final String icon;
  final String text;
  final String border;
  final String surface;

  const InformationalDefaultDesignSystem({
    this.icon = '',
    this.text = '',
    this.border = '',
    this.surface = '',
  });

  InformationalDefaultDesignSystem copyWith({
    String? icon,
    String? text,
    String? border,
    String? surface,
  }) {
    return InformationalDefaultDesignSystem(
      icon: icon ?? this.icon,
      text: text ?? this.text,
      border: border ?? this.border,
      surface: surface ?? this.surface,
    );
  }

  factory InformationalDefaultDesignSystem.fromJson(Map<String, dynamic> json) {
    return InformationalDefaultDesignSystem(
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
