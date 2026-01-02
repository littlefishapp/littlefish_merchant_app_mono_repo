// Package imports:
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import 'package:littlefish_merchant/models/reports/bq_tax_report.dart';

part 'bq_tax_comparison_report.g.dart';

@JsonSerializable()
class TaxComparisonReport {
  TaxComparisonReport({
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
  List<BqTaxReport>? reportResponse;

  factory TaxComparisonReport.fromJson(Map<String, dynamic> json) =>
      _$TaxComparisonReportFromJson(json);

  Map<String, dynamic> toJson() => _$TaxComparisonReportToJson(this);
}
