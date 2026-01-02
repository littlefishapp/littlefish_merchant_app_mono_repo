import 'package:json_annotation/json_annotation.dart';
import 'package:littlefish_merchant/models/stock/product_option.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/tools/converters/iso_date_time_converter.dart';

part 'full_product.g.dart';

@JsonSerializable()
@IsoDateTimeConverter()
class FullProduct {
  final StockProduct product;
  final List<ProductOption>? productOptions;

  FullProduct({required this.product, this.productOptions});

  factory FullProduct.fromJson(Map<String, dynamic> json) =>
      _$FullProductFromJson(json);

  Map<String, dynamic> toJson() => _$FullProductToJson(this);
}
