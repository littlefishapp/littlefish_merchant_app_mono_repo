import 'package:json_annotation/json_annotation.dart';
import 'package:littlefish_merchant/models/security/authentication/bank_merchant.dart';
// Project imports:
part 'verify_activation_response.g.dart';

@JsonSerializable(createToJson: true, explicitToJson: true)
class VerifyActivationResponse {
  final String activationId;
  final bool isComplete;
  final bool success;
  final String? errorMessage;
  final BankMerchant merchantInfo; // The merchant information

  VerifyActivationResponse({
    required this.activationId,
    required this.isComplete,
    required this.success,
    this.errorMessage,
    required this.merchantInfo,
  });

  factory VerifyActivationResponse.fromJson(Map<String, dynamic> json) =>
      _$VerifyActivationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyActivationResponseToJson(this);
}
