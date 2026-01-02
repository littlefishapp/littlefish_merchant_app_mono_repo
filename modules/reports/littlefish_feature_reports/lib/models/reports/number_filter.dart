// Package imports:
import 'package:json_annotation/json_annotation.dart';

part 'number_filter.g.dart';

@JsonSerializable()
class NumberFilter {
  FilterType? filterType;
  double? firstValue;
  double? secondValue;

  NumberFilter({this.filterType, this.firstValue, this.secondValue});

  factory NumberFilter.fromJson(Map<String, dynamic> json) =>
      _$NumberFilterFromJson(json);

  Map<String, dynamic> toJson() => _$NumberFilterToJson(this);
}

enum FilterType {
  @JsonValue(0)
  greater,
  @JsonValue(1)
  lessThan,
  @JsonValue(2)
  between,
  @JsonValue(3)
  exclude,
}
