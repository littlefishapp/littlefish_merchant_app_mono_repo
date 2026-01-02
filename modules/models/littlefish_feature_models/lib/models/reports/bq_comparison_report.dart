// Package imports:
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import 'package:littlefish_merchant/models/reports/bq_report.dart';

part 'bq_comparison_report.g.dart';

@JsonSerializable()
class ComparisonBqReport {
  ComparisonBqReport({
    this.seriesName,
    this.seriesNo,
    this.startDate,
    this.endDate,
    this.reportResponse,
  });

  String? seriesName;
  int? seriesNo;
  String? startDate;
  String? endDate;
  List<BqReport>? reportResponse;

  factory ComparisonBqReport.fromJson(Map<String, dynamic> json) =>
      _$ComparisonBqReportFromJson(json);

  Map<String, dynamic> toJson() => _$ComparisonBqReportToJson(this);
}
