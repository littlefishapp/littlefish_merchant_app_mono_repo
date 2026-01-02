// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_take_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockTakeItem _$StockTakeItemFromJson(Map<String, dynamic> json) =>
    StockTakeItem(
        stockCount: (json['stockCount'] as num?)?.toDouble(),
        productName: json['productName'] as String?,
        varianceName: json['varianceName'] as String?,
        costPrice: (json['costPrice'] as num?)?.toDouble() ?? 0.0,
        type: $enumDecodeNullable(_$StockRunTypeEnumMap, json['type']),
      )
      ..productId = json['productId'] as String?
      ..varianceId = json['varianceId'] as String?
      ..expectedItemCount = (json['expectedItemCount'] as num?)?.toDouble();

Map<String, dynamic> _$StockTakeItemToJson(StockTakeItem instance) =>
    <String, dynamic>{
      'productName': instance.productName,
      'varianceName': instance.varianceName,
      'type': _$StockRunTypeEnumMap[instance.type],
      'productId': instance.productId,
      'varianceId': instance.varianceId,
      'stockCount': instance.stockCount,
      'expectedItemCount': instance.expectedItemCount,
      'costPrice': instance.costPrice,
    };

const _$StockRunTypeEnumMap = {
  StockRunType.reCount: 0,
  StockRunType.damagedStock: 1,
  StockRunType.theft: 2,
  StockRunType.loss: 3,
  StockRunType.returnedStock: 4,
  StockRunType.otherDecrease: 5,
  StockRunType.otherIncrease: 6,
};
