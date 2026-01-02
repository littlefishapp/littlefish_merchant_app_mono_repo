// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bq_report_dataset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BqReportDataset _$BqReportDatasetFromJson(
  Map<String, dynamic> json,
) => BqReportDataset(
  comparisonReports: json['comparisonReports'] as List<dynamic>?,
  comparisonAnalysisPairs: (json['comparisonAnalysisPairs'] as List<dynamic>?)
      ?.map((e) => ComparisonBqReportSeries.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$BqReportDatasetToJson(BqReportDataset instance) =>
    <String, dynamic>{
      'comparisonReports': instance.comparisonReports,
      'comparisonAnalysisPairs': instance.comparisonAnalysisPairs,
    };
