// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activation_user_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivationUserInput _$ActivationUserInputFromJson(Map<String, dynamic> json) =>
    ActivationUserInput(
      formId: json['formId'] as String,
      activationFields: (json['activationFields'] as List<dynamic>)
          .map((e) => FormField.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ActivationUserInputToJson(
  ActivationUserInput instance,
) => <String, dynamic>{
  'formId': instance.formId,
  'activationFields': instance.activationFields,
};
