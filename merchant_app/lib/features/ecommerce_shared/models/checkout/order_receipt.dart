import 'package:json_annotation/json_annotation.dart';

import 'checkout_order.dart';

part 'order_receipt.g.dart';

@JsonSerializable()
class OrderReceipt {
  String? storeId, userId, orderId, id;
  String? receiptPDF;
  String? customerEmail, customerName;
  double? orderValue;
  int? quantity;
  List<CheckoutItem>? items;

  OrderReceipt({
    this.customerEmail,
    this.quantity,
    this.items,
    this.customerName,
    this.orderId,
    this.storeId,
    this.userId,
    this.orderValue,
    this.id,
    this.receiptPDF,
  });

  factory OrderReceipt.fromJson(Map<String, dynamic> json) =>
      _$OrderReceiptFromJson(json);

  Map<String, dynamic> toJson() => _$OrderReceiptToJson(this);
}
