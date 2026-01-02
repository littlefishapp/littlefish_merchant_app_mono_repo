// features/home/domain/entities/home_header_entity.dart
import 'package:equatable/equatable.dart';

class HomeHeaderEntity extends Equatable {
  final bool hasDecoratedSurface; // true → use gradient/background from theme
  final List<String> header1Texts;
  final List<String> header1Weights;
  final List<String> header1Sizes;
  final List<String> header2Texts;
  final List<String> header2Weights;
  final List<String> header2Sizes;
  final bool useBusinessNameForHeader2;
  final List<double> widgetPadding; // [top, right, bottom, left]
  final bool businessTileEnabled;
  final bool businessTileDashEnabled;
  final List<double> businessTilePadding; // [top, right, bottom, left]
  final double businessTileBorderRadius;

  const HomeHeaderEntity({
    this.hasDecoratedSurface = true,
    this.header1Texts = const [],
    this.header1Weights = const [],
    this.header1Sizes = const [],
    this.header2Texts = const [],
    this.header2Weights = const [],
    this.header2Sizes = const [],
    this.useBusinessNameForHeader2 = false,
    this.widgetPadding = const [32.0, 16.0, 32.0, 16.0],
    this.businessTileEnabled = false,
    this.businessTileDashEnabled = false,
    this.businessTilePadding = const [16.0, 16.0, 16.0, 16.0],
    this.businessTileBorderRadius = 12.0,
  });

  @override
  List<Object?> get props => [
    hasDecoratedSurface,
    header1Texts,
    header1Weights,
    header1Sizes,
    header2Texts,
    header2Weights,
    header2Sizes,
    useBusinessNameForHeader2,
    widgetPadding,
    businessTileEnabled,
    businessTileDashEnabled,
    businessTilePadding,
    businessTileBorderRadius,
  ];

  HomeHeaderEntity copyWith({
    bool? hasDecoratedSurface,
    List<String>? header1Texts,
    List<String>? header1Weights,
    List<String>? header1Sizes,
    List<String>? header2Texts,
    List<String>? header2Weights,
    List<String>? header2Sizes,
    List<double>? widgetPadding,
    bool? useBusinessNameForHeader2,
    bool? businessTileEnabled,
    bool? businessTileDashEnabled,
    List<double>? businessTilePadding,
    double? businessTileBorderRadius,
  }) {
    return HomeHeaderEntity(
      hasDecoratedSurface: hasDecoratedSurface ?? this.hasDecoratedSurface,
      header1Texts: header1Texts ?? this.header1Texts,
      header1Weights: header1Weights ?? this.header1Weights,
      header1Sizes: header1Sizes ?? this.header1Sizes,
      header2Texts: header2Texts ?? this.header2Texts,
      header2Weights: header2Weights ?? this.header2Weights,
      header2Sizes: header2Sizes ?? this.header2Sizes,
      useBusinessNameForHeader2:
          useBusinessNameForHeader2 ?? this.useBusinessNameForHeader2,
      widgetPadding: widgetPadding ?? this.widgetPadding,
      businessTileEnabled: businessTileEnabled ?? this.businessTileEnabled,
      businessTileDashEnabled:
          businessTileDashEnabled ?? this.businessTileDashEnabled,
      businessTilePadding: businessTilePadding ?? this.businessTilePadding,
      businessTileBorderRadius:
          businessTileBorderRadius ?? this.businessTileBorderRadius,
    );
  }
}
