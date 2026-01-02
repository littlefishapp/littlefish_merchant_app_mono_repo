// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activation_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivationType _$ActivationTypeFromJson(Map<String, dynamic> json) =>
    ActivationType(
      activationTypes: (json['activationTypes'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ActivationTypeToJson(ActivationType instance) =>
    <String, dynamic>{'activationTypes': instance.activationTypes};
