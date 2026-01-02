import 'package:json_annotation/json_annotation.dart';

part 'activation_type.g.dart';

@JsonSerializable(createToJson: true)
class ActivationType {
  List<String> activationTypes;

  ActivationType({required this.activationTypes});

  factory ActivationType.fromJson(Map<String, dynamic> json) =>
      _$ActivationTypeFromJson(json);

  Map<String, dynamic> toJson() => _$ActivationTypeToJson(this);
}
