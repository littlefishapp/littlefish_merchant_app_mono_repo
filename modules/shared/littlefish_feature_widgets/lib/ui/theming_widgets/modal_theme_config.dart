import 'package:json_annotation/json_annotation.dart';

part '../../../../../widgets/littlefish_feature_widgets/lib/ui/theming_widgets/modal_theme_config.g.dart';

@JsonSerializable()
class ModalThemeConfig {
  final bool enableVerticalActions;
  final bool enableIconBackground;

  const ModalThemeConfig({
    this.enableVerticalActions = true,
    this.enableIconBackground = false,
  });

  factory ModalThemeConfig.fromJson(Map<String, dynamic> json) =>
      _$ModalThemeConfigFromJson(json);

  Map<String, dynamic> toJson() => _$ModalThemeConfigToJson(this);
}
