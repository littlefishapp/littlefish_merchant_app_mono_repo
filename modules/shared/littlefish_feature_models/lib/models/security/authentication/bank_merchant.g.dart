// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_merchant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BankMerchant _$BankMerchantFromJson(Map<String, dynamic> json) => BankMerchant(
  id: json['_id'] as String? ?? '',
  firstName: json['firstName'] as String?,
  surname: json['surname'] as String?,
  emailAddress: json['emailAddress'] as String?,
  mobileNumber: json['mobileNumber'] as String?,
  businessName: json['businessName'] as String?,
  mcc: json['mcc'] as String?,
  businessType: json['businessType'] == null
      ? null
      : BusinessType.fromJson(json['businessType'] as Map<String, dynamic>),
  addressLine1: json['addressLine1'] as String?,
  addressLine2: json['addressLine2'] as String?,
  country: json['country'] as String?,
  state: json['state'] as String?,
  postalCode: json['postalCode'] as String?,
  city: json['city'] as String?,
  gender:
      $enumDecodeNullable(_$GenderEnumMap, json['gender']) ??
      Gender.notSpecified,
  deviceSerialNumber: json['deviceSerialNumber'] as String?,
  merchantId: json['merchantId'] as String?,
  accountNumber: json['accountNumber'] as String?,
);

Map<String, dynamic> _$BankMerchantToJson(BankMerchant instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'firstName': instance.firstName,
      'surname': instance.surname,
      'emailAddress': instance.emailAddress,
      'mobileNumber': instance.mobileNumber,
      'businessName': instance.businessName,
      'businessType': instance.businessType,
      'gender': _$GenderEnumMap[instance.gender],
      'mcc': instance.mcc,
      'addressLine1': instance.addressLine1,
      'addressLine2': instance.addressLine2,
      'country': instance.country,
      'state': instance.state,
      'postalCode': instance.postalCode,
      'city': instance.city,
      'deviceSerialNumber': instance.deviceSerialNumber,
      'merchantId': instance.merchantId,
      'accountNumber': instance.accountNumber,
    };

const _$GenderEnumMap = {
  Gender.male: 0,
  Gender.female: 1,
  Gender.other: 2,
  Gender.notSpecified: 3,
};
