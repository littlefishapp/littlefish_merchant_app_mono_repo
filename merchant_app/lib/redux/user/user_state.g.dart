// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UserState extends UserState {
  @override
  final bool? isLoading;
  @override
  final bool? hasError;
  @override
  final String? errorMessage;
  @override
  final bool? isGuestUser;
  @override
  final UserProfile? profile;
  @override
  final Map<String, bool>? permissions;
  @override
  final List<BusinessUserRole>? userBusinessRoles;
  @override
  final Position? location;
  @override
  final UserViewingMode? viewMode;
  @override
  final bool? canChangeViewMode;

  factory _$UserState([void Function(UserStateBuilder)? updates]) =>
      (UserStateBuilder()..update(updates))._build();

  _$UserState._({
    this.isLoading,
    this.hasError,
    this.errorMessage,
    this.isGuestUser,
    this.profile,
    this.permissions,
    this.userBusinessRoles,
    this.location,
    this.viewMode,
    this.canChangeViewMode,
  }) : super._();
  @override
  UserState rebuild(void Function(UserStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserStateBuilder toBuilder() => UserStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserState &&
        isLoading == other.isLoading &&
        hasError == other.hasError &&
        errorMessage == other.errorMessage &&
        isGuestUser == other.isGuestUser &&
        profile == other.profile &&
        permissions == other.permissions &&
        userBusinessRoles == other.userBusinessRoles &&
        location == other.location &&
        viewMode == other.viewMode &&
        canChangeViewMode == other.canChangeViewMode;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, isLoading.hashCode);
    _$hash = $jc(_$hash, hasError.hashCode);
    _$hash = $jc(_$hash, errorMessage.hashCode);
    _$hash = $jc(_$hash, isGuestUser.hashCode);
    _$hash = $jc(_$hash, profile.hashCode);
    _$hash = $jc(_$hash, permissions.hashCode);
    _$hash = $jc(_$hash, userBusinessRoles.hashCode);
    _$hash = $jc(_$hash, location.hashCode);
    _$hash = $jc(_$hash, viewMode.hashCode);
    _$hash = $jc(_$hash, canChangeViewMode.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserState')
          ..add('isLoading', isLoading)
          ..add('hasError', hasError)
          ..add('errorMessage', errorMessage)
          ..add('isGuestUser', isGuestUser)
          ..add('profile', profile)
          ..add('permissions', permissions)
          ..add('userBusinessRoles', userBusinessRoles)
          ..add('location', location)
          ..add('viewMode', viewMode)
          ..add('canChangeViewMode', canChangeViewMode))
        .toString();
  }
}

class UserStateBuilder implements Builder<UserState, UserStateBuilder> {
  _$UserState? _$v;

  bool? _isLoading;
  bool? get isLoading => _$this._isLoading;
  set isLoading(bool? isLoading) => _$this._isLoading = isLoading;

  bool? _hasError;
  bool? get hasError => _$this._hasError;
  set hasError(bool? hasError) => _$this._hasError = hasError;

  String? _errorMessage;
  String? get errorMessage => _$this._errorMessage;
  set errorMessage(String? errorMessage) => _$this._errorMessage = errorMessage;

  bool? _isGuestUser;
  bool? get isGuestUser => _$this._isGuestUser;
  set isGuestUser(bool? isGuestUser) => _$this._isGuestUser = isGuestUser;

  UserProfile? _profile;
  UserProfile? get profile => _$this._profile;
  set profile(UserProfile? profile) => _$this._profile = profile;

  Map<String, bool>? _permissions;
  Map<String, bool>? get permissions => _$this._permissions;
  set permissions(Map<String, bool>? permissions) =>
      _$this._permissions = permissions;

  List<BusinessUserRole>? _userBusinessRoles;
  List<BusinessUserRole>? get userBusinessRoles => _$this._userBusinessRoles;
  set userBusinessRoles(List<BusinessUserRole>? userBusinessRoles) =>
      _$this._userBusinessRoles = userBusinessRoles;

  Position? _location;
  Position? get location => _$this._location;
  set location(Position? location) => _$this._location = location;

  UserViewingMode? _viewMode;
  UserViewingMode? get viewMode => _$this._viewMode;
  set viewMode(UserViewingMode? viewMode) => _$this._viewMode = viewMode;

  bool? _canChangeViewMode;
  bool? get canChangeViewMode => _$this._canChangeViewMode;
  set canChangeViewMode(bool? canChangeViewMode) =>
      _$this._canChangeViewMode = canChangeViewMode;

  UserStateBuilder();

  UserStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _isLoading = $v.isLoading;
      _hasError = $v.hasError;
      _errorMessage = $v.errorMessage;
      _isGuestUser = $v.isGuestUser;
      _profile = $v.profile;
      _permissions = $v.permissions;
      _userBusinessRoles = $v.userBusinessRoles;
      _location = $v.location;
      _viewMode = $v.viewMode;
      _canChangeViewMode = $v.canChangeViewMode;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserState other) {
    _$v = other as _$UserState;
  }

  @override
  void update(void Function(UserStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserState build() => _build();

  _$UserState _build() {
    final _$result =
        _$v ??
        _$UserState._(
          isLoading: isLoading,
          hasError: hasError,
          errorMessage: errorMessage,
          isGuestUser: isGuestUser,
          profile: profile,
          permissions: permissions,
          userBusinessRoles: userBusinessRoles,
          location: location,
          viewMode: viewMode,
          canChangeViewMode: canChangeViewMode,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
