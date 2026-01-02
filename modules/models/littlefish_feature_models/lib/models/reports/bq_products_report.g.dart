// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bq_products_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BqProductsReport _$BqProductsReportFromJson(Map<String, dynamic> json) =>
    BqProductsReport(
      productName: json['productName'] as String?,
      qty: (json['qty'] as num?)?.toDouble(),
      amount: (json['amount'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$BqProductsReportToJson(BqProductsReport instance) =>
    <String, dynamic>{
      'productName': instance.productName,
      'qty': instance.qty,
      'amount': instance.amount,
    };
