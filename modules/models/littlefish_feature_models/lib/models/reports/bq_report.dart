// Package imports:
import 'package:json_annotation/json_annotation.dart';

part 'bq_report.g.dart';

@JsonSerializable()
class BqReport {
  BqReport({
    this.businessId,
    this.firstName,
    this.productName,
    this.paymentType,
    this.dateTimeIndex,
    this.revenue,
    this.sales,
    this.amount,
    this.qty,
    this.ats,
    this.percentage,
    this.amtToTax,
    this.profits,
  });

  String? businessId;
  String? firstName;
  String? productName;
  String? paymentType;
  dynamic dateTimeIndex;
  double? revenue;
  double? sales;
  double? profits;
  double? amount;
  int? qty;
  double? ats;
  double? percentage;
  double? amtToTax;

  factory BqReport.fromJson(Map<String, dynamic> json) =>
      _$BqReportFromJson(json);

  Map<String, dynamic> toJson() => _$BqReportToJson(this);
}
