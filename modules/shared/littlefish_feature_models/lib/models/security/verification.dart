// Package imports:
import 'package:json_annotation/json_annotation.dart';

part 'verification.g.dart';

@JsonSerializable()
class Verification {
  Verification({this.verificationDate, this.status});

  DateTime? verificationDate;
  VerificationStatus? status;

  factory Verification.fromJson(Map<String, dynamic> json) =>
      _$VerificationFromJson(json);

  Map<String, dynamic> toJson() => _$VerificationToJson(this);
}

enum VerificationStatus {
  @JsonValue(0)
  notStarted,
  @JsonValue(1)
  pending,
  @JsonValue(2)
  verified,
  @JsonValue(3)
  failed,
  @JsonValue(4)
  inProgress,
}
