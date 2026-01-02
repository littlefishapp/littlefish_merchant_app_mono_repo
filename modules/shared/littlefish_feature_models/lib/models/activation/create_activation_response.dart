import 'package:json_annotation/json_annotation.dart';
// Project imports:
part 'create_activation_response.g.dart';

@JsonSerializable(createToJson: true, explicitToJson: true)
class CreateActivationResponse {
  final String maskedEmail;
  final String maskedPhone;
  final String activationId;
  final bool isComplete;
  final bool success;
  final String? errorMessage;

  CreateActivationResponse({
    required this.maskedEmail,
    required this.maskedPhone,
    required this.activationId,
    required this.isComplete,
    required this.success,
    this.errorMessage,
  });

  factory CreateActivationResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateActivationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateActivationResponseToJson(this);
}
