// Package imports:
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import 'package:littlefish_merchant/models/reports/sales_report.dart';

part 'customer_report.g.dart';

@JsonSerializable()
class CustomerReport {
  CustomerReport({
    this.activeCustomers,
    this.customerSales,
    this.nonCustomerSales,
    this.topCustomersByPurchases,
    this.topCustomersByQuantity,
    this.topCustomersByVisits,
    this.totalCustomers,
    this.totalNonCustomerSalesAmount,
    this.totalNonCustomerSalesCount,
    this.totalNonCustomerSalesQuantity,
    this.totalCustomerSalesAmount,
    this.totalCustomerSalesCount,
    this.totalCustomerSalesQuantity,
  });

  int? totalCustomers;

  @JsonKey(name: 'customersActiveLastPeriod')
  int? activeCustomers;

  @JsonKey(name: 'topByVisits')
  List<VisitView>? topCustomersByVisits;

  @JsonKey(name: 'topByQuantity')
  List<ReportView>? topCustomersByQuantity;

  @JsonKey(name: 'topByAmount')
  List<ReportView>? topCustomersByPurchases;

  List<SimpleSalesView>? customerSales;

  List<SimpleSalesView>? nonCustomerSales;

  double? totalCustomerSalesAmount;

  double? totalCustomerSalesQuantity;

  double? totalCustomerSalesCount;

  double? totalNonCustomerSalesAmount;

  double? totalNonCustomerSalesQuantity;

  double? totalNonCustomerSalesCount;

  factory CustomerReport.fromJson(Map<String, dynamic> json) =>
      _$CustomerReportFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerReportToJson(this);
}

@JsonSerializable()
class VisitView {
  VisitView({this.amount, this.name, this.visits});

  String? name;

  double? amount;

  int? visits;

  factory VisitView.fromJson(Map<String, dynamic> json) =>
      _$VisitViewFromJson(json);

  Map<String, dynamic> toJson() => _$VisitViewToJson(this);
}
