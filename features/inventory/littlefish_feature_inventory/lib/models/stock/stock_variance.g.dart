// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_variance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockVariance _$StockVarianceFromJson(Map<String, dynamic> json) =>
    StockVariance(
      type: $enumDecodeNullable(_$StockVarianceTypeEnumMap, json['type']),
      quantity: (json['quantity'] as num?)?.toDouble() ?? 0,
      sellingPrice: (json['sellingPrice'] as num?)?.toDouble(),
      costPrice: (json['costPrice'] as num?)?.toDouble(),
      name: json['name'] as String?,
      id: json['id'] as String?,
      lowQuantityValue: (json['lowQuantityValue'] as num?)?.toDouble() ?? 10,
      vat: (json['vat'] as num?)?.toDouble() ?? 0,
      margin: (json['margin'] as num?)?.toDouble() ?? 0,
      supplier: json['supplier'] as String? ?? '',
      barcode: json['barcode'] as String?,
    )..markup = (json['markup'] as num?)?.toDouble();

Map<String, dynamic> _$StockVarianceToJson(StockVariance instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$StockVarianceTypeEnumMap[instance.type],
      'name': instance.name,
      'barcode': instance.barcode,
      'quantity': instance.quantity,
      'sellingPrice': instance.sellingPrice,
      'costPrice': instance.costPrice,
      'lowQuantityValue': instance.lowQuantityValue,
      'vat': instance.vat,
      'margin': instance.margin,
      'supplier': instance.supplier,
      'markup': instance.markup,
    };

const _$StockVarianceTypeEnumMap = {
  StockVarianceType.regular: 0,
  StockVarianceType.custom: 1,
};
