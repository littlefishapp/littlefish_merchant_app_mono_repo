// Package imports:
import 'package:json_annotation/json_annotation.dart';

part 'bq_staff_sales_report.g.dart';

@JsonSerializable()
class BqStaffSalesReport {
  BqStaffSalesReport({this.firstName, this.qty, this.amount});

  String? firstName;
  double? qty;
  double? amount;

  factory BqStaffSalesReport.fromJson(Map<String, dynamic> json) =>
      _$BqStaffSalesReportFromJson(json);

  Map<String, dynamic> toJson() => _$BqStaffSalesReportToJson(this);
}
