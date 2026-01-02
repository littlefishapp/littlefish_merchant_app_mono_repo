// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusinessSummary _$BusinessSummaryFromJson(Map<String, dynamic> json) =>
    BusinessSummary(
      expenses: (json['expenses'] as num?)?.toDouble(),
      expensesByType: (json['expensesByType'] as List<dynamic>?)
          ?.map((e) => AnalysisPair.fromJson(e as Map<String, dynamic>))
          .toList(),
      profit: (json['profit'] as num?)?.toDouble(),
      revenue: (json['revenue'] as num?)?.toDouble(),
      salesByPaymentType: (json['salesByPaymentType'] as List<dynamic>?)
          ?.map((e) => AnalysisPair.fromJson(e as Map<String, dynamic>))
          .toList(),
      recentTransactions: (json['recentTransactions'] as List<dynamic>?)
          ?.map((e) => CheckoutTransaction.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BusinessSummaryToJson(
  BusinessSummary instance,
) => <String, dynamic>{
  'salesByPaymentType': instance.salesByPaymentType
      ?.map((e) => e.toJson())
      .toList(),
  'expensesByType': instance.expensesByType?.map((e) => e.toJson()).toList(),
  'recentTransactions': instance.recentTransactions
      ?.map((e) => e.toJson())
      .toList(),
  'profit': instance.profit,
  'revenue': instance.revenue,
  'expenses': instance.expenses,
};
