// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoanRequest _$LoanRequestFromJson(Map<String, dynamic> json) => LoanRequest(
  id: json['id'] as String?,
  loanPurpose: json['loanPurpose'] as String?,
  requesterIdNumber: json['requesterIdNumber'] as String?,
  businessProfile: json['businessProfile'] == null
      ? null
      : BusinessProfile.fromJson(
          json['businessProfile'] as Map<String, dynamic>,
        ),
  amountRequested: (json['amountRequested'] as num?)?.toDouble(),
  repaymentPeriod: (json['repaymentPeriod'] as num?)?.toDouble(),
  userProfile: json['userProfile'] == null
      ? null
      : UserProfile.fromJson(json['userProfile'] as Map<String, dynamic>),
  score: json['score'] == null
      ? null
      : BusinessPerformanceScore.fromJson(
          json['score'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$LoanRequestToJson(LoanRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'loanPurpose': instance.loanPurpose,
      'requesterIdNumber': instance.requesterIdNumber,
      'businessProfile': instance.businessProfile,
      'userProfile': instance.userProfile,
      'score': instance.score,
      'amountRequested': instance.amountRequested,
      'repaymentPeriod': instance.repaymentPeriod,
    };
