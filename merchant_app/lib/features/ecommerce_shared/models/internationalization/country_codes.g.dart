// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country_codes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CountryCode _$CountryCodeFromJson(Map<String, dynamic> json) => CountryCode(
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

Map<String, dynamic> _$CountryCodeToJson(CountryCode instance) =>
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

CurrencyCode _$CurrencyCodeFromJson(Map<String, dynamic> json) => CurrencyCode(
  currencyCode: json['currencyCode'] as String?,
  decimalUnits: (json['decimalUnits'] as num?)?.toInt(),
  symbol: json['symbol'] as String?,
  symbolBeforeNumber: json['symbolBeforeNumber'] as bool?,
);

Map<String, dynamic> _$CurrencyCodeToJson(CurrencyCode instance) =>
    <String, dynamic>{
      'symbol': instance.symbol,
      'decimalUnits': instance.decimalUnits,
      'symbolBeforeNumber': instance.symbolBeforeNumber,
      'currencyCode': instance.currencyCode,
    };
