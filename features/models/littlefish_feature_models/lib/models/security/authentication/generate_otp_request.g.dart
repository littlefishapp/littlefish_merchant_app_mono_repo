// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generate_otp_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenerateOTPRequest _$GenerateOTPRequestFromJson(Map<String, dynamic> json) =>
    GenerateOTPRequest(
      type: (json['type'] as num).toInt(),
      recipient: json['recipient'] as String,
      firstName: json['firstName'] as String?,
    );

Map<String, dynamic> _$GenerateOTPRequestToJson(GenerateOTPRequest instance) =>
    <String, dynamic>{
      'type': instance.type,
      'recipient': instance.recipient,
      'firstName': instance.firstName,
    };
