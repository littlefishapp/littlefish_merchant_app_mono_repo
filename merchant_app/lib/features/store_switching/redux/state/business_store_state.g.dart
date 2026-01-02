// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_store_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BusinessStoreState extends BusinessStoreState {
  @override
  final List<BusinessStore> businessStores;
  @override
  final bool isLoading;
  @override
  final bool hasError;
  @override
  final GeneralError? error;

  factory _$BusinessStoreState([
    void Function(BusinessStoreStateBuilder)? updates,
  ]) => (BusinessStoreStateBuilder()..update(updates))._build();

  _$BusinessStoreState._({
    required this.businessStores,
    required this.isLoading,
    required this.hasError,
    this.error,
  }) : super._();
  @override
  BusinessStoreState rebuild(
    void Function(BusinessStoreStateBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  BusinessStoreStateBuilder toBuilder() =>
      BusinessStoreStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BusinessStoreState &&
        businessStores == other.businessStores &&
        isLoading == other.isLoading &&
        hasError == other.hasError &&
        error == other.error;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, businessStores.hashCode);
    _$hash = $jc(_$hash, isLoading.hashCode);
    _$hash = $jc(_$hash, hasError.hashCode);
    _$hash = $jc(_$hash, error.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BusinessStoreState')
          ..add('businessStores', businessStores)
          ..add('isLoading', isLoading)
          ..add('hasError', hasError)
          ..add('error', error))
        .toString();
  }
}

class BusinessStoreStateBuilder
    implements Builder<BusinessStoreState, BusinessStoreStateBuilder> {
  _$BusinessStoreState? _$v;

  List<BusinessStore>? _businessStores;
  List<BusinessStore>? get businessStores => _$this._businessStores;
  set businessStores(List<BusinessStore>? businessStores) =>
      _$this._businessStores = businessStores;

  bool? _isLoading;
  bool? get isLoading => _$this._isLoading;
  set isLoading(bool? isLoading) => _$this._isLoading = isLoading;

  bool? _hasError;
  bool? get hasError => _$this._hasError;
  set hasError(bool? hasError) => _$this._hasError = hasError;

  GeneralError? _error;
  GeneralError? get error => _$this._error;
  set error(GeneralError? error) => _$this._error = error;

  BusinessStoreStateBuilder();

  BusinessStoreStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _businessStores = $v.businessStores;
      _isLoading = $v.isLoading;
      _hasError = $v.hasError;
      _error = $v.error;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BusinessStoreState other) {
    _$v = other as _$BusinessStoreState;
  }

  @override
  void update(void Function(BusinessStoreStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BusinessStoreState build() => _build();

  _$BusinessStoreState _build() {
    final _$result =
        _$v ??
        _$BusinessStoreState._(
          businessStores: BuiltValueNullFieldError.checkNotNull(
            businessStores,
            r'BusinessStoreState',
            'businessStores',
          ),
          isLoading: BuiltValueNullFieldError.checkNotNull(
            isLoading,
            r'BusinessStoreState',
            'isLoading',
          ),
          hasError: BuiltValueNullFieldError.checkNotNull(
            hasError,
            r'BusinessStoreState',
            'hasError',
          ),
          error: error,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusinessStoreState _$BusinessStoreStateFromJson(Map<String, dynamic> json) =>
    BusinessStoreState();

Map<String, dynamic> _$BusinessStoreStateToJson(BusinessStoreState instance) =>
    <String, dynamic>{};
