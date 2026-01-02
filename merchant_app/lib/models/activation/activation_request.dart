import 'package:json_annotation/json_annotation.dart';
// Project imports:
part 'activation_request.g.dart';

@JsonSerializable(createToJson: true, explicitToJson: true)
class ActivationRequest {
  final String activationId; // Unique identifier of the Activation Attempt

  ActivationRequest({required this.activationId});

  factory ActivationRequest.fromJson(Map<String, dynamic> json) =>
      _$ActivationRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ActivationRequestToJson(this);
}
