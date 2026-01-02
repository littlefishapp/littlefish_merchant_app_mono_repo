// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country_stub.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CountryStub _$CountryStubFromJson(Map<String, dynamic> json) => CountryStub(
  countryName: json['countryName'] as String?,
  currencyCode: json['isoCurrencyCode'] as String?,
  diallingCode: json['diallingCode'] as String?,
  id: json['id'] as String?,
  minorCurrencyUnit: json['isoCurrencyMinorUnit'] as String?,
  shortCurrencyCode: json['shortCurrencyCode'] as String?,
  continent: json['continent'] as String?,
  countryCode: json['isoAlpha2'] as String?,
  countryCodeFull: json['isoAlpha3'] as String?,
  enabled: json['enabled'] as bool?,
);

Map<String, dynamic> _$CountryStubToJson(CountryStub instance) =>
    <String, dynamic>{
      'id': instance.id,
      'countryName': instance.countryName,
      'diallingCode': instance.diallingCode,
      'isoCurrencyCode': instance.currencyCode,
      'isoCurrencyMinorUnit': instance.minorCurrencyUnit,
      'shortCurrencyCode': instance.shortCurrencyCode,
      'continent': instance.continent,
      'isoAlpha2': instance.countryCode,
      'isoAlpha3': instance.countryCodeFull,
      'enabled': instance.enabled,
    };
