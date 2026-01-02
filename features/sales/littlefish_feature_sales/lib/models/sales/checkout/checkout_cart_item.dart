// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:json_annotation/json_annotation.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:uuid/uuid.dart';

// Project imports:
import 'package:littlefish_merchant/models/products/product_combo.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/models/stock/stock_variance.dart';
import 'package:littlefish_merchant/tools/converters/iso_date_time_converter.dart';

part 'checkout_cart_item.g.dart';

@JsonSerializable()
@IsoDateTimeConverter()
class CheckoutCartItem extends ChangeNotifier {
  CheckoutCartItem({
    required this.description,
    required this.quantity,
    required this.itemValue,
    required this.cartIndex,
    this.varianceId,
    this.productId,
    this.barcode,
    this.itemCost,
    this.isCombo,
    this.comboId,
    this.id,
    this.taxId,
    this.isPromotion,
    this.itemSaving,
    this.itemTax,
    this.promoId,
    this.itemType,
  }) {
    id ??= const Uuid().v4();
  }

  CheckoutCartItem.fromCustomSale(double value, String? description) {
    id = const Uuid().v4();
    quantity = 1;
    this.description = description ?? 'Custom Sale';
    itemCost = 0.0;
    itemValue = value;
    isCombo = false;
    isPromotion = false;
    itemTax = 0;
    taxId =
        (AppVariables.salesTax.enabled ?? false) &&
            (AppVariables.salesTax.applyToCustomAmount ?? false)
        ? AppVariables.salesTax.id
        : null;
    itemSaving = 0;
    isCustomSale = true;
    itemType = CheckoutCartItemType.customItem;
  }

  CheckoutCartItem.fromProduct(
    StockProduct product,
    StockVariance variance, {
    double? variablePrice,
    double? quantity,
  }) {
    id = const Uuid().v4();
    this.quantity = quantity ?? 1;
    description = product.displayName ?? 'Product Sale';
    itemCost = variance.costPrice;
    itemValue = product.isVariable
        ? (variablePrice ?? variance.sellingPrice)
        : variance.sellingPrice;
    barcode = variance.barcode;
    isCombo = false;
    isPromotion = false;
    itemTax = 0;
    taxId = product.taxId;
    itemSaving = 0;
    productId = product.id;
    isCustomSale = false;
    isService = product.productType == ProductType.service;
    itemType = CheckoutCartItemType.stockProduct;
  }

  CheckoutCartItem.fromCombo(ProductCombo combo, double qty) {
    id = const Uuid().v4();
    quantity = qty;
    itemCost = combo.comboCostPrice;
    itemValue = combo.comboSellingPrice;
    barcode = combo.barcode;
    isCombo = true;
    itemTax = 0;
    comboId = combo.id;
    description = combo.displayName;
    itemSaving = combo.originalSellingPrice - combo.comboSellingPrice;
    isPromotion = false;
    isCustomSale = false;
    isService = false;
  }

  int? cartIndex;

  String? id;

  String? taxId;

  String? description;

  @JsonKey(defaultValue: 1)
  late double quantity;

  @JsonKey(defaultValue: 0)
  double? itemCost;

  @JsonKey(defaultValue: 0)
  double? itemValue;

  String? productId;

  String? varianceId;

  String? barcode;

  @JsonKey(defaultValue: false)
  bool? isCombo;

  CheckoutCartItemType? itemType;

  String? comboId;

  String? promoId;

  @JsonKey(defaultValue: false)
  bool? isPromotion;

  @JsonKey(defaultValue: false)
  bool? isService;

  @JsonKey(defaultValue: false)
  bool? isCustomSale;

  @JsonKey(defaultValue: 0.0)
  double? itemSaving;

  @JsonKey(defaultValue: 0.0)
  double? itemTax;

  double? _valueCost;

  @JsonKey(defaultValue: 0)
  double? get valueCost {
    if (_valueCost != quantity * (itemCost ?? 0)) {
      _valueCost = quantity * (itemCost ?? 0);
    }

    return _valueCost;
  }

  set valueCost(double? v) {
    _valueCost = v;
  }

  double? _value;

  double? get value {
    if (_value != quantity * itemValue!) {
      _value = quantity * itemValue!;
    }
    return _value;
  }

  double get totalSaving {
    return quantity * (itemSaving ?? 0);
  }

  set value(double? v) {
    _value = v;
    notifyListeners();
  }

  set quantitySet(double qty) {
    quantity = qty;
    notifyListeners();
  }

  factory CheckoutCartItem.fromJson(Map<String, dynamic> json) =>
      _$CheckoutCartItemFromJson(json);

  Map<String, dynamic> toJson() => _$CheckoutCartItemToJson(this);
}
