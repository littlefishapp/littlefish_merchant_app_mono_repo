import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/auth/auth_actions.dart';
import 'package:littlefish_merchant/common/presentaion/components/circle_gradient_avatar.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/long_text.dart';
import 'package:littlefish_merchant/app/custom_route.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../security/login/splash_page.dart';
import '../initial/go_initial_page.dart';

class OfflinePage extends StatelessWidget {
  static const String route = '/offline';

  const OfflinePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppSimpleAppScaffold(
      displayAppBar: false,
      body: Column(
        children: <Widget>[
          Expanded(child: centerSuccess(context)),
          SizedBox(child: tryAgain(context)),
          SizedBox(child: cancel(context)),
        ],
      ),
      title: '',
    );
  }

  Container centerSuccess(BuildContext context) => Container(
    alignment: Alignment.center,
    child: CircleAvatar(
      radius: 138.0,
      backgroundColor: Colors.transparent,
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 136.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: OutlineGradientAvatar(
                colors: const [Colors.red, Colors.orange],
                radius: 48,
                child: Icon(MdiIcons.wifiOff, size: 48, color: Colors.red),
              ),
            ),
            context.labelLarge(
              'We are offline',
              color: Theme.of(context).extension<AppliedTextIcon>()?.emphasized,
              alignLeft: true,
              isBold: true,
            ),
            context.labelMedium(
              'Please try again later',
              color: Theme.of(context).extension<AppliedTextIcon>()?.emphasized,
              alignLeft: true,
            ),
          ],
        ),
      ),
    ),
  );

  Container tryAgain(BuildContext context) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 8.0),
    alignment: Alignment.bottomCenter,
    child: ButtonPrimary(
      buttonColor: Theme.of(context).colorScheme.primary,
      text: 'Try Again',
      onTap: (context) => Navigator.of(context).push(
        CustomRoute(
          builder: (BuildContext context) => const GoInitialPage(),
          settings: const RouteSettings(name: GoInitialPage.route),
        ),
      ),
    ),
  );

  Container cancel(BuildContext context) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
    alignment: Alignment.bottomCenter,
    child: ButtonPrimary(
      buttonColor: Theme.of(context).colorScheme.primary,
      text: 'Cancel',
      onTap: (context) => StoreProvider.of<AppState>(
        context,
      ).dispatch(signOut(reason: 'offline-user-cancel')),
    ),
  );
}

class NoInternetPage extends StatelessWidget {
  static const String route = '/offline/nointernet';

  const NoInternetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppSimpleAppScaffold(
      displayAppBar: false,
      body: Stack(
        children: <Widget>[centerSuccess(context), buttonActions(context)],
      ),
      title: '',
    );
  }

  Container centerSuccess(BuildContext context) => Container(
    alignment: Alignment.center,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.signal_wifi_off,
          size: 128.0,
          color: Theme.of(context).extension<AppliedTextIcon>()?.brand,
        ),
        const LongText('You do not have internet access', fontSize: null),
      ],
    ),
  );

  Container buttonActions(BuildContext context) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 8.0),
    alignment: Alignment.bottomCenter,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        ButtonPrimary(
          buttonColor: Theme.of(context).colorScheme.primary,
          text: 'Try Again',
          onTap: (context) => Navigator.of(context).push(
            CustomRoute(
              builder: (BuildContext context) => const SplashPage(),
              settings: const RouteSettings(name: SplashPage.route),
            ),
          ),
        ),
      ],
    ),
  );
}

class CountryNotSupportedPage extends StatelessWidget {
  static const String route = '/country-not-supported';

  const CountryNotSupportedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppSimpleAppScaffold(
      displayAppBar: false,
      body: Stack(
        children: <Widget>[centerSuccess(context), buttonActions(context)],
      ),
      title: '',
    );
  }

  Container centerSuccess(BuildContext context) => Container(
    alignment: Alignment.center,
    child: OutlineGradientAvatar(
      radius: 138.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.public,
            size: 128.0,
            color: Theme.of(context).colorScheme.primary,
          ),
          const LongText(
            'We are not available in your country yet!',
            fontSize: null,
            maxLines: 2,
            alignment: TextAlign.center,
          ),
        ],
      ),
    ),
  );

  Container buttonActions(BuildContext context) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 8.0),
    alignment: Alignment.bottomCenter,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        ButtonPrimary(
          buttonColor: Theme.of(context).colorScheme.primary,
          text: 'Try Again',
          onTap: (context) => Navigator.of(context).push(
            CustomRoute(
              builder: (BuildContext context) => const GoInitialPage(),
              settings: const RouteSettings(name: GoInitialPage.route),
            ),
          ),
        ),
      ],
    ),
  );
}
