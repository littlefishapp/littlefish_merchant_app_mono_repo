// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_authentication_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiAuthenticationResult _$ApiAuthenticationResultFromJson(
  Map<String, dynamic> json,
) => ApiAuthenticationResult(
  accessToken: json['accessToken'] as String?,
  token: json['token'] as String?,
  message: json['message'] as String?,
);

Map<String, dynamic> _$ApiAuthenticationResultToJson(
  ApiAuthenticationResult instance,
) => <String, dynamic>{
  'accessToken': instance.accessToken,
  'token': instance.token,
  'message': instance.message,
};
