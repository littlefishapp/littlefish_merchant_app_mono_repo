// Package imports:
import 'package:json_annotation/json_annotation.dart';

part 'bq_revenue_report.g.dart';

@JsonSerializable()
class BqRevenueReport {
  BqRevenueReport({this.dateTimeIndex, this.revenue, this.sales, this.ats});

  dynamic dateTimeIndex;
  double? revenue;
  double? sales;
  double? ats;

  factory BqRevenueReport.fromJson(Map<String, dynamic> json) =>
      _$BqRevenueReportFromJson(json);

  Map<String, dynamic> toJson() => _$BqRevenueReportToJson(this);
}
