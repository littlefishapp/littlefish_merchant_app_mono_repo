// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductReport _$ProductReportFromJson(Map<String, dynamic> json) =>
    ProductReport(
      avgCostPrice: (json['avgCostPrice'] as num?)?.toDouble(),
      avgMarkup: (json['avgMarkup'] as num?)?.toDouble(),
      avgProfit: (json['avgProfit'] as num?)?.toDouble(),
      avgSellingPrice: (json['avgSellingPrice'] as num?)?.toDouble(),
      mostProfitableProduct: (json['mostProfitableProduct'] as List<dynamic>?)
          ?.map((e) => ReportView.fromJson(e as Map<String, dynamic>))
          .toList(),
      mostSoldProduct: (json['mostSoldProduct'] as List<dynamic>?)
          ?.map((e) => ReportView.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalProducts: (json['totalProducts'] as num?)?.toInt(),
      totalQuantity: (json['totalQuantity'] as num?)?.toDouble(),
      totalValue: (json['totalValue'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$ProductReportToJson(ProductReport instance) =>
    <String, dynamic>{
      'totalProducts': instance.totalProducts,
      'totalQuantity': instance.totalQuantity,
      'totalValue': instance.totalValue,
      'avgMarkup': instance.avgMarkup,
      'avgSellingPrice': instance.avgSellingPrice,
      'avgCostPrice': instance.avgCostPrice,
      'avgProfit': instance.avgProfit,
      'mostSoldProduct': instance.mostSoldProduct,
      'mostProfitableProduct': instance.mostProfitableProduct,
    };
