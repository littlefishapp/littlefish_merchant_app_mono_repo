// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'billing_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BillingStoreInfo _$BillingStoreInfoFromJson(Map<String, dynamic> json) =>
    BillingStoreInfo(
      app: json['app'] as String?,
      businessId: json['businessId'] as String?,
      businessName: json['businessName'] as String?,
      country: json['country'] as String?,
      lastPaymentAmount: (json['lastPaymentAmount'] as num?)?.toDouble(),
      lastPaymentDate: const EpochDateTimeConverter().fromJson(
        json['lastPaymentDate'],
      ),
      currentLicense: json['currentLicense'] as String?,
      isPaid: json['isPaid'] as bool?,
      lastCheckedDate: const EpochDateTimeConverter().fromJson(
        json['lastCheckedDate'],
      ),
      overrideSubscription: json['overrideSubscription'] as bool? ?? false,
      syncedToRevenueCat: json['syncedToRevenueCat'] as bool? ?? false,
      validUntil: const EpochDateTimeConverter().fromJson(json['validUntil']),
      duration: $enumDecodeNullable(
        _$SubscriptionDurationEnumMap,
        json['duration'],
      ),
    );

Map<String, dynamic> _$BillingStoreInfoToJson(BillingStoreInfo instance) =>
    <String, dynamic>{
      'businessId': instance.businessId,
      'businessName': instance.businessName,
      'country': instance.country,
      'lastPaymentDate': const EpochDateTimeConverter().toJson(
        instance.lastPaymentDate,
      ),
      'lastCheckedDate': const EpochDateTimeConverter().toJson(
        instance.lastCheckedDate,
      ),
      'validUntil': const EpochDateTimeConverter().toJson(instance.validUntil),
      'lastPaymentAmount': instance.lastPaymentAmount,
      'app': instance.app,
      'currentLicense': instance.currentLicense,
      'isPaid': instance.isPaid,
      'overrideSubscription': instance.overrideSubscription,
      'syncedToRevenueCat': instance.syncedToRevenueCat,
      'duration': _$SubscriptionDurationEnumMap[instance.duration],
    };

const _$SubscriptionDurationEnumMap = {
  SubscriptionDuration.month: 'month',
  SubscriptionDuration.year: 'year',
};

BillingPaymentEntry _$BillingPaymentEntryFromJson(Map<String, dynamic> json) =>
    BillingPaymentEntry(
      app: json['app'] as String?,
      businessId: json['businessId'] as String?,
      businessName: json['businessName'] as String?,
      country: json['country'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
      paymentDate: const EpochDateTimeConverter().fromJson(json['paymentDate']),
      currentLicense: json['currentLicense'] as String?,
      paidBy: json['paidBy'] as String?,
      duration: $enumDecodeNullable(
        _$SubscriptionDurationEnumMap,
        json['duration'],
      ),
      isTrial: json['isTrial'] as bool?,
    );

Map<String, dynamic> _$BillingPaymentEntryToJson(
  BillingPaymentEntry instance,
) => <String, dynamic>{
  'businessId': instance.businessId,
  'businessName': instance.businessName,
  'country': instance.country,
  'paidBy': instance.paidBy,
  'paymentDate': const EpochDateTimeConverter().toJson(instance.paymentDate),
  'amount': instance.amount,
  'app': instance.app,
  'currentLicense': instance.currentLicense,
  'duration': _$SubscriptionDurationEnumMap[instance.duration],
  'isTrial': instance.isTrial,
};
