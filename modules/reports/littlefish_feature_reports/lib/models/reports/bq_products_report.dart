// Package imports:
import 'package:json_annotation/json_annotation.dart';

part 'bq_products_report.g.dart';

@JsonSerializable()
class BqProductsReport {
  BqProductsReport({this.productName, this.qty, this.amount});

  String? productName;
  double? qty;
  double? amount;

  factory BqProductsReport.fromJson(Map<String, dynamic> json) =>
      _$BqProductsReportFromJson(json);

  Map<String, dynamic> toJson() => _$BqProductsReportToJson(this);
}
