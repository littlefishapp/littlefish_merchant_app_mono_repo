import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/app/init_app_loading.dart';
import 'package:littlefish_merchant/app/theme/theme_factory.dart';
import 'package:littlefish_merchant/environment/environment_themes.dart';
import 'package:littlefish_merchant/features/initial_pages/domain/use_case/loading.dart';
import 'package:littlefish_merchant/redux/app_settings/app_settings_actions.dart';
import 'package:littlefish_merchant/ui/security/login/landing_page.dart';
import 'package:littlefish_merchant/ui/security/login/splash_page.dart';
import 'package:redux/redux.dart';
import 'package:littlefish_merchant/redux/app/app_actions.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/common/presentaion/components/completers.dart';

class InitialPage extends StatefulWidget {
  static const route = '/';

  final String? message;

  const InitialPage({Key? key, this.message}) : super(key: key);

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  final ValueNotifier<String> settingUpMessage = ValueNotifier<String>(
    'We\'re setting up your app. \nIf this takes long, please check your internet and try again.',
  );

  @override
  void dispose() {
    settingUpMessage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<AppState>(
      rebuildOnChange: false,
      onInitialBuild: (Store<AppState> store) {
        final screenHeight = MediaQuery.of(context).size.height;
        final screenWidth = MediaQuery.of(context).size.width;

        store.dispatch(
          preInitialize(
            screenHeight,
            screenWidth,
            completer: navigateCompleter(
              context,
              SplashPage.route,
              onFailedRoute: LandingPage.route,
            ),
          ),
        );
      },
      builder: (BuildContext context, Store<AppState> store) {
        return loadingWithMessage(settingUpMessage.value);
      },
    );
  }

  MaterialApp appErrorView() {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);
        return MediaQuery(
          data: mediaQuery.copyWith(
            textScaler: mediaQuery.textScaler.clamp(
              minScaleFactor: 1.0,
              maxScaleFactor: 1.2,
            ),
          ),
          child: child!,
        );
      },
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(LittleFishIcons.error, size: 48),
            const SizedBox(height: 16),
            Text(
              settingUpMessage.value,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  MaterialApp appWaitingView() {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: ValueListenableBuilder<String>(
          valueListenable: settingUpMessage,
          builder: (context, value, _) {
            final appInitInProgress = value.contains('dependencies');
            if (appInitInProgress) {
              return InitAppLoading(message: value);
            } else {
              return loading(settingUpMessage);
            }
          },
        ),
      ),
    );
  }
}
