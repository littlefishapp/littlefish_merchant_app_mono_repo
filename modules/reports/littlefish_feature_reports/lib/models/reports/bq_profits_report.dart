// Package imports:
import 'package:json_annotation/json_annotation.dart';

part 'bq_profits_report.g.dart';

@JsonSerializable()
class BqProfitsReport {
  BqProfitsReport({this.dateTimeIndex, this.revenue, this.profits});

  dynamic dateTimeIndex;
  double? revenue;
  double? profits;

  factory BqProfitsReport.fromJson(Map<String, dynamic> json) =>
      _$BqProfitsReportFromJson(json);

  Map<String, dynamic> toJson() => _$BqProfitsReportToJson(this);
}
