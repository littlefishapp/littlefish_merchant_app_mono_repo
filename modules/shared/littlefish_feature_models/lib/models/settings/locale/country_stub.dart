// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import 'package:littlefish_merchant/tools/converters/iso_date_time_converter.dart';
import 'package:littlefish_merchant/tools/parsers.dart';

part 'country_stub.g.dart';

@JsonSerializable()
@IsoDateTimeConverter()
class CountryStub with ChangeNotifier {
  CountryStub({
    this.countryName,
    this.currencyCode,
    this.diallingCode,
    this.id,
    this.minorCurrencyUnit,
    this.shortCurrencyCode,
    this.continent,
    this.countryCode,
    this.countryCodeFull,
    this.enabled,
  });

  String? id;

  String? countryName;

  String? diallingCode;

  @JsonKey(name: 'isoCurrencyCode')
  String? currencyCode;

  int get minCurrencyUnit =>
      minorCurrencyUnit == null ? 0 : toInt(minorCurrencyUnit);

  @JsonKey(name: 'isoCurrencyMinorUnit')
  String? minorCurrencyUnit;

  String? shortCurrencyCode;

  String? continent;

  String? get continentName => getContinentName();

  @JsonKey(name: 'isoAlpha2')
  String? countryCode;

  @JsonKey(name: 'isoAlpha3')
  String? countryCodeFull;

  bool? enabled;

  String? getContinentName() {
    if (continent == null || continent!.isEmpty) return 'Unknown';

    switch (continent) {
      case 'AF':
        return 'Africa';
      case 'EU':
        return 'Europe';
      case 'US':
        return 'America';
      default:
        return continent;
    }
  }

  factory CountryStub.fromJson(Map<String, dynamic> json) =>
      _$CountryStubFromJson(json);

  Map<String, dynamic> toJson() => _$CountryStubToJson(this);
}
