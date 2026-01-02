// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activation_option.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivationOption _$ActivationOptionFromJson(Map<String, dynamic> json) =>
    ActivationOption(
      formFields: (json['formFields'] as List<dynamic>)
          .map((e) => ActivationForm.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ActivationOptionToJson(ActivationOption instance) =>
    <String, dynamic>{'formFields': instance.formFields};
