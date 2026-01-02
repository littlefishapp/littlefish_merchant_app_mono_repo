// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusinessUserDto _$BusinessUserDtoFromJson(Map<String, dynamic> json) =>
    BusinessUserDto(
      businessId: json['businessId'] as String?,
      userId: json['userId'] as String?,
      uid: json['uid'] as String?,
    );

Map<String, dynamic> _$BusinessUserDtoToJson(BusinessUserDto instance) =>
    <String, dynamic>{
      'businessId': instance.businessId,
      'userId': instance.userId,
      'uid': instance.uid,
    };
