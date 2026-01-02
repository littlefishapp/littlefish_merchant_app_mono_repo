// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDevice _$UserDeviceFromJson(Map<String, dynamic> json) =>
    UserDevice(
        userId: json['userId'] as String?,
        brand: json['brand'] as String?,
        device: json['device'] as String?,
        fingerprint: json['fingerprint'] as String?,
        host: json['host'] as String?,
        accessDate: json['accessDate'] == null
            ? null
            : DateTime.parse(json['accessDate'] as String),
        deviceId: json['deviceId'] as String?,
        display: json['display'] as String?,
        isPhysicalDevice: json['isPhysicalDevice'] as bool?,
        manufacturer: json['manufacturer'] as String?,
        product: json['product'] as String?,
        platform: json['platform'] as String?,
        systemVersion: json['systemVersion'] as String?,
      )
      ..id = json['id'] as String?
      ..name = json['name'] as String?
      ..displayName = json['displayName'] as String?
      ..description = json['description'] as String?
      ..createdBy = json['createdBy'] as String?
      ..status = json['status'] as String?
      ..dateCreated = json['dateCreated'] == null
          ? null
          : DateTime.parse(json['dateCreated'] as String)
      ..dateUpdated = json['dateUpdated'] == null
          ? null
          : DateTime.parse(json['dateUpdated'] as String)
      ..itemSequence = (json['itemSequence'] as num?)?.toInt();

Map<String, dynamic> _$UserDeviceToJson(UserDevice instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'displayName': instance.displayName,
      'description': instance.description,
      'createdBy': instance.createdBy,
      'status': instance.status,
      'dateCreated': instance.dateCreated?.toIso8601String(),
      'dateUpdated': instance.dateUpdated?.toIso8601String(),
      'itemSequence': instance.itemSequence,
      'userId': instance.userId,
      'brand': instance.brand,
      'device': instance.device,
      'display': instance.display,
      'fingerprint': instance.fingerprint,
      'host': instance.host,
      'manufacturer': instance.manufacturer,
      'product': instance.product,
      'deviceId': instance.deviceId,
      'platform': instance.platform,
      'systemVersion': instance.systemVersion,
      'isPhysicalDevice': instance.isPhysicalDevice,
      'accessDate': instance.accessDate?.toIso8601String(),
    };
