// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_field.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FormField _$FormFieldFromJson(Map<String, dynamic> json) => FormField(
  fieldId: json['fieldId'] as String,
  fieldName: json['fieldName'] as String,
  displayName: json['displayName'] as String,
  defaultValue: json['defaultValue'] as String?,
  value: json['value'] as String?,
  description: json['description'] as String?,
  minLength: json['minLength'] as String?,
  maxLength: json['maxLength'] as String?,
  isRequired: json['isRequired'] as bool?,
  regex: json['regex'] as String?,
  regexMessage: json['regexMessage'] as String?,
  fieldType: $enumDecodeNullable(_$FieldTypeEnumMap, json['fieldType']),
  isHidden: json['isHidden'] as bool,
  isDisabled: json['isDisabled'] as bool,
);

Map<String, dynamic> _$FormFieldToJson(FormField instance) => <String, dynamic>{
  'fieldId': instance.fieldId,
  'fieldName': instance.fieldName,
  'displayName': instance.displayName,
  'description': instance.description,
  'defaultValue': instance.defaultValue,
  'value': instance.value,
  'minLength': instance.minLength,
  'maxLength': instance.maxLength,
  'isRequired': instance.isRequired,
  'regex': instance.regex,
  'regexMessage': instance.regexMessage,
  'fieldType': _$FieldTypeEnumMap[instance.fieldType],
  'isHidden': instance.isHidden,
  'isDisabled': instance.isDisabled,
};

const _$FieldTypeEnumMap = {FieldType.string: 0, FieldType.integer: 1};
