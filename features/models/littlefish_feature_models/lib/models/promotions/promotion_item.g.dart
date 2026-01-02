// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promotion_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PromotionItem _$PromotionItemFromJson(Map<String, dynamic> json) =>
    PromotionItem(
      promoUnitPrice: (json['promoUnitPrice'] as num?)?.toDouble() ?? 0.0,
      costPrice: (json['costPrice'] as num?)?.toDouble() ?? 0.0,
      discountType:
          $enumDecodeNullable(_$DiscountTypeEnumMap, json['discountType']) ??
          DiscountType.fixedPrice,
      discountValue: (json['discountValue'] as num?)?.toDouble() ?? 0.0,
      itemId: json['itemId'] as String?,
      itemType:
          $enumDecodeNullable(_$PromoItemTypeEnumMap, json['itemType']) ??
          PromoItemType.product,
      name: json['name'] as String?,
      percentageDiscount:
          (json['percentageDiscount'] as num?)?.toDouble() ?? 0.0,
      quantity: (json['quantity'] as num?)?.toDouble() ?? 0.0,
      sellingPrice: (json['sellingPrice'] as num?)?.toDouble() ?? 0.0,
      varianceId: json['varianceId'] as String?,
      promoSellingPrice: (json['promoSellingPrice'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$PromotionItemToJson(PromotionItem instance) =>
    <String, dynamic>{
      'name': instance.name,
      'itemId': instance.itemId,
      'varianceId': instance.varianceId,
      'quantity': instance.quantity,
      'costPrice': instance.costPrice,
      'sellingPrice': instance.sellingPrice,
      'promoUnitPrice': instance.promoUnitPrice,
      'promoSellingPrice': instance.promoSellingPrice,
      'discountValue': instance.discountValue,
      'percentageDiscount': instance.percentageDiscount,
      'itemType': _$PromoItemTypeEnumMap[instance.itemType],
      'discountType': _$DiscountTypeEnumMap[instance.discountType],
    };

const _$DiscountTypeEnumMap = {
  DiscountType.fixedPrice: 0,
  DiscountType.fixedDiscountAmount: 1,
  DiscountType.percentage: 2,
  DiscountType.none: 3,
};

const _$PromoItemTypeEnumMap = {
  PromoItemType.product: 'product',
  PromoItemType.combo: 'combo',
};
