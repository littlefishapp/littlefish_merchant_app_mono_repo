// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bq_overview_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BqOverviewReport _$BqOverviewReportFromJson(Map<String, dynamic> json) =>
    BqOverviewReport(
      businessId: json['businessId'] as String?,
      revenue: (json['revenue'] as num?)?.toDouble(),
      sales: (json['sales'] as num?)?.toDouble(),
      ats: (json['ats'] as num?)?.toDouble(),
      profits: (json['profits'] as num?)?.toDouble(),
      amtToTax: (json['amtToTax'] as num?)?.toDouble(),
      topProd: json['topProd'] as String?,
      paymentMeth: json['paymentMeth'] as String?,
      payMethAmt: (json['payMethAmt'] as num?)?.toDouble(),
      payMethPercent: (json['payMethPercent'] as num?)?.toDouble(),
      topProdSalesAmt: (json['topProdSalesAmt'] as num?)?.toDouble(),
      topProdCategory: json['topProdCategory'] as String?,
      topCust: json['topCust'] as String?,
      topCustSalesAmt: (json['topCustSalesAmt'] as num?)?.toDouble(),
      topStaff: json['topStaff'] as String?,
      topStaffSalesAmt: (json['topStaffSalesAmt'] as num?)?.toDouble(),
      onlineProfits: (json['onlineProfits'] as num?)?.toDouble(),
      onlineRevenue: (json['onlineRevenue'] as num?)?.toDouble(),
      onlineSalesATS: (json['onlineSalesATS'] as num?)?.toDouble(),
      onlineSalesCount: (json['onlineSalesCount'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$BqOverviewReportToJson(BqOverviewReport instance) =>
    <String, dynamic>{
      'businessId': instance.businessId,
      'revenue': instance.revenue,
      'sales': instance.sales,
      'ats': instance.ats,
      'profits': instance.profits,
      'amtToTax': instance.amtToTax,
      'topProd': instance.topProd,
      'paymentMeth': instance.paymentMeth,
      'payMethPercent': instance.payMethPercent,
      'payMethAmt': instance.payMethAmt,
      'topProdSalesAmt': instance.topProdSalesAmt,
      'topProdCategory': instance.topProdCategory,
      'topCust': instance.topCust,
      'topCustSalesAmt': instance.topCustSalesAmt,
      'topStaff': instance.topStaff,
      'topStaffSalesAmt': instance.topStaffSalesAmt,
      'onlineRevenue': instance.onlineRevenue,
      'onlineSalesCount': instance.onlineSalesCount,
      'onlineSalesATS': instance.onlineSalesATS,
      'onlineProfits': instance.onlineProfits,
    };
