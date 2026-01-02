// Package imports:
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import 'package:littlefish_merchant/models/reports/sales_report.dart';

part 'product_report.g.dart';

@JsonSerializable()
class ProductReport {
  ProductReport({
    this.avgCostPrice,
    this.avgMarkup,
    this.avgProfit,
    this.avgSellingPrice,
    this.mostProfitableProduct,
    this.mostSoldProduct,
    this.totalProducts,
    this.totalQuantity,
    this.totalValue,
  });

  int? totalProducts;

  double? totalQuantity;
  double? totalValue;
  double? avgMarkup;
  double? avgSellingPrice;
  double? avgCostPrice;
  double? avgProfit;

  List<ReportView>? mostSoldProduct;

  List<ReportView>? mostProfitableProduct;

  factory ProductReport.fromJson(Map<String, dynamic> json) =>
      _$ProductReportFromJson(json);

  Map<String, dynamic> toJson() => _$ProductReportToJson(this);
}
