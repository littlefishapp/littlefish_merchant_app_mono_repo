import 'package:equatable/equatable.dart';

class SquareButtonEntity extends Equatable {
  final double iconSize;

  // ! NB: Ensure that we always have defaults for every field!
  const SquareButtonEntity({this.iconSize = 18.0});

  @override
  List<Object?> get props => [iconSize];

  SquareButtonEntity copyWith({double? iconSize}) {
    return SquareButtonEntity(iconSize: iconSize ?? this.iconSize);
  }
}
