// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusinessType _$BusinessTypeFromJson(Map<String, dynamic> json) => BusinessType(
  description: json['description'] as String?,
  enabled: json['enabled'] as bool?,
  id: json['id'] as String?,
  name: json['name'] as String?,
  subTypes: (json['subTypes'] as List<dynamic>?)
      ?.map((e) => BusinessType.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$BusinessTypeToJson(BusinessType instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'enabled': instance.enabled,
      'subTypes': instance.subTypes?.map((e) => e.toJson()).toList(),
    };
