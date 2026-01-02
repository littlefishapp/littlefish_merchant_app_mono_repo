// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_overview.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InventoryOverview _$InventoryOverviewFromJson(Map<String, dynamic> json) =>
    InventoryOverview(
      productId: json['productId'] as String?,
      productName: json['productName'] as String?,
      closingInventory: (json['closingInventory'] as num?)?.toDouble(),
      avgCost: (json['avgCost'] as num?)?.toDouble(),
      daysCovered: (json['daysCovered'] as num?)?.toInt(),
      grossProfit: (json['grossProfit'] as num?)?.toDouble(),
      inventoryCostPrice: (json['inventoryCostPrice'] as num?)?.toDouble(),
      inventorySalePrice: (json['inventorySalePrice'] as num?)?.toDouble(),
      quantitySold: (json['quantitySold'] as num?)?.toDouble(),
      quantitySoldPerDay: (json['quantitySoldPerDay'] as num?)?.toDouble(),
      grossSales: (json['grossSales'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$InventoryOverviewToJson(InventoryOverview instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'productName': instance.productName,
      'closingInventory': instance.closingInventory,
      'quantitySold': instance.quantitySold,
      'quantitySoldPerDay': instance.quantitySoldPerDay,
      'daysCovered': instance.daysCovered,
      'avgCost': instance.avgCost,
      'grossProfit': instance.grossProfit,
      'inventoryCostPrice': instance.inventoryCostPrice,
      'inventorySalePrice': instance.inventorySalePrice,
      'grossSales': instance.grossSales,
    };
