// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_user_role.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusinessUserRole _$BusinessUserRoleFromJson(Map<String, dynamic> json) =>
    BusinessUserRole(
        roleId: json['roleId'] as String?,
        businessUserId: json['businessUserId'] as String?,
        businessId: json['businessId'] as String?,
      )
      ..id = json['id'] as String?
      ..dateCreated = const IsoDateTimeConverter().fromJson(json['dateCreated'])
      ..dateUpdated = const IsoDateTimeConverter().fromJson(json['dateUpdated'])
      ..createdBy = json['createdBy'] as String?
      ..updatedBy = json['updatedBy'] as String?
      ..deleted = json['deleted'] as bool?;

Map<String, dynamic> _$BusinessUserRoleToJson(BusinessUserRole instance) =>
    <String, dynamic>{
      'id': instance.id,
      'dateCreated': const IsoDateTimeConverter().toJson(instance.dateCreated),
      'dateUpdated': const IsoDateTimeConverter().toJson(instance.dateUpdated),
      'createdBy': instance.createdBy,
      'updatedBy': instance.updatedBy,
      'deleted': instance.deleted,
      'roleId': instance.roleId,
      'businessUserId': instance.businessUserId,
      'businessId': instance.businessId,
    };
