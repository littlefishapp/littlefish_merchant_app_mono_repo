// Package imports:
import 'package:json_annotation/json_annotation.dart';

part 'business_user_dto.g.dart';

@JsonSerializable()
class BusinessUserDto {
  BusinessUserDto({
    required this.businessId,
    required this.userId,
    required this.uid,
  });

  String? businessId;
  String? userId;
  String? uid;

  BusinessUserDto.create() : uid = '', businessId = '', userId = '';

  factory BusinessUserDto.fromJson(Map<String, dynamic> json) =>
      _$BusinessUserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$BusinessUserDtoToJson(this);
}
