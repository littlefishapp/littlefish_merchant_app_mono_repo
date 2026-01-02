import 'package:json_annotation/json_annotation.dart';
// Project imports:
part 'verify_activation_request.g.dart';

@JsonSerializable(createToJson: true, explicitToJson: true)
class VerifyActivationRequest {
  final String activationId; // Unique identifier of the Activation Attempt
  final String otp; // The captured OTP

  VerifyActivationRequest({required this.activationId, required this.otp});

  factory VerifyActivationRequest.fromJson(Map<String, dynamic> json) =>
      _$VerifyActivationRequestFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyActivationRequestToJson(this);
}
