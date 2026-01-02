// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vat_level.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VatLevel _$VatLevelFromJson(Map<String, dynamic> json) => VatLevel(
  vatLevelId: json['vatLevelId'] as String?,
  name: json['name'] as String?,
  rate: (json['rate'] as num?)?.toDouble(),
  isDefault: json['isDefault'] as bool? ?? false,
  isActive: json['isActive'] as bool? ?? false,
);

Map<String, dynamic> _$VatLevelToJson(VatLevel instance) => <String, dynamic>{
  'vatLevelId': instance.vatLevelId,
  'name': instance.name,
  'rate': instance.rate,
  'isDefault': instance.isDefault,
  'isActive': instance.isActive,
};
