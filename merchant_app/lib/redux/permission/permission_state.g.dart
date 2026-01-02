// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permission_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PermissionState extends PermissionState {
  @override
  final bool? isLoading;
  @override
  final bool? hasError;
  @override
  final String? errorMessage;
  @override
  final bool? isNew;
  @override
  final List<Permission>? permissions;
  @override
  final List<Permission>? userPermissions;
  @override
  final List<PermissionGroup>? permissionGroups;
  @override
  final List<BusinessRole>? roles;
  @override
  final BusinessRole? currentBusinessRole;

  factory _$PermissionState([void Function(PermissionStateBuilder)? updates]) =>
      (PermissionStateBuilder()..update(updates))._build();

  _$PermissionState._({
    this.isLoading,
    this.hasError,
    this.errorMessage,
    this.isNew,
    this.permissions,
    this.userPermissions,
    this.permissionGroups,
    this.roles,
    this.currentBusinessRole,
  }) : super._();
  @override
  PermissionState rebuild(void Function(PermissionStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PermissionStateBuilder toBuilder() => PermissionStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PermissionState &&
        isLoading == other.isLoading &&
        hasError == other.hasError &&
        errorMessage == other.errorMessage &&
        isNew == other.isNew &&
        permissions == other.permissions &&
        userPermissions == other.userPermissions &&
        permissionGroups == other.permissionGroups &&
        roles == other.roles &&
        currentBusinessRole == other.currentBusinessRole;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, isLoading.hashCode);
    _$hash = $jc(_$hash, hasError.hashCode);
    _$hash = $jc(_$hash, errorMessage.hashCode);
    _$hash = $jc(_$hash, isNew.hashCode);
    _$hash = $jc(_$hash, permissions.hashCode);
    _$hash = $jc(_$hash, userPermissions.hashCode);
    _$hash = $jc(_$hash, permissionGroups.hashCode);
    _$hash = $jc(_$hash, roles.hashCode);
    _$hash = $jc(_$hash, currentBusinessRole.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PermissionState')
          ..add('isLoading', isLoading)
          ..add('hasError', hasError)
          ..add('errorMessage', errorMessage)
          ..add('isNew', isNew)
          ..add('permissions', permissions)
          ..add('userPermissions', userPermissions)
          ..add('permissionGroups', permissionGroups)
          ..add('roles', roles)
          ..add('currentBusinessRole', currentBusinessRole))
        .toString();
  }
}

class PermissionStateBuilder
    implements Builder<PermissionState, PermissionStateBuilder> {
  _$PermissionState? _$v;

  bool? _isLoading;
  bool? get isLoading => _$this._isLoading;
  set isLoading(bool? isLoading) => _$this._isLoading = isLoading;

  bool? _hasError;
  bool? get hasError => _$this._hasError;
  set hasError(bool? hasError) => _$this._hasError = hasError;

  String? _errorMessage;
  String? get errorMessage => _$this._errorMessage;
  set errorMessage(String? errorMessage) => _$this._errorMessage = errorMessage;

  bool? _isNew;
  bool? get isNew => _$this._isNew;
  set isNew(bool? isNew) => _$this._isNew = isNew;

  List<Permission>? _permissions;
  List<Permission>? get permissions => _$this._permissions;
  set permissions(List<Permission>? permissions) =>
      _$this._permissions = permissions;

  List<Permission>? _userPermissions;
  List<Permission>? get userPermissions => _$this._userPermissions;
  set userPermissions(List<Permission>? userPermissions) =>
      _$this._userPermissions = userPermissions;

  List<PermissionGroup>? _permissionGroups;
  List<PermissionGroup>? get permissionGroups => _$this._permissionGroups;
  set permissionGroups(List<PermissionGroup>? permissionGroups) =>
      _$this._permissionGroups = permissionGroups;

  List<BusinessRole>? _roles;
  List<BusinessRole>? get roles => _$this._roles;
  set roles(List<BusinessRole>? roles) => _$this._roles = roles;

  BusinessRole? _currentBusinessRole;
  BusinessRole? get currentBusinessRole => _$this._currentBusinessRole;
  set currentBusinessRole(BusinessRole? currentBusinessRole) =>
      _$this._currentBusinessRole = currentBusinessRole;

  PermissionStateBuilder();

  PermissionStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _isLoading = $v.isLoading;
      _hasError = $v.hasError;
      _errorMessage = $v.errorMessage;
      _isNew = $v.isNew;
      _permissions = $v.permissions;
      _userPermissions = $v.userPermissions;
      _permissionGroups = $v.permissionGroups;
      _roles = $v.roles;
      _currentBusinessRole = $v.currentBusinessRole;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PermissionState other) {
    _$v = other as _$PermissionState;
  }

  @override
  void update(void Function(PermissionStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PermissionState build() => _build();

  _$PermissionState _build() {
    final _$result =
        _$v ??
        _$PermissionState._(
          isLoading: isLoading,
          hasError: hasError,
          errorMessage: errorMessage,
          isNew: isNew,
          permissions: permissions,
          userPermissions: userPermissions,
          permissionGroups: permissionGroups,
          roles: roles,
          currentBusinessRole: currentBusinessRole,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
