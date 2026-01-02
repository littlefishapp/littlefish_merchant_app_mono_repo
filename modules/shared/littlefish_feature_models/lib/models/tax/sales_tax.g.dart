// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_tax.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SalesTax _$SalesTaxFromJson(Map<String, dynamic> json) =>
    SalesTax(
        applyToCustomAmount: json['applyToCustomAmount'] as bool? ?? false,
        enabled: json['enabled'] as bool? ?? false,
        name: json['name'] as String?,
        percentage: (json['percentage'] as num?)?.toDouble() ?? 0,
        id: json['id'] as String?,
        taxPricingMode: $enumDecodeNullable(
          _$TaxPricingModeEnumMap,
          json['taxPricingMode'],
        ),
        businessId: json['businessId'] as String?,
        description: json['description'] as String?,
        vatRegistrationNumber: json['vatRegistrationNumber'] as String?,
        address: json['address'] == null
            ? null
            : Address.fromJson(json['address'] as Map<String, dynamic>),
      )
      ..status = json['status'] as String?
      ..displayName = json['displayName'] as String?
      ..deviceName = json['deviceName'] as String?
      ..dateCreated = const IsoDateTimeConverter().fromJson(json['dateCreated'])
      ..dateUpdated = const IsoDateTimeConverter().fromJson(json['dateUpdated'])
      ..createdBy = json['createdBy'] as String?
      ..updatedBy = json['updatedBy'] as String?
      ..indexNo = (json['indexNo'] as num?)?.toInt()
      ..deleted = json['deleted'] as bool?;

Map<String, dynamic> _$SalesTaxToJson(SalesTax instance) => <String, dynamic>{
  'status': instance.status,
  'displayName': instance.displayName,
  'deviceName': instance.deviceName,
  'dateCreated': const IsoDateTimeConverter().toJson(instance.dateCreated),
  'dateUpdated': const IsoDateTimeConverter().toJson(instance.dateUpdated),
  'createdBy': instance.createdBy,
  'updatedBy': instance.updatedBy,
  'indexNo': instance.indexNo,
  'deleted': instance.deleted,
  'businessId': instance.businessId,
  'id': instance.id,
  'enabled': instance.enabled,
  'applyToCustomAmount': instance.applyToCustomAmount,
  'name': instance.name,
  'description': instance.description,
  'percentage': instance.percentage,
  'taxPricingMode': _$TaxPricingModeEnumMap[instance.taxPricingMode],
  'vatRegistrationNumber': instance.vatRegistrationNumber,
  'address': instance.address,
};

const _$TaxPricingModeEnumMap = {
  TaxPricingMode.addToItem: 0,
  TaxPricingMode.alreadyIncluded: 1,
};
