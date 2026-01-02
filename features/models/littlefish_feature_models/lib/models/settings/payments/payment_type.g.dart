// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentType _$PaymentTypeFromJson(Map<String, dynamic> json) => PaymentType(
  enabled: json['enabled'] as bool?,
  id: json['id'] as String?,
  name: json['name'] as String?,
  displayIndex: (json['displayIndex'] as num?)?.toInt() ?? 0,
  provider: $enumDecodeNullable(_$PaymentProviderEnumMap, json['provider']),
  paid: json['paid'] as bool?,
  providerPaymentReference: json['providerPaymentReference'] as String?,
);

Map<String, dynamic> _$PaymentTypeToJson(PaymentType instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'providerPaymentReference': instance.providerPaymentReference,
      'enabled': instance.enabled,
      'paid': instance.paid,
      'provider': _$PaymentProviderEnumMap[instance.provider],
      'displayIndex': instance.displayIndex,
    };

const _$PaymentProviderEnumMap = {
  PaymentProvider.none: 0,
  PaymentProvider.zapper: 1,
  PaymentProvider.snapscan: 2,
};
