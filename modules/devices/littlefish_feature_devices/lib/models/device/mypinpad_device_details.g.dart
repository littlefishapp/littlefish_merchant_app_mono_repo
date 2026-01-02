// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mypinpad_device_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyPinPadDeviceDetails _$MyPinPadDeviceDetailsFromJson(
  Map<String, dynamic> json,
) => MyPinPadDeviceDetails(
  json['merchantId'] as String?,
  json['terminalId'] as String?,
  merchantName: json['merchantName'] as String?,
  deviceModel: json['deviceModel'] as String?,
  deviceId: json['deviceId'] as String?,
);

Map<String, dynamic> _$MyPinPadDeviceDetailsToJson(
  MyPinPadDeviceDetails instance,
) => <String, dynamic>{
  'deviceId': instance.deviceId,
  'deviceModel': instance.deviceModel,
  'merchantId': instance.merchantId,
  'merchantName': instance.merchantName,
  'terminalId': instance.terminalId,
};
