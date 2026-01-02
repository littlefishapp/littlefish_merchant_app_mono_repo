// Package imports:
import 'package:json_annotation/json_annotation.dart';

part 'bq_customer_sales_report.g.dart';

@JsonSerializable()
class BqCustomerSalesReport {
  BqCustomerSalesReport({this.firstName, this.qty, this.amount});

  @JsonKey(defaultValue: 'N/A')
  String? firstName;
  double? qty;
  double? amount;

  factory BqCustomerSalesReport.fromJson(Map<String, dynamic> json) =>
      _$BqCustomerSalesReportFromJson(json);

  Map<String, dynamic> toJson() => _$BqCustomerSalesReportToJson(this);
}
