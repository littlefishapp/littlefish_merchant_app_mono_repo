// Package imports:
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import 'package:littlefish_merchant/models/reports/bq_profits_report.dart';

part 'bq_profits_comparison_report.g.dart';

@JsonSerializable()
class ProfitsComparisonReport {
  ProfitsComparisonReport({
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
  List<BqProfitsReport>? reportResponse;

  factory ProfitsComparisonReport.fromJson(Map<String, dynamic> json) =>
      _$ProfitsComparisonReportFromJson(json);

  Map<String, dynamic> toJson() => _$ProfitsComparisonReportToJson(this);
}
