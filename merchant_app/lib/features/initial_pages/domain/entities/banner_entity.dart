import 'package:equatable/equatable.dart';

class BannerEntity extends Equatable {
  final bool showVersion;
  final bool centreBanner;
  final double leftPadding;
  final double topPadding;
  final double bottomPadding;
  final double rightPadding;
  final double height;
  final double width;
  final bool useHeight;
  final bool useWidth;
  final bool inverseColour;
  final bool useGradient;
  final String boxFit;

  const BannerEntity({
    this.showVersion = false,
    this.centreBanner = true,
    this.leftPadding = 0.0,
    this.topPadding = 0.0,
    this.bottomPadding = 0.0,
    this.rightPadding = 0.0,
    this.height = 200.0,
    this.width = 0.0,
    this.useHeight = true,
    this.useWidth = false,
    this.inverseColour = false,
    this.useGradient = true,
    this.boxFit = 'contain',
  });
  @override
  List<Object?> get props => [
    showVersion,
    centreBanner,
    leftPadding,
    topPadding,
    bottomPadding,
    rightPadding,
    height,
    width,
    useHeight,
    useWidth,
    inverseColour,
    useGradient,
    boxFit,
  ];
  BannerEntity copyWith({
    bool? showVersion,
    bool? centreBanner,
    double? leftPadding,
    double? topPadding,
    double? bottomPadding,
    double? rightPadding,
    double? height,
    double? width,
    bool? useHeight,
    bool? useWidth,
    bool? inverseColour,
    bool? useGradient,
    String? boxFit,
  }) {
    return BannerEntity(
      showVersion: showVersion ?? this.showVersion,
      centreBanner: centreBanner ?? this.centreBanner,
      leftPadding: leftPadding ?? this.leftPadding,
      topPadding: topPadding ?? this.topPadding,
      bottomPadding: bottomPadding ?? this.bottomPadding,
      rightPadding: rightPadding ?? this.rightPadding,
      height: height ?? this.height,
      width: width ?? this.width,
      useHeight: useHeight ?? this.useHeight,
      useWidth: useWidth ?? this.useWidth,
      inverseColour: inverseColour ?? this.inverseColour,
      useGradient: useGradient ?? this.useGradient,
      boxFit: boxFit ?? this.boxFit,
    );
  }
}
