// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_combo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductCombo _$ProductComboFromJson(Map<String, dynamic> json) =>
    ProductCombo(
        barcode: json['barcode'] as String?,
        cachedImageUri: json['cachedImageUri'] as String?,
        categoryId: json['categoryId'] as String?,
        color: json['color'] as String?,
        currencyCode: json['currencyCode'] as String?,
        imageUri: json['imageUri'] as String?,
      )
      ..id = json['id'] as String?
      ..name = json['name'] as String?
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
      ..enabled = json['enabled'] as bool?
      ..items = (json['items'] as List<dynamic>?)
          ?.map((e) => ProductComboItem.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$ProductComboToJson(ProductCombo instance) =>
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
      'barcode': instance.barcode,
      'color': instance.color,
      'currencyCode': instance.currencyCode,
      'imageUri': instance.imageUri,
      'cachedImageUri': instance.cachedImageUri,
      'categoryId': instance.categoryId,
      'items': instance.items,
    };

ProductComboItem _$ProductComboItemFromJson(Map<String, dynamic> json) =>
    ProductComboItem(
      name: json['name'] as String?,
      comboPrice: (json['comboPrice'] as num?)?.toDouble(),
      costPrice: (json['costPrice'] as num?)?.toDouble(),
      discount: (json['discount'] as num?)?.toDouble(),
      productId: json['productId'] as String?,
      quantity: (json['quantity'] as num?)?.toDouble(),
      sellingPrice: (json['sellingPrice'] as num?)?.toDouble(),
      varianceId: json['varianceId'] as String?,
    );

Map<String, dynamic> _$ProductComboItemToJson(ProductComboItem instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'varianceId': instance.varianceId,
      'name': instance.name,
      'quantity': instance.quantity,
      'costPrice': instance.costPrice,
      'sellingPrice': instance.sellingPrice,
      'discount': instance.discount,
      'comboPrice': instance.comboPrice,
    };
