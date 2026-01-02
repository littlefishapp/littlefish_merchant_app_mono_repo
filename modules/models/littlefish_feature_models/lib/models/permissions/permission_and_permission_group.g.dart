// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permission_and_permission_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PermissionAndPermissionGroup _$PermissionAndPermissionGroupFromJson(
  Map<String, dynamic> json,
) =>
    PermissionAndPermissionGroup(
        permissions: (json['permissions'] as List<dynamic>?)
            ?.map((e) => Permission.fromJson(e as Map<String, dynamic>))
            .toList(),
        permissionGroups: (json['permissionGroups'] as List<dynamic>?)
            ?.map((e) => PermissionGroup.fromJson(e as Map<String, dynamic>))
            .toList(),
      )
      ..id = json['id'] as String?
      ..dateCreated = const IsoDateTimeConverter().fromJson(json['dateCreated'])
      ..dateUpdated = const IsoDateTimeConverter().fromJson(json['dateUpdated'])
      ..createdBy = json['createdBy'] as String?
      ..updatedBy = json['updatedBy'] as String?
      ..deleted = json['deleted'] as bool?;

Map<String, dynamic> _$PermissionAndPermissionGroupToJson(
  PermissionAndPermissionGroup instance,
) => <String, dynamic>{
  'id': instance.id,
  'dateCreated': const IsoDateTimeConverter().toJson(instance.dateCreated),
  'dateUpdated': const IsoDateTimeConverter().toJson(instance.dateUpdated),
  'createdBy': instance.createdBy,
  'updatedBy': instance.updatedBy,
  'deleted': instance.deleted,
  'permissions': instance.permissions,
  'permissionGroups': instance.permissionGroups,
};
