// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_line_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderLineItem _$OrderLineItemFromJson(Map<String, dynamic> json) =>
    OrderLineItem(
      id: json['id'] as String? ?? '',
      orderId: json['orderId'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      unitPrice: (json['unitPrice'] as num?)?.toDouble() ?? 0.0,
      businessId: json['businessId'] as String? ?? '',
      productId: json['productId'] as String? ?? '',
      quantity: (json['quantity'] as num?)?.toDouble() ?? 0,
      subtotalPrice: (json['subtotalPrice'] as num?)?.toDouble() ?? 0.0,
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
      unitCost: (json['unitCost'] as num?)?.toDouble() ?? 0.0,
      taxable: json['taxable'] as bool? ?? false,
      isCombo: json['isCombo'] as bool? ?? false,
      isStockTrackable: json['isStockTrackable'] as bool? ?? false,
      comboItems:
          (json['comboItems'] as List<dynamic>?)
              ?.map((e) => ComboInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      discounts:
          (json['discounts'] as List<dynamic>?)
              ?.map((e) => OrderDiscount.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      imageUrl: json['imageUrl'] as String? ?? '',
      sku: json['sku'] as String? ?? '',
      taxInfo: json['taxInfo'] == null
          ? const TaxInfo()
          : TaxInfo.fromJson(json['taxInfo'] as Map<String, dynamic>),
      variantId: json['variantId'] as String? ?? '',
    );

Map<String, dynamic> _$OrderLineItemToJson(OrderLineItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderId': instance.orderId,
      'displayName': instance.displayName,
      'unitPrice': instance.unitPrice,
      'unitCost': instance.unitCost,
      'subtotalPrice': instance.subtotalPrice,
      'totalPrice': instance.totalPrice,
      'quantity': instance.quantity,
      'taxable': instance.taxable,
      'taxInfo': instance.taxInfo.toJson(),
      'sku': instance.sku,
      'variantId': instance.variantId,
      'imageUrl': instance.imageUrl,
      'businessId': instance.businessId,
      'productId': instance.productId,
      'discounts': instance.discounts.map((e) => e.toJson()).toList(),
      'isCombo': instance.isCombo,
      'isStockTrackable': instance.isStockTrackable,
      'comboItems': instance.comboItems.map((e) => e.toJson()).toList(),
    };
