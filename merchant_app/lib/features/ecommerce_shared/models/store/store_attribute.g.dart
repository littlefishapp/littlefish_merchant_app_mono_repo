// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_attribute.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreAttributeGroup _$StoreAttributeGroupFromJson(Map<String, dynamic> json) =>
    StoreAttributeGroup(
      description: json['description'] as String?,
      displayName: json['displayName'] as String?,
      imageUrl: json['imageUrl'] as String?,
      name: json['name'] as String?,
      storeCount: (json['storeCount'] as num?)?.toInt(),
      id: json['id'] as String?,
    );

Map<String, dynamic> _$StoreAttributeGroupToJson(
  StoreAttributeGroup instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'displayName': instance.displayName,
  'description': instance.description,
  'storeCount': instance.storeCount,
  'imageUrl': instance.imageUrl,
};

StoreAttribute _$StoreAttributeFromJson(Map<String, dynamic> json) =>
    StoreAttribute(
      attributeGroup: json['attributeGroup'] as String?,
      description: json['description'] as String?,
      displayName: json['displayName'] as String?,
      groupType:
          _$JsonConverterFromJson<String, StoreAttributeGroupSelectType?>(
            json['groupType'],
            const StoreAttributeGroupSelectTypeConverter().fromJson,
          ),
      imageUrl: json['imageUrl'] as String?,
      name: json['name'] as String?,
      id: json['id'] as String?,
      storeCount: (json['storeCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$StoreAttributeToJson(StoreAttribute instance) =>
    <String, dynamic>{
      'name': instance.name,
      'displayName': instance.displayName,
      'description': instance.description,
      'storeCount': instance.storeCount,
      'imageUrl': instance.imageUrl,
      'groupType': const StoreAttributeGroupSelectTypeConverter().toJson(
        instance.groupType,
      ),
      'attributeGroup': instance.attributeGroup,
      'id': instance.id,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);
