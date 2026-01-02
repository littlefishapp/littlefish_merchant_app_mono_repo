// Package imports:
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import 'package:littlefish_merchant/models/reports/bq_revenue_report.dart';

part 'bq_revenue_comparison_report.g.dart';

@JsonSerializable()
class RevenueComparisonReport {
  RevenueComparisonReport({
    this.seriesName,
    this.seriesNo,
    this.startDate,
    this.endDate,
    this.businessName,
    this.reportResponse,
  });

  String? seriesName;
  int? seriesNo;
  String? startDate;
  String? endDate;
  String? businessName;
  List<BqRevenueReport>? reportResponse;

  factory RevenueComparisonReport.fromJson(Map<String, dynamic> json) =>
      _$RevenueComparisonReportFromJson(json);

  Map<String, dynamic> toJson() => _$RevenueComparisonReportToJson(this);
}
