// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_preferences_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UserPreferencesState extends UserPreferencesState {
  @override
  final bool? isLoading;
  @override
  final bool? hasError;
  @override
  final String? errorMessage;
  @override
  final List<UIStateItem>? preferences;

  factory _$UserPreferencesState([
    void Function(UserPreferencesStateBuilder)? updates,
  ]) => (UserPreferencesStateBuilder()..update(updates))._build();

  _$UserPreferencesState._({
    this.isLoading,
    this.hasError,
    this.errorMessage,
    this.preferences,
  }) : super._();
  @override
  UserPreferencesState rebuild(
    void Function(UserPreferencesStateBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  UserPreferencesStateBuilder toBuilder() =>
      UserPreferencesStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserPreferencesState &&
        isLoading == other.isLoading &&
        hasError == other.hasError &&
        errorMessage == other.errorMessage &&
        preferences == other.preferences;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, isLoading.hashCode);
    _$hash = $jc(_$hash, hasError.hashCode);
    _$hash = $jc(_$hash, errorMessage.hashCode);
    _$hash = $jc(_$hash, preferences.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserPreferencesState')
          ..add('isLoading', isLoading)
          ..add('hasError', hasError)
          ..add('errorMessage', errorMessage)
          ..add('preferences', preferences))
        .toString();
  }
}

class UserPreferencesStateBuilder
    implements Builder<UserPreferencesState, UserPreferencesStateBuilder> {
  _$UserPreferencesState? _$v;

  bool? _isLoading;
  bool? get isLoading => _$this._isLoading;
  set isLoading(bool? isLoading) => _$this._isLoading = isLoading;

  bool? _hasError;
  bool? get hasError => _$this._hasError;
  set hasError(bool? hasError) => _$this._hasError = hasError;

  String? _errorMessage;
  String? get errorMessage => _$this._errorMessage;
  set errorMessage(String? errorMessage) => _$this._errorMessage = errorMessage;

  List<UIStateItem>? _preferences;
  List<UIStateItem>? get preferences => _$this._preferences;
  set preferences(List<UIStateItem>? preferences) =>
      _$this._preferences = preferences;

  UserPreferencesStateBuilder();

  UserPreferencesStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _isLoading = $v.isLoading;
      _hasError = $v.hasError;
      _errorMessage = $v.errorMessage;
      _preferences = $v.preferences;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserPreferencesState other) {
    _$v = other as _$UserPreferencesState;
  }

  @override
  void update(void Function(UserPreferencesStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserPreferencesState build() => _build();

  _$UserPreferencesState _build() {
    final _$result =
        _$v ??
        _$UserPreferencesState._(
          isLoading: isLoading,
          hasError: hasError,
          errorMessage: errorMessage,
          preferences: preferences,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
