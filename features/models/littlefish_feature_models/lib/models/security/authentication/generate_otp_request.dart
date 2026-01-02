// Package imports:
import 'package:json_annotation/json_annotation.dart';

part 'generate_otp_request.g.dart';

@JsonSerializable()
class GenerateOTPRequest {
  GenerateOTPRequest({
    required this.type,
    required this.recipient,
    this.firstName,
  });

  int type;
  String recipient;
  String? firstName;

  factory GenerateOTPRequest.fromJson(Map<String, dynamic> json) =>
      _$GenerateOTPRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GenerateOTPRequestToJson(this);
}
