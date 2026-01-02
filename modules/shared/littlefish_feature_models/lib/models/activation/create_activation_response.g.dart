// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_activation_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateActivationResponse _$CreateActivationResponseFromJson(
  Map<String, dynamic> json,
) => CreateActivationResponse(
  maskedEmail: json['maskedEmail'] as String,
  maskedPhone: json['maskedPhone'] as String,
  activationId: json['activationId'] as String,
  isComplete: json['isComplete'] as bool,
  success: json['success'] as bool,
  errorMessage: json['errorMessage'] as String?,
);

Map<String, dynamic> _$CreateActivationResponseToJson(
  CreateActivationResponse instance,
) => <String, dynamic>{
  'maskedEmail': instance.maskedEmail,
  'maskedPhone': instance.maskedPhone,
  'activationId': instance.activationId,
  'isComplete': instance.isComplete,
  'success': instance.success,
  'errorMessage': instance.errorMessage,
};
