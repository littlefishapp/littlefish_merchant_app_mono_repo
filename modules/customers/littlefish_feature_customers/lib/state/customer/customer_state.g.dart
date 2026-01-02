// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerState extends CustomerState {
  @override
  final bool? isLoading;
  @override
  final bool? hasError;
  @override
  final String? errorMessage;
  @override
  final List<Customer>? customers;
  @override
  final List<Contact>? contacts;

  factory _$CustomerState([void Function(CustomerStateBuilder)? updates]) =>
      (CustomerStateBuilder()..update(updates))._build();

  _$CustomerState._({
    this.isLoading,
    this.hasError,
    this.errorMessage,
    this.customers,
    this.contacts,
  }) : super._();
  @override
  CustomerState rebuild(void Function(CustomerStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CustomerStateBuilder toBuilder() => CustomerStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerState &&
        isLoading == other.isLoading &&
        hasError == other.hasError &&
        errorMessage == other.errorMessage &&
        customers == other.customers &&
        contacts == other.contacts;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, isLoading.hashCode);
    _$hash = $jc(_$hash, hasError.hashCode);
    _$hash = $jc(_$hash, errorMessage.hashCode);
    _$hash = $jc(_$hash, customers.hashCode);
    _$hash = $jc(_$hash, contacts.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CustomerState')
          ..add('isLoading', isLoading)
          ..add('hasError', hasError)
          ..add('errorMessage', errorMessage)
          ..add('customers', customers)
          ..add('contacts', contacts))
        .toString();
  }
}

class CustomerStateBuilder
    implements Builder<CustomerState, CustomerStateBuilder> {
  _$CustomerState? _$v;

  bool? _isLoading;
  bool? get isLoading => _$this._isLoading;
  set isLoading(bool? isLoading) => _$this._isLoading = isLoading;

  bool? _hasError;
  bool? get hasError => _$this._hasError;
  set hasError(bool? hasError) => _$this._hasError = hasError;

  String? _errorMessage;
  String? get errorMessage => _$this._errorMessage;
  set errorMessage(String? errorMessage) => _$this._errorMessage = errorMessage;

  List<Customer>? _customers;
  List<Customer>? get customers => _$this._customers;
  set customers(List<Customer>? customers) => _$this._customers = customers;

  List<Contact>? _contacts;
  List<Contact>? get contacts => _$this._contacts;
  set contacts(List<Contact>? contacts) => _$this._contacts = contacts;

  CustomerStateBuilder();

  CustomerStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _isLoading = $v.isLoading;
      _hasError = $v.hasError;
      _errorMessage = $v.errorMessage;
      _customers = $v.customers;
      _contacts = $v.contacts;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerState other) {
    _$v = other as _$CustomerState;
  }

  @override
  void update(void Function(CustomerStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerState build() => _build();

  _$CustomerState _build() {
    final _$result =
        _$v ??
        _$CustomerState._(
          isLoading: isLoading,
          hasError: hasError,
          errorMessage: errorMessage,
          customers: customers,
          contacts: contacts,
        );
    replace(_$result);
    return _$result;
  }
}

class _$CustomerUIState extends CustomerUIState {
  @override
  final UIEntityState<Customer?>? item;

  factory _$CustomerUIState([void Function(CustomerUIStateBuilder)? updates]) =>
      (CustomerUIStateBuilder()..update(updates))._build();

  _$CustomerUIState._({this.item}) : super._();
  @override
  CustomerUIState rebuild(void Function(CustomerUIStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CustomerUIStateBuilder toBuilder() => CustomerUIStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerUIState && item == other.item;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, item.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'CustomerUIState',
    )..add('item', item)).toString();
  }
}

class CustomerUIStateBuilder
    implements Builder<CustomerUIState, CustomerUIStateBuilder> {
  _$CustomerUIState? _$v;

  UIEntityState<Customer?>? _item;
  UIEntityState<Customer?>? get item => _$this._item;
  set item(UIEntityState<Customer?>? item) => _$this._item = item;

  CustomerUIStateBuilder();

  CustomerUIStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _item = $v.item;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerUIState other) {
    _$v = other as _$CustomerUIState;
  }

  @override
  void update(void Function(CustomerUIStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerUIState build() => _build();

  _$CustomerUIState _build() {
    final _$result = _$v ?? _$CustomerUIState._(item: item);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerState _$CustomerStateFromJson(Map<String, dynamic> json) =>
    CustomerState();

Map<String, dynamic> _$CustomerStateToJson(CustomerState instance) =>
    <String, dynamic>{};
