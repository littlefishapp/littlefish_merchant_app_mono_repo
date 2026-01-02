// Package imports:
import 'package:json_annotation/json_annotation.dart';

part 'inventory_overview.g.dart';

@JsonSerializable()
class InventoryOverview {
  String? productId, productName;
  double? closingInventory, quantitySold, quantitySoldPerDay;
  int? daysCovered;
  double? avgCost,
      grossProfit,
      inventoryCostPrice,
      inventorySalePrice,
      grossSales;

  InventoryOverview({
    this.productId,
    this.productName,
    this.closingInventory,
    this.avgCost,
    this.daysCovered,
    this.grossProfit,
    this.inventoryCostPrice,
    this.inventorySalePrice,
    this.quantitySold,
    this.quantitySoldPerDay,
    this.grossSales,
  });

  factory InventoryOverview.fromJson(Map<String, dynamic> json) =>
      _$InventoryOverviewFromJson(json);

  Map<String, dynamic> toJson() => _$InventoryOverviewToJson(this);
}
