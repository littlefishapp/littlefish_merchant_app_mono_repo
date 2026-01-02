// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_activation_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyActivationRequest _$VerifyActivationRequestFromJson(
  Map<String, dynamic> json,
) => VerifyActivationRequest(
  activationId: json['activationId'] as String,
  otp: json['otp'] as String,
);

Map<String, dynamic> _$VerifyActivationRequestToJson(
  VerifyActivationRequest instance,
) => <String, dynamic>{
  'activationId': instance.activationId,
  'otp': instance.otp,
};
