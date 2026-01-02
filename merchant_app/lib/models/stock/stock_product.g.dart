// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockProduct _$StockProductFromJson(Map<String, dynamic> json) =>
    StockProduct(
        additionalInformation: json['additionalInformation'] as String?,
        externalProductValues: json['externalProductValues'] == null
            ? null
            : ExternalProductValues.fromJson(
                json['externalProductValues'] as Map<String, dynamic>,
              ),
        manageVariantStock: json['manageVariantStock'] as bool? ?? false,
        manageVariant: json['manageVariant'] as bool? ?? true,
        productOptionAttributes:
            (json['productOptionAttributes'] as List<dynamic>?)
                ?.map(
                  (e) => ProductOptionAttribute.fromJson(
                    e as Map<String, dynamic>,
                  ),
                )
                .toList(),
        unitOfMeasure: json['unitOfMeasure'] as String?,
        tags: (json['tags'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList(),
        imageUris: (json['imageUris'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList(),
        additionalBarcodes: (json['additionalBarcodes'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList(),
        autoGenerateSKU: json['autoGenerateSKU'] as bool? ?? false,
        createdBy: json['createdBy'] as String?,
        dateCreated: const IsoDateTimeConverter().fromJson(json['dateCreated']),
        description: json['description'] as String?,
        id: json['id'] as String?,
        name: json['name'] as String?,
        variances: (json['variances'] as List<dynamic>?)
            ?.map((e) => StockVariance.fromJson(e as Map<String, dynamic>))
            .toList(),
        unitType: $enumDecodeNullable(_$StockUnitTypeEnumMap, json['unitType']),
        enabled: json['enabled'] as bool? ?? true,
        categoryId: json['categoryId'] as String?,
        discountId: json['discountId'] as String?,
        displayName: json['displayName'] as String?,
        color: json['color'] as String?,
        imageUri: json['imageUri'] as String?,
        taxId: json['taxId'] as String?,
        currencyCode: json['currencyCode'] as String?,
        shrinkage: json['shrinkage'] == null
            ? null
            : ProductShrinkage.fromJson(
                json['shrinkage'] as Map<String, dynamic>,
              ),
        productType:
            $enumDecodeNullable(_$ProductTypeEnumMap, json['productType']) ??
            ProductType.physical,
        favourite: json['favourite'] as bool? ?? false,
        sku: json['sku'] as String?,
        isOnline: json['isOnline'] as bool? ?? false,
        isStockTrackable: json['isStockTrackable'] as bool? ?? true,
        isInStore: json['isInStore'] as bool? ?? true,
        parentId: json['parentId'] as String?,
      )
      ..status = json['status'] as String?
      ..businessId = json['businessId'] as String?
      ..deviceName = json['deviceName'] as String?
      ..dateUpdated = const IsoDateTimeConverter().fromJson(json['dateUpdated'])
      ..updatedBy = json['updatedBy'] as String?
      ..indexNo = (json['indexNo'] as num?)?.toInt()
      ..deleted = json['deleted'] as bool?;

Map<String, dynamic> _$StockProductToJson(StockProduct instance) =>
    <String, dynamic>{
      'status': instance.status,
      'businessId': instance.businessId,
      'deviceName': instance.deviceName,
      'dateUpdated': const IsoDateTimeConverter().toJson(instance.dateUpdated),
      'updatedBy': instance.updatedBy,
      'indexNo': instance.indexNo,
      'deleted': instance.deleted,
      'enabled': instance.enabled,
      'isInStore': instance.isInStore,
      'unitOfMeasure': instance.unitOfMeasure,
      'productType': _$ProductTypeEnumMap[instance.productType],
      'id': instance.id,
      'displayName': instance.displayName,
      'name': instance.name,
      'description': instance.description,
      'color': instance.color,
      'imageUri': instance.imageUri,
      'sku': instance.sku,
      'isOnline': instance.isOnline,
      'parentId': instance.parentId,
      'isStockTrackable': instance.isStockTrackable,
      'autoGenerateSKU': instance.autoGenerateSKU,
      'additionalBarcodes': instance.additionalBarcodes,
      'imageUris': instance.imageUris,
      'tags': instance.tags,
      'productOptionAttributes': instance.productOptionAttributes,
      'manageVariant': instance.manageVariant,
      'manageVariantStock': instance.manageVariantStock,
      'externalProductValues': instance.externalProductValues,
      'additionalInformation': instance.additionalInformation,
      'taxId': instance.taxId,
      'categoryId': instance.categoryId,
      'discountId': instance.discountId,
      'dateCreated': const IsoDateTimeConverter().toJson(instance.dateCreated),
      'currencyCode': instance.currencyCode,
      'createdBy': instance.createdBy,
      'unitType': _$StockUnitTypeEnumMap[instance.unitType],
      'shrinkage': instance.shrinkage,
      'variances': instance.variances,
      'favourite': instance.favourite,
    };

const _$StockUnitTypeEnumMap = {
  StockUnitType.byUnit: 0,
  StockUnitType.byFraction: 1,
};

const _$ProductTypeEnumMap = {ProductType.physical: 0, ProductType.service: 1};

ProductShrinkage _$ProductShrinkageFromJson(Map<String, dynamic> json) =>
    ProductShrinkage(
      json['caseShrinkage'] == null
          ? null
          : StockProductCasing.fromJson(
              json['caseShrinkage'] as Map<String, dynamic>,
            ),
      json['eighteenPackShrinkage'] == null
          ? null
          : StockProductCasing.fromJson(
              json['eighteenPackShrinkage'] as Map<String, dynamic>,
            ),
      json['sixPackShrinkage'] == null
          ? null
          : StockProductCasing.fromJson(
              json['sixPackShrinkage'] as Map<String, dynamic>,
            ),
      json['twelvePackShrinkage'] == null
          ? null
          : StockProductCasing.fromJson(
              json['twelvePackShrinkage'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$ProductShrinkageToJson(ProductShrinkage instance) =>
    <String, dynamic>{
      'sixPackShrinkage': instance.sixPackShrinkage,
      'twelvePackShrinkage': instance.twelvePackShrinkage,
      'eighteenPackShrinkage': instance.eighteenPackShrinkage,
      'caseShrinkage': instance.caseShrinkage,
    };

StockProductCasing _$StockProductCasingFromJson(Map<String, dynamic> json) =>
    StockProductCasing(
      amount: (json['amount'] as num?)?.toDouble(),
      barcode: json['barcode'] as String?,
      casingType: ProductCasingTypeConverter.fromJsonStatic(
        (json['casingType'] as num?)?.toInt(),
      ),
    );

Map<String, dynamic> _$StockProductCasingToJson(
  StockProductCasing instance,
) => <String, dynamic>{
  'casingType': ProductCasingTypeConverter.toJsonStatic(instance.casingType),
  'barcode': instance.barcode,
  'amount': instance.amount,
};

ProductOptionAttribute _$ProductOptionAttributeFromJson(
  Map<String, dynamic> json,
) => ProductOptionAttribute(
  option: json['option'] as String?,
  attributes: (json['attributes'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$ProductOptionAttributeToJson(
  ProductOptionAttribute instance,
) => <String, dynamic>{
  'option': instance.option,
  'attributes': instance.attributes,
};
