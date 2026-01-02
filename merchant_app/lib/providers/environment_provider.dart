import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:littlefish_merchant/environment/environment_config.dart';

enum DeviceSize { extraSmall, small, standard, large }

class EnvironmentProvider with ChangeNotifier {
  static final EnvironmentProvider instance = EnvironmentProvider._internal();

  EnvironmentProvider._internal();

  factory EnvironmentProvider({required EnvironmentConfig config}) {
    instance.config = config;
    return instance;
  }

  static EnvironmentProvider of(BuildContext context, {bool listen = true}) =>
      Provider.of<EnvironmentProvider>(context, listen: listen);

  EnvironmentConfig? config;

  double? screenHeight;

  double? screenWidth;

  bool? isMobile;

  bool? isDesktop;

  bool isLargeDisplay = false;
  bool isSmallDisplay = false;
  bool isXsmallDisplay = false;

  List<DeviceOrientation>? orientations;

  void setOrientations(BuildContext context) {
    var currentOrientation = MediaQuery.of(context).orientation;

    if (currentOrientation == Orientation.landscape) {
      screenWidth = MediaQuery.of(context).size.height;
      screenHeight = MediaQuery.of(context).size.width;
    } else {
      screenHeight = MediaQuery.of(context).size.height;
      screenWidth = MediaQuery.of(context).size.width;
    }

    setScreenSize();

    orientations = isLargeDisplay
        ? [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]
        : [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown];
  }

  void initialize(BuildContext context) async {
    isDesktop = Platform.isWindows || Platform.isLinux || Platform.isMacOS;
    isMobile = !isDesktop!;

    var currentOrientation = MediaQuery.of(context).orientation;

    if (currentOrientation == Orientation.landscape) {
      screenWidth = MediaQuery.of(context).size.height;
      screenHeight = MediaQuery.of(context).size.width;
    } else {
      screenHeight = MediaQuery.of(context).size.height;
      screenWidth = MediaQuery.of(context).size.width;
    }

    setScreenSize();

    orientations = isLargeDisplay!
        ? [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]
        : [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown];
  }

  void setScreenSize() {
    isLargeDisplay = screenWidth == null ? false : screenWidth! > 600;
    isLargeDisplay = screenWidth == null ? false : screenWidth! > 600;
  }
}
