// File: welcom_entity.dart
import 'package:equatable/equatable.dart';

class WelcomeEntity extends Equatable {
  final bool inverseColour;
  final List<String> topRow;
  final List<String> middleRow;
  final List<String> bottomRow;
  final List<String> topWeight;
  final List<String> middleWeight;
  final List<String> bottomWeight;
  final List<double> componentPadding;
  final String topSize;
  final String middleSize;
  final String bottomSize;

  const WelcomeEntity({
    this.inverseColour = false,
    this.topRow = const [],
    this.middleRow = const [],
    this.bottomRow = const [],
    this.topWeight = const [],
    this.middleWeight = const [],
    this.bottomWeight = const [],
    this.componentPadding = const [0.0, 0.0, 0.0, 0.0],
    this.topSize = 'xsmall',
    this.middleSize = 'medium',
    this.bottomSize = 'medium',
  });

  @override
  List<Object?> get props => [
    inverseColour,
    topRow,
    middleRow,
    bottomRow,
    topWeight,
    middleWeight,
    bottomWeight,
    componentPadding,
    topSize,
    middleSize,
    bottomSize,
  ];

  WelcomeEntity copyWith({
    bool? inverseColour,
    List<String>? topRow,
    List<String>? middleRow,
    List<String>? bottomRow,
    List<String>? topWeight,
    List<String>? middleWeight,
    List<String>? bottomWeight,
    List<double>? componentPadding,
    String? topSize,
    String? middleSize,
    String? bottomSize,
  }) {
    return WelcomeEntity(
      inverseColour: inverseColour ?? this.inverseColour,
      topRow: topRow ?? this.topRow,
      middleRow: middleRow ?? this.middleRow,
      bottomRow: bottomRow ?? this.bottomRow,
      topWeight: topWeight ?? this.topWeight,
      middleWeight: middleWeight ?? this.middleWeight,
      bottomWeight: bottomWeight ?? this.bottomWeight,
      componentPadding: componentPadding ?? this.componentPadding,
      topSize: topSize ?? this.topSize,
      middleSize: middleSize ?? this.middleSize,
      bottomSize: bottomSize ?? this.bottomSize,
    );
  }
}
