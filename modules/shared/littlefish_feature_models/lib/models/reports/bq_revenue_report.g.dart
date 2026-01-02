// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bq_revenue_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BqRevenueReport _$BqRevenueReportFromJson(Map<String, dynamic> json) =>
    BqRevenueReport(
      dateTimeIndex: json['dateTimeIndex'],
      revenue: (json['revenue'] as num?)?.toDouble(),
      sales: (json['sales'] as num?)?.toDouble(),
      ats: (json['ats'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$BqRevenueReportToJson(BqRevenueReport instance) =>
    <String, dynamic>{
      'dateTimeIndex': instance.dateTimeIndex,
      'revenue': instance.revenue,
      'sales': instance.sales,
      'ats': instance.ats,
    };
