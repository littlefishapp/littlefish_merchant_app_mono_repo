// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cashback_requirements.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CashbackRequirements _$CashbackRequirementsFromJson(
  Map<String, dynamic> json,
) => CashbackRequirements(
  minAmount: (json['minAmount'] as num?)?.toDouble(),
  maxAmount: (json['maxAmount'] as num?)?.toDouble(),
  isRequired: json['isRequired'] as bool? ?? false,
);

Map<String, dynamic> _$CashbackRequirementsToJson(
  CashbackRequirements instance,
) => <String, dynamic>{
  'minAmount': instance.minAmount,
  'maxAmount': instance.maxAmount,
  'isRequired': instance.isRequired,
};
