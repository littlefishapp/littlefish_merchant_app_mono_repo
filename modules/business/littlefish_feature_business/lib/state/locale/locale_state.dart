// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:built_value/built_value.dart';
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import 'package:littlefish_merchant/models/settings/locale/country_stub.dart';

part 'locale_state.g.dart';

@immutable
@JsonSerializable()
abstract class LocaleState implements Built<LocaleState, LocaleStateBuilder> {
  const LocaleState._();

  factory LocaleState() =>
      _$LocaleState._(hasError: false, isLoading: false, errorMessage: null);

  // static Serializer<LocaleState> get serializer => _$localeStateSerializer;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? get isLoading;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? get hasError;

  @JsonKey(includeFromJson: false, includeToJson: false)
  String? get errorMessage;

  CountryStub? get currentLocale;

  String? get countryCode;

  String? get countryName;

  String? get dialingCode;

  String? get currencyCode;

  List<CountryStub>? get locales;
}
