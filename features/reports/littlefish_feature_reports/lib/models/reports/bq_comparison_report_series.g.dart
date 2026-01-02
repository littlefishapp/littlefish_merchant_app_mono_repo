// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bq_comparison_report_series.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ComparisonBqReportSeries _$ComparisonBqReportSeriesFromJson(
  Map<String, dynamic> json,
) => ComparisonBqReportSeries(
  dateRange: json['dateRange'] == null
      ? null
      : BqReportDateRange.fromJson(json['dateRange'] as Map<String, dynamic>),
  seriesNo: (json['seriesNo'] as num?)?.toInt(),
  analysisPairs: (json['analysisPairs'] as List<dynamic>?)
      ?.map((e) => AnalysisPair.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ComparisonBqReportSeriesToJson(
  ComparisonBqReportSeries instance,
) => <String, dynamic>{
  'dateRange': instance.dateRange,
  'seriesNo': instance.seriesNo,
  'analysisPairs': instance.analysisPairs,
};
