// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) => LoginRequest(
  userName: json['userName'] as String?,
  userPassword: json['userPassword'] as String?,
  deviceId: json['deviceId'] as String?,
  deviceInfo: json['deviceInfo'] == null
      ? null
      : UserDevice.fromJson(json['deviceInfo'] as Map<String, dynamic>),
);

Map<String, dynamic> _$LoginRequestToJson(LoginRequest instance) =>
    <String, dynamic>{
      'userName': instance.userName,
      'userPassword': instance.userPassword,
      'deviceId': instance.deviceId,
      'deviceInfo': instance.deviceInfo,
    };
