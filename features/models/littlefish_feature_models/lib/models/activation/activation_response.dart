import 'package:json_annotation/json_annotation.dart';
// Project imports:
part 'activation_response.g.dart';

@JsonSerializable(createToJson: true, explicitToJson: true)
class ActivationResponse {
  final String activationId;
  final bool isComplete;
  final bool success;
  final String? errorMessage;

  ActivationResponse({
    required this.activationId,
    required this.isComplete,
    required this.success,
    this.errorMessage,
  });

  factory ActivationResponse.fromJson(Map<String, dynamic> json) =>
      _$ActivationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ActivationResponseToJson(this);
}
