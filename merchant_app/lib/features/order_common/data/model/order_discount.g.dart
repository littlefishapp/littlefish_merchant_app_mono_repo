// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_discount.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderDiscount _$OrderDiscountFromJson(Map<String, dynamic> json) =>
    OrderDiscount(
      id: json['id'] as String? ?? '',
      discountTarget:
          $enumDecodeNullable(
            _$DiscountTargetEnumMap,
            json['discountTarget'],
          ) ??
          DiscountTarget.undefined,
      type:
          $enumDecodeNullable(_$DiscountValueTypeEnumMap, json['type']) ??
          DiscountValueType.undefined,
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$OrderDiscountToJson(OrderDiscount instance) =>
    <String, dynamic>{
      'id': instance.id,
      'value': instance.value,
      'type': _$DiscountValueTypeEnumMap[instance.type]!,
      'discountTarget': _$DiscountTargetEnumMap[instance.discountTarget]!,
    };

const _$DiscountTargetEnumMap = {
  DiscountTarget.undefined: -1,
  DiscountTarget.lineItem: 0,
  DiscountTarget.cart: 1,
  DiscountTarget.shipping: 2,
};

const _$DiscountValueTypeEnumMap = {
  DiscountValueType.undefined: -1,
  DiscountValueType.fixedAmount: 0,
  DiscountValueType.percentage: 1,
};
