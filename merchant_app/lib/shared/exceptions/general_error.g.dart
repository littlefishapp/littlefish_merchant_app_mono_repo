// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'general_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeneralError _$GeneralErrorFromJson(Map<String, dynamic> json) => GeneralError(
  message: json['message'] as String,
  methodName: json['methodName'] as String?,
  error: json['error'],
  errorCode: json['errorCode'] as String?,
);

Map<String, dynamic> _$GeneralErrorToJson(GeneralError instance) =>
    <String, dynamic>{
      'message': instance.message,
      'methodName': instance.methodName,
      'error': instance.error,
      'errorCode': instance.errorCode,
    };
