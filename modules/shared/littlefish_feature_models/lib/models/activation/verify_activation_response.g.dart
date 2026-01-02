// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_activation_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyActivationResponse _$VerifyActivationResponseFromJson(
  Map<String, dynamic> json,
) => VerifyActivationResponse(
  activationId: json['activationId'] as String,
  isComplete: json['isComplete'] as bool,
  success: json['success'] as bool,
  errorMessage: json['errorMessage'] as String?,
  merchantInfo: BankMerchant.fromJson(
    json['merchantInfo'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$VerifyActivationResponseToJson(
  VerifyActivationResponse instance,
) => <String, dynamic>{
  'activationId': instance.activationId,
  'isComplete': instance.isComplete,
  'success': instance.success,
  'errorMessage': instance.errorMessage,
  'merchantInfo': instance.merchantInfo.toJson(),
};
