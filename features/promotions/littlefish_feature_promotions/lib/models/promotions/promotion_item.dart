// Package imports:
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/products/product_combo.dart';
import 'package:littlefish_merchant/models/promotions/promotion.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/models/stock/stock_variance.dart';
import 'package:littlefish_merchant/tools/converters/iso_date_time_converter.dart';

part 'promotion_item.g.dart';

@JsonSerializable()
@IsoDateTimeConverter()
class PromotionItem {
  PromotionItem({
    this.promoUnitPrice,
    this.costPrice,
    this.discountType,
    this.discountValue,
    this.itemId,
    this.itemType,
    this.name,
    this.percentageDiscount,
    this.quantity,
    this.sellingPrice,
    this.varianceId,
    this.promoSellingPrice,
  });

  PromotionItem.fromProduct(StockProduct productValue) {
    name = productValue.displayName;
    itemId = productValue.id;
    quantity = 1;
    costPrice = productValue.regularCostPrice;
    sellingPrice = productValue.regularPrice;
    discountType = DiscountType.fixedPrice;
    varianceId = productValue.regularVariance?.id;
    promoUnitPrice = productValue.regularPrice;
    discountValue = 0.0;
    percentageDiscount = 0.0;
    itemType = PromoItemType.product;
    product = productValue;
    variance = productValue.regularVariance;
  }

  PromotionItem.fromCombo(ProductCombo comboValue) {
    name = comboValue.displayName;
    itemId = comboValue.id;
    quantity = 1;
    costPrice = comboValue.comboCostPrice;
    sellingPrice = comboValue.comboSellingPrice;
    discountType = DiscountType.fixedPrice;
    promoUnitPrice = comboValue.comboSellingPrice;
    discountValue = 0.0;
    percentageDiscount = 0.0;
    itemType = PromoItemType.combo;
    combo = comboValue;
  }

  String? name, itemId;

  //only relevant for a product promotion item
  String? varianceId;

  @JsonKey(defaultValue: 0.0)
  double? quantity;

  @JsonKey(defaultValue: 0.0)
  double? costPrice;

  @JsonKey(defaultValue: 0.0)
  double? sellingPrice;

  @JsonKey(defaultValue: 0.0)
  double? promoUnitPrice;

  @JsonKey(defaultValue: 0.0)
  double? promoSellingPrice;

  @JsonKey(defaultValue: 0.0)
  double? discountValue;

  @JsonKey(defaultValue: 0.0)
  double? percentageDiscount;

  @JsonKey(defaultValue: PromoItemType.product)
  PromoItemType? itemType;

  @JsonKey(defaultValue: DiscountType.fixedPrice)
  DiscountType? discountType;

  @JsonKey(includeFromJson: false, includeToJson: false)
  StockProduct? product;

  @JsonKey(includeFromJson: false, includeToJson: false)
  StockVariance? variance;

  @JsonKey(includeFromJson: false, includeToJson: false)
  ProductCombo? combo;

  factory PromotionItem.fromJson(Map<String, dynamic> json) =>
      _$PromotionItemFromJson(json);

  Map<String, dynamic> toJson() => _$PromotionItemToJson(this);
}
