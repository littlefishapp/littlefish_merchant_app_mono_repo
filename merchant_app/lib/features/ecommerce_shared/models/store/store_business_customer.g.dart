// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_business_customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreBusinessCustomer _$StoreBusinessCustomerFromJson(
  Map<String, dynamic> json,
) => StoreBusinessCustomer(
  averagePurchaseValue: (json['averagePurchaseValue'] as num?)?.toDouble(),
  businessId: json['businessId'] as String?,
  email: json['email'] as String?,
  mobileNumber: json['mobileNumber'] as String?,
  note: json['note'] as String?,
  ranking: $enumDecodeNullable(_$StoreCustomerRankingEnumMap, json['ranking']),
  totalPurchaseCount: (json['totalPurchaseCount'] as num?)?.toDouble(),
  totalPurchases: (json['totalPurchases'] as num?)?.toDouble(),
  lastPurchaseDate: const EpochDateTimeConverter().fromJson(
    json['lastPurchaseDate'],
  ),
  deleted: json['deleted'] as bool? ?? false,
  dateCreated: const EpochDateTimeConverter().fromJson(json['dateCreated']),
  processedBy: json['processedBy'] == null
      ? null
      : StoreCustomer.fromJson(json['processedBy'] as Map<String, dynamic>),
  customerId: json['customerId'] as String?,
)..displayName = json['displayName'] as String?;

Map<String, dynamic> _$StoreBusinessCustomerToJson(
  StoreBusinessCustomer instance,
) => <String, dynamic>{
  'displayName': instance.displayName,
  'businessId': instance.businessId,
  'customerId': instance.customerId,
  'note': instance.note,
  'email': instance.email,
  'mobileNumber': instance.mobileNumber,
  'deleted': instance.deleted,
  'totalPurchases': instance.totalPurchases,
  'totalPurchaseCount': instance.totalPurchaseCount,
  'lastPurchaseDate': const EpochDateTimeConverter().toJson(
    instance.lastPurchaseDate,
  ),
  'dateCreated': const EpochDateTimeConverter().toJson(instance.dateCreated),
  'processedBy': instance.processedBy,
  'averagePurchaseValue': instance.averagePurchaseValue,
  'ranking': _$StoreCustomerRankingEnumMap[instance.ranking],
};

const _$StoreCustomerRankingEnumMap = {
  StoreCustomerRanking.starter: 'starter',
  StoreCustomerRanking.visitor: 'visitor',
  StoreCustomerRanking.regular: 'regular',
  StoreCustomerRanking.ambassador: 'ambassador',
};
