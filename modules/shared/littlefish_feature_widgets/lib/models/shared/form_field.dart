import 'package:json_annotation/json_annotation.dart';
import 'package:littlefish_merchant/models/enums.dart';

part 'form_field.g.dart';

@FieldTypeConverter()
@JsonSerializable(createToJson: true)
class FormField {
  String fieldId;
  String fieldName;
  String displayName;
  String? description;
  String? defaultValue;
  String? value;
  String? minLength;
  String? maxLength;
  bool? isRequired;
  String? regex;
  String? regexMessage;
  FieldType? fieldType;
  bool isHidden;
  bool isDisabled;

  FormField({
    required this.fieldId,
    required this.fieldName,
    required this.displayName,
    this.defaultValue,
    this.value,
    this.description,
    this.minLength,
    this.maxLength,
    this.isRequired,
    this.regex,
    this.regexMessage,
    this.fieldType,
    required this.isHidden,
    required this.isDisabled,
  });

  factory FormField.fromJson(Map<String, dynamic> json) =>
      _$FormFieldFromJson(json);

  Map<String, dynamic> toJson() => _$FormFieldToJson(this);
}

class FieldTypeConverter implements JsonConverter<dynamic, int> {
  const FieldTypeConverter();

  @override
  FieldType fromJson(int json) {
    return FieldType.values[json];
  }

  @override
  int toJson(dynamic object) {
    return object.index;
  }
}
