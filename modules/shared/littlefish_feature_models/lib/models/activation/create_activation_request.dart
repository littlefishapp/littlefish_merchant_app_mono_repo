import 'package:json_annotation/json_annotation.dart';
// Project imports:
part 'create_activation_request.g.dart';

@JsonSerializable(createToJson: true, explicitToJson: true)
class CreateActivationRequest {
  final String merchantId;
  final String userId;

  CreateActivationRequest({required this.merchantId, required this.userId});

  factory CreateActivationRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateActivationRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateActivationRequestToJson(this);
}
