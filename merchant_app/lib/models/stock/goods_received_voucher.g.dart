// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goods_received_voucher.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoodsRecievedVoucher _$GoodsRecievedVoucherFromJson(
  Map<String, dynamic> json,
) =>
    GoodsRecievedVoucher(
        dateReceived: const IsoDateTimeConverter().fromJson(
          json['dateReceived'],
        ),
        deliveredBy: json['deliveredBy'] as String?,
        invoiceAmount: (json['invoiceAmount'] as num?)?.toDouble(),
        invoiceId: json['invoiceId'] as String?,
        invoiceReference: json['invoiceReference'] as String?,
        isNew: json['isNew'] as bool? ?? false,
        items: (json['items'] as List<dynamic>?)
            ?.map((e) => GoodsRecievedItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        notes: (json['notes'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList(),
        receivedBy: json['receivedBy'] as String?,
        supplierId: json['supplierId'] as String?,
        supplierName: json['supplierName'] as String?,
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
      ..receivablesValue = (json['receivablesValue'] as num).toDouble();

Map<String, dynamic> _$GoodsRecievedVoucherToJson(
  GoodsRecievedVoucher instance,
) => <String, dynamic>{
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
  'supplierId': instance.supplierId,
  'supplierName': instance.supplierName,
  'invoiceId': instance.invoiceId,
  'invoiceReference': instance.invoiceReference,
  'invoiceAmount': instance.invoiceAmount,
  'receivablesValue': instance.receivablesValue,
  'dateReceived': const IsoDateTimeConverter().toJson(instance.dateReceived),
  'receivedBy': instance.receivedBy,
  'deliveredBy': instance.deliveredBy,
  'notes': instance.notes,
  'items': instance.items,
};

GoodsRecievedItem _$GoodsRecievedItemFromJson(Map<String, dynamic> json) =>
    GoodsRecievedItem(
        packUnitQuantity: (json['packUnitQuantity'] as num?)?.toDouble() ?? 1.0,
        taxInclusive: json['taxInclusive'] as bool? ?? true,
      )
      ..productName = json['productName'] as String?
      ..productId = json['productId'] as String?
      ..variantName = json['variantName'] as String?
      ..variantId = json['variantId'] as String?
      ..byUnit = json['byUnit'] as bool?
      ..currentUnitCost = (json['currentUnitCost'] as num?)?.toDouble()
      ..currentUnitCount = (json['currentUnitCount'] as num?)?.toDouble()
      ..packCost = (json['packCost'] as num?)?.toDouble()
      ..packTax = (json['packTax'] as num?)?.toDouble()
      ..packQuantity = (json['packQuantity'] as num?)?.toDouble()
      ..totalUnits = (json['totalUnits'] as num).toDouble()
      ..totalUnitCost = (json['totalUnitCost'] as num).toDouble()
      ..unitCost = (json['unitCost'] as num).toDouble()
      ..unitTax = (json['unitTax'] as num).toDouble();

Map<String, dynamic> _$GoodsRecievedItemToJson(GoodsRecievedItem instance) =>
    <String, dynamic>{
      'productName': instance.productName,
      'productId': instance.productId,
      'variantName': instance.variantName,
      'variantId': instance.variantId,
      'byUnit': instance.byUnit,
      'taxInclusive': instance.taxInclusive,
      'currentUnitCost': instance.currentUnitCost,
      'currentUnitCount': instance.currentUnitCount,
      'packCost': instance.packCost,
      'packTax': instance.packTax,
      'packQuantity': instance.packQuantity,
      'packUnitQuantity': instance.packUnitQuantity,
      'totalUnits': instance.totalUnits,
      'totalUnitCost': instance.totalUnitCost,
      'unitCost': instance.unitCost,
      'unitTax': instance.unitTax,
    };
