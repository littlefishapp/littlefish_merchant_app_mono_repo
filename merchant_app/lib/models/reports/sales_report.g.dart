// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SalesReport _$SalesReportFromJson(Map<String, dynamic> json) => SalesReport(
  averageSale: (json['averageSale'] as num?)?.toDouble(),
  current: (json['current'] as List<dynamic>?)
      ?.map((e) => SalesView.fromJson(e as Map<String, dynamic>))
      .toList(),
  discountsAndComp: (json['discountsAndComp'] as num?)?.toDouble(),
  grossSales: (json['grossSales'] as num?)?.toDouble(),
  netSales: (json['netSales'] as num?)?.toDouble(),
  previous: (json['previous'] as List<dynamic>?)
      ?.map((e) => SalesView.fromJson(e as Map<String, dynamic>))
      .toList(),
  returns: (json['returns'] as num?)?.toDouble(),
  sales: (json['sales'] as num?)?.toDouble(),
  salesByPaymentType: (json['salesByPaymentType'] as List<dynamic>?)
      ?.map((e) => AnalysisPair.fromJson(e as Map<String, dynamic>))
      .toList(),
  topCategories: (json['topCategories'] as List<dynamic>?)
      ?.map((e) => ReportView.fromJson(e as Map<String, dynamic>))
      .toList(),
  topCustomers: (json['topCustomers'] as List<dynamic>?)
      ?.map((e) => ReportView.fromJson(e as Map<String, dynamic>))
      .toList(),
  topProducts: (json['topProducts'] as List<dynamic>?)
      ?.map((e) => ReportView.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SalesReportToJson(SalesReport instance) =>
    <String, dynamic>{
      'grossSales': instance.grossSales,
      'netSales': instance.netSales,
      'sales': instance.sales,
      'averageSale': instance.averageSale,
      'returns': instance.returns,
      'discountsAndComp': instance.discountsAndComp,
      'current': instance.current,
      'previous': instance.previous,
      'salesByPaymentType': instance.salesByPaymentType,
      'topProducts': instance.topProducts,
      'topCustomers': instance.topCustomers,
      'topCategories': instance.topCategories,
    };

SalesView _$SalesViewFromJson(Map<String, dynamic> json) => SalesView(
  averageSale: (json['averageSale'] as num?)?.toDouble(),
  key: json['_id'] == null
      ? null
      : SalesGrouping.fromJson(json['_id'] as Map<String, dynamic>),
  netSales: (json['netSales'] as num?)?.toDouble(),
  saleCount: (json['saleCount'] as num?)?.toDouble(),
  totalDiscounts: (json['totalDiscounts'] as num?)?.toDouble(),
  totalSales: (json['totalSales'] as num?)?.toDouble(),
  grossProfit: (json['grossProfit'] as num?)?.toDouble(),
);

Map<String, dynamic> _$SalesViewToJson(SalesView instance) => <String, dynamic>{
  'totalDiscounts': instance.totalDiscounts,
  'averageSale': instance.averageSale,
  'netSales': instance.netSales,
  'totalSales': instance.totalSales,
  'saleCount': instance.saleCount,
  'grossProfit': instance.grossProfit,
  '_id': instance.key,
};

SimpleSalesView _$SimpleSalesViewFromJson(Map<String, dynamic> json) =>
    SimpleSalesView(
      avgSales: (json['avgSales'] as num?)?.toDouble(),
      avgSalesQuantity: (json['avgSalesQuantity'] as num?)?.toDouble(),
      key: json['_id'] == null
          ? null
          : SalesGrouping.fromJson(json['_id'] as Map<String, dynamic>),
      name: json['name'] as String?,
      totalSales: (json['totalSales'] as num?)?.toDouble(),
      totalSalesQuantity: (json['totalSalesQuantity'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$SimpleSalesViewToJson(SimpleSalesView instance) =>
    <String, dynamic>{
      '_id': instance.key,
      'totalSales': instance.totalSales,
      'totalSalesQuantity': instance.totalSalesQuantity,
      'avgSales': instance.avgSales,
      'avgSalesQuantity': instance.avgSalesQuantity,
      'name': instance.name,
    };

SalesGrouping _$SalesGroupingFromJson(Map<String, dynamic> json) =>
    SalesGrouping(
      day: (json['day'] as num?)?.toInt(),
      hour: (json['hour'] as num?)?.toInt(),
      month: (json['month'] as num?)?.toInt(),
      week: (json['week'] as num?)?.toInt(),
      year: (json['year'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SalesGroupingToJson(SalesGrouping instance) =>
    <String, dynamic>{
      'year': instance.year,
      'month': instance.month,
      'week': instance.week,
      'day': instance.day,
      'hour': instance.hour,
    };

ReportView _$ReportViewFromJson(Map<String, dynamic> json) => ReportView(
  amount: (json['amount'] as num?)?.toDouble(),
  count: (json['count'] as num?)?.toDouble(),
  name: json['name'] as String?,
);

Map<String, dynamic> _$ReportViewToJson(ReportView instance) =>
    <String, dynamic>{
      'name': instance.name,
      'count': instance.count,
      'amount': instance.amount,
    };
