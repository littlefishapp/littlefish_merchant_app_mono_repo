// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_refund_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RefundItem _$RefundItemFromJson(Map<String, dynamic> json) => RefundItem(
  checkoutCartItemId: json['checkoutCartItemId'] as String,
  displayName: json['displayName'] as String?,
  quantity: (json['quantity'] as num?)?.toDouble(),
  itemCost: (json['itemCost'] as num?)?.toDouble(),
  itemTotalCost: (json['itemTotalCost'] as num?)?.toDouble(),
  itemValue: (json['itemValue'] as num?)?.toDouble(),
  itemTotalValue: (json['itemTotalValue'] as num?)?.toDouble(),
  type: $enumDecodeNullable(_$StockRunTypeEnumMap, json['type']),
);

Map<String, dynamic> _$RefundItemToJson(RefundItem instance) =>
    <String, dynamic>{
      'checkoutCartItemId': instance.checkoutCartItemId,
      'displayName': instance.displayName,
      'quantity': instance.quantity,
      'itemCost': instance.itemCost,
      'itemTotalCost': instance.itemTotalCost,
      'itemValue': instance.itemValue,
      'itemTotalValue': instance.itemTotalValue,
      'type': _$StockRunTypeEnumMap[instance.type],
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
