// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_date_range.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportDateRange _$ReportDateRangeFromJson(Map<String, dynamic> json) =>
    ReportDateRange(
      seriesName: json['seriesName'] as String?,
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      mode: $enumDecodeNullable(_$ReportModeEnumMap, json['mode']),
      seriesNo: (json['seriesNo'] as num?)?.toInt(),
      isDeleted: json['isDeleted'] as bool?,
    );

Map<String, dynamic> _$ReportDateRangeToJson(ReportDateRange instance) =>
    <String, dynamic>{
      'seriesName': instance.seriesName,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'mode': _$ReportModeEnumMap[instance.mode],
      'seriesNo': instance.seriesNo,
      'isDeleted': instance.isDeleted,
    };

const _$ReportModeEnumMap = {
  ReportMode.day: 0,
  ReportMode.week: 1,
  ReportMode.month: 2,
  ReportMode.threeMonths: 3,
  ReportMode.year: 4,
  ReportMode.custom: 5,
  ReportMode.hour: 6,
  ReportMode.prevDay: 7,
  ReportMode.prevWeek: 8,
  ReportMode.prevMonth: 9,
  ReportMode.prevYear: 10,
};
