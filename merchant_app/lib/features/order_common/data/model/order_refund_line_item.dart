import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order_line_item.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order_refund.dart';

part 'order_refund_line_item.g.dart';

@JsonSerializable(explicitToJson: true)
class OrderRefundLineItem extends Equatable {
  final String productId;
  final String name;
  final OrderLineItem orderLineItem;
  final double quantity;
  final String transactionId;
  final String refundId;
  final RestockType restockType;
  final DateTime? dateCreated;
  final DateTime? dateUpdated;
  final String createdBy;
  final String updatedBy;

  const OrderRefundLineItem({
    this.name = '',
    this.orderLineItem = const OrderLineItem(),
    this.productId = '',
    this.quantity = 0.0,
    this.refundId = '',
    this.restockType = RestockType.undefined,
    this.transactionId = '',
    this.createdBy = '',
    this.dateCreated,
    this.dateUpdated,
    this.updatedBy = '',
  });

  OrderRefundLineItem copyWith({
    String? productId,
    String? name,
    OrderLineItem? orderLineItem,
    double? quantity,
    String? transactionId,
    String? refundId,
    RestockType? restockType,
    DateTime? dateCreated,
    DateTime? dateUpdated,
    String? createdBy,
    String? updatedBy,
  }) {
    return OrderRefundLineItem(
      name: name ?? this.name,
      orderLineItem: orderLineItem ?? this.orderLineItem,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      refundId: refundId ?? this.refundId,
      restockType: restockType ?? this.restockType,
      transactionId: transactionId ?? this.transactionId,
      createdBy: createdBy ?? this.createdBy,
      dateCreated: dateCreated ?? this.dateCreated,
      dateUpdated: dateUpdated ?? this.dateUpdated,
      updatedBy: updatedBy ?? this.updatedBy,
    );
  }

  factory OrderRefundLineItem.fromJson(Map<String, dynamic> json) =>
      _$OrderRefundLineItemFromJson(json);

  Map<String, dynamic> toJson() => _$OrderRefundLineItemToJson(this);

  @override
  List<Object?> get props => [
    productId,
    name,
    orderLineItem,
    quantity,
    transactionId,
    refundId,
    restockType,
    dateCreated,
    dateUpdated,
    createdBy,
    updatedBy,
  ];
}
