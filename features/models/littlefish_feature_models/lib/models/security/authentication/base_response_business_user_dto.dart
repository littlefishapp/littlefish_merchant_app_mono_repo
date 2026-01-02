// Package imports:
import 'package:json_annotation/json_annotation.dart';
import 'package:littlefish_merchant/models/security/authentication/business_user_dto.dart';

part 'base_response_business_user_dto.g.dart';

@JsonSerializable()
class BaseResponseBusinessUserDto {
  BaseResponseBusinessUserDto({
    required this.data,
    required this.success,
    required this.error,
  });

  BusinessUserDto? data;
  bool success;
  String? error;

  factory BaseResponseBusinessUserDto.fromJson(Map<String, dynamic> json) =>
      _$BaseResponseBusinessUserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$BaseResponseBusinessUserDtoToJson(this);
}
