// Package imports:
import 'package:json_annotation/json_annotation.dart';
import 'package:littlefish_merchant/models/security/authentication/generate_otp_request.dart';

part 'generated_otp_request.g.dart';

@JsonSerializable()
class GeneratedOTPRequest {
  GeneratedOTPRequest({required this.success, required this.recipients});

  bool success;
  List<GenerateOTPRequest> recipients;

  factory GeneratedOTPRequest.fromJson(Map<String, dynamic> json) =>
      _$GeneratedOTPRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GeneratedOTPRequestToJson(this);
}
