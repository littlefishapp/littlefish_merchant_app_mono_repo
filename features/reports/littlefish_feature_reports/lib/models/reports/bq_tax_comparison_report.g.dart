// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bq_tax_comparison_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaxComparisonReport _$TaxComparisonReportFromJson(Map<String, dynamic> json) =>
    TaxComparisonReport(
      seriesName: json['seriesName'] as String?,
      seriesNo: (json['seriesNo'] as num?)?.toInt(),
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      businessName: json['businessName'] as String?,
      reportResponse: (json['reportResponse'] as List<dynamic>?)
          ?.map((e) => BqTaxReport.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TaxComparisonReportToJson(
  TaxComparisonReport instance,
) => <String, dynamic>{
  'seriesName': instance.seriesName,
  'seriesNo': instance.seriesNo,
  'startDate': instance.startDate,
  'endDate': instance.endDate,
  'businessName': instance.businessName,
  'reportResponse': instance.reportResponse,
};
