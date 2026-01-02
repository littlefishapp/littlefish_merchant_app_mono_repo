// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_modifier.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModifier _$ProductModifierFromJson(Map<String, dynamic> json) =>
    ProductModifier(
        maxSelection: (json['maxSelection'] as num?)?.toInt(),
        modifiers: (json['modifiers'] as List<dynamic>?)
            ?.map((e) => Modifier.fromJson(e as Map<String, dynamic>))
            .toList(),
        multiSelect: json['multipleSelection'] as bool? ?? false,
      )
      ..id = json['id'] as String?
      ..name = json['name'] as String?
      ..description = json['description'] as String?
      ..status = json['status'] as String?
      ..businessId = json['businessId'] as String?
      ..displayName = json['displayName'] as String?
      ..deviceName = json['deviceName'] as String?
      ..dateCreated = const IsoDateTimeConverter().fromJson(json['dateCreated'])
      ..dateUpdated = const IsoDateTimeConverter().fromJson(json['dateUpdated'])
      ..createdBy = json['createdBy'] as String?
      ..updatedBy = json['updatedBy'] as String?
      ..indexNo = (json['indexNo'] as num?)?.toInt()
      ..deleted = json['deleted'] as bool?
      ..enabled = json['enabled'] as bool?;

Map<String, dynamic> _$ProductModifierToJson(ProductModifier instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'status': instance.status,
      'businessId': instance.businessId,
      'displayName': instance.displayName,
      'deviceName': instance.deviceName,
      'dateCreated': const IsoDateTimeConverter().toJson(instance.dateCreated),
      'dateUpdated': const IsoDateTimeConverter().toJson(instance.dateUpdated),
      'createdBy': instance.createdBy,
      'updatedBy': instance.updatedBy,
      'indexNo': instance.indexNo,
      'deleted': instance.deleted,
      'enabled': instance.enabled,
      'multipleSelection': instance.multiSelect,
      'maxSelection': instance.maxSelection,
      'modifiers': instance.modifiers,
    };

Modifier _$ModifierFromJson(Map<String, dynamic> json) => Modifier(
  id: json['id'] as String?,
  name: json['name'] as String?,
  price: (json['price'] as num?)?.toDouble(),
);

Map<String, dynamic> _$ModifierToJson(Modifier instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'price': instance.price,
};
