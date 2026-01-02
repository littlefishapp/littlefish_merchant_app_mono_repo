// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paged_product_sales_summary_view.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PagedProductSalesSummaryView _$PagedProductSalesSummaryViewFromJson(
  Map<String, dynamic> json,
) => PagedProductSalesSummaryView(
  result: (json['result'] as List<dynamic>?)
      ?.map((e) => ProductSalesSummaryView.fromJson(e as Map<String, dynamic>))
      .toList(),
  count: (json['count'] as num?)?.toInt(),
);

Map<String, dynamic> _$PagedProductSalesSummaryViewToJson(
  PagedProductSalesSummaryView instance,
) => <String, dynamic>{'count': instance.count, 'result': instance.result};

ProductSalesSummaryView _$ProductSalesSummaryViewFromJson(
  Map<String, dynamic> json,
) => ProductSalesSummaryView(
  productId: json['productId'] as String?,
  productName: json['productName'] as String?,
  quantitySold: (json['quantitySold'] as num?)?.toDouble(),
  totalSalesValue: (json['totalSalesValue'] as num?)?.toDouble(),
);

Map<String, dynamic> _$ProductSalesSummaryViewToJson(
  ProductSalesSummaryView instance,
) => <String, dynamic>{
  'productId': instance.productId,
  'productName': instance.productName,
  'quantitySold': instance.quantitySold,
  'totalSalesValue': instance.totalSalesValue,
};
