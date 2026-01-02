import 'package:json_annotation/json_annotation.dart';
import 'package:littlefish_merchant/models/shared/form_field.dart';

part 'activation_user_input.g.dart';

@JsonSerializable(createToJson: true)
class ActivationUserInput {
  String formId;
  List<FormField> activationFields;

  ActivationUserInput({required this.formId, required this.activationFields});

  factory ActivationUserInput.fromJson(Map<String, dynamic> json) =>
      _$ActivationUserInputFromJson(json);

  Map<String, dynamic> toJson() => _$ActivationUserInputToJson(this);
}
