import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:littlefish_merchant/features/order_common/data/model/combo_info.dart';
import 'package:uuid/uuid.dart';

import 'order_discount.dart';
import 'tax_info.dart';

part 'order_line_item.g.dart';

@JsonSerializable(explicitToJson: true)
class OrderLineItem extends Equatable {
  final String id;
  final String orderId;
  final String displayName;
  final double unitPrice;
  final double unitCost;
  final double subtotalPrice;
  final double totalPrice;
  final double quantity;
  final bool taxable;
  final TaxInfo taxInfo;
  final String sku;
  final String variantId;
  final String imageUrl;
  final String businessId;
  final String productId;
  final List<OrderDiscount> discounts;
  final bool isCombo;
  final bool isStockTrackable;
  final List<ComboInfo> comboItems;

  const OrderLineItem({
    this.id = '',
    this.orderId = '',
    this.displayName = '',
    this.unitPrice = 0.0,
    this.businessId = '',
    this.productId = '',
    this.quantity = 0,
    this.subtotalPrice = 0.0,
    this.totalPrice = 0.0,
    this.unitCost = 0.0,
    this.taxable = false,
    this.isCombo = false,
    this.isStockTrackable = false,
    this.comboItems = const [],
    this.discounts = const [],
    this.imageUrl = '',
    this.sku = '',
    this.taxInfo = const TaxInfo(),
    this.variantId = '',
  });

  OrderLineItem copyWith({
    String? id,
    String? orderId,
    String? displayName,
    double? unitPrice,
    double? unitCost,
    double? subtotalPrice,
    double? totalPrice,
    double? quantity,
    bool? taxable,
    TaxInfo? taxInfo,
    String? sku,
    String? variantId,
    String? imageUrl,
    String? businessId,
    String? productId,
    List<OrderDiscount>? discounts,
    bool? isCombo,
    bool? isStockTrackable,
    List<ComboInfo>? comboItems,
  }) {
    return OrderLineItem(
      businessId: businessId ?? this.businessId,
      comboItems: comboItems ?? this.comboItems,
      discounts: discounts ?? this.discounts,
      displayName: displayName ?? this.displayName,
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      isCombo: isCombo ?? this.isCombo,
      isStockTrackable: isStockTrackable ?? this.isStockTrackable,
      orderId: orderId ?? this.orderId,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      sku: sku ?? this.sku,
      subtotalPrice: subtotalPrice ?? this.subtotalPrice,
      taxInfo: taxInfo ?? this.taxInfo,
      taxable: taxable ?? this.taxable,
      totalPrice: totalPrice ?? this.totalPrice,
      unitCost: unitCost ?? this.unitCost,
      unitPrice: unitPrice ?? this.unitPrice,
      variantId: variantId ?? this.variantId,
    );
  }

  OrderLineItem fromQuickSale({
    String? orderId,
    String? businessId,
    String? description,
    double? amount,
  }) {
    return OrderLineItem(
      businessId: businessId ?? this.businessId,
      orderId: orderId ?? this.orderId,
      id: const Uuid().v4(),
      displayName: description ?? '',
      quantity: 1,
      subtotalPrice: amount ?? 0,
    );
  }

  factory OrderLineItem.fromJson(Map<String, dynamic> json) =>
      _$OrderLineItemFromJson(json);

  Map<String, dynamic> toJson() => _$OrderLineItemToJson(this);

  @override
  List<Object?> get props => [
    id,
    orderId,
    displayName,
    unitPrice,
    unitCost,
    subtotalPrice,
    totalPrice,
    quantity,
    taxable,
    taxInfo,
    sku,
    variantId,
    imageUrl,
    businessId,
    productId,
    discounts,
    isCombo,
    isStockTrackable,
    comboItems,
  ];
}
