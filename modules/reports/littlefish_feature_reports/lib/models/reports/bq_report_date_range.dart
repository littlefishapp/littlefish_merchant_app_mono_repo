// Package imports:
import 'package:json_annotation/json_annotation.dart';

// Project imports:

part 'bq_report_date_range.g.dart';

@JsonSerializable()
class BqReportDateRange {
  BqReportDateRange({this.seriesName, this.startDate, this.endDate});

  String? seriesName;
  String? startDate;
  String? endDate;

  factory BqReportDateRange.fromJson(Map<String, dynamic> json) =>
      _$BqReportDateRangeFromJson(json);

  Map<String, dynamic> toJson() => _$BqReportDateRangeToJson(this);
}
