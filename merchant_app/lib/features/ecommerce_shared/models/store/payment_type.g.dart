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
  provider: _$JsonConverterFromJson<int, PaymentProvider>(
    json['provider'],
    const PaymentProviderConverter().fromJson,
  ),
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
      'provider': _$JsonConverterToJson<int, PaymentProvider>(
        instance.provider,
        const PaymentProviderConverter().toJson,
      ),
      'displayIndex': instance.displayIndex,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
