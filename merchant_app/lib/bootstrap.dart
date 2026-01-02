import 'dart:isolate';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_core/logging/services/logger_service.dart';
import 'package:littlefish_merchant/app/theme/theme_factory.dart';
import 'package:littlefish_merchant/environment/environment_config.dart';
import 'package:littlefish_merchant/environment/environment_themes.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:localstorage/localstorage.dart';

import 'app/app.dart';
import 'redux/user/user_state.dart';

final globalNavigatorKey = GlobalKey<NavigatorState>();

Future<void> bootstrapApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initLocalStorage();

  /// the next assignment will stop debugprint from outputting text
  if (!kDebugMode) {
    debugPrint = (String? message, {int? wrapWidth}) {};
  }

  debugPrint('#### App bootstrap -> Firebase.initializeApp() called');

  //ToDo: BMR confirm if this can be loaded else-where...
  await Firebase.initializeApp();

  await initialiseCore();
  await configureDependencies();

  var env = _setAppEnvironment();

  await SystemSound.play(SystemSoundType.alert);
  await SystemSound.play(SystemSoundType.click);

  FlutterError.onError = ((details) async {
    try {
      LoggerService logger = LittleFishCore.instance.get<LoggerService>();

      logger.error(
        'flutter-error.onError()',
        details.exceptionAsString(),
        error: details.exception,
        stackTrace: details.stack,
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  });

  //ToDo: confirm this works as expected or not...
  Isolate.current.addErrorListener(
    RawReceivePort((dynamic pair) {
      final List<dynamic> errorAndStacktrace = pair;

      try {
        LoggerService logger = LittleFishCore.instance.get<LoggerService>();

        logger.error(
          'flutter-onisolate.onError()',
          errorAndStacktrace.first.toString(),
          error: errorAndStacktrace.first,
          stackTrace: errorAndStacktrace.last,
        );
      } catch (e) {
        debugPrint(e.toString());
      }
    }).sendPort,
  );

  debugPrint('#### App bootstrap -> runApp() called');
  runApp(
    App(
      environment: env,
      initialState: null,
      initialViewingMode: UserViewingMode.full,
    ),
  );
}

AppEnvironment _setAppEnvironment() {
  var item = const String.fromEnvironment('APP_ENVIRONMENT');

  if (item == 'dev') return AppEnvironment.dev;
  if (item == 'prod') return AppEnvironment.prod;

  return AppEnvironment.local;
}
