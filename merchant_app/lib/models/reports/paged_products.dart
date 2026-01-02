// Package imports:
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import 'package:littlefish_merchant/models/shared/simple_data_item.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/models/stock/stock_variance.dart';

part 'paged_products.g.dart';

@JsonSerializable()
class PagedProducts {
  PagedProducts({this.result, this.count});

  int? count;
  List<ProductSingleVariance>? result;

  factory PagedProducts.fromJson(Map<String, dynamic> json) =>
      _$PagedProductsFromJson(json);

  Map<String, dynamic> toJson() => _$PagedProductsToJson(this);
}

@JsonSerializable()
class ProductSingleVariance extends BusinessDataItem {
  ProductSingleVariance({
    this.additionalBarcodes,
    this.productType,
    this.barcode,
    this.sku,
    this.color,
    this.currencyCode,
    this.favourite,
    this.imageUri,
    this.cachedImageUri,
    this.taxId,
    this.categoryId,
    this.unitType,
    this.variances,
    this.shrinkage,
  });

  ProductType? productType;
  String? barcode;
  String? sku;
  List<String>? additionalBarcodes;
  String? color;
  String? currencyCode;
  bool? favourite;
  String? imageUri;
  String? cachedImageUri;
  String? taxId;
  String? categoryId;
  StockUnitType? unitType;
  StockVariance? variances;
  ProductShrinkage? shrinkage;

  factory ProductSingleVariance.fromJson(Map<String, dynamic> json) =>
      _$ProductSingleVarianceFromJson(json);

  Map<String, dynamic> toJson() => _$ProductSingleVarianceToJson(this);
}
