class InformationalErrorDesignSystem {
  final String icon;
  final String text;
  final String border;
  final String surface;

  const InformationalErrorDesignSystem({
    this.icon = '',
    this.text = '',
    this.border = '',
    this.surface = '',
  });

  InformationalErrorDesignSystem copyWith({
    String? icon,
    String? text,
    String? border,
    String? surface,
  }) {
    return InformationalErrorDesignSystem(
      icon: icon ?? this.icon,
      text: text ?? this.text,
      border: border ?? this.border,
      surface: surface ?? this.surface,
    );
  }

  factory InformationalErrorDesignSystem.fromJson(Map<String, dynamic> json) {
    return InformationalErrorDesignSystem(
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
