// File: drawer_title_entity.dart
import 'package:equatable/equatable.dart';

class DrawerTitleEntity extends Equatable {
  final bool inverseColour;
  final List<String> texts;
  final List<String> textSizes;
  final List<String> textWeights;
  final bool showIcon;
  final bool useAssetLogo;
  final List<double> padding;

  const DrawerTitleEntity({
    this.inverseColour = false,
    this.texts = const [],
    this.textSizes = const [],
    this.textWeights = const [],
    this.showIcon = false,
    this.useAssetLogo = false,
    this.padding = const [0.0, 0.0, 0.0, 0.0],
  });

  @override
  List<Object?> get props => [
    inverseColour,
    texts,
    textSizes,
    textWeights,
    showIcon,
    useAssetLogo,
    padding,
  ];

  DrawerTitleEntity copyWith({
    bool? inverseColour,
    List<String>? texts,
    List<String>? textSizes,
    List<String>? textWeights,
    bool? showIcon,
    bool? useAssetLogo,
    List<double>? padding,
  }) {
    return DrawerTitleEntity(
      inverseColour: inverseColour ?? this.inverseColour,
      texts: texts ?? this.texts,
      textSizes: textSizes ?? this.textSizes,
      textWeights: textWeights ?? this.textWeights,
      showIcon: showIcon ?? this.showIcon,
      useAssetLogo: useAssetLogo ?? this.useAssetLogo,
      padding: padding ?? this.padding,
    );
  }
}
