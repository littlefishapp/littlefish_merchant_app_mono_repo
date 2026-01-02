// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analysis_overviews.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusinessOverviewCount _$BusinessOverviewCountFromJson(
  Map<String, dynamic> json,
) => BusinessOverviewCount(
  totalDiscount: (json['totalDiscount'] as num?)?.toDouble(),
  totalSalesCost: (json['totalSalesCost'] as num?)?.toDouble(),
  totalRefundedSalesCost: (json['totalRefundedSalesCost'] as num?)?.toDouble(),
  totalRefundedSales: (json['totalRefundedSales'] as num?)?.toDouble(),
  businessId: json['businessId'] as String?,
  customerCount: (json['customerCount'] as num?)?.toInt(),
  employeeCount: (json['employeeCount'] as num?)?.toInt(),
  productCount: (json['productCount'] as num?)?.toInt(),
  salesCount: (json['salesCount'] as num?)?.toInt(),
  supplierCount: (json['supplierCount'] as num?)?.toInt(),
  totalInventoryValue: (json['totalInventoryValue'] as num?)?.toDouble(),
  totalSalesValue: (json['totalSalesValue'] as num?)?.toDouble(),
  totalProfit: (json['totalProfit'] as num?)?.toDouble(),
  totalExpenses: (json['totalExpenses'] as num?)?.toDouble(),
  totalTax: (json['totalTax'] as num?)?.toDouble(),
  totalItemsSold: (json['totalItemsSold'] as num?)?.toDouble(),
  avgItemsSold: (json['avgItemsSold'] as num?)?.toDouble(),
);

Map<String, dynamic> _$BusinessOverviewCountToJson(
  BusinessOverviewCount instance,
) => <String, dynamic>{
  'totalDiscount': instance.totalDiscount,
  'totalRefundedSalesCost': instance.totalRefundedSalesCost,
  'totalSalesCost': instance.totalSalesCost,
  'businessId': instance.businessId,
  'productCount': instance.productCount,
  'customerCount': instance.customerCount,
  'employeeCount': instance.employeeCount,
  'supplierCount': instance.supplierCount,
  'salesCount': instance.salesCount,
  'avgItemsSold': instance.avgItemsSold,
  'totalInventoryValue': instance.totalInventoryValue,
  'totalSalesValue': instance.totalSalesValue,
  'totalRefundedSales': instance.totalRefundedSales,
  'totalProfit': instance.totalProfit,
  'totalExpenses': instance.totalExpenses,
  'totalTax': instance.totalTax,
  'totalItemsSold': instance.totalItemsSold,
};

CustomerTopTen _$CustomerTopTenFromJson(
  Map<String, dynamic> json,
) => CustomerTopTen(
  topCustomersBySaleCount: (json['topCustomersBySaleCount'] as List<dynamic>?)
      ?.map((e) => AnalysisPair.fromJson(e as Map<String, dynamic>))
      .toList(),
  topCustomersBySaleValue: (json['topCustomersBySaleValue'] as List<dynamic>?)
      ?.map((e) => AnalysisPair.fromJson(e as Map<String, dynamic>))
      .toList(),
  worstCustomersBySaleCount:
      (json['worstCustomersBySaleCount'] as List<dynamic>?)
          ?.map((e) => AnalysisPair.fromJson(e as Map<String, dynamic>))
          .toList(),
  worstCustomersBySaleValue:
      (json['worstCustomersBySaleValue'] as List<dynamic>?)
          ?.map((e) => AnalysisPair.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$CustomerTopTenToJson(CustomerTopTen instance) =>
    <String, dynamic>{
      'topCustomersBySaleValue': instance.topCustomersBySaleValue,
      'topCustomersBySaleCount': instance.topCustomersBySaleCount,
      'worstCustomersBySaleValue': instance.worstCustomersBySaleValue,
      'worstCustomersBySaleCount': instance.worstCustomersBySaleCount,
    };

ProductTopTen _$ProductTopTenFromJson(Map<String, dynamic> json) =>
    ProductTopTen(
      mostSold: (json['mostSold'] as List<dynamic>?)
          ?.map((e) => AnalysisPair.fromJson(e as Map<String, dynamic>))
          .toList(),
      mostProfit: (json['mostProfit'] as List<dynamic>?)
          ?.map((e) => AnalysisPair.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProductTopTenToJson(ProductTopTen instance) =>
    <String, dynamic>{
      'mostSold': instance.mostSold,
      'mostProfit': instance.mostProfit,
    };

CustomerStatistic _$CustomerStatisticFromJson(Map<String, dynamic> json) =>
    CustomerStatistic(
      (json['data'] as List<dynamic>?)
          ?.map((e) => AnalysisPair.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['name'] as String?,
    );

Map<String, dynamic> _$CustomerStatisticToJson(CustomerStatistic instance) =>
    <String, dynamic>{'data': instance.data, 'name': instance.name};

AnalysisPair _$AnalysisPairFromJson(Map<String, dynamic> json) => AnalysisPair(
  id: json['id'] as String?,
  value: (json['value'] as num?)?.toDouble(),
  max: (json['max'] as num?)?.toDouble() ?? 0.0,
  min: (json['min'] as num?)?.toDouble() ?? 0.0,
);

Map<String, dynamic> _$AnalysisPairToJson(AnalysisPair instance) =>
    <String, dynamic>{
      'id': instance.id,
      'value': instance.value,
      'max': instance.max,
      'min': instance.min,
    };
