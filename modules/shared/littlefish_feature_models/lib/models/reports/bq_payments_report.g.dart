// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bq_payments_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BqPaymentsReport _$BqPaymentsReportFromJson(Map<String, dynamic> json) =>
    BqPaymentsReport(
      paymentType: json['paymentType'] as String?,
      qty: (json['qty'] as num?)?.toDouble(),
      amount: (json['amount'] as num?)?.toDouble(),
      percentage: (json['percentage'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$BqPaymentsReportToJson(BqPaymentsReport instance) =>
    <String, dynamic>{
      'paymentType': instance.paymentType,
      'qty': instance.qty,
      'amount': instance.amount,
      'percentage': instance.percentage,
    };
