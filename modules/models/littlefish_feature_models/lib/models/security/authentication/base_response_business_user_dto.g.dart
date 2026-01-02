// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_response_business_user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseResponseBusinessUserDto _$BaseResponseBusinessUserDtoFromJson(
  Map<String, dynamic> json,
) => BaseResponseBusinessUserDto(
  data: json['data'] == null
      ? null
      : BusinessUserDto.fromJson(json['data'] as Map<String, dynamic>),
  success: json['success'] as bool,
  error: json['error'] as String?,
);

Map<String, dynamic> _$BaseResponseBusinessUserDtoToJson(
  BaseResponseBusinessUserDto instance,
) => <String, dynamic>{
  'data': instance.data,
  'success': instance.success,
  'error': instance.error,
};
