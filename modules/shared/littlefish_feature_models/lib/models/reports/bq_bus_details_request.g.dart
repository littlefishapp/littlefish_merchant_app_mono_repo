// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bq_bus_details_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BqBusDetailsRequest _$BqBusDetailsRequestFromJson(Map<String, dynamic> json) =>
    BqBusDetailsRequest(
      businessId: json['businessId'] as String?,
      busName: json['busName'] as String?,
      userEmail: json['userEmail'] as String?,
    );

Map<String, dynamic> _$BqBusDetailsRequestToJson(
  BqBusDetailsRequest instance,
) => <String, dynamic>{
  'businessId': instance.businessId,
  'busName': instance.busName,
  'userEmail': instance.userEmail,
};
