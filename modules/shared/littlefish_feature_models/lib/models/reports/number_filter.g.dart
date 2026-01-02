// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'number_filter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NumberFilter _$NumberFilterFromJson(Map<String, dynamic> json) => NumberFilter(
  filterType: $enumDecodeNullable(_$FilterTypeEnumMap, json['filterType']),
  firstValue: (json['firstValue'] as num?)?.toDouble(),
  secondValue: (json['secondValue'] as num?)?.toDouble(),
);

Map<String, dynamic> _$NumberFilterToJson(NumberFilter instance) =>
    <String, dynamic>{
      'filterType': _$FilterTypeEnumMap[instance.filterType],
      'firstValue': instance.firstValue,
      'secondValue': instance.secondValue,
    };

const _$FilterTypeEnumMap = {
  FilterType.greater: 0,
  FilterType.lessThan: 1,
  FilterType.between: 2,
  FilterType.exclude: 3,
};
