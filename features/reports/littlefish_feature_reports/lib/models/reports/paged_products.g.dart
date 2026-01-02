// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paged_products.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PagedProducts _$PagedProductsFromJson(Map<String, dynamic> json) =>
    PagedProducts(
      result: (json['result'] as List<dynamic>?)
          ?.map(
            (e) => ProductSingleVariance.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      count: (json['count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PagedProductsToJson(PagedProducts instance) =>
    <String, dynamic>{'count': instance.count, 'result': instance.result};

ProductSingleVariance _$ProductSingleVarianceFromJson(
  Map<String, dynamic> json,
) =>
    ProductSingleVariance(
        additionalBarcodes: (json['additionalBarcodes'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList(),
        productType: $enumDecodeNullable(
          _$ProductTypeEnumMap,
          json['productType'],
        ),
        barcode: json['barcode'] as String?,
        sku: json['sku'] as String?,
        color: json['color'] as String?,
        currencyCode: json['currencyCode'] as String?,
        favourite: json['favourite'] as bool?,
        imageUri: json['imageUri'] as String?,
        cachedImageUri: json['cachedImageUri'] as String?,
        taxId: json['taxId'] as String?,
        categoryId: json['categoryId'] as String?,
        unitType: $enumDecodeNullable(_$StockUnitTypeEnumMap, json['unitType']),
        variances: json['variances'] == null
            ? null
            : StockVariance.fromJson(json['variances'] as Map<String, dynamic>),
        shrinkage: json['shrinkage'] == null
            ? null
            : ProductShrinkage.fromJson(
                json['shrinkage'] as Map<String, dynamic>,
              ),
      )
      ..id = json['id'] as String?
      ..name = json['name'] as String?
      ..description = json['description'] as String?
      ..status = json['status'] as String?
      ..businessId = json['businessId'] as String?
      ..displayName = json['displayName'] as String?
      ..deviceName = json['deviceName'] as String?
      ..dateCreated = json['dateCreated'] == null
          ? null
          : DateTime.parse(json['dateCreated'] as String)
      ..dateUpdated = json['dateUpdated'] == null
          ? null
          : DateTime.parse(json['dateUpdated'] as String)
      ..createdBy = json['createdBy'] as String?
      ..updatedBy = json['updatedBy'] as String?
      ..indexNo = (json['indexNo'] as num?)?.toInt()
      ..deleted = json['deleted'] as bool?
      ..enabled = json['enabled'] as bool?;

Map<String, dynamic> _$ProductSingleVarianceToJson(
  ProductSingleVariance instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'status': instance.status,
  'businessId': instance.businessId,
  'displayName': instance.displayName,
  'deviceName': instance.deviceName,
  'dateCreated': instance.dateCreated?.toIso8601String(),
  'dateUpdated': instance.dateUpdated?.toIso8601String(),
  'createdBy': instance.createdBy,
  'updatedBy': instance.updatedBy,
  'indexNo': instance.indexNo,
  'deleted': instance.deleted,
  'enabled': instance.enabled,
  'productType': _$ProductTypeEnumMap[instance.productType],
  'barcode': instance.barcode,
  'sku': instance.sku,
  'additionalBarcodes': instance.additionalBarcodes,
  'color': instance.color,
  'currencyCode': instance.currencyCode,
  'favourite': instance.favourite,
  'imageUri': instance.imageUri,
  'cachedImageUri': instance.cachedImageUri,
  'taxId': instance.taxId,
  'categoryId': instance.categoryId,
  'unitType': _$StockUnitTypeEnumMap[instance.unitType],
  'variances': instance.variances,
  'shrinkage': instance.shrinkage,
};

const _$ProductTypeEnumMap = {ProductType.physical: 0, ProductType.service: 1};

const _$StockUnitTypeEnumMap = {
  StockUnitType.byUnit: 0,
  StockUnitType.byFraction: 1,
};
