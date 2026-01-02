// Package imports:
import 'package:json_annotation/json_annotation.dart';

part 'otp_result.g.dart';

@JsonSerializable()
class OTPResult {
  OTPResult({this.id, this.token});

  String? id, token;

  factory OTPResult.fromJson(Map<String, dynamic> json) =>
      _$OTPResultFromJson(json);

  Map<String, dynamic> toJson() => _$OTPResultToJson(this);
}
