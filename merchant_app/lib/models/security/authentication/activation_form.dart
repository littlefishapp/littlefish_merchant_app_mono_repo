import 'package:json_annotation/json_annotation.dart';
import 'package:littlefish_merchant/models/shared/form_field.dart';

part 'activation_form.g.dart';

@JsonSerializable(createToJson: true)
class ActivationForm {
  @JsonKey(name: '_id')
  String id;
  String title;
  String formId;
  String? description;
  List<FormField> fields;

  ActivationForm({
    required this.id,
    required this.title,
    required this.formId,
    required this.fields,
    this.description,
  });

  factory ActivationForm.fromJson(Map<String, dynamic> json) =>
      _$ActivationFormFromJson(json);

  Map<String, dynamic> toJson() => _$ActivationFormToJson(this);
}
