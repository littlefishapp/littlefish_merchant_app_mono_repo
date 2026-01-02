// Package imports:
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import 'package:littlefish_merchant/models/reports/bq_overview_report.dart';

part 'bq_comparison_overview_report.g.dart';

@JsonSerializable(explicitToJson: true)
class OverviewComparisonReport {
  OverviewComparisonReport({
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
  List<BqOverviewReport>? reportResponse;

  factory OverviewComparisonReport.fromJson(Map<String, dynamic> json) =>
      _$OverviewComparisonReportFromJson(json);

  Map<String, dynamic> toJson() => _$OverviewComparisonReportToJson(this);
}
