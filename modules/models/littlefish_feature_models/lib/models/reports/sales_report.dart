// Package imports:
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import 'package:littlefish_merchant/models/analysis/analysis_overviews.dart';

part 'sales_report.g.dart';

@JsonSerializable()
class SalesReport {
  SalesReport({
    this.averageSale,
    this.current,
    this.discountsAndComp,
    this.grossSales,
    this.netSales,
    this.previous,
    this.returns,
    this.sales,
    this.salesByPaymentType,
    this.topCategories,
    this.topCustomers,
    this.topProducts,
  });

  // @JsonKey(name: "GrossSales")
  double? grossSales;

  // @JsonKey(name: "NetSales")
  double? netSales;

  // @JsonKey(name: "Sales")
  double? sales;

  // @JsonKey(name: "AverageSale")
  double? averageSale;

  // @JsonKey(name: "Returns")
  double? returns;

  // @JsonKey(name: "DiscountsAndComp")
  double? discountsAndComp;

  // @JsonKey(name: "Current")
  List<SalesView>? current;

  // @JsonKey(name: "Previous")
  List<SalesView>? previous;

  // @JsonKey(name: "SalesByPaymentType")
  List<AnalysisPair>? salesByPaymentType;

  // @JsonKey(name: "TopProducts")
  List<ReportView>? topProducts;

  // @JsonKey(name: "TopCustomers")
  List<ReportView>? topCustomers;
  //
  // @JsonKey(name: "TopCategories")
  List<ReportView>? topCategories;

  factory SalesReport.fromJson(Map<String, dynamic> json) =>
      _$SalesReportFromJson(json);

  Map<String, dynamic> toJson() => _$SalesReportToJson(this);
}

@JsonSerializable()
class SalesView {
  SalesView({
    this.averageSale,
    this.key,
    this.netSales,
    this.saleCount,
    this.totalDiscounts,
    this.totalSales,
    this.grossProfit,
  });

  // @JsonKey(name: "TotalDiscounts")
  double? totalDiscounts;

  // @JsonKey(name: "AverageSale")
  double? averageSale;

  // @JsonKey(name: "NetSales")
  double? netSales;

  // @JsonKey(name: "TotalSales")
  double? totalSales;

  // @JsonKey(name: "SaleCount")
  double? saleCount;

  double? grossProfit;

  @JsonKey(name: '_id')
  SalesGrouping? key;

  factory SalesView.fromJson(Map<String, dynamic> json) =>
      _$SalesViewFromJson(json);

  Map<String, dynamic> toJson() => _$SalesViewToJson(this);
}

@JsonSerializable()
class SimpleSalesView {
  SimpleSalesView({
    this.avgSales,
    this.avgSalesQuantity,
    this.key,
    this.name,
    this.totalSales,
    this.totalSalesQuantity,
  });

  @JsonKey(name: '_id')
  SalesGrouping? key;

  double? totalSales;

  double? totalSalesQuantity;

  double? avgSales;

  double? avgSalesQuantity;

  String? name;

  factory SimpleSalesView.fromJson(Map<String, dynamic> json) =>
      _$SimpleSalesViewFromJson(json);

  Map<String, dynamic> toJson() => _$SimpleSalesViewToJson(this);
}

@JsonSerializable()
class SalesGrouping {
  SalesGrouping({this.day, this.hour, this.month, this.week, this.year});

  // @JsonKey(name: "Year")
  int? year;

  // @JsonKey(name: "Month")
  int? month;

  // @JsonKey(name: "Week")
  int? week;

  // @JsonKey(name: "Day")
  int? day;

  // @JsonKey(name: "Hour")
  int? hour;

  factory SalesGrouping.fromJson(Map<String, dynamic> json) =>
      _$SalesGroupingFromJson(json);

  Map<String, dynamic> toJson() => _$SalesGroupingToJson(this);
}

@JsonSerializable()
class ReportView {
  ReportView({this.amount, this.count, this.name});

  @JsonKey(name: 'name')
  String? name;

  @JsonKey(name: 'count')
  double? count;

  @JsonKey(name: 'amount')
  double? amount;

  factory ReportView.fromJson(Map<String, dynamic> json) =>
      _$ReportViewFromJson(json);

  Map<String, dynamic> toJson() => _$ReportViewToJson(this);
}
