// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bq_comparison_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ComparisonBqReport _$ComparisonBqReportFromJson(Map<String, dynamic> json) =>
    ComparisonBqReport(
      seriesName: json['seriesName'] as String?,
      seriesNo: (json['seriesNo'] as num?)?.toInt(),
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      reportResponse: (json['reportResponse'] as List<dynamic>?)
          ?.map((e) => BqReport.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ComparisonBqReportToJson(ComparisonBqReport instance) =>
    <String, dynamic>{
      'seriesName': instance.seriesName,
      'seriesNo': instance.seriesNo,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'reportResponse': instance.reportResponse,
    };
