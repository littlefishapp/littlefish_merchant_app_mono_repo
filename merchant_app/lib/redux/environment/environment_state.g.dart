// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'environment_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EnvironmentState extends EnvironmentState {
  @override
  final AppEnvironment? environment;
  @override
  final bool? isLoading;
  @override
  final bool? hasError;
  @override
  final String? errorMessage;
  @override
  final EnvironmentConfig? environmentConfig;
  @override
  final double? screenHeight;
  @override
  final double? screenWidth;
  @override
  final bool? isMobile;
  @override
  final bool? isDesktop;
  @override
  final bool? isLargeDisplay;
  @override
  final List<DeviceOrientation>? orientations;
  @override
  final UserDevice? deviceInfo;
  @override
  final List<Permission>? permissions;
  @override
  final bool? hasInternet;

  factory _$EnvironmentState([
    void Function(EnvironmentStateBuilder)? updates,
  ]) => (EnvironmentStateBuilder()..update(updates))._build();

  _$EnvironmentState._({
    this.environment,
    this.isLoading,
    this.hasError,
    this.errorMessage,
    this.environmentConfig,
    this.screenHeight,
    this.screenWidth,
    this.isMobile,
    this.isDesktop,
    this.isLargeDisplay,
    this.orientations,
    this.deviceInfo,
    this.permissions,
    this.hasInternet,
  }) : super._();
  @override
  EnvironmentState rebuild(void Function(EnvironmentStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EnvironmentStateBuilder toBuilder() =>
      EnvironmentStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EnvironmentState &&
        environment == other.environment &&
        isLoading == other.isLoading &&
        hasError == other.hasError &&
        errorMessage == other.errorMessage &&
        environmentConfig == other.environmentConfig &&
        screenHeight == other.screenHeight &&
        screenWidth == other.screenWidth &&
        isMobile == other.isMobile &&
        isDesktop == other.isDesktop &&
        isLargeDisplay == other.isLargeDisplay &&
        orientations == other.orientations &&
        deviceInfo == other.deviceInfo &&
        permissions == other.permissions &&
        hasInternet == other.hasInternet;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, environment.hashCode);
    _$hash = $jc(_$hash, isLoading.hashCode);
    _$hash = $jc(_$hash, hasError.hashCode);
    _$hash = $jc(_$hash, errorMessage.hashCode);
    _$hash = $jc(_$hash, environmentConfig.hashCode);
    _$hash = $jc(_$hash, screenHeight.hashCode);
    _$hash = $jc(_$hash, screenWidth.hashCode);
    _$hash = $jc(_$hash, isMobile.hashCode);
    _$hash = $jc(_$hash, isDesktop.hashCode);
    _$hash = $jc(_$hash, isLargeDisplay.hashCode);
    _$hash = $jc(_$hash, orientations.hashCode);
    _$hash = $jc(_$hash, deviceInfo.hashCode);
    _$hash = $jc(_$hash, permissions.hashCode);
    _$hash = $jc(_$hash, hasInternet.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EnvironmentState')
          ..add('environment', environment)
          ..add('isLoading', isLoading)
          ..add('hasError', hasError)
          ..add('errorMessage', errorMessage)
          ..add('environmentConfig', environmentConfig)
          ..add('screenHeight', screenHeight)
          ..add('screenWidth', screenWidth)
          ..add('isMobile', isMobile)
          ..add('isDesktop', isDesktop)
          ..add('isLargeDisplay', isLargeDisplay)
          ..add('orientations', orientations)
          ..add('deviceInfo', deviceInfo)
          ..add('permissions', permissions)
          ..add('hasInternet', hasInternet))
        .toString();
  }
}

class EnvironmentStateBuilder
    implements Builder<EnvironmentState, EnvironmentStateBuilder> {
  _$EnvironmentState? _$v;

  AppEnvironment? _environment;
  AppEnvironment? get environment => _$this._environment;
  set environment(AppEnvironment? environment) =>
      _$this._environment = environment;

  bool? _isLoading;
  bool? get isLoading => _$this._isLoading;
  set isLoading(bool? isLoading) => _$this._isLoading = isLoading;

  bool? _hasError;
  bool? get hasError => _$this._hasError;
  set hasError(bool? hasError) => _$this._hasError = hasError;

  String? _errorMessage;
  String? get errorMessage => _$this._errorMessage;
  set errorMessage(String? errorMessage) => _$this._errorMessage = errorMessage;

  EnvironmentConfig? _environmentConfig;
  EnvironmentConfig? get environmentConfig => _$this._environmentConfig;
  set environmentConfig(EnvironmentConfig? environmentConfig) =>
      _$this._environmentConfig = environmentConfig;

  double? _screenHeight;
  double? get screenHeight => _$this._screenHeight;
  set screenHeight(double? screenHeight) => _$this._screenHeight = screenHeight;

  double? _screenWidth;
  double? get screenWidth => _$this._screenWidth;
  set screenWidth(double? screenWidth) => _$this._screenWidth = screenWidth;

  bool? _isMobile;
  bool? get isMobile => _$this._isMobile;
  set isMobile(bool? isMobile) => _$this._isMobile = isMobile;

  bool? _isDesktop;
  bool? get isDesktop => _$this._isDesktop;
  set isDesktop(bool? isDesktop) => _$this._isDesktop = isDesktop;

  bool? _isLargeDisplay;
  bool? get isLargeDisplay => _$this._isLargeDisplay;
  set isLargeDisplay(bool? isLargeDisplay) =>
      _$this._isLargeDisplay = isLargeDisplay;

  List<DeviceOrientation>? _orientations;
  List<DeviceOrientation>? get orientations => _$this._orientations;
  set orientations(List<DeviceOrientation>? orientations) =>
      _$this._orientations = orientations;

  UserDevice? _deviceInfo;
  UserDevice? get deviceInfo => _$this._deviceInfo;
  set deviceInfo(UserDevice? deviceInfo) => _$this._deviceInfo = deviceInfo;

  List<Permission>? _permissions;
  List<Permission>? get permissions => _$this._permissions;
  set permissions(List<Permission>? permissions) =>
      _$this._permissions = permissions;

  bool? _hasInternet;
  bool? get hasInternet => _$this._hasInternet;
  set hasInternet(bool? hasInternet) => _$this._hasInternet = hasInternet;

  EnvironmentStateBuilder();

  EnvironmentStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _environment = $v.environment;
      _isLoading = $v.isLoading;
      _hasError = $v.hasError;
      _errorMessage = $v.errorMessage;
      _environmentConfig = $v.environmentConfig;
      _screenHeight = $v.screenHeight;
      _screenWidth = $v.screenWidth;
      _isMobile = $v.isMobile;
      _isDesktop = $v.isDesktop;
      _isLargeDisplay = $v.isLargeDisplay;
      _orientations = $v.orientations;
      _deviceInfo = $v.deviceInfo;
      _permissions = $v.permissions;
      _hasInternet = $v.hasInternet;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EnvironmentState other) {
    _$v = other as _$EnvironmentState;
  }

  @override
  void update(void Function(EnvironmentStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EnvironmentState build() => _build();

  _$EnvironmentState _build() {
    final _$result =
        _$v ??
        _$EnvironmentState._(
          environment: environment,
          isLoading: isLoading,
          hasError: hasError,
          errorMessage: errorMessage,
          environmentConfig: environmentConfig,
          screenHeight: screenHeight,
          screenWidth: screenWidth,
          isMobile: isMobile,
          isDesktop: isDesktop,
          isLargeDisplay: isLargeDisplay,
          orientations: orientations,
          deviceInfo: deviceInfo,
          permissions: permissions,
          hasInternet: hasInternet,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
