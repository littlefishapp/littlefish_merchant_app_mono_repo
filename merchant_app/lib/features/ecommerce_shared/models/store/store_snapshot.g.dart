// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_snapshot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreSnapshot _$StoreSnapshotFromJson(Map<String, dynamic> json) =>
    StoreSnapshot(
      description: json['description'] as String?,
      displayName: json['displayName'] as String?,
      id: json['id'] as String?,
      name: json['name'] as String?,
      storeId: json['storeId'] as String?,
      storeSubtypeId: json['storeSubtypeId'] as String?,
      storeTypeId: json['storeTypeId'] as String?,
      coverImageUrl: json['coverImageUrl'] as String?,
      logoUrl: json['logoUrl'] as String?,
      primaryAddress: json['primaryAddress'] == null
          ? null
          : StoreAddress.fromJson(
              json['primaryAddress'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$StoreSnapshotToJson(StoreSnapshot instance) =>
    <String, dynamic>{
      'id': instance.id,
      'storeId': instance.storeId,
      'name': instance.name,
      'displayName': instance.displayName,
      'description': instance.description,
      'storeTypeId': instance.storeTypeId,
      'storeSubtypeId': instance.storeSubtypeId,
      'coverImageUrl': instance.coverImageUrl,
      'logoUrl': instance.logoUrl,
      'primaryAddress': instance.primaryAddress,
    };
