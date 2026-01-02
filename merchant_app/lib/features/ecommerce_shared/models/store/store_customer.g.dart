// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreCustomer _$StoreCustomerFromJson(Map<String, dynamic> json) =>
    StoreCustomer(
      averagePurchaseValue: (json['averagePurchaseValue'] as num?)?.toDouble(),
      businessId: json['businessId'] as String?,
      customerId: json['customerId'] as String?,
      email: json['email'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      mobileNumber: json['mobileNumber'] as String?,
      note: json['note'] as String?,
      ranking: $enumDecodeNullable(
        _$StoreCustomerRankingEnumMap,
        json['ranking'],
      ),
      totalPurchaseCount: (json['totalPurchaseCount'] as num?)?.toDouble(),
      totalPurchases: (json['totalPurchases'] as num?)?.toDouble(),
      uid: json['uid'] as String?,
      lastPurchaseDate: const EpochDateTimeConverter().fromJson(
        json['lastPurchaseDate'],
      ),
      deleted: json['deleted'] as bool? ?? false,
      dateCreated: const EpochDateTimeConverter().fromJson(json['dateCreated']),
      emails: (json['emails'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      jobTitle: json['jobTitle'] as String?,
      phones: (json['phones'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      prefix: json['prefix'] as String?,
      suffix: json['suffix'] as String?,
    )..displayName = json['displayName'] as String?;

Map<String, dynamic> _$StoreCustomerToJson(
  StoreCustomer instance,
) => <String, dynamic>{
  'displayName': instance.displayName,
  'businessId': instance.businessId,
  'customerId': instance.customerId,
  'uid': instance.uid,
  'note': instance.note,
  'email': instance.email,
  'prefix': instance.prefix,
  'suffix': instance.suffix,
  'jobTitle': instance.jobTitle,
  'emails': instance.emails,
  'mobileNumber': instance.mobileNumber,
  'phones': instance.phones,
  'firstName': instance.firstName,
  'deleted': instance.deleted,
  'lastName': instance.lastName,
  'totalPurchases': instance.totalPurchases,
  'totalPurchaseCount': instance.totalPurchaseCount,
  'lastPurchaseDate': const EpochDateTimeConverter().toJson(
    instance.lastPurchaseDate,
  ),
  'dateCreated': const EpochDateTimeConverter().toJson(instance.dateCreated),
  'averagePurchaseValue': instance.averagePurchaseValue,
  'ranking': _$StoreCustomerRankingEnumMap[instance.ranking],
};

const _$StoreCustomerRankingEnumMap = {
  StoreCustomerRanking.starter: 'starter',
  StoreCustomerRanking.visitor: 'visitor',
  StoreCustomerRanking.regular: 'regular',
  StoreCustomerRanking.ambassador: 'ambassador',
};

CustomerList _$CustomerListFromJson(Map<String, dynamic> json) => CustomerList(
  id: json['id'] as String?,
  name: json['name'] as String?,
  displayName: json['displayName'] as String?,
  dateCreated: const IsoDateTimeConverter().fromJson(json['dateCreated']),
  description: json['description'] as String?,
  searchName: json['searchName'] as String?,
  totalCustomers: (json['totalCustomers'] as num?)?.toInt() ?? 0,
  deleted: json['deleted'] as bool?,
);

Map<String, dynamic> _$CustomerListToJson(CustomerList instance) =>
    <String, dynamic>{
      'dateCreated': const IsoDateTimeConverter().toJson(instance.dateCreated),
      'id': instance.id,
      'name': instance.name,
      'displayName': instance.displayName,
      'searchName': instance.searchName,
      'description': instance.description,
      'deleted': instance.deleted,
      'totalCustomers': instance.totalCustomers,
    };

CustomerListLink _$CustomerListLinkFromJson(Map<String, dynamic> json) =>
    CustomerListLink(
      customerId: json['customerId'] as String?,
      listId: json['listId'] as String?,
      displayName: json['displayName'] as String?,
      dateCreated: const IsoDateTimeConverter().fromJson(json['dateCreated']),
    );

Map<String, dynamic> _$CustomerListLinkToJson(CustomerListLink instance) =>
    <String, dynamic>{
      'customerId': instance.customerId,
      'listId': instance.listId,
      'displayName': instance.displayName,
      'dateCreated': const IsoDateTimeConverter().toJson(instance.dateCreated),
    };
