// Package imports:
import 'package:json_annotation/json_annotation.dart';

part 'bq_payments_report.g.dart';

@JsonSerializable()
class BqPaymentsReport {
  BqPaymentsReport({this.paymentType, this.qty, this.amount, this.percentage});

  String? paymentType;
  double? qty;
  double? amount;
  double? percentage;

  factory BqPaymentsReport.fromJson(Map<String, dynamic> json) =>
      _$BqPaymentsReportFromJson(json);

  Map<String, dynamic> toJson() => _$BqPaymentsReportToJson(this);
}
