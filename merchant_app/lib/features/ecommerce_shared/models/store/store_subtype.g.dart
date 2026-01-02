// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_subtype.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreSubtype _$StoreSubtypeFromJson(Map<String, dynamic> json) => StoreSubtype(
  storeType: json['storeType'] as String?,
  description: json['description'] as String?,
  displayName: json['displayName'] as String?,
  id: json['id'] as String?,
  imageUrl: json['imageUrl'] as String?,
  name: json['name'] as String?,
  storeCount: (json['storeCount'] as num?)?.toInt(),
  productTypeCount: (json['productTypeCount'] as num?)?.toInt(),
  icon: json['icon'] as String?,
);

Map<String, dynamic> _$StoreSubtypeToJson(StoreSubtype instance) =>
    <String, dynamic>{
      'storeType': instance.storeType,
      'name': instance.name,
      'displayName': instance.displayName,
      'description': instance.description,
      'icon': instance.icon,
      'id': instance.id,
      'imageUrl': instance.imageUrl,
      'storeCount': instance.storeCount,
      'productTypeCount': instance.productTypeCount,
    };

StoreProductType _$StoreProductTypeFromJson(Map<String, dynamic> json) =>
    StoreProductType(
      description: json['description'] as String?,
      displayName: json['displayName'] as String?,
      id: json['id'] as String?,
      storeSubtypeId: json['storeSubtypeId'] as String?,
      name: json['name'] as String?,
      subgroup: json['subgroup'] as String?,
      storeCount: (json['storeCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$StoreProductTypeToJson(StoreProductType instance) =>
    <String, dynamic>{
      'name': instance.name,
      'displayName': instance.displayName,
      'description': instance.description,
      'subgroup': instance.subgroup,
      'id': instance.id,
      'storeSubtypeId': instance.storeSubtypeId,
      'storeCount': instance.storeCount,
    };

StoreAttributeGroupLink _$StoreAttributeGroupLinkFromJson(
  Map<String, dynamic> json,
) => StoreAttributeGroupLink(
  id: json['id'] as String?,
  storeSubtypeId: json['storeSubtypeId'] as String?,
);

Map<String, dynamic> _$StoreAttributeGroupLinkToJson(
  StoreAttributeGroupLink instance,
) => <String, dynamic>{
  'id': instance.id,
  'storeSubtypeId': instance.storeSubtypeId,
};
