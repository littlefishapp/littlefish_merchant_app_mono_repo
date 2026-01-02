// Package imports:
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import 'package:littlefish_merchant/models/reports/bq_payments_report.dart';

part 'bq_payments_comparison_report.g.dart';

@JsonSerializable()
class PaymentsComparisonReport {
  PaymentsComparisonReport({
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
  List<BqPaymentsReport>? reportResponse;

  factory PaymentsComparisonReport.fromJson(Map<String, dynamic> json) =>
      _$PaymentsComparisonReportFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentsComparisonReportToJson(this);
}
