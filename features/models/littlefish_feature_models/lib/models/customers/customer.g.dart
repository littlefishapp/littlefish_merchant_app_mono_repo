// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Customer _$CustomerFromJson(Map<String, dynamic> json) =>
    Customer(
        email: json['email'] as String?,
        firstName: json['firstName'] as String?,
        id: json['id'] as String?,
        lastName: json['lastName'] as String?,
        mobileNumber: json['mobileNumber'] as String?,
        internationalNumber: json['internationalNumber'] as String?,
        identityNumber: json['identityNumber'] as String?,
        notes: (json['notes'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList(),
        lastPurchaseDate: const IsoDateTimeConverter().fromJson(
          json['lastPurchaseDate'],
        ),
        averageSaleValue: (json['averageSaleValue'] as num?)?.toDouble() ?? 0,
        lastSaleValue: (json['lastSaleValue'] as num?)?.toDouble() ?? 0,
        totalSaleCount: (json['totalSaleCount'] as num?)?.toInt() ?? 0,
        totalSaleValue: (json['totalSaleValue'] as num?)?.toDouble() ?? 0,
        profileImageUri: json['profileImageUri'] as String?,
        address: json['address'] == null
            ? null
            : StoreAddress.fromJson(json['address'] as Map<String, dynamic>),
        creditBalance: (json['creditBalance'] as num?)?.toDouble() ?? 0,
        companyAddress: json['companyAddress'] == null
            ? null
            : StoreAddress.fromJson(
                json['companyAddress'] as Map<String, dynamic>,
              ),
        companyContactNumber: json['companyContactNumber'] as String?,
        companyName: json['companyName'] as String?,
        companyRegVatNumber: json['companyRegVatNumber'] as String?,
      )
      ..name = json['name'] as String?
      ..description = json['description'] as String?
      ..status = json['status'] as String?
      ..businessId = json['businessId'] as String?
      ..deviceName = json['deviceName'] as String?
      ..dateCreated = const IsoDateTimeConverter().fromJson(json['dateCreated'])
      ..dateUpdated = const IsoDateTimeConverter().fromJson(json['dateUpdated'])
      ..createdBy = json['createdBy'] as String?
      ..updatedBy = json['updatedBy'] as String?
      ..indexNo = (json['indexNo'] as num?)?.toInt()
      ..deleted = json['deleted'] as bool?
      ..enabled = json['enabled'] as bool?
      ..displayName = json['displayName'] as String?
      ..customerLedgerEntries =
          (json['customerLedgerEntries'] as List<dynamic>?)
              ?.map(
                (e) => CustomerLedgerEntry.fromJson(e as Map<String, dynamic>),
              )
              .toList()
      ..transactionHistory = (json['transactionHistory'] as List<dynamic>?)
          ?.map((e) => CheckoutTransaction.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
  'name': instance.name,
  'description': instance.description,
  'status': instance.status,
  'businessId': instance.businessId,
  'deviceName': instance.deviceName,
  'dateCreated': const IsoDateTimeConverter().toJson(instance.dateCreated),
  'dateUpdated': const IsoDateTimeConverter().toJson(instance.dateUpdated),
  'createdBy': instance.createdBy,
  'updatedBy': instance.updatedBy,
  'indexNo': instance.indexNo,
  'deleted': instance.deleted,
  'enabled': instance.enabled,
  'id': instance.id,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'displayName': instance.displayName,
  'profileImageUri': instance.profileImageUri,
  'identityNumber': instance.identityNumber,
  'mobileNumber': instance.mobileNumber,
  'internationalNumber': instance.internationalNumber,
  'email': instance.email,
  'lastSaleValue': instance.lastSaleValue,
  'totalSaleValue': instance.totalSaleValue,
  'averageSaleValue': instance.averageSaleValue,
  'creditBalance': instance.creditBalance,
  'totalSaleCount': instance.totalSaleCount,
  'lastPurchaseDate': const IsoDateTimeConverter().toJson(
    instance.lastPurchaseDate,
  ),
  'notes': instance.notes,
  'address': instance.address,
  'companyName': instance.companyName,
  'companyRegVatNumber': instance.companyRegVatNumber,
  'companyContactNumber': instance.companyContactNumber,
  'companyAddress': instance.companyAddress,
  'customerLedgerEntries': instance.customerLedgerEntries,
  'transactionHistory': instance.transactionHistory,
};

CustomerLedgerEntry _$CustomerLedgerEntryFromJson(Map<String, dynamic> json) =>
    CustomerLedgerEntry(
      entryType: json['entryType'] as String?,
      customerId: json['customerId'] as String?,
      addedBy: json['addedBy'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
      businessId: json['businessId'] as String?,
      dateAdded: json['dateAdded'] == null
          ? null
          : DateTime.parse(json['dateAdded'] as String),
      id: json['id'] as String?,
      transactionId: json['transactionId'] as String?,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$CustomerLedgerEntryToJson(
  CustomerLedgerEntry instance,
) => <String, dynamic>{
  'entryType': instance.entryType,
  'customerId': instance.customerId,
  'id': instance.id,
  'businessId': instance.businessId,
  'addedBy': instance.addedBy,
  'transactionId': instance.transactionId,
  'status': instance.status,
  'amount': instance.amount,
  'dateAdded': instance.dateAdded?.toIso8601String(),
};
