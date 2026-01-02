// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/redux/environment/environment_actions.dart';
import 'package:littlefish_merchant/redux/environment/environment_state.dart';

final environmentReducer = combineReducers<EnvironmentState>([
  TypedReducer<EnvironmentState, SetEnvironmentConfigAction>(
    onSetEnvironmentConfig,
  ).call,
  TypedReducer<EnvironmentState, SetOrientationsAction>(
    onSetDeviceOrientations,
  ).call,
  TypedReducer<EnvironmentState, SetPlatformAction>(onSetPlatform).call,
  TypedReducer<EnvironmentState, SetDeviceInfoAction>(onSetDevice).call,
  TypedReducer<EnvironmentState, SetInternetStatusAction>(
    onSetInternetStatus,
  ).call,
  TypedReducer<EnvironmentState, SetEnvironmentAction>(onSetEnvironment).call,
]);

EnvironmentState onSetEnvironmentConfig(
  EnvironmentState state,
  SetEnvironmentConfigAction action,
) {
  return state.rebuild((b) => b.environmentConfig = action.value);
}

EnvironmentState onSetDeviceOrientations(
  EnvironmentState state,
  SetOrientationsAction action,
) {
  return state.rebuild((b) {
    b.screenHeight = action.screenHeight;
    b.screenWidth = action.screenWidth;
    b.isLargeDisplay = b.screenWidth! > 600;

    b.orientations = b.isLargeDisplay!
        ? [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]
        : [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown];

    EnvironmentProvider.instance.orientations = b.orientations;
    EnvironmentProvider.instance.screenHeight = b.screenHeight;
    EnvironmentProvider.instance.screenWidth = b.screenWidth;

    EnvironmentProvider.instance.setScreenSize();
    //EnvironmentProvider.instance.isLargeDisplay = b.isLargeDisplay ?? false;
    b.isLargeDisplay = EnvironmentProvider.instance.isLargeDisplay;
  });
}

EnvironmentState onSetPlatform(
  EnvironmentState state,
  SetPlatformAction action,
) {
  return state.rebuild((b) {
    b.isMobile = action.isMobile;
    b.isDesktop = action.isDesktop;

    EnvironmentProvider.instance.isMobile = b.isMobile;
    EnvironmentProvider.instance.isDesktop = b.isDesktop;
  });
}

EnvironmentState onSetDevice(
  EnvironmentState state,
  SetDeviceInfoAction action,
) {
  return state.rebuild((b) => b.deviceInfo = action.value);
}

EnvironmentState onSetInternetStatus(
  EnvironmentState state,
  SetInternetStatusAction action,
) => state.rebuild((b) => b.hasInternet = action.value);

EnvironmentState onSetEnvironment(
  EnvironmentState state,
  SetEnvironmentAction action,
) => state.rebuild((b) {
  b.environment = action.value;
});
