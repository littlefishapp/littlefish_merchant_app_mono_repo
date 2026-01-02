// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_system_value.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusinessSystemValue _$BusinessSystemValueFromJson(Map<String, dynamic> json) =>
    BusinessSystemValue(
      businessId: json['businessId'] as String?,
      id: json['id'] as String?,
      key: json['key'] as String?,
      lastUpdated: const IsoDateTimeConverter().fromJson(json['lastUpdated']),
      value: json['value'],
      sectionKey: json['sectionKey'] as String?,
    );

Map<String, dynamic> _$BusinessSystemValueToJson(
  BusinessSystemValue instance,
) => <String, dynamic>{
  'id': instance.id,
  'businessId': instance.businessId,
  'key': instance.key,
  'sectionKey': instance.sectionKey,
  'value': instance.value,
  'lastUpdated': const IsoDateTimeConverter().toJson(instance.lastUpdated),
};
