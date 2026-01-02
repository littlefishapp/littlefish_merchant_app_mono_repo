class NavigationDesignSystem {
  final String defaultIcon;
  final String defaultText;
  final String activeIcon;
  final String activeText;
  final String defaultBackground;
  final String activeBackground;

  const NavigationDesignSystem({
    this.defaultIcon = '',
    this.defaultText = '',
    this.activeIcon = '',
    this.activeText = '',
    this.defaultBackground = '',
    this.activeBackground = '',
  });

  NavigationDesignSystem copyWith({
    String? defaultIcon,
    String? defaultText,
    String? activeIcon,
    String? defaultBackground,
    String? activeBackground,
  }) {
    return NavigationDesignSystem(
      defaultIcon: defaultIcon ?? this.defaultIcon,
      defaultText: defaultText ?? this.defaultText,
      activeIcon: activeIcon ?? this.activeIcon,
      defaultBackground: defaultBackground ?? this.defaultBackground,
      activeBackground: activeBackground ?? this.activeBackground,
    );
  }

  factory NavigationDesignSystem.fromJson(Map<String, dynamic> json) =>
      NavigationDesignSystem(
        defaultIcon: json['defaultIcon'] ?? '',
        defaultText: json['defaultText'] ?? '',
        activeIcon: json['activeIcon'] ?? '',
        activeText: json['activeText'] ?? '',
        defaultBackground: json['defaultBackground'] ?? '',
        activeBackground: json['activeBackground'] ?? '',
      );

  Map<String, dynamic> toJson() => {
    'defaultIcon': defaultIcon,
    'defaultText': defaultText,
    'activeIcon': activeIcon,
    'activeText': activeText,
    'defaultBackground': defaultBackground,
    'activeBackground': activeBackground,
  };
}
