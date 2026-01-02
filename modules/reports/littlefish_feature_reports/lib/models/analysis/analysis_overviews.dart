// Package imports:
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import 'package:littlefish_merchant/tools/converters/iso_date_time_converter.dart';

part 'analysis_overviews.g.dart';

@JsonSerializable()
@IsoDateTimeConverter()
class BusinessOverviewCount {
  double? totalDiscount;

  double? totalRefundedSalesCost;

  double? totalSalesCost;

  String? businessId;

  int? productCount;

  int? customerCount;

  int? employeeCount;

  int? supplierCount;

  int? salesCount;

  double? avgItemsSold;

  double? totalInventoryValue;

  double? totalSalesValue;

  double? totalRefundedSales;

  double? totalProfit;

  double? totalExpenses;

  double? totalTax;

  double? totalItemsSold;

  BusinessOverviewCount({
    this.totalDiscount,
    this.totalSalesCost,
    this.totalRefundedSalesCost,
    this.totalRefundedSales,
    this.businessId,
    this.customerCount,
    this.employeeCount,
    this.productCount,
    this.salesCount,
    this.supplierCount,
    this.totalInventoryValue,
    this.totalSalesValue,
    this.totalProfit,
    this.totalExpenses,
    this.totalTax,
    this.totalItemsSold,
    this.avgItemsSold,
  });

  factory BusinessOverviewCount.fromJson(Map<String, dynamic> json) =>
      _$BusinessOverviewCountFromJson(json);

  Map<String, dynamic> toJson() => _$BusinessOverviewCountToJson(this);
}

@JsonSerializable()
class CustomerTopTen {
  CustomerTopTen({
    this.topCustomersBySaleCount,
    this.topCustomersBySaleValue,
    this.worstCustomersBySaleCount,
    this.worstCustomersBySaleValue,
  });

  List<AnalysisPair>? topCustomersBySaleValue;
  List<AnalysisPair>? topCustomersBySaleCount;
  List<AnalysisPair>? worstCustomersBySaleValue;
  List<AnalysisPair>? worstCustomersBySaleCount;

  factory CustomerTopTen.fromJson(Map<String, dynamic> json) =>
      _$CustomerTopTenFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerTopTenToJson(this);
}

@JsonSerializable()
class ProductTopTen {
  ProductTopTen({this.mostSold, this.mostProfit});

  List<AnalysisPair>? mostSold;
  List<AnalysisPair>? mostProfit;

  factory ProductTopTen.fromJson(Map<String, dynamic> json) =>
      _$ProductTopTenFromJson(json);

  Map<String, dynamic> toJson() => _$ProductTopTenToJson(this);
}

@JsonSerializable()
class CustomerStatistic {
  List<AnalysisPair>? data;

  String? name;

  CustomerStatistic(this.data, this.name);

  factory CustomerStatistic.fromJson(Map<String, dynamic> json) =>
      _$CustomerStatisticFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerStatisticToJson(this);
}

@JsonSerializable()
class AnalysisPair {
  AnalysisPair({
    this.id,
    this.value,
    this.max,
    this.min,
    this.useLessThan,
    this.lessThanValue,
  });

  String? id;

  double? value;

  @JsonKey(defaultValue: 0.0)
  double? max;

  @JsonKey(defaultValue: 0.0)
  double? min;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? useLessThan;

  @JsonKey(includeFromJson: false, includeToJson: false)
  double? lessThanValue;

  factory AnalysisPair.fromJson(Map<String, dynamic> json) =>
      _$AnalysisPairFromJson(json);

  Map<String, dynamic> toJson() => _$AnalysisPairToJson(this);
}
