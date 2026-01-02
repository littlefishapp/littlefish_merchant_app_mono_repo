// Package imports:
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import 'package:littlefish_merchant/models/analysis/analysis_overviews.dart';
import 'package:littlefish_merchant/models/reports/bq_report_date_range.dart';

part 'bq_comparison_report_series.g.dart';

@JsonSerializable()
class ComparisonBqReportSeries {
  ComparisonBqReportSeries({this.dateRange, this.seriesNo, this.analysisPairs});

  BqReportDateRange? dateRange;
  int? seriesNo;
  List<AnalysisPair>? analysisPairs;

  factory ComparisonBqReportSeries.fromJson(Map<String, dynamic> json) =>
      _$ComparisonBqReportSeriesFromJson(json);

  Map<String, dynamic> toJson() => _$ComparisonBqReportSeriesToJson(this);
}
