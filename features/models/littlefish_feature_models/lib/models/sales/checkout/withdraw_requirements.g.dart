// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'withdraw_requirements.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WithdrawRequirements _$WithdrawRequirementsFromJson(
  Map<String, dynamic> json,
) => WithdrawRequirements(
  minAmount: (json['minAmount'] as num?)?.toDouble(),
  maxAmount: (json['maxAmount'] as num?)?.toDouble(),
  isRequired: json['isRequired'] as bool? ?? false,
);

Map<String, dynamic> _$WithdrawRequirementsToJson(
  WithdrawRequirements instance,
) => <String, dynamic>{
  'minAmount': instance.minAmount,
  'maxAmount': instance.maxAmount,
  'isRequired': instance.isRequired,
};
