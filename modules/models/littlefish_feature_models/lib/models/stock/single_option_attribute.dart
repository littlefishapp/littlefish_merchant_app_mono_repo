import 'package:json_annotation/json_annotation.dart';

part 'single_option_attribute.g.dart';

@JsonSerializable()
class SingleOptionAttribute {
  final String option;
  final String attribute;

  SingleOptionAttribute({required this.option, required this.attribute});

  factory SingleOptionAttribute.fromJson(Map<String, dynamic> json) =>
      _$SingleOptionAttributeFromJson(json);

  Map<String, dynamic> toJson() => _$SingleOptionAttributeToJson(this);
}
