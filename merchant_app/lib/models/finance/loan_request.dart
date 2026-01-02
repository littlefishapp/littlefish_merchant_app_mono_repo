// Package imports:
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import 'package:littlefish_merchant/models/finance/score.dart';
import 'package:littlefish_merchant/models/security/user/user_profile.dart';
import 'package:littlefish_merchant/models/store/business_profile.dart';

part 'loan_request.g.dart';

@JsonSerializable()
class LoanRequest {
  String? id;
  String? loanPurpose;
  String? requesterIdNumber;
  BusinessProfile? businessProfile;
  UserProfile? userProfile;
  BusinessPerformanceScore? score;
  double? amountRequested;
  double? repaymentPeriod;

  LoanRequest({
    this.id,
    this.loanPurpose,
    this.requesterIdNumber,
    this.businessProfile,
    this.amountRequested,
    this.repaymentPeriod,
    this.userProfile,
    this.score,
  });

  factory LoanRequest.fromJson(Map<String, dynamic> json) =>
      _$LoanRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LoanRequestToJson(this);
}
