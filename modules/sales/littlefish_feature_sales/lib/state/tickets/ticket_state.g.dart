// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TicketState extends TicketState {
  @override
  final bool? isLoading;
  @override
  final bool? hasError;
  @override
  final String? errorMessage;
  @override
  final String? searchText;
  @override
  final List<Ticket?>? tickets;

  factory _$TicketState([void Function(TicketStateBuilder)? updates]) =>
      (TicketStateBuilder()..update(updates))._build();

  _$TicketState._({
    this.isLoading,
    this.hasError,
    this.errorMessage,
    this.searchText,
    this.tickets,
  }) : super._();
  @override
  TicketState rebuild(void Function(TicketStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TicketStateBuilder toBuilder() => TicketStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TicketState &&
        isLoading == other.isLoading &&
        hasError == other.hasError &&
        errorMessage == other.errorMessage &&
        searchText == other.searchText &&
        tickets == other.tickets;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, isLoading.hashCode);
    _$hash = $jc(_$hash, hasError.hashCode);
    _$hash = $jc(_$hash, errorMessage.hashCode);
    _$hash = $jc(_$hash, searchText.hashCode);
    _$hash = $jc(_$hash, tickets.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TicketState')
          ..add('isLoading', isLoading)
          ..add('hasError', hasError)
          ..add('errorMessage', errorMessage)
          ..add('searchText', searchText)
          ..add('tickets', tickets))
        .toString();
  }
}

class TicketStateBuilder implements Builder<TicketState, TicketStateBuilder> {
  _$TicketState? _$v;

  bool? _isLoading;
  bool? get isLoading => _$this._isLoading;
  set isLoading(bool? isLoading) => _$this._isLoading = isLoading;

  bool? _hasError;
  bool? get hasError => _$this._hasError;
  set hasError(bool? hasError) => _$this._hasError = hasError;

  String? _errorMessage;
  String? get errorMessage => _$this._errorMessage;
  set errorMessage(String? errorMessage) => _$this._errorMessage = errorMessage;

  String? _searchText;
  String? get searchText => _$this._searchText;
  set searchText(String? searchText) => _$this._searchText = searchText;

  List<Ticket?>? _tickets;
  List<Ticket?>? get tickets => _$this._tickets;
  set tickets(List<Ticket?>? tickets) => _$this._tickets = tickets;

  TicketStateBuilder();

  TicketStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _isLoading = $v.isLoading;
      _hasError = $v.hasError;
      _errorMessage = $v.errorMessage;
      _searchText = $v.searchText;
      _tickets = $v.tickets;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TicketState other) {
    _$v = other as _$TicketState;
  }

  @override
  void update(void Function(TicketStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TicketState build() => _build();

  _$TicketState _build() {
    final _$result =
        _$v ??
        _$TicketState._(
          isLoading: isLoading,
          hasError: hasError,
          errorMessage: errorMessage,
          searchText: searchText,
          tickets: tickets,
        );
    replace(_$result);
    return _$result;
  }
}

class _$TicketUIState extends TicketUIState {
  @override
  final UIEntityState<Ticket>? item;

  factory _$TicketUIState([void Function(TicketUIStateBuilder)? updates]) =>
      (TicketUIStateBuilder()..update(updates))._build();

  _$TicketUIState._({this.item}) : super._();
  @override
  TicketUIState rebuild(void Function(TicketUIStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TicketUIStateBuilder toBuilder() => TicketUIStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TicketUIState && item == other.item;
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
      r'TicketUIState',
    )..add('item', item)).toString();
  }
}

class TicketUIStateBuilder
    implements Builder<TicketUIState, TicketUIStateBuilder> {
  _$TicketUIState? _$v;

  UIEntityState<Ticket>? _item;
  UIEntityState<Ticket>? get item => _$this._item;
  set item(UIEntityState<Ticket>? item) => _$this._item = item;

  TicketUIStateBuilder();

  TicketUIStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _item = $v.item;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TicketUIState other) {
    _$v = other as _$TicketUIState;
  }

  @override
  void update(void Function(TicketUIStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TicketUIState build() => _build();

  _$TicketUIState _build() {
    final _$result = _$v ?? _$TicketUIState._(item: item);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TicketState _$TicketStateFromJson(Map<String, dynamic> json) => TicketState();

Map<String, dynamic> _$TicketStateToJson(TicketState instance) =>
    <String, dynamic>{};
