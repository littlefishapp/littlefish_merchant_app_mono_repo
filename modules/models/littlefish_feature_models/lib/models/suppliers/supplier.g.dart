// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplier.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Supplier _$SupplierFromJson(Map<String, dynamic> json) =>
    Supplier(
        address: json['address'] == null
            ? null
            : StoreAddress.fromJson(json['address'] as Map<String, dynamic>),
        contactDetails: json['contactDetails'] == null
            ? null
            : ContactDetail.fromJson(
                json['contactDetails'] as Map<String, dynamic>,
              ),
        contacts:
            (json['contacts'] as List<dynamic>?)
                ?.map((e) => Contact.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        taxNumber: json['taxNumber'] as String?,
        website: json['website'] as String?,
        products: (json['products'] as List<dynamic>?)
            ?.map((e) => SupplierProduct.fromJson(e as Map<String, dynamic>))
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

Map<String, dynamic> _$SupplierToJson(Supplier instance) => <String, dynamic>{
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
  'contactDetails': instance.contactDetails,
  'address': instance.address,
  'contacts': instance.contacts,
  'taxNumber': instance.taxNumber,
  'website': instance.website,
  'products': instance.products,
};

SupplierProduct _$SupplierProductFromJson(Map<String, dynamic> json) =>
    SupplierProduct(
      json['displayName'] as String?,
      json['productId'] as String?,
      json['varianceId'] as String?,
    );

Map<String, dynamic> _$SupplierProductToJson(SupplierProduct instance) =>
    <String, dynamic>{
      'displayName': instance.displayName,
      'productId': instance.productId,
      'varianceId': instance.varianceId,
    };
