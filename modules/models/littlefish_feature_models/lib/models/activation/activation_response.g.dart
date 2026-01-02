// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activation_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivationResponse _$ActivationResponseFromJson(Map<String, dynamic> json) =>
    ActivationResponse(
      activationId: json['activationId'] as String,
      isComplete: json['isComplete'] as bool,
      success: json['success'] as bool,
      errorMessage: json['errorMessage'] as String?,
    );

Map<String, dynamic> _$ActivationResponseToJson(ActivationResponse instance) =>
    <String, dynamic>{
      'activationId': instance.activationId,
      'isComplete': instance.isComplete,
      'success': instance.success,
      'errorMessage': instance.errorMessage,
    };
