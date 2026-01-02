// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_setting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderSetting _$OrderSettingFromJson(Map<String, dynamic> json) =>
    OrderSetting(
        json['enabled'] as bool?,
        (json['items'] as List<dynamic>?)
            ?.map((e) => OrderSettingItem.fromJson(e as Map<String, dynamic>))
            .toList(),
      )
      ..id = json['id'] as String?
      ..businessId = json['businessId'] as String?
      ..dateUpdated = json['dateUpdated'] == null
          ? null
          : DateTime.parse(json['dateUpdated'] as String)
      ..dateCreated = json['dateCreated'] == null
          ? null
          : DateTime.parse(json['dateCreated'] as String)
      ..createdBy = json['createdBy'] as String?
      ..updatedBy = json['updatedBy'] as String?;

Map<String, dynamic> _$OrderSettingToJson(OrderSetting instance) =>
    <String, dynamic>{
      'id': instance.id,
      'businessId': instance.businessId,
      'enabled': instance.enabled,
      'dateUpdated': instance.dateUpdated?.toIso8601String(),
      'dateCreated': instance.dateCreated?.toIso8601String(),
      'createdBy': instance.createdBy,
      'updatedBy': instance.updatedBy,
      'items': instance.items,
    };

OrderSettingItem _$OrderSettingItemFromJson(Map<String, dynamic> json) =>
    OrderSettingItem(id: json['id'] as String?, name: json['name'] as String?);

Map<String, dynamic> _$OrderSettingItemToJson(OrderSettingItem instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};
