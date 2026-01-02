// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bq_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BqReport _$BqReportFromJson(Map<String, dynamic> json) => BqReport(
  businessId: json['businessId'] as String?,
  firstName: json['firstName'] as String?,
  productName: json['productName'] as String?,
  paymentType: json['paymentType'] as String?,
  dateTimeIndex: json['dateTimeIndex'],
  revenue: (json['revenue'] as num?)?.toDouble(),
  sales: (json['sales'] as num?)?.toDouble(),
  amount: (json['amount'] as num?)?.toDouble(),
  qty: (json['qty'] as num?)?.toInt(),
  ats: (json['ats'] as num?)?.toDouble(),
  percentage: (json['percentage'] as num?)?.toDouble(),
  amtToTax: (json['amtToTax'] as num?)?.toDouble(),
  profits: (json['profits'] as num?)?.toDouble(),
);

Map<String, dynamic> _$BqReportToJson(BqReport instance) => <String, dynamic>{
  'businessId': instance.businessId,
  'firstName': instance.firstName,
  'productName': instance.productName,
  'paymentType': instance.paymentType,
  'dateTimeIndex': instance.dateTimeIndex,
  'revenue': instance.revenue,
  'sales': instance.sales,
  'profits': instance.profits,
  'amount': instance.amount,
  'qty': instance.qty,
  'ats': instance.ats,
  'percentage': instance.percentage,
  'amtToTax': instance.amtToTax,
};
