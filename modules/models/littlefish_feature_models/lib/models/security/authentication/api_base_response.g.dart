// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_base_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiBaseResponse _$ApiBaseResponseFromJson(Map<String, dynamic> json) =>
    ApiBaseResponse(
      success: json['success'] as bool,
      data: json['data'],
      error: json['error'] as String?,
    );

Map<String, dynamic> _$ApiBaseResponseToJson(ApiBaseResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'error': instance.error,
      'data': instance.data,
    };
