// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_refund.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderRefund _$OrderRefundFromJson(Map<String, dynamic> json) => OrderRefund(
  transactionId: json['transactionId'] as String? ?? '',
  totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
  subtotalPrice: (json['subtotalPrice'] as num?)?.toDouble() ?? 0.0,
  orderLineItemTotalPrice:
      (json['orderLineItemTotalPrice'] as num?)?.toDouble() ?? 0.0,
  refundLineItems:
      (json['refundLineItems'] as List<dynamic>?)
          ?.map((e) => OrderRefundLineItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  id: json['id'] as String? ?? '',
);

Map<String, dynamic> _$OrderRefundToJson(
  OrderRefund instance,
) => <String, dynamic>{
  'id': instance.id,
  'transactionId': instance.transactionId,
  'totalPrice': instance.totalPrice,
  'subtotalPrice': instance.subtotalPrice,
  'orderLineItemTotalPrice': instance.orderLineItemTotalPrice,
  'refundLineItems': instance.refundLineItems.map((e) => e.toJson()).toList(),
};
