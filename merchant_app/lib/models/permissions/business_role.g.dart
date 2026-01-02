// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_role.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusinessRole _$BusinessRoleFromJson(Map<String, dynamic> json) =>
    BusinessRole(
        name: json['name'] as String?,
        description: json['description'] as String?,
        businessId: json['businessId'] as String?,
        permissions: (json['permissions'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList(),
        systemRole: json['systemRole'] as bool?,
      )
      ..id = json['id'] as String?
      ..dateCreated = const IsoDateTimeConverter().fromJson(json['dateCreated'])
      ..dateUpdated = const IsoDateTimeConverter().fromJson(json['dateUpdated'])
      ..createdBy = json['createdBy'] as String?
      ..updatedBy = json['updatedBy'] as String?
      ..deleted = json['deleted'] as bool?;

Map<String, dynamic> _$BusinessRoleToJson(BusinessRole instance) =>
    <String, dynamic>{
      'id': instance.id,
      'dateCreated': const IsoDateTimeConverter().toJson(instance.dateCreated),
      'dateUpdated': const IsoDateTimeConverter().toJson(instance.dateUpdated),
      'createdBy': instance.createdBy,
      'updatedBy': instance.updatedBy,
      'deleted': instance.deleted,
      'name': instance.name,
      'description': instance.description,
      'businessId': instance.businessId,
      'systemRole': instance.systemRole,
      'permissions': instance.permissions,
    };
