// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_run.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockRun _$StockRunFromJson(Map<String, dynamic> json) =>
    StockRun(
        capturerName: json['capturerName'] as String?,
        items: (json['entries'] as List<dynamic>?)
            ?.map((e) => StockTakeItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        runNumber: (json['runNumber'] as num?)?.toInt(),
        isNew: json['isNew'] as bool? ?? false,
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

Map<String, dynamic> _$StockRunToJson(StockRun instance) => <String, dynamic>{
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
  'capturerName': instance.capturerName,
  'runNumber': instance.runNumber,
  'entries': instance.items,
};
