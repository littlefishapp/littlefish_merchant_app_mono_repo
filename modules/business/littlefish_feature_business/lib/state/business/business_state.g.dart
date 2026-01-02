// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BusinessState extends BusinessState {
  @override
  final bool? isLoading;
  @override
  final bool? hasError;
  @override
  final String? errorMessage;
  @override
  final List<Business>? businesses;
  @override
  final List<BusinessUser>? businessUsers;
  @override
  final String? businessId;
  @override
  final BusinessProfile? profile;
  @override
  final List<BusinessType>? types;
  @override
  final List<Employee>? employees;
  @override
  final List<BusinessUser?>? users;
  @override
  final List<BusinessUserRole>? usersBusinessRoles;
  @override
  final Verification? verificationStatus;

  factory _$BusinessState([void Function(BusinessStateBuilder)? updates]) =>
      (BusinessStateBuilder()..update(updates))._build();

  _$BusinessState._({
    this.isLoading,
    this.hasError,
    this.errorMessage,
    this.businesses,
    this.businessUsers,
    this.businessId,
    this.profile,
    this.types,
    this.employees,
    this.users,
    this.usersBusinessRoles,
    this.verificationStatus,
  }) : super._();
  @override
  BusinessState rebuild(void Function(BusinessStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BusinessStateBuilder toBuilder() => BusinessStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BusinessState &&
        isLoading == other.isLoading &&
        hasError == other.hasError &&
        errorMessage == other.errorMessage &&
        businesses == other.businesses &&
        businessUsers == other.businessUsers &&
        businessId == other.businessId &&
        profile == other.profile &&
        types == other.types &&
        employees == other.employees &&
        users == other.users &&
        usersBusinessRoles == other.usersBusinessRoles &&
        verificationStatus == other.verificationStatus;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, isLoading.hashCode);
    _$hash = $jc(_$hash, hasError.hashCode);
    _$hash = $jc(_$hash, errorMessage.hashCode);
    _$hash = $jc(_$hash, businesses.hashCode);
    _$hash = $jc(_$hash, businessUsers.hashCode);
    _$hash = $jc(_$hash, businessId.hashCode);
    _$hash = $jc(_$hash, profile.hashCode);
    _$hash = $jc(_$hash, types.hashCode);
    _$hash = $jc(_$hash, employees.hashCode);
    _$hash = $jc(_$hash, users.hashCode);
    _$hash = $jc(_$hash, usersBusinessRoles.hashCode);
    _$hash = $jc(_$hash, verificationStatus.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BusinessState')
          ..add('isLoading', isLoading)
          ..add('hasError', hasError)
          ..add('errorMessage', errorMessage)
          ..add('businesses', businesses)
          ..add('businessUsers', businessUsers)
          ..add('businessId', businessId)
          ..add('profile', profile)
          ..add('types', types)
          ..add('employees', employees)
          ..add('users', users)
          ..add('usersBusinessRoles', usersBusinessRoles)
          ..add('verificationStatus', verificationStatus))
        .toString();
  }
}

class BusinessStateBuilder
    implements Builder<BusinessState, BusinessStateBuilder> {
  _$BusinessState? _$v;

  bool? _isLoading;
  bool? get isLoading => _$this._isLoading;
  set isLoading(bool? isLoading) => _$this._isLoading = isLoading;

  bool? _hasError;
  bool? get hasError => _$this._hasError;
  set hasError(bool? hasError) => _$this._hasError = hasError;

  String? _errorMessage;
  String? get errorMessage => _$this._errorMessage;
  set errorMessage(String? errorMessage) => _$this._errorMessage = errorMessage;

  List<Business>? _businesses;
  List<Business>? get businesses => _$this._businesses;
  set businesses(List<Business>? businesses) => _$this._businesses = businesses;

  List<BusinessUser>? _businessUsers;
  List<BusinessUser>? get businessUsers => _$this._businessUsers;
  set businessUsers(List<BusinessUser>? businessUsers) =>
      _$this._businessUsers = businessUsers;

  String? _businessId;
  String? get businessId => _$this._businessId;
  set businessId(String? businessId) => _$this._businessId = businessId;

  BusinessProfile? _profile;
  BusinessProfile? get profile => _$this._profile;
  set profile(BusinessProfile? profile) => _$this._profile = profile;

  List<BusinessType>? _types;
  List<BusinessType>? get types => _$this._types;
  set types(List<BusinessType>? types) => _$this._types = types;

  List<Employee>? _employees;
  List<Employee>? get employees => _$this._employees;
  set employees(List<Employee>? employees) => _$this._employees = employees;

  List<BusinessUser?>? _users;
  List<BusinessUser?>? get users => _$this._users;
  set users(List<BusinessUser?>? users) => _$this._users = users;

  List<BusinessUserRole>? _usersBusinessRoles;
  List<BusinessUserRole>? get usersBusinessRoles => _$this._usersBusinessRoles;
  set usersBusinessRoles(List<BusinessUserRole>? usersBusinessRoles) =>
      _$this._usersBusinessRoles = usersBusinessRoles;

  Verification? _verificationStatus;
  Verification? get verificationStatus => _$this._verificationStatus;
  set verificationStatus(Verification? verificationStatus) =>
      _$this._verificationStatus = verificationStatus;

  BusinessStateBuilder();

  BusinessStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _isLoading = $v.isLoading;
      _hasError = $v.hasError;
      _errorMessage = $v.errorMessage;
      _businesses = $v.businesses;
      _businessUsers = $v.businessUsers;
      _businessId = $v.businessId;
      _profile = $v.profile;
      _types = $v.types;
      _employees = $v.employees;
      _users = $v.users;
      _usersBusinessRoles = $v.usersBusinessRoles;
      _verificationStatus = $v.verificationStatus;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BusinessState other) {
    _$v = other as _$BusinessState;
  }

  @override
  void update(void Function(BusinessStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BusinessState build() => _build();

  _$BusinessState _build() {
    final _$result =
        _$v ??
        _$BusinessState._(
          isLoading: isLoading,
          hasError: hasError,
          errorMessage: errorMessage,
          businesses: businesses,
          businessUsers: businessUsers,
          businessId: businessId,
          profile: profile,
          types: types,
          employees: employees,
          users: users,
          usersBusinessRoles: usersBusinessRoles,
          verificationStatus: verificationStatus,
        );
    replace(_$result);
    return _$result;
  }
}

class _$EmployeesUIState extends EmployeesUIState {
  @override
  final UIEntityState<Employee>? item;

  factory _$EmployeesUIState([
    void Function(EmployeesUIStateBuilder)? updates,
  ]) => (EmployeesUIStateBuilder()..update(updates))._build();

  _$EmployeesUIState._({this.item}) : super._();
  @override
  EmployeesUIState rebuild(void Function(EmployeesUIStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EmployeesUIStateBuilder toBuilder() =>
      EmployeesUIStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EmployeesUIState && item == other.item;
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
      r'EmployeesUIState',
    )..add('item', item)).toString();
  }
}

class EmployeesUIStateBuilder
    implements Builder<EmployeesUIState, EmployeesUIStateBuilder> {
  _$EmployeesUIState? _$v;

  UIEntityState<Employee>? _item;
  UIEntityState<Employee>? get item => _$this._item;
  set item(UIEntityState<Employee>? item) => _$this._item = item;

  EmployeesUIStateBuilder();

  EmployeesUIStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _item = $v.item;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EmployeesUIState other) {
    _$v = other as _$EmployeesUIState;
  }

  @override
  void update(void Function(EmployeesUIStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EmployeesUIState build() => _build();

  _$EmployeesUIState _build() {
    final _$result = _$v ?? _$EmployeesUIState._(item: item);
    replace(_$result);
    return _$result;
  }
}

class _$BusinessUsersUIState extends BusinessUsersUIState {
  @override
  final UIEntityState<BusinessUser?>? item;
  @override
  final List<BusinessUserRole>? userRoles;

  factory _$BusinessUsersUIState([
    void Function(BusinessUsersUIStateBuilder)? updates,
  ]) => (BusinessUsersUIStateBuilder()..update(updates))._build();

  _$BusinessUsersUIState._({this.item, this.userRoles}) : super._();
  @override
  BusinessUsersUIState rebuild(
    void Function(BusinessUsersUIStateBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  BusinessUsersUIStateBuilder toBuilder() =>
      BusinessUsersUIStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BusinessUsersUIState &&
        item == other.item &&
        userRoles == other.userRoles;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, item.hashCode);
    _$hash = $jc(_$hash, userRoles.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BusinessUsersUIState')
          ..add('item', item)
          ..add('userRoles', userRoles))
        .toString();
  }
}

class BusinessUsersUIStateBuilder
    implements Builder<BusinessUsersUIState, BusinessUsersUIStateBuilder> {
  _$BusinessUsersUIState? _$v;

  UIEntityState<BusinessUser?>? _item;
  UIEntityState<BusinessUser?>? get item => _$this._item;
  set item(UIEntityState<BusinessUser?>? item) => _$this._item = item;

  List<BusinessUserRole>? _userRoles;
  List<BusinessUserRole>? get userRoles => _$this._userRoles;
  set userRoles(List<BusinessUserRole>? userRoles) =>
      _$this._userRoles = userRoles;

  BusinessUsersUIStateBuilder();

  BusinessUsersUIStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _item = $v.item;
      _userRoles = $v.userRoles;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BusinessUsersUIState other) {
    _$v = other as _$BusinessUsersUIState;
  }

  @override
  void update(void Function(BusinessUsersUIStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BusinessUsersUIState build() => _build();

  _$BusinessUsersUIState _build() {
    final _$result =
        _$v ?? _$BusinessUsersUIState._(item: item, userRoles: userRoles);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
