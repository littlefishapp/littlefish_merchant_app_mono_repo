// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bq_customer_sales_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BqCustomerSalesReport _$BqCustomerSalesReportFromJson(
  Map<String, dynamic> json,
) => BqCustomerSalesReport(
  firstName: json['firstName'] as String? ?? 'N/A',
  qty: (json['qty'] as num?)?.toDouble(),
  amount: (json['amount'] as num?)?.toDouble(),
);

Map<String, dynamic> _$BqCustomerSalesReportToJson(
  BqCustomerSalesReport instance,
) => <String, dynamic>{
  'firstName': instance.firstName,
  'qty': instance.qty,
  'amount': instance.amount,
};
