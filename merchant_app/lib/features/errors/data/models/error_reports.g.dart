// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_reports.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorReport _$ErrorReportFromJson(Map<String, dynamic> json) => ErrorReport(
  errorMessage: json['errorMessage'] as String,
  errorLocation: json['errorLocation'] as String,
  errorCode: json['errorCode'] as String?,
  errorTrace: json['errorTrace'] as String?,
  businessId: json['businessId'] as String?,
  userId: json['userId'] as String?,
  businessProfileId: json['businessProfileId'] as String?,
  userName: json['userName'] as String?,
  email: json['email'] as String?,
  deviceId: json['deviceId'] as String?,
  deviceModel: json['deviceModel'] as String?,
  merchantId: json['merchantId'] as String?,
  merchantName: json['merchantName'] as String?,
  terminalId: json['terminalId'] as String?,
);

Map<String, dynamic> _$ErrorReportToJson(ErrorReport instance) =>
    <String, dynamic>{
      'errorMessage': instance.errorMessage,
      'errorLocation': instance.errorLocation,
      'errorCode': instance.errorCode,
      'errorTrace': instance.errorTrace,
      'businessId': instance.businessId,
      'userId': instance.userId,
      'businessProfileId': instance.businessProfileId,
      'userName': instance.userName,
      'email': instance.email,
      'deviceId': instance.deviceId,
      'deviceModel': instance.deviceModel,
      'merchantId': instance.merchantId,
      'merchantName': instance.merchantName,
      'terminalId': instance.terminalId,
    };
