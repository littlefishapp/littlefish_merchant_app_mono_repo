// Package imports:
import 'package:json_annotation/json_annotation.dart';

part 'verify_otp_request.g.dart';

@JsonSerializable()
class VerifyOTPRequest {
  VerifyOTPRequest({required this.otpValue});

  String otpValue;

  factory VerifyOTPRequest.fromJson(Map<String, dynamic> json) =>
      _$VerifyOTPRequestFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyOTPRequestToJson(this);
}
