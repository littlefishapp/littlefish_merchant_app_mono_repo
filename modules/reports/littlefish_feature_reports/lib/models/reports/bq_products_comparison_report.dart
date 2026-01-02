// Package imports:
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import 'package:littlefish_merchant/models/reports/bq_products_report.dart';

part 'bq_products_comparison_report.g.dart';

@JsonSerializable()
class ProductsComparisonReport {
  ProductsComparisonReport({
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
  List<BqProductsReport>? reportResponse;

  factory ProductsComparisonReport.fromJson(Map<String, dynamic> json) =>
      _$ProductsComparisonReportFromJson(json);

  Map<String, dynamic> toJson() => _$ProductsComparisonReportToJson(this);
}
