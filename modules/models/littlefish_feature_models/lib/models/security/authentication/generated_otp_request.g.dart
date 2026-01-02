// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generated_otp_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeneratedOTPRequest _$GeneratedOTPRequestFromJson(Map<String, dynamic> json) =>
    GeneratedOTPRequest(
      success: json['success'] as bool,
      recipients: (json['recipients'] as List<dynamic>)
          .map((e) => GenerateOTPRequest.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GeneratedOTPRequestToJson(
  GeneratedOTPRequest instance,
) => <String, dynamic>{
  'success': instance.success,
  'recipients': instance.recipients,
};
