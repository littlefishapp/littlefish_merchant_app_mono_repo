// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activation_form.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivationForm _$ActivationFormFromJson(Map<String, dynamic> json) =>
    ActivationForm(
      id: json['_id'] as String,
      title: json['title'] as String,
      formId: json['formId'] as String,
      fields: (json['fields'] as List<dynamic>)
          .map((e) => FormField.fromJson(e as Map<String, dynamic>))
          .toList(),
      description: json['description'] as String?,
    );

Map<String, dynamic> _$ActivationFormToJson(ActivationForm instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'formId': instance.formId,
      'description': instance.description,
      'fields': instance.fields,
    };
