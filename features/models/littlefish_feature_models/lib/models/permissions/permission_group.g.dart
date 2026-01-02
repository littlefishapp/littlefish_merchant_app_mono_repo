// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permission_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PermissionGroup _$PermissionGroupFromJson(Map<String, dynamic> json) =>
    PermissionGroup(
        name: json['name'] as String?,
        description: json['description'] as String?,
        subGroupName: json['subGroupName'] as String?,
      )
      ..id = json['id'] as String?
      ..dateCreated = const IsoDateTimeConverter().fromJson(json['dateCreated'])
      ..dateUpdated = const IsoDateTimeConverter().fromJson(json['dateUpdated'])
      ..createdBy = json['createdBy'] as String?
      ..updatedBy = json['updatedBy'] as String?
      ..deleted = json['deleted'] as bool?;

Map<String, dynamic> _$PermissionGroupToJson(PermissionGroup instance) =>
    <String, dynamic>{
      'id': instance.id,
      'dateCreated': const IsoDateTimeConverter().toJson(instance.dateCreated),
      'dateUpdated': const IsoDateTimeConverter().toJson(instance.dateUpdated),
      'createdBy': instance.createdBy,
      'updatedBy': instance.updatedBy,
      'deleted': instance.deleted,
      'name': instance.name,
      'description': instance.description,
      'subGroupName': instance.subGroupName,
    };
