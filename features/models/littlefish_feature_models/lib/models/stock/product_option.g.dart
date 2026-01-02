// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_option.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductOption _$ProductOptionFromJson(Map<String, dynamic> json) =>
    ProductOption(
        id: json['id'] as String?,
        name: json['name'] as String?,
        parentProductId: json['parentProductId'] as String? ?? '',
        barcode: json['barcode'] as String? ?? '',
        sku: json['sku'] as String? ?? '',
        additionalBarcodes: (json['additionalBarcodes'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList(),
        color: json['color'] as String? ?? '',
        currencyCode: json['currencyCode'] as String? ?? '',
        favourite: json['favourite'] as bool? ?? false,
        imageUri: json['imageUri'] as String? ?? '',
        taxId: json['taxId'] as String? ?? '',
        categoryId: json['categoryId'] as String? ?? '',
        unitType: $enumDecodeNullable(_$StockUnitTypeEnumMap, json['unitType']),
        variances: (json['variances'] as List<dynamic>?)
            ?.map((e) => StockVariance.fromJson(e as Map<String, dynamic>))
            .toList(),
        shrinkage: json['shrinkage'] == null
            ? null
            : ProductShrinkage.fromJson(
                json['shrinkage'] as Map<String, dynamic>,
              ),
        isOnline: json['isOnline'] as bool? ?? false,
        isStockTrackable: json['isStockTrackable'] as bool? ?? false,
        unitOfMeasure: json['unitOfMeasure'] as String? ?? '',
        quantity: (json['quantity'] as num?)?.toInt() ?? 0,
        attributeCombinations: (json['attributeCombinations'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList(),
        autoGenerateSKU: json['autoGenerateSKU'] as bool? ?? false,
        productType: $enumDecodeNullable(
          _$ProductTypeEnumMap,
          json['productType'],
        ),
      )
      ..description = json['description'] as String?
      ..status = json['status'] as String?
      ..businessId = json['businessId'] as String?
      ..displayName = json['displayName'] as String?
      ..deviceName = json['deviceName'] as String?
      ..dateCreated = const IsoDateTimeConverter().fromJson(json['dateCreated'])
      ..dateUpdated = const IsoDateTimeConverter().fromJson(json['dateUpdated'])
      ..createdBy = json['createdBy'] as String?
      ..updatedBy = json['updatedBy'] as String?
      ..indexNo = (json['indexNo'] as num?)?.toInt()
      ..deleted = json['deleted'] as bool?
      ..enabled = json['enabled'] as bool?;

Map<String, dynamic> _$ProductOptionToJson(ProductOption instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'status': instance.status,
      'businessId': instance.businessId,
      'displayName': instance.displayName,
      'deviceName': instance.deviceName,
      'dateCreated': const IsoDateTimeConverter().toJson(instance.dateCreated),
      'dateUpdated': const IsoDateTimeConverter().toJson(instance.dateUpdated),
      'createdBy': instance.createdBy,
      'updatedBy': instance.updatedBy,
      'indexNo': instance.indexNo,
      'deleted': instance.deleted,
      'enabled': instance.enabled,
      'parentProductId': instance.parentProductId,
      'barcode': instance.barcode,
      'sku': instance.sku,
      'additionalBarcodes': instance.additionalBarcodes,
      'color': instance.color,
      'currencyCode': instance.currencyCode,
      'favourite': instance.favourite,
      'imageUri': instance.imageUri,
      'taxId': instance.taxId,
      'categoryId': instance.categoryId,
      'unitType': _$StockUnitTypeEnumMap[instance.unitType],
      'variances': instance.variances,
      'shrinkage': instance.shrinkage,
      'isOnline': instance.isOnline,
      'isStockTrackable': instance.isStockTrackable,
      'unitOfMeasure': instance.unitOfMeasure,
      'quantity': instance.quantity,
      'attributeCombinations': instance.attributeCombinations,
      'autoGenerateSKU': instance.autoGenerateSKU,
      'productType': _$ProductTypeEnumMap[instance.productType],
    };

const _$StockUnitTypeEnumMap = {
  StockUnitType.byUnit: 0,
  StockUnitType.byFraction: 1,
};

const _$ProductTypeEnumMap = {ProductType.physical: 0, ProductType.service: 1};
