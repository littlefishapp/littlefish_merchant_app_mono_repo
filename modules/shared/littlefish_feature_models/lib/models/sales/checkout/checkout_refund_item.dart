// Package imports:
import 'package:json_annotation/json_annotation.dart';
import 'package:littlefish_merchant/models/stock/stock_take_item.dart';

// Project imports:
part 'checkout_refund_item.g.dart';

@JsonSerializable(createToJson: true, explicitToJson: true)
class RefundItem {
  String checkoutCartItemId;
  String? displayName;
  late double? quantity;
  double? itemCost;
  double? itemTotalCost;
  double? itemValue;
  double? itemTotalValue;
  StockRunType? type;

  RefundItem({
    required this.checkoutCartItemId,
    this.displayName,
    this.quantity,
    this.itemCost,
    this.itemTotalCost,
    this.itemValue,
    this.itemTotalValue,
    this.type,
  });

  factory RefundItem.fromJson(Map<String, dynamic> json) =>
      _$RefundItemFromJson(json);

  Map<String, dynamic> toJson() => _$RefundItemToJson(this);
}
