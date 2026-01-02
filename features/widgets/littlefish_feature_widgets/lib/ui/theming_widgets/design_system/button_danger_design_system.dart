class ButtonDangerDesignSystem {
  final String defaults;
  final String active;
  final String disabled;
  final String hover;
  final String tertiary;

  const ButtonDangerDesignSystem({
    this.defaults = '',
    this.active = '',
    this.disabled = '',
    this.hover = '',
    this.tertiary = '',
  });

  ButtonDangerDesignSystem copyWith({
    String? defaults,
    String? active,
    String? disabled,
    String? hover,
    String? tertiary,
  }) {
    return ButtonDangerDesignSystem(
      defaults: defaults ?? this.defaults,
      active: active ?? this.active,
      disabled: disabled ?? this.disabled,
      hover: hover ?? this.hover,
      tertiary: tertiary ?? this.tertiary,
    );
  }

  factory ButtonDangerDesignSystem.fromJson(Map<String, dynamic> json) =>
      ButtonDangerDesignSystem(
        defaults: json['default'] ?? '',
        active: json['active'] ?? '',
        disabled: json['disabled'] ?? '',
        hover: json['hover'] ?? '',
        tertiary: json['tertiary'] ?? '',
      );

  Map<String, dynamic> toJson() => {
    'default': defaults,
    'active': active,
    'disabled': disabled,
    'hover': hover,
    'tertiary': tertiary,
  };
}
