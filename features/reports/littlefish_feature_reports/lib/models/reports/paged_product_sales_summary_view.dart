// Project imports:
import 'package:json_annotation/json_annotation.dart';

part 'paged_product_sales_summary_view.g.dart';

@JsonSerializable()
class PagedProductSalesSummaryView {
  PagedProductSalesSummaryView({this.result, this.count});

  int? count;
  List<ProductSalesSummaryView>? result;

  factory PagedProductSalesSummaryView.fromJson(Map<String, dynamic> json) =>
      _$PagedProductSalesSummaryViewFromJson(json);

  Map<String, dynamic> toJson() => _$PagedProductSalesSummaryViewToJson(this);
}

@JsonSerializable()
class ProductSalesSummaryView {
  ProductSalesSummaryView({
    this.productId,
    this.productName,
    this.quantitySold,
    this.totalSalesValue,
  });

  String? productId;
  String? productName;
  double? quantitySold;
  double? totalSalesValue;

  factory ProductSalesSummaryView.fromJson(Map<String, dynamic> json) =>
      _$ProductSalesSummaryViewFromJson(json);

  Map<String, dynamic> toJson() => _$ProductSalesSummaryViewToJson(this);
}
