// Package imports:
import 'package:json_annotation/json_annotation.dart';

part 'bq_tax_report.g.dart';

@JsonSerializable()
class BqTaxReport {
  BqTaxReport({
    this.dateTimeIndex,
    this.revenue,
    this.sales,
    this.ats,
    this.amtToTax,
  });

  dynamic dateTimeIndex;
  double? revenue;
  double? sales;
  double? ats;
  double? amtToTax;

  factory BqTaxReport.fromJson(Map<String, dynamic> json) =>
      _$BqTaxReportFromJson(json);

  Map<String, dynamic> toJson() => _$BqTaxReportToJson(this);
}
