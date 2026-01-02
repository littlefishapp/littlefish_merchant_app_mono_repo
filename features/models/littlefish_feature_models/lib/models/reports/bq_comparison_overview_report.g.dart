// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bq_comparison_overview_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OverviewComparisonReport _$OverviewComparisonReportFromJson(
  Map<String, dynamic> json,
) => OverviewComparisonReport(
  seriesName: json['seriesName'] as String?,
  seriesNo: (json['seriesNo'] as num?)?.toInt(),
  startDate: json['startDate'] as String?,
  endDate: json['endDate'] as String?,
  businessName: json['businessName'] as String?,
  reportResponse: (json['reportResponse'] as List<dynamic>?)
      ?.map((e) => BqOverviewReport.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$OverviewComparisonReportToJson(
  OverviewComparisonReport instance,
) => <String, dynamic>{
  'seriesName': instance.seriesName,
  'seriesNo': instance.seriesNo,
  'startDate': instance.startDate,
  'endDate': instance.endDate,
  'businessName': instance.businessName,
  'reportResponse': instance.reportResponse?.map((e) => e.toJson()).toList(),
};
