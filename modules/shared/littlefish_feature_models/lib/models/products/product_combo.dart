// Package imports:
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

// Project imports:
import 'package:littlefish_merchant/models/shared/simple_data_item.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/tools/converters/iso_date_time_converter.dart';

part 'product_combo.g.dart';

@JsonSerializable()
@IsoDateTimeConverter()
class ProductCombo extends BusinessDataItem {
  ProductCombo({
    this.barcode,
    this.cachedImageUri,
    this.categoryId,
    this.color,
    this.currencyCode,
    this.imageUri,
    this.isNew = false,
  });

  ProductCombo.create() {
    id = const Uuid().v4();
    enabled = true;
    deleted = false;
    isNew = true;
    items = [];
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? isNew;

  String? barcode, color, currencyCode, imageUri, cachedImageUri, categoryId;

  List<ProductComboItem>? items = [];

  addComboItem(ProductComboItem item) {
    if (items == null) {
      items = [item];
    } else {
      //if it already exists, we should not add it
      var existingIndex = items!.indexWhere(
        (c) => c.productId == item.productId,
      );
      if (existingIndex >= 0) {
        items![existingIndex] = item;
      } else {
        items!.add(item);
      }
    }
  }

  void addItem(StockProduct item) {
    if (items == null) {
      items = [ProductComboItem.fromProduct(item)];
    } else {
      //if it already exists, we should not add it
      var existingIndex = items!.indexWhere((c) => c.productId == item.id);
      if (existingIndex >= 0) {
        return;
      } else {
        items!.add(ProductComboItem.fromProduct(item));
      }
    }
  }

  void removeItem(StockProduct item) {
    if (items == null) return;

    var existingIndex = items!.indexWhere((c) => c.productId == item.id);
    if (existingIndex >= 0) items!.removeAt(existingIndex);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  double get totalItems {
    if (items!.isEmpty) return 0;

    return items?.map((p) => p.quantity).reduce((a, b) => a! + b!) ?? 0;
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  int get markup {
    return totalItems > 0
        ? 100 - ((comboCostPrice / comboSellingPrice) * 100).round()
        : 0;
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  double get comboCostPrice {
    if (items!.isEmpty) return 0;

    return items
            ?.map((p) => (p.quantity! * p.costPrice!))
            .reduce((a, b) => a + b) ??
        0;
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  double get originalSellingPrice {
    if (items!.isEmpty) return 0;
    return items
            ?.map((p) => (p.quantity! * p.sellingPrice!))
            .reduce((a, b) => a + b) ??
        0;
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  double get comboSellingPrice {
    if (items!.isEmpty) return 0;
    return items
            ?.map((p) => (p.quantity! * p.comboPrice!))
            .reduce((a, b) => a + b) ??
        0;
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  double get comboSaving {
    return originalSellingPrice - comboSellingPrice;
  }

  factory ProductCombo.fromJson(Map<String, dynamic> json) =>
      _$ProductComboFromJson(json);

  Map<String, dynamic> toJson() => _$ProductComboToJson(this);
}

@JsonSerializable()
@IsoDateTimeConverter()
class ProductComboItem {
  ProductComboItem({
    this.name,
    this.comboPrice,
    this.costPrice,
    this.discount,
    this.productId,
    this.quantity,
    this.sellingPrice,
    this.varianceId,
  });

  String? productId, varianceId, name;

  double? quantity, costPrice, sellingPrice, discount, comboPrice;

  @JsonKey(includeFromJson: false, includeToJson: false)
  StockProduct? product;

  @JsonKey(includeFromJson: false, includeToJson: false)
  double get comboSaving {
    return sellingPrice! - comboPrice!;
  }

  factory ProductComboItem.fromProduct(StockProduct product) =>
      ProductComboItem(
        name: product.displayName,
        comboPrice: product.regularPrice,
        costPrice: product.regularCostPrice,
        discount: 0,
        productId: product.id,
        quantity: 1,
        sellingPrice: product.regularPrice,
        varianceId: product.regularVariance?.id,
      )..product = product;

  factory ProductComboItem.fromJson(Map<String, dynamic> json) =>
      _$ProductComboItemFromJson(json);

  Map<String, dynamic> toJson() => _$ProductComboItemToJson(this);
}
