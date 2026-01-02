// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_overview.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerOverview _$CustomerOverviewFromJson(Map<String, dynamic> json) =>
    CustomerOverview(
      sales: json['sales'] == null
          ? null
          : PagedCheckoutTransaction.fromJson(
              json['sales'] as Map<String, dynamic>,
            ),
      lastPurchaseDate: json['lastPurchaseDate'] == null
          ? null
          : DateTime.parse(json['lastPurchaseDate'] as String),
      favoriteItem: json['favoriteItem'] == null
          ? null
          : AnalysisPair.fromJson(json['favoriteItem'] as Map<String, dynamic>),
      avgSaleValue: (json['avgSaleValue'] as num?)?.toDouble(),
      lastSaleValue: (json['lastSaleValue'] as num?)?.toDouble(),
      totalSaleValue: (json['totalSaleValue'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$CustomerOverviewToJson(CustomerOverview instance) =>
    <String, dynamic>{
      'lastPurchaseDate': instance.lastPurchaseDate?.toIso8601String(),
      'totalSaleValue': instance.totalSaleValue,
      'avgSaleValue': instance.avgSaleValue,
      'lastSaleValue': instance.lastSaleValue,
      'favoriteItem': instance.favoriteItem,
      'sales': instance.sales,
    };
