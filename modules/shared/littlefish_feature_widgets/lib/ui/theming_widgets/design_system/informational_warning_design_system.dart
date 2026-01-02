class InformationalWarningDesignSystem {
  final String icon;
  final String text;
  final String border;
  final String surface;

  const InformationalWarningDesignSystem({
    this.icon = '',
    this.text = '',
    this.border = '',
    this.surface = '',
  });

  InformationalWarningDesignSystem copyWith({
    String? icon,
    String? text,
    String? border,
    String? surface,
  }) {
    return InformationalWarningDesignSystem(
      icon: icon ?? this.icon,
      text: text ?? this.text,
      border: border ?? this.border,
      surface: surface ?? this.surface,
    );
  }

  factory InformationalWarningDesignSystem.fromJson(Map<String, dynamic> json) {
    return InformationalWarningDesignSystem(
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
