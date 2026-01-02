// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:collection/collection.dart' show IterableExtension;
import 'package:json_annotation/json_annotation.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order_line_item.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:uuid/uuid.dart';

// Project imports:
import 'package:littlefish_merchant/models/shared/simple_data_item.dart';
import 'package:littlefish_merchant/models/stock/stock_variance.dart';
import 'package:littlefish_merchant/providers/file_system_provider.dart';
import 'package:littlefish_merchant/tools/converters/iso_date_time_converter.dart';

import 'external_product_values.dart';

part 'stock_product.g.dart';

@JsonSerializable()
@IsoDateTimeConverter()
class StockProduct extends BusinessDataItem {
  StockProduct({
    this.additionalInformation,
    this.externalProductValues,
    this.manageVariantStock = false,
    this.manageVariant = true,
    this.productOptionAttributes,
    this.unitOfMeasure,
    this.tags,
    this.imageUris,
    this.additionalBarcodes,
    this.autoGenerateSKU = false,
    this.createdBy,
    this.dateCreated,
    this.description,
    this.id,
    this.name,
    this.variances,
    this.unitType,
    this.enabled,
    this.categoryId,
    this.discountId,
    this.displayName,
    this.color,
    this.imageUri,
    this.taxId,
    this.currencyCode,
    this.shrinkage,
    this.isNew = false,
    this.productType = ProductType.physical,
    this.favourite = false,
    this.sku,
    this.isOnline = false,
    this.isStockTrackable = true,
    this.isInStore = true,
    this.parentId,
  }) : super(id: id, name: name, displayName: displayName) {
    variances ??= [];
  }

  StockProduct.create({String? businessId, String? id}) {
    autoGenerateSKU = false;
    discountId = '';
    enabled = true;
    deleted = false;
    this.businessId = businessId;
    this.id = id ?? const Uuid().v4();
    unitType = StockUnitType.byUnit;
    variances = [
      StockVariance(
        name: 'Regular',
        id: const Uuid().v4(),
        quantity: 0,
        type: StockVarianceType.regular,
      ),
    ];
    isNew = true;
    shrinkage = ProductShrinkage.create();
    productType = ProductType.physical;
    favourite = false;
    isOnline = false;
    isInStore = true;
    isStockTrackable = true;
    createdBy = AppVariables.store?.state.currentUser?.email;
    dateCreated = DateTime.now().toUtc();
    currencyCode =
        AppVariables.store?.state.localeState.currentLocale!.currencyCode;
    manageVariant = true;
  }

  factory StockProduct.fromCartItem(CheckoutItem item) => StockProduct(
    categoryId: '',
    discountId: '',
    color: null,
    currencyCode:
        AppVariables.store?.state.localeState.currentLocale!.currencyCode,
    displayName: item.name,
    name: cleanString(item.name),
    id: item.productId,
    isOnline: true,
    unitType: StockUnitType.byUnit,
    variances: [
      StockVariance(
        name: 'Regular',
        id: item.varianceId ?? item.productId,
        quantity: item.quantity,
        type: StockVarianceType.regular,
        costPrice: item.unitCostPrice,
        sellingPrice: item.unitSellingPrice,
        lowQuantityValue: 10,
      ),
    ],
  );

  factory StockProduct.fromOrderCartItem(OrderLineItem item) => StockProduct(
    categoryId: '',
    discountId: '',
    color: null,
    currencyCode:
        AppVariables.store?.state.localeState.currentLocale!.currencyCode,
    displayName: item.displayName,
    name: cleanString(item.displayName),
    id: item.productId,
    isOnline: true,
    unitType: StockUnitType.byUnit,
    variances: [
      StockVariance(
        name: 'Regular',
        id: item.productId,
        quantity: item.quantity,
        type: StockVarianceType.regular,
        costPrice: item.unitCost,
        sellingPrice: item.unitPrice,
        lowQuantityValue: 10,
      ),
    ],
  );

  factory StockProduct.clone({required StockProduct product}) => StockProduct(
    categoryId: product.categoryId,
    discountId: product.discountId,
    color: product.color,
    createdBy: product.createdBy,
    dateCreated: product.dateCreated,
    description: product.description,
    displayName: product.displayName,
    enabled: product.enabled,
    id: product.id,
    imageUri: product.imageUri,
    name: product.name,
    unitType: product.unitType,
    taxId: product.taxId,
    currencyCode: product.currencyCode,
    variances: product.variances!
        .map((v) => StockVariance.fromJson(v.toJson()))
        .toList(),
    isInStore: product.isInStore,
    manageVariant: product.manageVariant,
    manageVariantStock: product.manageVariantStock,
  )..cachedImageUri = product.cachedImageUri;

  StockProduct copyWith({
    String? additionalInformation,
    ExternalProductValues? externalProductValues,
    bool? manageVariantStock,
    bool? manageVariant,
    List<ProductOptionAttribute>? productOptionAttributes,
    String? unitOfMeasure,
    bool? isInStore,
    List<String>? tags,
    List<String>? imageUris,
    List<String>? additionalBarcodes,
    bool? autoGenerateSKU,
    String? categoryId,
    String? discountId,
    String? description,
    String? createdBy,
    String? name,
    DateTime? dateCreated,
    bool? enabled,
    String? id,
    String? displayName,
    String? color,
    String? currencyCode,
    bool? favourite,
    String? imageUri,
    bool? isNew,
    bool? isOnline,
    bool? isStockTrackable,
    ProductType? productType,
    ProductShrinkage? shrinkage,
    String? sku,
    String? taxId,
    StockUnitType? unitType,
    List<StockVariance>? variances,
    DateTime? dateUpdated,
    bool? deleted,
    String? deviceName,
    String? businessId,
    String? parentId,
  }) {
    return StockProduct(
        additionalInformation:
            additionalInformation ?? this.additionalInformation,
        manageVariantStock: manageVariantStock ?? this.manageVariantStock,
        manageVariant: manageVariant ?? this.manageVariant,
        productOptionAttributes:
            productOptionAttributes ?? this.productOptionAttributes,
        unitOfMeasure: unitOfMeasure ?? this.unitOfMeasure,
        isInStore: isInStore ?? this.isInStore,
        tags: tags ?? this.tags,
        imageUris: imageUris ?? this.imageUris,
        additionalBarcodes: additionalBarcodes ?? this.additionalBarcodes,
        autoGenerateSKU: autoGenerateSKU ?? this.autoGenerateSKU,
        categoryId: categoryId ?? this.categoryId,
        discountId: discountId ?? this.discountId,
        description: description ?? this.description,
        createdBy: createdBy ?? this.createdBy,
        name: name ?? this.name,
        dateCreated: dateCreated ?? this.dateCreated,
        enabled: enabled ?? this.enabled,
        id: id ?? this.id,
        displayName: displayName ?? this.displayName,
        color: color ?? this.color,
        currencyCode: currencyCode ?? this.currencyCode,
        favourite: favourite ?? this.favourite,
        imageUri: imageUri ?? this.imageUri,
        isNew: isNew ?? this.isNew,
        isOnline: isOnline ?? this.isOnline,
        isStockTrackable: isStockTrackable ?? this.isStockTrackable,
        productType: productType ?? this.productType,
        shrinkage: shrinkage ?? this.shrinkage,
        sku: sku ?? this.sku,
        taxId: taxId ?? this.taxId,
        unitType: unitType ?? this.unitType,
        variances: variances ?? this.variances,
        parentId: parentId ?? this.parentId,
      )
      ..dateCreated = dateCreated ?? this.dateCreated
      ..dateUpdated = dateUpdated ?? this.dateUpdated
      ..deleted = deleted ?? this.deleted
      ..deviceName = deviceName ?? this.deviceName
      ..businessId = businessId ?? this.businessId;
  }

  factory StockProduct.fromJson(Map<String, dynamic> json) =>
      _$StockProductFromJson(json);

  Map<String, dynamic> toJson() => _$StockProductToJson(this);

  @override
  @JsonKey(defaultValue: true)
  // removed ignore: overridden_fields
  bool? enabled;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? isNew;

  bool? isInStore;

  String? unitOfMeasure;

  ProductType? productType;

  @override
  @override
  @override
  @override
  // removed ignore: overridden_fields, override_on_non_overriding_member
  String? id, displayName, name, description, color, imageUri;

  String? sku;

  String? _cachedImageUri;

  bool? isOnline;

  String? parentId;

  bool? isStockTrackable;

  bool? autoGenerateSKU;

  List<String>? additionalBarcodes;

  List<String>? imageUris;

  List<String>? tags;

  List<ProductOptionAttribute>? productOptionAttributes;

  bool? manageVariant;

  bool? manageVariantStock;

  ExternalProductValues? externalProductValues;

  String? additionalInformation;
  // @JsonKey(defaultValue: <StoreLink>[])
  // List<StoreLink> storeLinks;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get isVariable => (regularPrice ?? 0.0) <= 0;

  @JsonKey(includeFromJson: false, includeToJson: false)
  String get shortDescription {
    if (displayName == null || displayName!.isEmpty) return '....';

    if (displayName!.length < 4) return displayName!.trim();

    return displayName!.substring(0, 4).trim();
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  int get markup {
    if (isVariable) return 0;

    return (100 *
            ((variances![0].sellingPrice! - variances![0].costPrice!) /
                variances![0].costPrice!))
        .round();
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  String? get cachedImageUri {
    if (_cachedImageUri == null &&
        FileSystemProvider.cacheDirectoryPath != null) {
      return _cachedImageUri =
          '${FileSystemProvider.cacheDirectoryPath}/products/$id';
    }
    return _cachedImageUri;
  }

  set cachedImageUri(String? value) {
    if (_cachedImageUri != value) {
      _cachedImageUri = value;
      // notifyListeners\(\);
    }
  }

  File? _image;

  @JsonKey(includeFromJson: false, includeToJson: false)
  File? get image {
    if (_image == null &&
        cachedImageUri != null &&
        cachedImageUri!.isNotEmpty &&
        File(cachedImageUri!).existsSync()) {
      _image = File(cachedImageUri!);
    }
    return _image;
  }

  set image(File? value) {
    if (_image != value) {
      _image = value;

      FileSystemProvider.instance
          .saveFile(category: 'products', file: value, name: id)
          .then((result) {
            if (result != null) cachedImageUri = result.path;
          });

      // notifyListeners\(\);
    }
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  Color get itemColor {
    if (color == null || color!.isEmpty) return Colors.blueAccent;

    return Color(int.parse(color!));
  }

  set itemColor(Color color) {
    if (color.value.toString() != this.color) {
      this.color = color.value.toString();
      // notifyListeners\(\);
    }
  }

  String? taxId;

  String? categoryId, discountId;

  @override
  // removed ignore: overridden_fields
  DateTime? dateCreated;

  String? currencyCode;

  @override
  // removed ignore: overridden_fields
  String? createdBy;

  StockUnitType? unitType;

  ProductShrinkage? shrinkage;

  @JsonKey(includeFromJson: false, includeToJson: false)
  StockVariance? get regularVariance {
    return variances?.first;
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  double? get regularPrice {
    return regularVariance?.sellingPrice;
  }

  set regularPrice(double? value) {
    if (regularVariance == null) {
      variances!.add(
        StockVariance(
          type: StockVarianceType.regular,
          sellingPrice: value,
          quantity: 0,
          costPrice: 0.0,
          name: 'Regular',
        ),
      );
    } else {
      regularVariance!.sellingPrice = value;
    }

    // notifyListeners\(\);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  double? get regularCostPrice {
    return regularVariance?.costPrice;
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  double? get regularSellingPrice {
    return regularVariance?.sellingPrice;
  }

  set regularCostPrice(double? value) {
    if (regularVariance == null) {
      variances!.add(
        StockVariance(
          type: StockVarianceType.regular,
          sellingPrice: 0.0,
          quantity: 0,
          costPrice: value,
          name: 'Regular',
        ),
      );
    } else {
      regularVariance!.costPrice = value;
    }
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  String? get regularBarCode {
    return regularVariance?.barcode;
  }

  set regularBarCode(String? value) {
    if (regularVariance == null) {
      variances!.add(
        StockVariance(
          type: StockVarianceType.regular,
          sellingPrice: 0.0,
          quantity: 0,
          costPrice: 0.0,
          name: 'Regular',
        )..barcode = value,
      );
    } else {
      regularVariance!.barcode = value;
    }
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  double get regularItemQuantity {
    return regularVariance?.quantity ?? 0;
  }

  set regularItemQuantity(double? value) {
    if (regularVariance == null) {
      variances!.add(
        StockVariance(
          type: StockVarianceType.regular,
          sellingPrice: 0.0,
          quantity: value,
          costPrice: 0.0,
          name: 'Regular',
        ),
      );
    } else {
      regularVariance!.quantity = value;
    }
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  int get priceCount {
    if (variances == null) return 0;

    return variances!.map((r) => r.sellingPrice ?? 0.0).toSet().toList().length;
  }

  double get quantity {
    if (variances == null) return 0.0;

    var qty = 0.0;

    for (var v in variances!) {
      qty += v.quantity!;
    }

    if (qty < 0) return 0.0;

    return qty;
  }

  List<StockVariance>? variances;

  @JsonKey(defaultValue: false)
  bool? favourite;

  bool isProduct(String barcode) {
    if (barcode.isEmpty) return false;

    return variances!.any((p) => p.barcode == barcode);
  }

  bool isProductByVarianceId(String id) {
    if (id.isEmpty) return false;

    return variances!.any((p) => p.id == id);
  }

  bool isProductById(String? id) {
    if (id == null || id.isEmpty) return false;

    return this.id == id;
  }

  StockVariance? getProductVariance(String barcode) {
    if (!isProduct(barcode)) return null;

    return variances?.firstWhere((v) => v.barcode == barcode);
  }

  StockVariance? getProductVarianceById(String id) {
    if (!isProduct(id)) return null;

    return variances?.firstWhereOrNull((v) => v.barcode == id);
  }

  Future<void> removeVariance(StockVariance item) async {
    variances?.removeWhere((v) => v.id == item.id);
    // notifyListeners\(\);
  }

  Future<void> addVariance(StockVariance item) async {
    if (variances!.any((v) => v.id == item.id)) {
      variances![variances!.indexWhere((v) => v.id == item.id)] = item;
    } else {
      variances!.add(item);
    }

    // notifyListeners\(\);
  }
}

@JsonSerializable()
class ProductShrinkage {
  ProductShrinkage(
    this.caseShrinkage,
    this.eighteenPackShrinkage,
    this.sixPackShrinkage,
    this.twelvePackShrinkage,
  );

  ProductShrinkage.create() {
    caseShrinkage = StockProductCasing(
      amount: 0.0,
      barcode: null,
      casingType: ProductCasingType.twentyFourPack,
    );

    eighteenPackShrinkage = StockProductCasing(
      amount: 0.0,
      barcode: null,
      casingType: ProductCasingType.eighteenPack,
    );

    twelvePackShrinkage = StockProductCasing(
      amount: 0.0,
      barcode: null,
      casingType: ProductCasingType.twelvePack,
    );

    sixPackShrinkage = StockProductCasing(
      amount: 0.0,
      barcode: null,
      casingType: ProductCasingType.sixPack,
    );
  }

  StockProductCasing? sixPackShrinkage,
      twelvePackShrinkage,
      eighteenPackShrinkage,
      caseShrinkage;

  factory ProductShrinkage.fromJson(Map<String, dynamic> json) =>
      _$ProductShrinkageFromJson(json);

  Map<String, dynamic> toJson() => _$ProductShrinkageToJson(this);
}

@JsonSerializable(explicitToJson: true)
@IsoDateTimeConverter()
class StockProductCasing {
  StockProductCasing({this.amount, this.barcode, required this.casingType});

  @JsonKey(
    toJson: ProductCasingTypeConverter.toJsonStatic,
    fromJson: ProductCasingTypeConverter.fromJsonStatic,
  )
  ProductCasingType casingType;

  String? barcode;

  double? amount;

  @override
  String toString() {
    switch (casingType) {
      case ProductCasingType.single:
        return 'Single Unit';
      case ProductCasingType.sixPack:
        return '6 Pack';
      case ProductCasingType.twelvePack:
        return '12 Pack';
      case ProductCasingType.eighteenPack:
        return '18 Pack';
      case ProductCasingType.twentyFourPack:
        return 'Case';
      default:
        return super.toString();
    }
  }

  factory StockProductCasing.fromJson(Map<String, dynamic> json) =>
      _$StockProductCasingFromJson(json);

  Map<String, dynamic> toJson() => _$StockProductCasingToJson(this);
}

enum StockUnitType {
  @JsonValue(0)
  byUnit,
  @JsonValue(1)
  byFraction,
}

class ProductCasingTypeConverter
    implements JsonConverter<ProductCasingType, int> {
  const ProductCasingTypeConverter();

  @override
  ProductCasingType fromJson(int? json) {
    if (json == 1) {
      return ProductCasingType.values[json! - 1];
    } else {
      return ProductCasingType.values[(json! / 6).floor()];
    }
  }

  @override
  int toJson(ProductCasingType object) {
    if (object.index == 0) return 1;

    return (object.index) * 6;
  }

  static ProductCasingType fromJsonStatic(int? json) {
    if (json == 1) {
      return ProductCasingType.values[json! - 1];
    } else {
      return ProductCasingType.values[(json! / 6).floor()];
    }
  }

  static int toJsonStatic(ProductCasingType object) {
    if (object.index == 0) return 1;

    return (object.index) * 6;
  }
}

enum ProductCasingType {
  single,
  sixPack,
  twelvePack,
  eighteenPack,
  twentyFourPack,
}

enum ProductType {
  @JsonValue(0)
  physical,
  @JsonValue(1)
  service,
}

@JsonSerializable(explicitToJson: true)
class ProductOptionAttribute {
  String? option;
  List<String>? attributes;

  ProductOptionAttribute({this.option, this.attributes});

  factory ProductOptionAttribute.fromJson(Map<String, dynamic> json) =>
      _$ProductOptionAttributeFromJson(json);
  Map<String, dynamic> toJson() => _$ProductOptionAttributeToJson(this);
}
