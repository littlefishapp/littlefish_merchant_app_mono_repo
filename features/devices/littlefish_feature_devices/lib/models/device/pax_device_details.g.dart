// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pax_device_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaxDeviceDetails _$PaxDeviceDetailsFromJson(Map<String, dynamic> json) =>
    PaxDeviceDetails(
      json['deviceId'] as String?,
      json['deviceModel'] as String?,
      json['merchantId'] as String?,
      json['merchantName'] as String?,
      json['terminalId'] as String?,
    );

Map<String, dynamic> _$PaxDeviceDetailsToJson(PaxDeviceDetails instance) =>
    <String, dynamic>{
      'deviceId': instance.deviceId,
      'deviceModel': instance.deviceModel,
      'merchantId': instance.merchantId,
      'merchantName': instance.merchantName,
      'terminalId': instance.terminalId,
    };
