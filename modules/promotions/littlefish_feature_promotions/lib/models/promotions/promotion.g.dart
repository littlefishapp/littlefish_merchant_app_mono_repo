// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promotion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Promotion _$PromotionFromJson(Map<String, dynamic> json) =>
    Promotion(
        endDate: const IsoDateTimeConverter().fromJson(json['endDate']),
        items:
            (json['items'] as List<dynamic>?)
                ?.map((e) => PromotionItem.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        startDate: const IsoDateTimeConverter().fromJson(json['startDate']),
        totalCost: (json['costPrice'] as num?)?.toDouble() ?? 0,
        totalValue: (json['sellingPrice'] as num?)?.toDouble() ?? 0,
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

Map<String, dynamic> _$PromotionToJson(Promotion instance) => <String, dynamic>{
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
  'startDate': const IsoDateTimeConverter().toJson(instance.startDate),
  'endDate': const IsoDateTimeConverter().toJson(instance.endDate),
  'costPrice': instance.totalCost,
  'sellingPrice': instance.totalValue,
  'items': instance.items,
};
