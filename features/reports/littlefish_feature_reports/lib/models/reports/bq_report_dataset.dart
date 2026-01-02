// Package imports:
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import 'package:littlefish_merchant/models/reports/bq_comparison_report_series.dart';

part 'bq_report_dataset.g.dart';

@JsonSerializable()
class BqReportDataset {
  BqReportDataset({this.comparisonReports, this.comparisonAnalysisPairs});

  List<dynamic>? comparisonReports;
  List<ComparisonBqReportSeries>? comparisonAnalysisPairs;

  factory BqReportDataset.fromJson(Map<String, dynamic> json) =>
      _$BqReportDatasetFromJson(json);

  Map<String, dynamic> toJson() => _$BqReportDatasetToJson(this);
}
