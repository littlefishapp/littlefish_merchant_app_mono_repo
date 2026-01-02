// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AuthState extends AuthState {
  @override
  final Timer? authTimer;
  @override
  final Timer? lockoutTimer;
  @override
  final bool? isLoading;
  @override
  final bool? hasError;
  @override
  final String? errorMessage;
  @override
  final String? token;
  @override
  final String? sessionId;
  @override
  final String? refreshToken;
  @override
  final String? userId;
  @override
  final String? userName;
  @override
  final DateTime? expirationTime;
  @override
  final bool? hasAppInitialized;
  @override
  final bool? otpRequired;
  @override
  final String? otpId;
  @override
  final Map<String, dynamic>? routes;
  @override
  final UserPermissions? permissions;
  @override
  final AccessManager? accessManager;
  @override
  final AuthUser<dynamic>? currentUser;
  @override
  final AuthUserInfo? userInfo;
  @override
  final String? signInProvider;
  @override
  final DateTime? issuedAtTime;
  @override
  final bool? hasTokenError;
  @override
  final DateTime? authTime;

  factory _$AuthState([void Function(AuthStateBuilder)? updates]) =>
      (AuthStateBuilder()..update(updates))._build();

  _$AuthState._({
    this.authTimer,
    this.lockoutTimer,
    this.isLoading,
    this.hasError,
    this.errorMessage,
    this.token,
    this.sessionId,
    this.refreshToken,
    this.userId,
    this.userName,
    this.expirationTime,
    this.hasAppInitialized,
    this.otpRequired,
    this.otpId,
    this.routes,
    this.permissions,
    this.accessManager,
    this.currentUser,
    this.userInfo,
    this.signInProvider,
    this.issuedAtTime,
    this.hasTokenError,
    this.authTime,
  }) : super._();
  @override
  AuthState rebuild(void Function(AuthStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AuthStateBuilder toBuilder() => AuthStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AuthState &&
        authTimer == other.authTimer &&
        lockoutTimer == other.lockoutTimer &&
        isLoading == other.isLoading &&
        hasError == other.hasError &&
        errorMessage == other.errorMessage &&
        token == other.token &&
        sessionId == other.sessionId &&
        refreshToken == other.refreshToken &&
        userId == other.userId &&
        userName == other.userName &&
        expirationTime == other.expirationTime &&
        hasAppInitialized == other.hasAppInitialized &&
        otpRequired == other.otpRequired &&
        otpId == other.otpId &&
        routes == other.routes &&
        permissions == other.permissions &&
        accessManager == other.accessManager &&
        currentUser == other.currentUser &&
        userInfo == other.userInfo &&
        signInProvider == other.signInProvider &&
        issuedAtTime == other.issuedAtTime &&
        hasTokenError == other.hasTokenError &&
        authTime == other.authTime;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, authTimer.hashCode);
    _$hash = $jc(_$hash, lockoutTimer.hashCode);
    _$hash = $jc(_$hash, isLoading.hashCode);
    _$hash = $jc(_$hash, hasError.hashCode);
    _$hash = $jc(_$hash, errorMessage.hashCode);
    _$hash = $jc(_$hash, token.hashCode);
    _$hash = $jc(_$hash, sessionId.hashCode);
    _$hash = $jc(_$hash, refreshToken.hashCode);
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jc(_$hash, userName.hashCode);
    _$hash = $jc(_$hash, expirationTime.hashCode);
    _$hash = $jc(_$hash, hasAppInitialized.hashCode);
    _$hash = $jc(_$hash, otpRequired.hashCode);
    _$hash = $jc(_$hash, otpId.hashCode);
    _$hash = $jc(_$hash, routes.hashCode);
    _$hash = $jc(_$hash, permissions.hashCode);
    _$hash = $jc(_$hash, accessManager.hashCode);
    _$hash = $jc(_$hash, currentUser.hashCode);
    _$hash = $jc(_$hash, userInfo.hashCode);
    _$hash = $jc(_$hash, signInProvider.hashCode);
    _$hash = $jc(_$hash, issuedAtTime.hashCode);
    _$hash = $jc(_$hash, hasTokenError.hashCode);
    _$hash = $jc(_$hash, authTime.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AuthState')
          ..add('authTimer', authTimer)
          ..add('lockoutTimer', lockoutTimer)
          ..add('isLoading', isLoading)
          ..add('hasError', hasError)
          ..add('errorMessage', errorMessage)
          ..add('token', token)
          ..add('sessionId', sessionId)
          ..add('refreshToken', refreshToken)
          ..add('userId', userId)
          ..add('userName', userName)
          ..add('expirationTime', expirationTime)
          ..add('hasAppInitialized', hasAppInitialized)
          ..add('otpRequired', otpRequired)
          ..add('otpId', otpId)
          ..add('routes', routes)
          ..add('permissions', permissions)
          ..add('accessManager', accessManager)
          ..add('currentUser', currentUser)
          ..add('userInfo', userInfo)
          ..add('signInProvider', signInProvider)
          ..add('issuedAtTime', issuedAtTime)
          ..add('hasTokenError', hasTokenError)
          ..add('authTime', authTime))
        .toString();
  }
}

class AuthStateBuilder implements Builder<AuthState, AuthStateBuilder> {
  _$AuthState? _$v;

  Timer? _authTimer;
  Timer? get authTimer => _$this._authTimer;
  set authTimer(Timer? authTimer) => _$this._authTimer = authTimer;

  Timer? _lockoutTimer;
  Timer? get lockoutTimer => _$this._lockoutTimer;
  set lockoutTimer(Timer? lockoutTimer) => _$this._lockoutTimer = lockoutTimer;

  bool? _isLoading;
  bool? get isLoading => _$this._isLoading;
  set isLoading(bool? isLoading) => _$this._isLoading = isLoading;

  bool? _hasError;
  bool? get hasError => _$this._hasError;
  set hasError(bool? hasError) => _$this._hasError = hasError;

  String? _errorMessage;
  String? get errorMessage => _$this._errorMessage;
  set errorMessage(String? errorMessage) => _$this._errorMessage = errorMessage;

  String? _token;
  String? get token => _$this._token;
  set token(String? token) => _$this._token = token;

  String? _sessionId;
  String? get sessionId => _$this._sessionId;
  set sessionId(String? sessionId) => _$this._sessionId = sessionId;

  String? _refreshToken;
  String? get refreshToken => _$this._refreshToken;
  set refreshToken(String? refreshToken) => _$this._refreshToken = refreshToken;

  String? _userId;
  String? get userId => _$this._userId;
  set userId(String? userId) => _$this._userId = userId;

  String? _userName;
  String? get userName => _$this._userName;
  set userName(String? userName) => _$this._userName = userName;

  DateTime? _expirationTime;
  DateTime? get expirationTime => _$this._expirationTime;
  set expirationTime(DateTime? expirationTime) =>
      _$this._expirationTime = expirationTime;

  bool? _hasAppInitialized;
  bool? get hasAppInitialized => _$this._hasAppInitialized;
  set hasAppInitialized(bool? hasAppInitialized) =>
      _$this._hasAppInitialized = hasAppInitialized;

  bool? _otpRequired;
  bool? get otpRequired => _$this._otpRequired;
  set otpRequired(bool? otpRequired) => _$this._otpRequired = otpRequired;

  String? _otpId;
  String? get otpId => _$this._otpId;
  set otpId(String? otpId) => _$this._otpId = otpId;

  Map<String, dynamic>? _routes;
  Map<String, dynamic>? get routes => _$this._routes;
  set routes(Map<String, dynamic>? routes) => _$this._routes = routes;

  UserPermissions? _permissions;
  UserPermissions? get permissions => _$this._permissions;
  set permissions(UserPermissions? permissions) =>
      _$this._permissions = permissions;

  AccessManager? _accessManager;
  AccessManager? get accessManager => _$this._accessManager;
  set accessManager(AccessManager? accessManager) =>
      _$this._accessManager = accessManager;

  AuthUser<dynamic>? _currentUser;
  AuthUser<dynamic>? get currentUser => _$this._currentUser;
  set currentUser(AuthUser<dynamic>? currentUser) =>
      _$this._currentUser = currentUser;

  AuthUserInfo? _userInfo;
  AuthUserInfo? get userInfo => _$this._userInfo;
  set userInfo(AuthUserInfo? userInfo) => _$this._userInfo = userInfo;

  String? _signInProvider;
  String? get signInProvider => _$this._signInProvider;
  set signInProvider(String? signInProvider) =>
      _$this._signInProvider = signInProvider;

  DateTime? _issuedAtTime;
  DateTime? get issuedAtTime => _$this._issuedAtTime;
  set issuedAtTime(DateTime? issuedAtTime) =>
      _$this._issuedAtTime = issuedAtTime;

  bool? _hasTokenError;
  bool? get hasTokenError => _$this._hasTokenError;
  set hasTokenError(bool? hasTokenError) =>
      _$this._hasTokenError = hasTokenError;

  DateTime? _authTime;
  DateTime? get authTime => _$this._authTime;
  set authTime(DateTime? authTime) => _$this._authTime = authTime;

  AuthStateBuilder();

  AuthStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _authTimer = $v.authTimer;
      _lockoutTimer = $v.lockoutTimer;
      _isLoading = $v.isLoading;
      _hasError = $v.hasError;
      _errorMessage = $v.errorMessage;
      _token = $v.token;
      _sessionId = $v.sessionId;
      _refreshToken = $v.refreshToken;
      _userId = $v.userId;
      _userName = $v.userName;
      _expirationTime = $v.expirationTime;
      _hasAppInitialized = $v.hasAppInitialized;
      _otpRequired = $v.otpRequired;
      _otpId = $v.otpId;
      _routes = $v.routes;
      _permissions = $v.permissions;
      _accessManager = $v.accessManager;
      _currentUser = $v.currentUser;
      _userInfo = $v.userInfo;
      _signInProvider = $v.signInProvider;
      _issuedAtTime = $v.issuedAtTime;
      _hasTokenError = $v.hasTokenError;
      _authTime = $v.authTime;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AuthState other) {
    _$v = other as _$AuthState;
  }

  @override
  void update(void Function(AuthStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AuthState build() => _build();

  _$AuthState _build() {
    final _$result =
        _$v ??
        _$AuthState._(
          authTimer: authTimer,
          lockoutTimer: lockoutTimer,
          isLoading: isLoading,
          hasError: hasError,
          errorMessage: errorMessage,
          token: token,
          sessionId: sessionId,
          refreshToken: refreshToken,
          userId: userId,
          userName: userName,
          expirationTime: expirationTime,
          hasAppInitialized: hasAppInitialized,
          otpRequired: otpRequired,
          otpId: otpId,
          routes: routes,
          permissions: permissions,
          accessManager: accessManager,
          currentUser: currentUser,
          userInfo: userInfo,
          signInProvider: signInProvider,
          issuedAtTime: issuedAtTime,
          hasTokenError: hasTokenError,
          authTime: authTime,
        );
    replace(_$result);
    return _$result;
  }
}

class _$AuthUIState extends AuthUIState {
  @override
  final bool? isLoading;
  @override
  final bool? hasError;
  @override
  final String? errorMessage;
  @override
  final String? userName;
  @override
  final String? password;
  @override
  final String? pin;
  @override
  final LoginProvider? loginProvider;
  @override
  final String? otpIdentifier;
  @override
  final BankMerchant? bankMerchant;
  @override
  final List<GenerateOTPRequest>? merchantOTPContactInfo;

  factory _$AuthUIState([void Function(AuthUIStateBuilder)? updates]) =>
      (AuthUIStateBuilder()..update(updates))._build();

  _$AuthUIState._({
    this.isLoading,
    this.hasError,
    this.errorMessage,
    this.userName,
    this.password,
    this.pin,
    this.loginProvider,
    this.otpIdentifier,
    this.bankMerchant,
    this.merchantOTPContactInfo,
  }) : super._();
  @override
  AuthUIState rebuild(void Function(AuthUIStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AuthUIStateBuilder toBuilder() => AuthUIStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AuthUIState &&
        isLoading == other.isLoading &&
        hasError == other.hasError &&
        errorMessage == other.errorMessage &&
        userName == other.userName &&
        password == other.password &&
        pin == other.pin &&
        loginProvider == other.loginProvider &&
        otpIdentifier == other.otpIdentifier &&
        bankMerchant == other.bankMerchant &&
        merchantOTPContactInfo == other.merchantOTPContactInfo;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, isLoading.hashCode);
    _$hash = $jc(_$hash, hasError.hashCode);
    _$hash = $jc(_$hash, errorMessage.hashCode);
    _$hash = $jc(_$hash, userName.hashCode);
    _$hash = $jc(_$hash, password.hashCode);
    _$hash = $jc(_$hash, pin.hashCode);
    _$hash = $jc(_$hash, loginProvider.hashCode);
    _$hash = $jc(_$hash, otpIdentifier.hashCode);
    _$hash = $jc(_$hash, bankMerchant.hashCode);
    _$hash = $jc(_$hash, merchantOTPContactInfo.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AuthUIState')
          ..add('isLoading', isLoading)
          ..add('hasError', hasError)
          ..add('errorMessage', errorMessage)
          ..add('userName', userName)
          ..add('password', password)
          ..add('pin', pin)
          ..add('loginProvider', loginProvider)
          ..add('otpIdentifier', otpIdentifier)
          ..add('bankMerchant', bankMerchant)
          ..add('merchantOTPContactInfo', merchantOTPContactInfo))
        .toString();
  }
}

class AuthUIStateBuilder implements Builder<AuthUIState, AuthUIStateBuilder> {
  _$AuthUIState? _$v;

  bool? _isLoading;
  bool? get isLoading => _$this._isLoading;
  set isLoading(bool? isLoading) => _$this._isLoading = isLoading;

  bool? _hasError;
  bool? get hasError => _$this._hasError;
  set hasError(bool? hasError) => _$this._hasError = hasError;

  String? _errorMessage;
  String? get errorMessage => _$this._errorMessage;
  set errorMessage(String? errorMessage) => _$this._errorMessage = errorMessage;

  String? _userName;
  String? get userName => _$this._userName;
  set userName(String? userName) => _$this._userName = userName;

  String? _password;
  String? get password => _$this._password;
  set password(String? password) => _$this._password = password;

  String? _pin;
  String? get pin => _$this._pin;
  set pin(String? pin) => _$this._pin = pin;

  LoginProvider? _loginProvider;
  LoginProvider? get loginProvider => _$this._loginProvider;
  set loginProvider(LoginProvider? loginProvider) =>
      _$this._loginProvider = loginProvider;

  String? _otpIdentifier;
  String? get otpIdentifier => _$this._otpIdentifier;
  set otpIdentifier(String? otpIdentifier) =>
      _$this._otpIdentifier = otpIdentifier;

  BankMerchant? _bankMerchant;
  BankMerchant? get bankMerchant => _$this._bankMerchant;
  set bankMerchant(BankMerchant? bankMerchant) =>
      _$this._bankMerchant = bankMerchant;

  List<GenerateOTPRequest>? _merchantOTPContactInfo;
  List<GenerateOTPRequest>? get merchantOTPContactInfo =>
      _$this._merchantOTPContactInfo;
  set merchantOTPContactInfo(
    List<GenerateOTPRequest>? merchantOTPContactInfo,
  ) => _$this._merchantOTPContactInfo = merchantOTPContactInfo;

  AuthUIStateBuilder();

  AuthUIStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _isLoading = $v.isLoading;
      _hasError = $v.hasError;
      _errorMessage = $v.errorMessage;
      _userName = $v.userName;
      _password = $v.password;
      _pin = $v.pin;
      _loginProvider = $v.loginProvider;
      _otpIdentifier = $v.otpIdentifier;
      _bankMerchant = $v.bankMerchant;
      _merchantOTPContactInfo = $v.merchantOTPContactInfo;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AuthUIState other) {
    _$v = other as _$AuthUIState;
  }

  @override
  void update(void Function(AuthUIStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AuthUIState build() => _build();

  _$AuthUIState _build() {
    final _$result =
        _$v ??
        _$AuthUIState._(
          isLoading: isLoading,
          hasError: hasError,
          errorMessage: errorMessage,
          userName: userName,
          password: password,
          pin: pin,
          loginProvider: loginProvider,
          otpIdentifier: otpIdentifier,
          bankMerchant: bankMerchant,
          merchantOTPContactInfo: merchantOTPContactInfo,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthState _$AuthStateFromJson(Map<String, dynamic> json) => AuthState();

Map<String, dynamic> _$AuthStateToJson(AuthState instance) =>
    <String, dynamic>{};
