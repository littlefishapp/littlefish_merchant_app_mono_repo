// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:built_value/built_value.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:permission_handler/permission_handler.dart';

// Project imports:
import 'package:littlefish_merchant/environment/environment_config.dart';
import 'package:littlefish_merchant/models/security/user/user_device.dart';

part 'environment_state.g.dart';

@immutable
abstract class EnvironmentState
    implements Built<EnvironmentState, EnvironmentStateBuilder> {
  const EnvironmentState._();

  factory EnvironmentState() => _$EnvironmentState._(
    hasError: false,
    isLoading: false,
    errorMessage: null,
    hasInternet: true,
  );

  AppEnvironment? get environment;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? get isLoading;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? get hasError;

  @JsonKey(includeFromJson: false, includeToJson: false)
  String? get errorMessage;

  @JsonKey(includeFromJson: false, includeToJson: false)
  EnvironmentConfig? get environmentConfig;

  double? get screenHeight;

  double? get screenWidth;

  bool? get isMobile;

  bool? get isDesktop;

  bool? get isLargeDisplay;

  @JsonKey(includeFromJson: false, includeToJson: false)
  List<DeviceOrientation>? get orientations;

  UserDevice? get deviceInfo;

  @JsonKey(includeFromJson: false, includeToJson: false)
  List<Permission>? get permissions;

  bool? get hasInternet;
}
