// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerReport _$CustomerReportFromJson(Map<String, dynamic> json) =>
    CustomerReport(
      activeCustomers: (json['customersActiveLastPeriod'] as num?)?.toInt(),
      customerSales: (json['customerSales'] as List<dynamic>?)
          ?.map((e) => SimpleSalesView.fromJson(e as Map<String, dynamic>))
          .toList(),
      nonCustomerSales: (json['nonCustomerSales'] as List<dynamic>?)
          ?.map((e) => SimpleSalesView.fromJson(e as Map<String, dynamic>))
          .toList(),
      topCustomersByPurchases: (json['topByAmount'] as List<dynamic>?)
          ?.map((e) => ReportView.fromJson(e as Map<String, dynamic>))
          .toList(),
      topCustomersByQuantity: (json['topByQuantity'] as List<dynamic>?)
          ?.map((e) => ReportView.fromJson(e as Map<String, dynamic>))
          .toList(),
      topCustomersByVisits: (json['topByVisits'] as List<dynamic>?)
          ?.map((e) => VisitView.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCustomers: (json['totalCustomers'] as num?)?.toInt(),
      totalNonCustomerSalesAmount: (json['totalNonCustomerSalesAmount'] as num?)
          ?.toDouble(),
      totalNonCustomerSalesCount: (json['totalNonCustomerSalesCount'] as num?)
          ?.toDouble(),
      totalNonCustomerSalesQuantity:
          (json['totalNonCustomerSalesQuantity'] as num?)?.toDouble(),
      totalCustomerSalesAmount: (json['totalCustomerSalesAmount'] as num?)
          ?.toDouble(),
      totalCustomerSalesCount: (json['totalCustomerSalesCount'] as num?)
          ?.toDouble(),
      totalCustomerSalesQuantity: (json['totalCustomerSalesQuantity'] as num?)
          ?.toDouble(),
    );

Map<String, dynamic> _$CustomerReportToJson(CustomerReport instance) =>
    <String, dynamic>{
      'totalCustomers': instance.totalCustomers,
      'customersActiveLastPeriod': instance.activeCustomers,
      'topByVisits': instance.topCustomersByVisits,
      'topByQuantity': instance.topCustomersByQuantity,
      'topByAmount': instance.topCustomersByPurchases,
      'customerSales': instance.customerSales,
      'nonCustomerSales': instance.nonCustomerSales,
      'totalCustomerSalesAmount': instance.totalCustomerSalesAmount,
      'totalCustomerSalesQuantity': instance.totalCustomerSalesQuantity,
      'totalCustomerSalesCount': instance.totalCustomerSalesCount,
      'totalNonCustomerSalesAmount': instance.totalNonCustomerSalesAmount,
      'totalNonCustomerSalesQuantity': instance.totalNonCustomerSalesQuantity,
      'totalNonCustomerSalesCount': instance.totalNonCustomerSalesCount,
    };

VisitView _$VisitViewFromJson(Map<String, dynamic> json) => VisitView(
  amount: (json['amount'] as num?)?.toDouble(),
  name: json['name'] as String?,
  visits: (json['visits'] as num?)?.toInt(),
);

Map<String, dynamic> _$VisitViewToJson(VisitView instance) => <String, dynamic>{
  'name': instance.name,
  'amount': instance.amount,
  'visits': instance.visits,
};
