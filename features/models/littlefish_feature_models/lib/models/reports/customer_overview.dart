// Package imports:
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import 'package:littlefish_merchant/models/analysis/analysis_overviews.dart';
import 'package:littlefish_merchant/models/reports/paged_checkout_transaction.dart';

part 'customer_overview.g.dart';

@JsonSerializable()
class CustomerOverview {
  DateTime? lastPurchaseDate;
  double? totalSaleValue;
  double? avgSaleValue;
  double? lastSaleValue;
  AnalysisPair? favoriteItem;
  PagedCheckoutTransaction? sales;

  CustomerOverview({
    this.sales,
    this.lastPurchaseDate,
    this.favoriteItem,
    this.avgSaleValue,
    this.lastSaleValue,
    this.totalSaleValue,
  });

  factory CustomerOverview.fromJson(Map<String, dynamic> json) =>
      _$CustomerOverviewFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerOverviewToJson(this);
}
