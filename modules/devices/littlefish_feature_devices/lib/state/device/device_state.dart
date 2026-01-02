// Package imports:
import 'package:built_value/built_value.dart';
import 'package:json_annotation/json_annotation.dart';

// Project imports:

import '../../models/device/interfaces/device_details.dart';

part 'device_state.g.dart';

@JsonSerializable()
abstract class DeviceState implements Built<DeviceState, DeviceStateBuilder> {
  DeviceState._();

  factory DeviceState() => _$DeviceState._(
    hasError: false,
    isLoading: false,
    errorMessage: null,
    deviceDetails: null,
  );

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? get isLoading;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? get hasError;

  @JsonKey(includeFromJson: false, includeToJson: false)
  String? get errorMessage;

  @JsonKey(includeFromJson: false, includeToJson: false)
  DeviceDetails? get deviceDetails;
}
