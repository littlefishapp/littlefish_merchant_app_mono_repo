class ButtonNeutralDesignSystem {
  final String defaults;
  final String active;
  final String disabled;
  final String hover;
  final String tertiary;

  const ButtonNeutralDesignSystem({
    this.defaults = '',
    this.active = '',
    this.disabled = '',
    this.hover = '',
    this.tertiary = '',
  });

  ButtonNeutralDesignSystem copyWith({
    String? defaults,
    String? active,
    String? disabled,
    String? hover,
    String? tertiary,
  }) {
    return ButtonNeutralDesignSystem(
      defaults: defaults ?? this.defaults,
      active: active ?? this.active,
      disabled: disabled ?? this.disabled,
      hover: hover ?? this.hover,
      tertiary: tertiary ?? this.tertiary,
    );
  }

  factory ButtonNeutralDesignSystem.fromJson(Map<String, dynamic> json) =>
      ButtonNeutralDesignSystem(
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
