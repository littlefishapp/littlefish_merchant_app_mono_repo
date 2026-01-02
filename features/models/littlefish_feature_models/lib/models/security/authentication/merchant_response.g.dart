// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MerchantResponse _$MerchantResponseFromJson(Map<String, dynamic> json) =>
    MerchantResponse(
      baseResponse: ApiBaseResponse.fromJson(
        json['baseResponse'] as Map<String, dynamic>,
      ),
      otpInformation: (json['otpInformation'] as List<dynamic>?)
          ?.map((e) => GenerateOTPRequest.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MerchantResponseToJson(MerchantResponse instance) =>
    <String, dynamic>{
      'baseResponse': instance.baseResponse,
      'otpInformation': instance.otpInformation,
    };
