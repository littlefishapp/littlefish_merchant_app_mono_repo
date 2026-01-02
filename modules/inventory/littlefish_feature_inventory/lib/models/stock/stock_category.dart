// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

// Project imports:
import 'package:littlefish_merchant/models/shared/simple_data_item.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/tools/converters/iso_date_time_converter.dart';

part 'stock_category.g.dart';

@JsonSerializable()
@IsoDateTimeConverter()
class StockCategory extends BusinessDataItem {
  StockCategory({
    this.categoryColor,
    this.imageUri,
    this.isNew = false,
    this.productCount = 0,
    this.isOnline = false,
    this.isFeatured = false,
  });

  StockCategory.create() {
    id = const Uuid().v4();
    color = Colors.teal;
    isNew = true;
    enabled = true;
    deleted = false;
    dateCreated = DateTime.now().toUtc();
    products = newProducts = removedProducts = <StockProduct>[];
    productCount = 0;
  }

  factory StockCategory.clone(StockCategory category) =>
      StockCategory(
          categoryColor: category.categoryColor,
          isNew: category.isNew,
          productCount: category.productCount,
        )
        ..description = category.description
        ..name = category.name
        ..dateCreated = category.dateCreated
        ..enabled = category.enabled
        ..id = category.id
        ..businessId = category.businessId
        ..displayName = category.displayName;

  StockCategory copyWith(StockCategory? item) {
    return StockCategory(
        categoryColor: item?.categoryColor ?? categoryColor,
        imageUri: item?.imageUri ?? imageUri,
        isNew: item?.isNew ?? isNew,
        isOnline: item?.isOnline ?? isOnline,
        isFeatured: item?.isFeatured ?? isFeatured,
        productCount: item?.productCount ?? productCount,
      )
      ..description = item?.description ?? description
      ..createdBy = item?.createdBy ?? createdBy
      ..name = item?.name ?? name
      ..dateCreated = item?.dateCreated ?? dateCreated
      ..enabled = item?.enabled ?? enabled
      ..id = item?.id ?? id
      ..businessId = item?.businessId ?? businessId
      ..deleted = item?.deleted ?? deleted
      ..displayName = item?.displayName ?? displayName;
  }

  // bool? enabled, deleted;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? isNew;

  @JsonKey(includeFromJson: false, includeToJson: false)
  List<StockProduct>? products = [];

  @JsonKey(includeFromJson: false, includeToJson: false)
  List<StockProduct> newProducts = [];

  @JsonKey(includeFromJson: false, includeToJson: false)
  List<StockProduct> removedProducts = [];

  int? productCount;

  // String? businessId;

  // DateTime? dateCreated;

  String? categoryColor;

  String? imageUri;

  bool? isOnline;

  bool? isFeatured;

  @JsonKey(includeFromJson: false, includeToJson: false)
  Color get color {
    if (categoryColor == null || categoryColor!.isEmpty) {
      return Colors.blueAccent;
    }

    return Color(int.parse(categoryColor!));
  }

  set color(Color color) {
    if (color.value.toString() != categoryColor) {
      categoryColor = color.value.toString();
    }
  }

  factory StockCategory.fromJson(Map<String, dynamic> json) =>
      _$StockCategoryFromJson(json)..imageUri = json['imageUri'] as String?;

  Map<String, dynamic> toJson() => _$StockCategoryToJson(this);
}
