import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_merchant/bootstrap.dart';
import 'package:littlefish_merchant/ui/checkout/sell_page.dart';
import 'package:permission_handler/permission_handler.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/environment/environment_config.dart';
import 'package:littlefish_merchant/models/security/user/user_device.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/services/permissions_service.dart';

import '../../ui/home/home_page.dart';

final core = LittleFishCore.instance;

Future<void> initializeDeviceParams(
  double screenHeight,
  double screenWidth,
  Store<AppState> store,
) async {
  var isDesktop = Platform.isWindows || Platform.isLinux || Platform.isMacOS;
  var isPOS = AppVariables.isPOSBuild;
  var isMobile = !isDesktop && !isPOS;

  store.dispatch(SetOrientationsAction(screenHeight, screenWidth));
  store.dispatch(SetPlatformAction(isDesktop, isMobile));

  var info = await deviceInfo();
  store.dispatch(SetDeviceInfoAction(info!));

  // var permissions = await getDevicePermissions();
  // store.dispatch(SetDevicePermissions(permissions));

  await SystemChrome.setPreferredOrientations(
    store.state.environmentState.orientations ?? [],
  );
}

Future<List<Permission>> devicePermissions() async {
  return await getDevicePermissions();
}

Future<UserDevice?>? deviceInfo() async {
  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  UserDevice? info;

  if (Platform.isAndroid) {
    var droidInfo = await deviceInfoPlugin.androidInfo;

    info = UserDevice.fromAndroidInfo(droidInfo);
  } else if (Platform.isIOS) {
    info = UserDevice.fromIosDeviceInfo(await deviceInfoPlugin.iosInfo);
  } else if (Platform.isWindows) {
    info = UserDevice.fromWindows();
  }

  return info;
}

ThunkAction<AppState> onInternetStatusChanged({
  required bool isOnline,
  required bool hasAppInitialized,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      store.dispatch(SetInternetStatusAction(isOnline));
      var route =
          AppVariables.store!.state.permissions?.makeSale == true ||
              AppVariables.store!.state.permissions?.isAdmin == true
          ? SellPage.route
          : HomePage.route;

      if (!isOnline && hasAppInitialized) {
        Navigator.pushNamedAndRemoveUntil(
          globalNavigatorKey.currentContext!,
          route,
          ModalRoute.withName(route),
        );
      }
    });
  };
}

class SetEnvironmentConfigAction {
  EnvironmentConfig value;

  SetEnvironmentConfigAction(this.value);
}

class SetOrientationsAction {
  double screenHeight;
  double screenWidth;

  SetOrientationsAction(this.screenHeight, this.screenWidth);
}

class SetPlatformAction {
  bool isDesktop;
  bool isMobile;

  SetPlatformAction(this.isDesktop, this.isMobile);
}

class SetDeviceInfoAction {
  UserDevice value;

  SetDeviceInfoAction(this.value);
}

class SetDevicePermissions {
  List<Permission> value;

  SetDevicePermissions(this.value);
}

class SetInternetStatusAction {
  bool value;

  SetInternetStatusAction(this.value);
}

class SetEnvironmentAction {
  AppEnvironment value;

  SetEnvironmentAction(this.value);
}
