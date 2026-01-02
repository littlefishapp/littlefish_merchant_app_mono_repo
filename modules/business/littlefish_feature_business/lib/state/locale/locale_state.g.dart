// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locale_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LocaleState extends LocaleState {
  @override
  final bool? isLoading;
  @override
  final bool? hasError;
  @override
  final String? errorMessage;
  @override
  final CountryStub? currentLocale;
  @override
  final String? countryCode;
  @override
  final String? countryName;
  @override
  final String? dialingCode;
  @override
  final String? currencyCode;
  @override
  final List<CountryStub>? locales;

  factory _$LocaleState([void Function(LocaleStateBuilder)? updates]) =>
      (LocaleStateBuilder()..update(updates))._build();

  _$LocaleState._({
    this.isLoading,
    this.hasError,
    this.errorMessage,
    this.currentLocale,
    this.countryCode,
    this.countryName,
    this.dialingCode,
    this.currencyCode,
    this.locales,
  }) : super._();
  @override
  LocaleState rebuild(void Function(LocaleStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LocaleStateBuilder toBuilder() => LocaleStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LocaleState &&
        isLoading == other.isLoading &&
        hasError == other.hasError &&
        errorMessage == other.errorMessage &&
        currentLocale == other.currentLocale &&
        countryCode == other.countryCode &&
        countryName == other.countryName &&
        dialingCode == other.dialingCode &&
        currencyCode == other.currencyCode &&
        locales == other.locales;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, isLoading.hashCode);
    _$hash = $jc(_$hash, hasError.hashCode);
    _$hash = $jc(_$hash, errorMessage.hashCode);
    _$hash = $jc(_$hash, currentLocale.hashCode);
    _$hash = $jc(_$hash, countryCode.hashCode);
    _$hash = $jc(_$hash, countryName.hashCode);
    _$hash = $jc(_$hash, dialingCode.hashCode);
    _$hash = $jc(_$hash, currencyCode.hashCode);
    _$hash = $jc(_$hash, locales.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LocaleState')
          ..add('isLoading', isLoading)
          ..add('hasError', hasError)
          ..add('errorMessage', errorMessage)
          ..add('currentLocale', currentLocale)
          ..add('countryCode', countryCode)
          ..add('countryName', countryName)
          ..add('dialingCode', dialingCode)
          ..add('currencyCode', currencyCode)
          ..add('locales', locales))
        .toString();
  }
}

class LocaleStateBuilder implements Builder<LocaleState, LocaleStateBuilder> {
  _$LocaleState? _$v;

  bool? _isLoading;
  bool? get isLoading => _$this._isLoading;
  set isLoading(bool? isLoading) => _$this._isLoading = isLoading;

  bool? _hasError;
  bool? get hasError => _$this._hasError;
  set hasError(bool? hasError) => _$this._hasError = hasError;

  String? _errorMessage;
  String? get errorMessage => _$this._errorMessage;
  set errorMessage(String? errorMessage) => _$this._errorMessage = errorMessage;

  CountryStub? _currentLocale;
  CountryStub? get currentLocale => _$this._currentLocale;
  set currentLocale(CountryStub? currentLocale) =>
      _$this._currentLocale = currentLocale;

  String? _countryCode;
  String? get countryCode => _$this._countryCode;
  set countryCode(String? countryCode) => _$this._countryCode = countryCode;

  String? _countryName;
  String? get countryName => _$this._countryName;
  set countryName(String? countryName) => _$this._countryName = countryName;

  String? _dialingCode;
  String? get dialingCode => _$this._dialingCode;
  set dialingCode(String? dialingCode) => _$this._dialingCode = dialingCode;

  String? _currencyCode;
  String? get currencyCode => _$this._currencyCode;
  set currencyCode(String? currencyCode) => _$this._currencyCode = currencyCode;

  List<CountryStub>? _locales;
  List<CountryStub>? get locales => _$this._locales;
  set locales(List<CountryStub>? locales) => _$this._locales = locales;

  LocaleStateBuilder();

  LocaleStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _isLoading = $v.isLoading;
      _hasError = $v.hasError;
      _errorMessage = $v.errorMessage;
      _currentLocale = $v.currentLocale;
      _countryCode = $v.countryCode;
      _countryName = $v.countryName;
      _dialingCode = $v.dialingCode;
      _currencyCode = $v.currencyCode;
      _locales = $v.locales;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LocaleState other) {
    _$v = other as _$LocaleState;
  }

  @override
  void update(void Function(LocaleStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LocaleState build() => _build();

  _$LocaleState _build() {
    final _$result =
        _$v ??
        _$LocaleState._(
          isLoading: isLoading,
          hasError: hasError,
          errorMessage: errorMessage,
          currentLocale: currentLocale,
          countryCode: countryCode,
          countryName: countryName,
          dialingCode: dialingCode,
          currencyCode: currencyCode,
          locales: locales,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocaleState _$LocaleStateFromJson(Map<String, dynamic> json) => LocaleState();

Map<String, dynamic> _$LocaleStateToJson(LocaleState instance) =>
    <String, dynamic>{};
