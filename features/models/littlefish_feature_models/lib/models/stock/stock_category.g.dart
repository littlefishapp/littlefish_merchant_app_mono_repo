// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockCategory _$StockCategoryFromJson(Map<String, dynamic> json) =>
    StockCategory(
        categoryColor: json['categoryColor'] as String?,
        imageUri: json['imageUri'] as String?,
        productCount: (json['productCount'] as num?)?.toInt() ?? 0,
        isOnline: json['isOnline'] as bool? ?? false,
        isFeatured: json['isFeatured'] as bool? ?? false,
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
      ..enabled = json['enabled'] as bool?;

Map<String, dynamic> _$StockCategoryToJson(StockCategory instance) =>
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
      'productCount': instance.productCount,
      'categoryColor': instance.categoryColor,
      'imageUri': instance.imageUri,
      'isOnline': instance.isOnline,
      'isFeatured': instance.isFeatured,
    };
