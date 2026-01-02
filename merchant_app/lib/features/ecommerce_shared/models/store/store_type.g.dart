// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreType _$StoreTypeFromJson(Map<String, dynamic> json) => StoreType(
  id: json['id'] as String?,
  description: json['description'] as String?,
  displayName: json['displayName'] as String?,
  imageUrl: json['imageUrl'] as String?,
  name: json['name'] as String?,
  storeCount: (json['storeCount'] as num?)?.toInt(),
);

Map<String, dynamic> _$StoreTypeToJson(StoreType instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'displayName': instance.displayName,
  'description': instance.description,
  'storeCount': instance.storeCount,
  'imageUrl': instance.imageUrl,
};
