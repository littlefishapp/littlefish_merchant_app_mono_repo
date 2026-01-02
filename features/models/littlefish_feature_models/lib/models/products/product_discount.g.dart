// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_discount.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductDiscount _$ProductDiscountFromJson(Map<String, dynamic> json) =>
    ProductDiscount(
        isNew: json['isNew'] as bool? ?? false,
        maxValue: (json['maxValue'] as num?)?.toDouble() ?? 0.0,
        minValue: (json['minValue'] as num?)?.toDouble() ?? 0.0,
        type:
            _$JsonConverterFromJson<int, DiscountType>(
              json['type'],
              const DiscountTypeConverter().fromJson,
            ) ??
            DiscountType.fixedDiscountAmount,
        value: (json['value'] as num?)?.toDouble() ?? 0.0,
        products: (json['products'] as List<dynamic>?)
            ?.map((e) => StockProduct.fromJson(e as Map<String, dynamic>))
            .toList(),
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

Map<String, dynamic> _$ProductDiscountToJson(ProductDiscount instance) =>
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
      'isNew': instance.isNew,
      'value': instance.value,
      'maxValue': instance.maxValue,
      'minValue': instance.minValue,
      'type': _$JsonConverterToJson<int, DiscountType>(
        instance.type,
        const DiscountTypeConverter().toJson,
      ),
      'products': instance.products,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
