// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bq_profits_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BqProfitsReport _$BqProfitsReportFromJson(Map<String, dynamic> json) =>
    BqProfitsReport(
      dateTimeIndex: json['dateTimeIndex'],
      revenue: (json['revenue'] as num?)?.toDouble(),
      profits: (json['profits'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$BqProfitsReportToJson(BqProfitsReport instance) =>
    <String, dynamic>{
      'dateTimeIndex': instance.dateTimeIndex,
      'revenue': instance.revenue,
      'profits': instance.profits,
    };
