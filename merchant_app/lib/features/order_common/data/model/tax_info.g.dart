// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tax_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaxInfo _$TaxInfoFromJson(Map<String, dynamic> json) => TaxInfo(
  taxId: json['taxId'] as String? ?? '',
  name: json['name'] as String? ?? '',
  price: (json['price'] as num?)?.toDouble() ?? 0.0,
  rate: (json['rate'] as num?)?.toDouble() ?? 0.0,
  target:
      $enumDecodeNullable(_$TaxTargetEnumMap, json['target']) ??
      TaxTarget.undefined,
  type:
      $enumDecodeNullable(_$TaxTypeEnumMap, json['type']) ?? TaxType.undefined,
);

Map<String, dynamic> _$TaxInfoToJson(TaxInfo instance) => <String, dynamic>{
  'taxId': instance.taxId,
  'name': instance.name,
  'price': instance.price,
  'rate': instance.rate,
  'type': _$TaxTypeEnumMap[instance.type]!,
  'target': _$TaxTargetEnumMap[instance.target]!,
};

const _$TaxTargetEnumMap = {
  TaxTarget.undefined: -1,
  TaxTarget.lineItem: 0,
  TaxTarget.cart: 1,
};

const _$TaxTypeEnumMap = {
  TaxType.undefined: -1,
  TaxType.amount: 0,
  TaxType.percentage: 1,
};
