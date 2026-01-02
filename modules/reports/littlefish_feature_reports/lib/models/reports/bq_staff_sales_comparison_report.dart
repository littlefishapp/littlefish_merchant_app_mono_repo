// Package imports:
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import 'package:littlefish_merchant/models/reports/bq_staff_sales_report.dart';

part 'bq_staff_sales_comparison_report.g.dart';

@JsonSerializable()
class StaffSalesComparisonReport {
  StaffSalesComparisonReport({
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
  List<BqStaffSalesReport>? reportResponse;

  factory StaffSalesComparisonReport.fromJson(Map<String, dynamic> json) =>
      _$StaffSalesComparisonReportFromJson(json);

  Map<String, dynamic> toJson() => _$StaffSalesComparisonReportToJson(this);
}
