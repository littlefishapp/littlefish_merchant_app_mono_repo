// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ErrorState extends ErrorState {
  @override
  final ErrorReport? errorReport;
  @override
  final GeneralError? error;
  @override
  final bool hasError;
  @override
  final bool isLoading;
  @override
  final bool appErrorReportedSuccessfully;

  factory _$ErrorState([void Function(ErrorStateBuilder)? updates]) =>
      (ErrorStateBuilder()..update(updates))._build();

  _$ErrorState._({
    this.errorReport,
    this.error,
    required this.hasError,
    required this.isLoading,
    required this.appErrorReportedSuccessfully,
  }) : super._();
  @override
  ErrorState rebuild(void Function(ErrorStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ErrorStateBuilder toBuilder() => ErrorStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ErrorState &&
        errorReport == other.errorReport &&
        error == other.error &&
        hasError == other.hasError &&
        isLoading == other.isLoading &&
        appErrorReportedSuccessfully == other.appErrorReportedSuccessfully;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, errorReport.hashCode);
    _$hash = $jc(_$hash, error.hashCode);
    _$hash = $jc(_$hash, hasError.hashCode);
    _$hash = $jc(_$hash, isLoading.hashCode);
    _$hash = $jc(_$hash, appErrorReportedSuccessfully.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ErrorState')
          ..add('errorReport', errorReport)
          ..add('error', error)
          ..add('hasError', hasError)
          ..add('isLoading', isLoading)
          ..add('appErrorReportedSuccessfully', appErrorReportedSuccessfully))
        .toString();
  }
}

class ErrorStateBuilder implements Builder<ErrorState, ErrorStateBuilder> {
  _$ErrorState? _$v;

  ErrorReport? _errorReport;
  ErrorReport? get errorReport => _$this._errorReport;
  set errorReport(ErrorReport? errorReport) =>
      _$this._errorReport = errorReport;

  GeneralError? _error;
  GeneralError? get error => _$this._error;
  set error(GeneralError? error) => _$this._error = error;

  bool? _hasError;
  bool? get hasError => _$this._hasError;
  set hasError(bool? hasError) => _$this._hasError = hasError;

  bool? _isLoading;
  bool? get isLoading => _$this._isLoading;
  set isLoading(bool? isLoading) => _$this._isLoading = isLoading;

  bool? _appErrorReportedSuccessfully;
  bool? get appErrorReportedSuccessfully =>
      _$this._appErrorReportedSuccessfully;
  set appErrorReportedSuccessfully(bool? appErrorReportedSuccessfully) =>
      _$this._appErrorReportedSuccessfully = appErrorReportedSuccessfully;

  ErrorStateBuilder();

  ErrorStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _errorReport = $v.errorReport;
      _error = $v.error;
      _hasError = $v.hasError;
      _isLoading = $v.isLoading;
      _appErrorReportedSuccessfully = $v.appErrorReportedSuccessfully;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ErrorState other) {
    _$v = other as _$ErrorState;
  }

  @override
  void update(void Function(ErrorStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ErrorState build() => _build();

  _$ErrorState _build() {
    final _$result =
        _$v ??
        _$ErrorState._(
          errorReport: errorReport,
          error: error,
          hasError: BuiltValueNullFieldError.checkNotNull(
            hasError,
            r'ErrorState',
            'hasError',
          ),
          isLoading: BuiltValueNullFieldError.checkNotNull(
            isLoading,
            r'ErrorState',
            'isLoading',
          ),
          appErrorReportedSuccessfully: BuiltValueNullFieldError.checkNotNull(
            appErrorReportedSuccessfully,
            r'ErrorState',
            'appErrorReportedSuccessfully',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorState _$ErrorStateFromJson(Map<String, dynamic> json) => ErrorState();

Map<String, dynamic> _$ErrorStateToJson(ErrorState instance) =>
    <String, dynamic>{};
