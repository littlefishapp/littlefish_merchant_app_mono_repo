// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permission.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Permission _$PermissionFromJson(Map<String, dynamic> json) =>
    Permission(
        name: json['name'] as String?,
        description: json['description'] as String?,
        permissionGroupId: json['permissionGroupId'] as String?,
        subGroupName: json['subGroupName'] as String?,
        enabled: json['enabled'] as bool?,
      )
      ..id = json['id'] as String?
      ..dateCreated = const IsoDateTimeConverter().fromJson(json['dateCreated'])
      ..dateUpdated = const IsoDateTimeConverter().fromJson(json['dateUpdated'])
      ..createdBy = json['createdBy'] as String?
      ..updatedBy = json['updatedBy'] as String?
      ..deleted = json['deleted'] as bool?;

Map<String, dynamic> _$PermissionToJson(Permission instance) =>
    <String, dynamic>{
      'id': instance.id,
      'dateCreated': const IsoDateTimeConverter().toJson(instance.dateCreated),
      'dateUpdated': const IsoDateTimeConverter().toJson(instance.dateUpdated),
      'createdBy': instance.createdBy,
      'updatedBy': instance.updatedBy,
      'deleted': instance.deleted,
      'name': instance.name,
      'description': instance.description,
      'permissionGroupId': instance.permissionGroupId,
      'subGroupName': instance.subGroupName,
      'enabled': instance.enabled,
    };
