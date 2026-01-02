// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Verification _$VerificationFromJson(Map<String, dynamic> json) => Verification(
  verificationDate: json['verificationDate'] == null
      ? null
      : DateTime.parse(json['verificationDate'] as String),
  status: $enumDecodeNullable(_$VerificationStatusEnumMap, json['status']),
);

Map<String, dynamic> _$VerificationToJson(Verification instance) =>
    <String, dynamic>{
      'verificationDate': instance.verificationDate?.toIso8601String(),
      'status': _$VerificationStatusEnumMap[instance.status],
    };

const _$VerificationStatusEnumMap = {
  VerificationStatus.notStarted: 0,
  VerificationStatus.pending: 1,
  VerificationStatus.verified: 2,
  VerificationStatus.failed: 3,
  VerificationStatus.inProgress: 4,
};
