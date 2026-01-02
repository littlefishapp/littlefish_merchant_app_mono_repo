// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_create_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserCreateRequest _$UserCreateRequestFromJson(Map<String, dynamic> json) =>
    UserCreateRequest(
      userName: json['userName'] as String?,
      userPassword: json['userPassword'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      displayName: json['displayName'] as String?,
      mobileNumber: json['mobileNumber'] as String?,
      email: json['email'] as String?,
      deviceInfo: json['deviceInfo'] == null
          ? null
          : UserDevice.fromJson(json['deviceInfo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserCreateRequestToJson(UserCreateRequest instance) =>
    <String, dynamic>{
      'userName': instance.userName,
      'userPassword': instance.userPassword,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'displayName': instance.displayName,
      'mobileNumber': instance.mobileNumber,
      'email': instance.email,
      'deviceInfo': instance.deviceInfo,
    };
