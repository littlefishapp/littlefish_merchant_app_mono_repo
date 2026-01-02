// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_receipt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderReceipt _$OrderReceiptFromJson(Map<String, dynamic> json) => OrderReceipt(
  customerEmail: json['customerEmail'] as String?,
  quantity: (json['quantity'] as num?)?.toInt(),
  items: (json['items'] as List<dynamic>?)
      ?.map((e) => CheckoutItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  customerName: json['customerName'] as String?,
  orderId: json['orderId'] as String?,
  storeId: json['storeId'] as String?,
  userId: json['userId'] as String?,
  orderValue: (json['orderValue'] as num?)?.toDouble(),
  id: json['id'] as String?,
  receiptPDF: json['receiptPDF'] as String?,
);

Map<String, dynamic> _$OrderReceiptToJson(OrderReceipt instance) =>
    <String, dynamic>{
      'storeId': instance.storeId,
      'userId': instance.userId,
      'orderId': instance.orderId,
      'id': instance.id,
      'receiptPDF': instance.receiptPDF,
      'customerEmail': instance.customerEmail,
      'customerName': instance.customerName,
      'orderValue': instance.orderValue,
      'quantity': instance.quantity,
      'items': instance.items,
    };
