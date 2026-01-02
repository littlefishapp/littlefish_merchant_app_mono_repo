// logo_entity.dart
import 'package:equatable/equatable.dart';

class LogoEntity extends Equatable {
  final bool showVersion;
  final bool centreLogo;
  final double leftPadding;
  final double topPadding;
  final double bottomPadding;
  final double rightPadding;
  final double height;
  final double width;
  final bool useHeight;
  final bool useWidth;
  final bool inverseColour;
  final String boxFit;

  const LogoEntity({
    this.showVersion = false,
    this.centreLogo = true,
    this.leftPadding = 0.0,
    this.topPadding = 32.0,
    this.bottomPadding = 12.0,
    this.rightPadding = 0.0,
    this.height = 154.0,
    this.width = 80.0,
    this.useHeight = false,
    this.useWidth = true,
    this.inverseColour = false,
    this.boxFit = 'contain',
  });

  @override
  List<Object?> get props => [
    showVersion,
    centreLogo,
    leftPadding,
    topPadding,
    bottomPadding,
    rightPadding,
    height,
    width,
    useHeight,
    useWidth,
    inverseColour,
    boxFit,
  ];

  LogoEntity copyWith({
    bool? showVersion,
    bool? centreLogo,
    double? leftPadding,
    double? topPadding,
    double? bottomPadding,
    double? rightPadding,
    double? height,
    double? width,
    bool? useHeight,
    bool? useWidth,
    bool? inverseColour,
    String? boxFit,
  }) {
    return LogoEntity(
      showVersion: showVersion ?? this.showVersion,
      centreLogo: centreLogo ?? this.centreLogo,
      leftPadding: leftPadding ?? this.leftPadding,
      topPadding: topPadding ?? this.topPadding,
      bottomPadding: bottomPadding ?? this.bottomPadding,
      rightPadding: rightPadding ?? this.rightPadding,
      height: height ?? this.height,
      width: width ?? this.width,
      useHeight: useHeight ?? this.useHeight,
      useWidth: useWidth ?? this.useWidth,
      inverseColour: inverseColour ?? this.inverseColour,
      boxFit: boxFit ?? this.boxFit,
    );
  }
}
