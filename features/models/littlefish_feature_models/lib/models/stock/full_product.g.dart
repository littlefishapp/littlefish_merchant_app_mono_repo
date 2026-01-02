// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'full_product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FullProduct _$FullProductFromJson(Map<String, dynamic> json) => FullProduct(
  product: StockProduct.fromJson(json['product'] as Map<String, dynamic>),
  productOptions: (json['productOptions'] as List<dynamic>?)
      ?.map((e) => ProductOption.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$FullProductToJson(FullProduct instance) =>
    <String, dynamic>{
      'product': instance.product,
      'productOptions': instance.productOptions,
    };
