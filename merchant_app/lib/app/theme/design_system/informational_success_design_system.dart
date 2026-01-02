class InformationalSuccessDesignSystem {
  final String icon;
  final String text;
  final String border;
  final String surface;

  const InformationalSuccessDesignSystem({
    this.icon = '',
    this.text = '',
    this.border = '',
    this.surface = '',
  });

  InformationalSuccessDesignSystem copyWith({
    String? icon,
    String? text,
    String? border,
    String? surface,
  }) {
    return InformationalSuccessDesignSystem(
      icon: icon ?? this.icon,
      text: text ?? this.text,
      border: border ?? this.border,
      surface: surface ?? this.surface,
    );
  }

  factory InformationalSuccessDesignSystem.fromJson(Map<String, dynamic> json) {
    return InformationalSuccessDesignSystem(
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
