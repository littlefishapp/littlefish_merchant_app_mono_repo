// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_cart_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckoutCartItem _$CheckoutCartItemFromJson(Map<String, dynamic> json) =>
    CheckoutCartItem(
        description: json['description'] as String?,
        quantity: (json['quantity'] as num?)?.toDouble() ?? 1,
        itemValue: (json['itemValue'] as num?)?.toDouble() ?? 0,
        cartIndex: (json['cartIndex'] as num?)?.toInt(),
        varianceId: json['varianceId'] as String?,
        productId: json['productId'] as String?,
        barcode: json['barcode'] as String?,
        itemCost: (json['itemCost'] as num?)?.toDouble() ?? 0,
        isCombo: json['isCombo'] as bool? ?? false,
        comboId: json['comboId'] as String?,
        id: json['id'] as String?,
        taxId: json['taxId'] as String?,
        isPromotion: json['isPromotion'] as bool? ?? false,
        itemSaving: (json['itemSaving'] as num?)?.toDouble() ?? 0.0,
        itemTax: (json['itemTax'] as num?)?.toDouble() ?? 0.0,
        promoId: json['promoId'] as String?,
        itemType: $enumDecodeNullable(
          _$CheckoutCartItemTypeEnumMap,
          json['itemType'],
        ),
      )
      ..isService = json['isService'] as bool? ?? false
      ..isCustomSale = json['isCustomSale'] as bool? ?? false
      ..valueCost = (json['valueCost'] as num?)?.toDouble() ?? 0
      ..value = (json['value'] as num?)?.toDouble();

Map<String, dynamic> _$CheckoutCartItemToJson(CheckoutCartItem instance) =>
    <String, dynamic>{
      'cartIndex': instance.cartIndex,
      'id': instance.id,
      'taxId': instance.taxId,
      'description': instance.description,
      'quantity': instance.quantity,
      'itemCost': instance.itemCost,
      'itemValue': instance.itemValue,
      'productId': instance.productId,
      'varianceId': instance.varianceId,
      'barcode': instance.barcode,
      'isCombo': instance.isCombo,
      'itemType': _$CheckoutCartItemTypeEnumMap[instance.itemType],
      'comboId': instance.comboId,
      'promoId': instance.promoId,
      'isPromotion': instance.isPromotion,
      'isService': instance.isService,
      'isCustomSale': instance.isCustomSale,
      'itemSaving': instance.itemSaving,
      'itemTax': instance.itemTax,
      'valueCost': instance.valueCost,
      'value': instance.value,
    };

const _$CheckoutCartItemTypeEnumMap = {
  CheckoutCartItemType.stockProduct: 0,
  CheckoutCartItemType.productCombo: 1,
  CheckoutCartItemType.customItem: 2,
};
