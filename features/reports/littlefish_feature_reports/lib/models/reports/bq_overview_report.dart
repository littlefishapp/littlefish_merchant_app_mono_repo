// Package imports:
import 'package:json_annotation/json_annotation.dart';

part 'bq_overview_report.g.dart';

@JsonSerializable()
class BqOverviewReport {
  BqOverviewReport({
    this.businessId,
    this.revenue,
    this.sales,
    this.ats,
    this.profits,
    this.amtToTax,
    this.topProd,
    this.paymentMeth,
    this.payMethAmt,
    this.payMethPercent,
    this.topProdSalesAmt,
    this.topProdCategory,
    this.topCust,
    this.topCustSalesAmt,
    this.topStaff,
    this.topStaffSalesAmt,
    this.onlineProfits,
    this.onlineRevenue,
    this.onlineSalesATS,
    this.onlineSalesCount,
  });

  String? businessId;
  double? revenue;
  double? sales;
  double? ats;
  double? profits;
  double? amtToTax;
  String? topProd;
  String? paymentMeth;
  double? payMethPercent;
  double? payMethAmt;
  double? topProdSalesAmt;
  String? topProdCategory;
  String? topCust;
  double? topCustSalesAmt;
  String? topStaff;
  double? topStaffSalesAmt;
  double? onlineRevenue;
  double? onlineSalesCount;
  double? onlineSalesATS;
  double? onlineProfits;

  factory BqOverviewReport.fromJson(Map<String, dynamic> json) =>
      _$BqOverviewReportFromJson(json);

  Map<String, dynamic> toJson() => _$BqOverviewReportToJson(this);
}
