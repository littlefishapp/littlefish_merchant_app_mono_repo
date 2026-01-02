// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bq_staff_sales_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BqStaffSalesReport _$BqStaffSalesReportFromJson(Map<String, dynamic> json) =>
    BqStaffSalesReport(
      firstName: json['firstName'] as String?,
      qty: (json['qty'] as num?)?.toDouble(),
      amount: (json['amount'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$BqStaffSalesReportToJson(BqStaffSalesReport instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'qty': instance.qty,
      'amount': instance.amount,
    };
