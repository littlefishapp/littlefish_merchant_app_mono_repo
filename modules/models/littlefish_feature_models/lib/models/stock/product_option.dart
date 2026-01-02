import 'package:json_annotation/json_annotation.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/models/shared/simple_data_item.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/models/stock/stock_variance.dart';
import 'package:littlefish_merchant/tools/converters/iso_date_time_converter.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:littlefish_merchant/tools/helpers/sku_generator.dart';
import 'package:quiver/strings.dart';
import 'package:uuid/uuid.dart';

part 'product_option.g.dart';

@JsonSerializable()
@IsoDateTimeConverter()
class ProductOption extends BusinessDataItem {
  String parentProductId;
  String barcode;
  String sku;
  List<String> additionalBarcodes;
  String color;
  String currencyCode;
  bool favourite;
  String imageUri;
  String taxId;
  String categoryId;
  StockUnitType? unitType;
  List<StockVariance> variances;
  ProductShrinkage? shrinkage;
  bool isOnline;
  bool isStockTrackable;
  String unitOfMeasure;
  int quantity;
  List<String>? attributeCombinations;
  bool autoGenerateSKU;
  ProductType? productType;

  ProductOption({
    String? id,
    String? name,
    this.parentProductId = '',
    this.barcode = '',
    this.sku = '',
    List<String>? additionalBarcodes,
    this.color = '',
    this.currencyCode = '',
    this.favourite = false,
    this.imageUri = '',
    this.taxId = '',
    this.categoryId = '',
    this.unitType,
    List<StockVariance>? variances,
    this.shrinkage,
    this.isOnline = false,
    this.isStockTrackable = false,
    this.unitOfMeasure = '',
    this.quantity = 0,
    this.attributeCombinations,
    this.autoGenerateSKU = false,
    this.productType,
  }) : additionalBarcodes = additionalBarcodes ?? const [],
       variances = variances ?? const [],
       super(id: id, name: name);

  factory ProductOption.fromJson(Map<String, dynamic> json) =>
      _$ProductOptionFromJson(json);

  Map<String, dynamic> toJson() => _$ProductOptionToJson(this);

  factory ProductOption.fromStockProduct({
    required StockProduct product,
    required String name,
    bool isVariantStockTrackable = false,
  }) {
    final option = ProductOption(
      id: const Uuid().v4(),
      name: cleanString(name),
      parentProductId: product.id ?? '',
      barcode: product.regularBarCode ?? '',
      sku: SkuGenerator.generateSKU(),
      additionalBarcodes: const [],
      color: product.color ?? '',
      favourite: product.favourite ?? false,
      imageUri: '',
      taxId: product.taxId ?? '',
      categoryId: product.categoryId ?? '',
      unitType: product.unitType,
      variances:
          product.variances
              ?.map((stockVariance) => stockVariance.copyWith())
              .toList() ??
          [],
      shrinkage: product.shrinkage,
      isOnline: product.isOnline ?? false,
      isStockTrackable: isVariantStockTrackable,
      unitOfMeasure: product.unitOfMeasure ?? '',
      quantity: product.quantity.toInt(),
      attributeCombinations: null,

      /// DEPRECATED: DO NOT USE attributeCombinations
      autoGenerateSKU: product.autoGenerateSKU ?? true,
      productType: product.productType,
    );
    option.displayName = name;
    option.businessId = product.businessId;
    option.createdBy = AppVariables.store?.state.currentUser?.email;
    option.dateCreated = DateTime.now().toUtc();
    option.dateUpdated = DateTime.now().toUtc();
    option.deleted = product.deleted;
    option.description = product.description;
    option.status = product.status;
    option.updatedBy = AppVariables.store?.state.currentUser?.email;
    option.enabled = product.enabled;
    option.indexNo = product.indexNo;
    option.deviceName = product.deviceName;
    option.currencyCode =
        product.currencyCode ??
        AppVariables.store?.state.localeState.currentLocale!.currencyCode ??
        '';
    return option;
  }

  bool isProduct(String barcode) {
    bool stockVarianceHasBarcode = variances.any((v) => v.barcode == barcode);
    if (barcode == this.barcode || stockVarianceHasBarcode) {
      return true;
    }
    return false;
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  StockVariance? get regularVariance {
    if (variances.isEmpty) return null;
    return variances.first;
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  double? get regularPrice {
    return regularVariance?.sellingPrice;
  }

  set regularPrice(double? value) {
    if (regularVariance == null) {
      variances.add(
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
      variances.add(
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
    if (isNotBlank(regularVariance?.barcode)) {
      return regularVariance?.barcode;
    }
    if (barcode.isNotEmpty) {
      return barcode;
    }
    return null;
  }

  set regularBarCode(String? value) {
    barcode = value ?? '';
    if (regularVariance == null) {
      variances.add(
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
      variances.add(
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
}
