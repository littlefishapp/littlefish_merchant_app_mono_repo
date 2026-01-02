// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bq_tax_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BqTaxReport _$BqTaxReportFromJson(Map<String, dynamic> json) => BqTaxReport(
  dateTimeIndex: json['dateTimeIndex'],
  revenue: (json['revenue'] as num?)?.toDouble(),
  sales: (json['sales'] as num?)?.toDouble(),
  ats: (json['ats'] as num?)?.toDouble(),
  amtToTax: (json['amtToTax'] as num?)?.toDouble(),
);

Map<String, dynamic> _$BqTaxReportToJson(BqTaxReport instance) =>
    <String, dynamic>{
      'dateTimeIndex': instance.dateTimeIndex,
      'revenue': instance.revenue,
      'sales': instance.sales,
      'ats': instance.ats,
      'amtToTax': instance.amtToTax,
    };
