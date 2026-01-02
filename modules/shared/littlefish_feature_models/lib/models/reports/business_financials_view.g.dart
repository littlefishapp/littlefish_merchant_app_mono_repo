// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_financials_view.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusinessFinancialsView _$BusinessFinancialsViewFromJson(
  Map<String, dynamic> json,
) => BusinessFinancialsView(
  expenseType: (json['expenseType'] as List<dynamic>?)
      ?.map((e) => AnalysisPair.fromJson(e as Map<String, dynamic>))
      .toList(),
  paymentType: (json['paymentType'] as List<dynamic>?)
      ?.map((e) => AnalysisPair.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalDiscount: (json['totalDiscount'] as num?)?.toDouble(),
  totalExpenses: (json['totalExpenses'] as num?)?.toDouble(),
  totalProfit: (json['totalProfit'] as num?)?.toDouble(),
  totalRevenue: (json['totalRevenue'] as num?)?.toDouble(),
  totalSalesCost: (json['totalSalesCost'] as num?)?.toDouble(),
  totalSalesProfit: (json['totalSalesProfit'] as num?)?.toDouble(),
  totalRefundedSales: (json['totalRefundedSales'] as num?)?.toDouble(),
  totalRefundedSalesCost: (json['totalRefundedSalesCost'] as num?)?.toDouble(),
  refundPaymentType: (json['refundPaymentType'] as List<dynamic>?)
      ?.map((e) => AnalysisPair.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalTax: (json['totalTax'] as num?)?.toDouble(),
);

Map<String, dynamic> _$BusinessFinancialsViewToJson(
  BusinessFinancialsView instance,
) => <String, dynamic>{
  'totalProfit': instance.totalProfit,
  'totalDiscount': instance.totalDiscount,
  'totalTax': instance.totalTax,
  'totalSalesCost': instance.totalSalesCost,
  'totalSalesProfit': instance.totalSalesProfit,
  'totalRevenue': instance.totalRevenue,
  'totalRefundedSales': instance.totalRefundedSales,
  'totalRefundedSalesCost': instance.totalRefundedSalesCost,
  'paymentType': instance.paymentType,
  'totalExpenses': instance.totalExpenses,
  'expenseType': instance.expenseType,
  'refundPaymentType': instance.refundPaymentType,
};
