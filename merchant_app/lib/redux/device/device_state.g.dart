// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DeviceState extends DeviceState {
  @override
  final bool? isLoading;
  @override
  final bool? hasError;
  @override
  final String? errorMessage;
  @override
  final DeviceDetails? deviceDetails;

  factory _$DeviceState([void Function(DeviceStateBuilder)? updates]) =>
      (DeviceStateBuilder()..update(updates))._build();

  _$DeviceState._({
    this.isLoading,
    this.hasError,
    this.errorMessage,
    this.deviceDetails,
  }) : super._();
  @override
  DeviceState rebuild(void Function(DeviceStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DeviceStateBuilder toBuilder() => DeviceStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DeviceState &&
        isLoading == other.isLoading &&
        hasError == other.hasError &&
        errorMessage == other.errorMessage &&
        deviceDetails == other.deviceDetails;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, isLoading.hashCode);
    _$hash = $jc(_$hash, hasError.hashCode);
    _$hash = $jc(_$hash, errorMessage.hashCode);
    _$hash = $jc(_$hash, deviceDetails.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DeviceState')
          ..add('isLoading', isLoading)
          ..add('hasError', hasError)
          ..add('errorMessage', errorMessage)
          ..add('deviceDetails', deviceDetails))
        .toString();
  }
}

class DeviceStateBuilder implements Builder<DeviceState, DeviceStateBuilder> {
  _$DeviceState? _$v;

  bool? _isLoading;
  bool? get isLoading => _$this._isLoading;
  set isLoading(bool? isLoading) => _$this._isLoading = isLoading;

  bool? _hasError;
  bool? get hasError => _$this._hasError;
  set hasError(bool? hasError) => _$this._hasError = hasError;

  String? _errorMessage;
  String? get errorMessage => _$this._errorMessage;
  set errorMessage(String? errorMessage) => _$this._errorMessage = errorMessage;

  DeviceDetails? _deviceDetails;
  DeviceDetails? get deviceDetails => _$this._deviceDetails;
  set deviceDetails(DeviceDetails? deviceDetails) =>
      _$this._deviceDetails = deviceDetails;

  DeviceStateBuilder();

  DeviceStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _isLoading = $v.isLoading;
      _hasError = $v.hasError;
      _errorMessage = $v.errorMessage;
      _deviceDetails = $v.deviceDetails;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DeviceState other) {
    _$v = other as _$DeviceState;
  }

  @override
  void update(void Function(DeviceStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DeviceState build() => _build();

  _$DeviceState _build() {
    final _$result =
        _$v ??
        _$DeviceState._(
          isLoading: isLoading,
          hasError: hasError,
          errorMessage: errorMessage,
          deviceDetails: deviceDetails,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceState _$DeviceStateFromJson(Map<String, dynamic> json) => DeviceState();

Map<String, dynamic> _$DeviceStateToJson(DeviceState instance) =>
    <String, dynamic>{};
