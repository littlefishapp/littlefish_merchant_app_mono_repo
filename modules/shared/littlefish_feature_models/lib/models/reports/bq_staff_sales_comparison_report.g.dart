// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bq_staff_sales_comparison_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StaffSalesComparisonReport _$StaffSalesComparisonReportFromJson(
  Map<String, dynamic> json,
) => StaffSalesComparisonReport(
  seriesName: json['seriesName'] as String?,
  seriesNo: (json['seriesNo'] as num?)?.toInt(),
  startDate: json['startDate'] as String?,
  endDate: json['endDate'] as String?,
  businessName: json['businessName'] as String?,
  reportResponse: (json['reportResponse'] as List<dynamic>?)
      ?.map((e) => BqStaffSalesReport.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$StaffSalesComparisonReportToJson(
  StaffSalesComparisonReport instance,
) => <String, dynamic>{
  'seriesName': instance.seriesName,
  'seriesNo': instance.seriesNo,
  'startDate': instance.startDate,
  'endDate': instance.endDate,
  'businessName': instance.businessName,
  'reportResponse': instance.reportResponse,
};
