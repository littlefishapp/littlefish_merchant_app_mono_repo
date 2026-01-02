import 'package:json_annotation/json_annotation.dart';

part 'error_reports.g.dart';

@JsonSerializable()
class ErrorReport {
  String errorMessage;
  String errorLocation;
  String? errorCode;
  String? errorTrace;

  String? businessId;
  String? userId;
  String? businessProfileId;
  String? userName;
  String? email;

  // Device/terminal information
  String? deviceId;
  String? deviceModel;
  String? merchantId;
  String? merchantName;
  String? terminalId;

  ErrorReport({
    required this.errorMessage,
    required this.errorLocation,
    this.errorCode,
    this.errorTrace,
    this.businessId,
    this.userId,
    this.businessProfileId,
    this.userName,
    this.email,
    this.deviceId,
    this.deviceModel,
    this.merchantId,
    this.merchantName,
    this.terminalId,
  });

  factory ErrorReport.fromJson(Map<String, dynamic> json) =>
      _$ErrorReportFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorReportToJson(this);
}
