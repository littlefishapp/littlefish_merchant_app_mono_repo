// Package imports:
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import 'package:littlefish_merchant/models/reports/bq_customer_sales_report.dart';

part 'bq_customer_sales_comparison_report.g.dart';

@JsonSerializable()
class CustomerSalesComparisonReport {
  CustomerSalesComparisonReport({
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
  List<BqCustomerSalesReport>? reportResponse;

  factory CustomerSalesComparisonReport.fromJson(Map<String, dynamic> json) =>
      _$CustomerSalesComparisonReportFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerSalesComparisonReportToJson(this);
}
