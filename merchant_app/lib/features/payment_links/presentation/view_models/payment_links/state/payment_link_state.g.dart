// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_link_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PaymentLinksState extends PaymentLinksState {
  @override
  final BuiltList<Order> links;
  @override
  final bool isLoading;
  @override
  final bool hasError;
  @override
  final GeneralError? error;
  @override
  final int offset;
  @override
  final int limit;
  @override
  final int totalRecords;
  @override
  final bool hasMore;

  factory _$PaymentLinksState([
    void Function(PaymentLinksStateBuilder)? updates,
  ]) => (PaymentLinksStateBuilder()..update(updates))._build();

  _$PaymentLinksState._({
    required this.links,
    required this.isLoading,
    required this.hasError,
    this.error,
    required this.offset,
    required this.limit,
    required this.totalRecords,
    required this.hasMore,
  }) : super._();
  @override
  PaymentLinksState rebuild(void Function(PaymentLinksStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PaymentLinksStateBuilder toBuilder() =>
      PaymentLinksStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PaymentLinksState &&
        links == other.links &&
        isLoading == other.isLoading &&
        hasError == other.hasError &&
        error == other.error &&
        offset == other.offset &&
        limit == other.limit &&
        totalRecords == other.totalRecords &&
        hasMore == other.hasMore;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, links.hashCode);
    _$hash = $jc(_$hash, isLoading.hashCode);
    _$hash = $jc(_$hash, hasError.hashCode);
    _$hash = $jc(_$hash, error.hashCode);
    _$hash = $jc(_$hash, offset.hashCode);
    _$hash = $jc(_$hash, limit.hashCode);
    _$hash = $jc(_$hash, totalRecords.hashCode);
    _$hash = $jc(_$hash, hasMore.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PaymentLinksState')
          ..add('links', links)
          ..add('isLoading', isLoading)
          ..add('hasError', hasError)
          ..add('error', error)
          ..add('offset', offset)
          ..add('limit', limit)
          ..add('totalRecords', totalRecords)
          ..add('hasMore', hasMore))
        .toString();
  }
}

class PaymentLinksStateBuilder
    implements Builder<PaymentLinksState, PaymentLinksStateBuilder> {
  _$PaymentLinksState? _$v;

  ListBuilder<Order>? _links;
  ListBuilder<Order> get links => _$this._links ??= ListBuilder<Order>();
  set links(ListBuilder<Order>? links) => _$this._links = links;

  bool? _isLoading;
  bool? get isLoading => _$this._isLoading;
  set isLoading(bool? isLoading) => _$this._isLoading = isLoading;

  bool? _hasError;
  bool? get hasError => _$this._hasError;
  set hasError(bool? hasError) => _$this._hasError = hasError;

  GeneralError? _error;
  GeneralError? get error => _$this._error;
  set error(GeneralError? error) => _$this._error = error;

  int? _offset;
  int? get offset => _$this._offset;
  set offset(int? offset) => _$this._offset = offset;

  int? _limit;
  int? get limit => _$this._limit;
  set limit(int? limit) => _$this._limit = limit;

  int? _totalRecords;
  int? get totalRecords => _$this._totalRecords;
  set totalRecords(int? totalRecords) => _$this._totalRecords = totalRecords;

  bool? _hasMore;
  bool? get hasMore => _$this._hasMore;
  set hasMore(bool? hasMore) => _$this._hasMore = hasMore;

  PaymentLinksStateBuilder();

  PaymentLinksStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _links = $v.links.toBuilder();
      _isLoading = $v.isLoading;
      _hasError = $v.hasError;
      _error = $v.error;
      _offset = $v.offset;
      _limit = $v.limit;
      _totalRecords = $v.totalRecords;
      _hasMore = $v.hasMore;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PaymentLinksState other) {
    _$v = other as _$PaymentLinksState;
  }

  @override
  void update(void Function(PaymentLinksStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PaymentLinksState build() => _build();

  _$PaymentLinksState _build() {
    _$PaymentLinksState _$result;
    try {
      _$result =
          _$v ??
          _$PaymentLinksState._(
            links: links.build(),
            isLoading: BuiltValueNullFieldError.checkNotNull(
              isLoading,
              r'PaymentLinksState',
              'isLoading',
            ),
            hasError: BuiltValueNullFieldError.checkNotNull(
              hasError,
              r'PaymentLinksState',
              'hasError',
            ),
            error: error,
            offset: BuiltValueNullFieldError.checkNotNull(
              offset,
              r'PaymentLinksState',
              'offset',
            ),
            limit: BuiltValueNullFieldError.checkNotNull(
              limit,
              r'PaymentLinksState',
              'limit',
            ),
            totalRecords: BuiltValueNullFieldError.checkNotNull(
              totalRecords,
              r'PaymentLinksState',
              'totalRecords',
            ),
            hasMore: BuiltValueNullFieldError.checkNotNull(
              hasMore,
              r'PaymentLinksState',
              'hasMore',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'links';
        links.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'PaymentLinksState',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentLinksState _$PaymentLinksStateFromJson(Map<String, dynamic> json) =>
    PaymentLinksState();

Map<String, dynamic> _$PaymentLinksStateToJson(PaymentLinksState instance) =>
    <String, dynamic>{};
