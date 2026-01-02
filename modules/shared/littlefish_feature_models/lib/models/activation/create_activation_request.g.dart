// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_activation_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateActivationRequest _$CreateActivationRequestFromJson(
  Map<String, dynamic> json,
) => CreateActivationRequest(
  merchantId: json['merchantId'] as String,
  userId: json['userId'] as String,
);

Map<String, dynamic> _$CreateActivationRequestToJson(
  CreateActivationRequest instance,
) => <String, dynamic>{
  'merchantId': instance.merchantId,
  'userId': instance.userId,
};
