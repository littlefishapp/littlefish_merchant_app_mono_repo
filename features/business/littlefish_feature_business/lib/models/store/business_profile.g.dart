// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusinessProfile _$BusinessProfileFromJson(Map<String, dynamic> json) =>
    BusinessProfile(
      category: json['category'] == null
          ? null
          : BusinessType.fromJson(json['category'] as Map<String, dynamic>),
      description: json['description'] as String?,
      id: json['id'] as String?,
      name: json['name'] as String?,
      parentId: json['parentId'] as String?,
      type: json['type'] == null
          ? null
          : BusinessType.fromJson(json['type'] as Map<String, dynamic>),
      countryCode: json['countryCode'] as String?,
      values: json['values'] as Map<String, dynamic>?,
      address: json['address'] == null
          ? null
          : Address.fromJson(json['address'] as Map<String, dynamic>),
      receiptData: json['receiptData'] == null
          ? null
          : ReceiptData.fromJson(json['receiptData'] as Map<String, dynamic>),
      contacts:
          (json['contacts'] as List<dynamic>?)
              ?.map((e) => Contact.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      contactDetails: json['contactDetail'] == null
          ? null
          : ContactDetail.fromJson(
              json['contactDetail'] as Map<String, dynamic>,
            ),
      logoUri: json['logoUri'] as String?,
      linkedAccounts: (json['linkedAccounts'] as List<dynamic>?)
          ?.map((e) => LinkedAccount.fromJson(e as Map<String, dynamic>))
          .toList(),
      taxNumber: json['taxNumber'] as String?,
      tradingTime: json['tradingTime'] == null
          ? null
          : TradingTime.fromJson(json['tradingTime'] as Map<String, dynamic>),
      dateEstablished: const IsoDateTimeConverter().fromJson(
        json['dateEstablished'],
      ),
      coverUri: json['coverUri'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      businessEmail: json['businessEmail'] as String?,
      whatsappLine: json['whatsappLine'] as String?,
      website: json['website'] as String?,
      instagramHandle: json['instagramHandle'] as String?,
      facebook: json['facebook'] as String?,
      twitter: json['twitter'] as String?,
      salesChannels: (json['salesChannels'] as List<dynamic>?)
          ?.map((e) => SalesChannel.fromJson(e as Map<String, dynamic>))
          .toList(),
      storeCreditSettings: json['storeCreditSettings'] == null
          ? null
          : StoreCreditSettings.fromJson(
              json['storeCreditSettings'] as Map<String, dynamic>,
            ),
      registrationNumber: json['registrationNumber'] as String?,
      masterMerchantId: json['masterMerchantId'] as String?,
      mcc: json['mcc'] as String?,
      vatEnabled: json['vatEnabled'] as bool?,
      vatBillingAddress: json['vatBillingAddress'] == null
          ? null
          : Address.fromJson(json['vatBillingAddress'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BusinessProfileToJson(
  BusinessProfile instance,
) => <String, dynamic>{
  'id': instance.id,
  'parentId': instance.parentId,
  'name': instance.name,
  'description': instance.description,
  'countryCode': instance.countryCode,
  'type': instance.type?.toJson(),
  'category': instance.category?.toJson(),
  'values': instance.values,
  'address': instance.address?.toJson(),
  'vatBillingAddress': instance.vatBillingAddress?.toJson(),
  'whatsappLine': instance.whatsappLine,
  'instagramHandle': instance.instagramHandle,
  'storeCreditSettings': instance.storeCreditSettings?.toJson(),
  'logoUri': instance.logoUri,
  'businessEmail': instance.businessEmail,
  'facebook': instance.facebook,
  'twitter': instance.twitter,
  'phoneNumber': instance.phoneNumber,
  'website': instance.website,
  'masterMerchantId': instance.masterMerchantId,
  'taxNumber': instance.taxNumber,
  'vatEnabled': instance.vatEnabled,
  'mcc': instance.mcc,
  'registrationNumber': instance.registrationNumber,
  'receiptData': instance.receiptData?.toJson(),
  'contactDetail': instance.contactDetails?.toJson(),
  'tradingTime': instance.tradingTime?.toJson(),
  'coverUri': instance.coverUri,
  'dateEstablished': const IsoDateTimeConverter().toJson(
    instance.dateEstablished,
  ),
  'linkedAccounts': instance.linkedAccounts?.map((e) => e.toJson()).toList(),
  'salesChannels': instance.salesChannels?.map((e) => e.toJson()).toList(),
  'contacts': instance.contacts?.map((e) => e.toJson()).toList(),
};

TradingHours _$TradingHoursFromJson(Map<String, dynamic> json) => TradingHours(
  open: json['open'] as String?,
  close: json['close'] as String?,
);

Map<String, dynamic> _$TradingHoursToJson(TradingHours instance) =>
    <String, dynamic>{'open': instance.open, 'close': instance.close};

TradingTime _$TradingTimeFromJson(Map<String, dynamic> json) => TradingTime(
  publicHoliday: json['publicHoliday'] == null
      ? null
      : TradingHours.fromJson(json['publicHoliday'] as Map<String, dynamic>),
  saturday: json['saturday'] == null
      ? null
      : TradingHours.fromJson(json['saturday'] as Map<String, dynamic>),
  sunday: json['sunday'] == null
      ? null
      : TradingHours.fromJson(json['sunday'] as Map<String, dynamic>),
  weekday: json['weekday'] == null
      ? null
      : TradingHours.fromJson(json['weekday'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TradingTimeToJson(TradingTime instance) =>
    <String, dynamic>{
      'weekday': instance.weekday,
      'saturday': instance.saturday,
      'sunday': instance.sunday,
      'publicHoliday': instance.publicHoliday,
    };

StoreCreditSettings _$StoreCreditSettingsFromJson(Map<String, dynamic> json) =>
    StoreCreditSettings(
      businessId: json['businessId'] as String?,
      creditLimit: (json['creditLimit'] as num?)?.toDouble(),
      dateUpdated: const IsoDateTimeConverter().fromJson(json['dateUpdated']),
      enabled: json['enabled'] as bool?,
      interestRate: (json['interestRate'] as num?)?.toDouble(),
      repaymentPeriod: json['repaymentPeriod'] as String?,
      updatedBy: json['updatedBy'] as String?,
      enableInterest: json['enableInterest'] as bool?,
    );

Map<String, dynamic> _$StoreCreditSettingsToJson(
  StoreCreditSettings instance,
) => <String, dynamic>{
  'enabled': instance.enabled,
  'enableInterest': instance.enableInterest,
  'dateUpdated': const IsoDateTimeConverter().toJson(instance.dateUpdated),
  'repaymentPeriod': instance.repaymentPeriod,
  'businessId': instance.businessId,
  'updatedBy': instance.updatedBy,
  'interestRate': instance.interestRate,
  'creditLimit': instance.creditLimit,
};
