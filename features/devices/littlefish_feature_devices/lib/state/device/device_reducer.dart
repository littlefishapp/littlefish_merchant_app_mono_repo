// removed ignore: depend_on_referenced_packages

import 'package:littlefish_merchant/redux/device/device_state.dart';
import 'package:redux/redux.dart';

import 'device_actions.dart';

final deviceReducer = combineReducers<DeviceState>([
  TypedReducer<DeviceState, SetDeviceDetails>(onSetDeviceDetails).call,
  TypedReducer<DeviceState, DeviceStateFailureAction>(onFailure).call,
]);

DeviceState onSetDeviceDetails(DeviceState state, SetDeviceDetails action) {
  return state.rebuild((b) => b.deviceDetails = action.deviceDetails);
}

DeviceState onFailure(DeviceState state, DeviceStateFailureAction action) =>
    state.rebuild((b) {
      b.hasError = true;
      b.errorMessage = action.value;
      b.isLoading = false;
    });
