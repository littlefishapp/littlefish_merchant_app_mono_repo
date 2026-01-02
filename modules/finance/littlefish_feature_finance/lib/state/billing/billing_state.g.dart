// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'billing_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BillingState extends BillingState {
  @override
  final bool? isLoading;
  @override
  final bool? hasError;
  @override
  final String? errorMessage;
  @override
  final bool? billingSupported;
  @override
  final BillingStoreInfo? billingStoreInfo;
  @override
  final bool? showBillingPage;

  factory _$BillingState([void Function(BillingStateBuilder)? updates]) =>
      (BillingStateBuilder()..update(updates))._build();

  _$BillingState._({
    this.isLoading,
    this.hasError,
    this.errorMessage,
    this.billingSupported,
    this.billingStoreInfo,
    this.showBillingPage,
  }) : super._();
  @override
  BillingState rebuild(void Function(BillingStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BillingStateBuilder toBuilder() => BillingStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BillingState &&
        isLoading == other.isLoading &&
        hasError == other.hasError &&
        errorMessage == other.errorMessage &&
        billingSupported == other.billingSupported &&
        billingStoreInfo == other.billingStoreInfo &&
        showBillingPage == other.showBillingPage;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, isLoading.hashCode);
    _$hash = $jc(_$hash, hasError.hashCode);
    _$hash = $jc(_$hash, errorMessage.hashCode);
    _$hash = $jc(_$hash, billingSupported.hashCode);
    _$hash = $jc(_$hash, billingStoreInfo.hashCode);
    _$hash = $jc(_$hash, showBillingPage.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BillingState')
          ..add('isLoading', isLoading)
          ..add('hasError', hasError)
          ..add('errorMessage', errorMessage)
          ..add('billingSupported', billingSupported)
          ..add('billingStoreInfo', billingStoreInfo)
          ..add('showBillingPage', showBillingPage))
        .toString();
  }
}

class BillingStateBuilder
    implements Builder<BillingState, BillingStateBuilder> {
  _$BillingState? _$v;

  bool? _isLoading;
  bool? get isLoading => _$this._isLoading;
  set isLoading(bool? isLoading) => _$this._isLoading = isLoading;

  bool? _hasError;
  bool? get hasError => _$this._hasError;
  set hasError(bool? hasError) => _$this._hasError = hasError;

  String? _errorMessage;
  String? get errorMessage => _$this._errorMessage;
  set errorMessage(String? errorMessage) => _$this._errorMessage = errorMessage;

  bool? _billingSupported;
  bool? get billingSupported => _$this._billingSupported;
  set billingSupported(bool? billingSupported) =>
      _$this._billingSupported = billingSupported;

  BillingStoreInfo? _billingStoreInfo;
  BillingStoreInfo? get billingStoreInfo => _$this._billingStoreInfo;
  set billingStoreInfo(BillingStoreInfo? billingStoreInfo) =>
      _$this._billingStoreInfo = billingStoreInfo;

  bool? _showBillingPage;
  bool? get showBillingPage => _$this._showBillingPage;
  set showBillingPage(bool? showBillingPage) =>
      _$this._showBillingPage = showBillingPage;

  BillingStateBuilder();

  BillingStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _isLoading = $v.isLoading;
      _hasError = $v.hasError;
      _errorMessage = $v.errorMessage;
      _billingSupported = $v.billingSupported;
      _billingStoreInfo = $v.billingStoreInfo;
      _showBillingPage = $v.showBillingPage;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BillingState other) {
    _$v = other as _$BillingState;
  }

  @override
  void update(void Function(BillingStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BillingState build() => _build();

  _$BillingState _build() {
    final _$result =
        _$v ??
        _$BillingState._(
          isLoading: isLoading,
          hasError: hasError,
          errorMessage: errorMessage,
          billingSupported: billingSupported,
          billingStoreInfo: billingStoreInfo,
          showBillingPage: showBillingPage,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
