// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_refund_line_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderRefundLineItem _$OrderRefundLineItemFromJson(Map<String, dynamic> json) =>
    OrderRefundLineItem(
      name: json['name'] as String? ?? '',
      orderLineItem: json['orderLineItem'] == null
          ? const OrderLineItem()
          : OrderLineItem.fromJson(
              json['orderLineItem'] as Map<String, dynamic>,
            ),
      productId: json['productId'] as String? ?? '',
      quantity: (json['quantity'] as num?)?.toDouble() ?? 0.0,
      refundId: json['refundId'] as String? ?? '',
      restockType:
          $enumDecodeNullable(_$RestockTypeEnumMap, json['restockType']) ??
          RestockType.undefined,
      transactionId: json['transactionId'] as String? ?? '',
      createdBy: json['createdBy'] as String? ?? '',
      dateCreated: json['dateCreated'] == null
          ? null
          : DateTime.parse(json['dateCreated'] as String),
      dateUpdated: json['dateUpdated'] == null
          ? null
          : DateTime.parse(json['dateUpdated'] as String),
      updatedBy: json['updatedBy'] as String? ?? '',
    );

Map<String, dynamic> _$OrderRefundLineItemToJson(
  OrderRefundLineItem instance,
) => <String, dynamic>{
  'productId': instance.productId,
  'name': instance.name,
  'orderLineItem': instance.orderLineItem.toJson(),
  'quantity': instance.quantity,
  'transactionId': instance.transactionId,
  'refundId': instance.refundId,
  'restockType': _$RestockTypeEnumMap[instance.restockType]!,
  'dateCreated': instance.dateCreated?.toIso8601String(),
  'dateUpdated': instance.dateUpdated?.toIso8601String(),
  'createdBy': instance.createdBy,
  'updatedBy': instance.updatedBy,
};

const _$RestockTypeEnumMap = {
  RestockType.undefined: -1,
  RestockType.noRestock: 0,
  RestockType.cancel: 1,
  RestockType.$return: 2,
};
