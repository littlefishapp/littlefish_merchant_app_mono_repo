import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order_refund_line_item.dart';

part 'order_refund.g.dart';

@JsonSerializable(explicitToJson: true)
class OrderRefund extends Equatable {
  final String id;
  final String transactionId;
  final double totalPrice;
  final double subtotalPrice;
  final double orderLineItemTotalPrice;
  final List<OrderRefundLineItem> refundLineItems;

  const OrderRefund({
    this.transactionId = '',
    this.totalPrice = 0.0,
    this.subtotalPrice = 0.0,
    this.orderLineItemTotalPrice = 0.0,
    this.refundLineItems = const [],
    this.id = '',
  });

  OrderRefund copyWith({
    String? id,
    String? transactionId,
    double? totalPrice,
    double? subtotalPrice,
    double? orderLineItemTotalPrice,
    List<OrderRefundLineItem>? refundLineItems,
  }) {
    return OrderRefund(
      id: id ?? this.id,
      orderLineItemTotalPrice:
          orderLineItemTotalPrice ?? this.orderLineItemTotalPrice,
      refundLineItems: refundLineItems ?? this.refundLineItems,
      subtotalPrice: subtotalPrice ?? this.subtotalPrice,
      totalPrice: totalPrice ?? this.totalPrice,
      transactionId: transactionId ?? this.transactionId,
    );
  }

  factory OrderRefund.fromJson(Map<String, dynamic> json) =>
      _$OrderRefundFromJson(json);

  Map<String, dynamic> toJson() => _$OrderRefundToJson(this);

  @override
  List<Object?> get props => [
    id,
    transactionId,
    totalPrice,
    subtotalPrice,
    orderLineItemTotalPrice,
    refundLineItems,
  ];
}

@JsonEnum()
enum RestockType {
  @JsonValue(-1)
  undefined,
  @JsonValue(0)
  noRestock,
  @JsonValue(1)
  cancel,
  @JsonValue(2)
  $return,
}
