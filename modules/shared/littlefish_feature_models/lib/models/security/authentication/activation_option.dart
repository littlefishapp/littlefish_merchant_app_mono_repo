import 'package:json_annotation/json_annotation.dart';
import 'package:littlefish_merchant/models/security/authentication/activation_form.dart';

part 'activation_option.g.dart';

@JsonSerializable(createToJson: true)
class ActivationOption {
  List<ActivationForm> formFields;

  ActivationOption({required this.formFields});

  factory ActivationOption.fromJson(Map<String, dynamic> json) =>
      _$ActivationOptionFromJson(json);

  Map<String, dynamic> toJson() => _$ActivationOptionToJson(this);
}
