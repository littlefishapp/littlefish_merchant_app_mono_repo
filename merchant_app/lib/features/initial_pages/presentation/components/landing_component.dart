import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/bootstrap.dart';
import 'package:littlefish_merchant/common/presentaion/components/banner_panel.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_secondary.dart';
import 'package:littlefish_merchant/features/initial_pages/domain/entities/landing_entity.dart';
import 'package:littlefish_merchant/features/initial_pages/domain/use_case/banner.dart';
import 'package:littlefish_merchant/features/initial_pages/domain/use_case/loading.dart';
import 'package:littlefish_merchant/features/initial_pages/domain/use_case/logo.dart';
import 'package:littlefish_merchant/features/initial_pages/domain/use_case/terms_and_conditions.dart';
import 'package:littlefish_merchant/features/initial_pages/domain/use_case/welcome.dart';
import 'package:littlefish_merchant/models/assets/app_assets.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/redux/auth/auth_actions.dart';
import 'package:littlefish_merchant/ui/online_store/shared/routes/custom_route.dart';
import 'package:littlefish_merchant/ui/security/guestLogin/pages/guest_login_page.dart';
import 'package:littlefish_merchant/ui/security/login/login_page.dart';
import 'package:littlefish_merchant/ui/security/login/viewmodels/login_viewmodel.dart';
import 'package:littlefish_merchant/ui/security/registration/activation_offline_page.dart';
import 'package:littlefish_merchant/ui/security/registration/getting_started_page.dart';
import 'package:littlefish_merchant/ui/security/registration/register_page.dart';

enum _LayoutMode { stacked, splitLeftBanner, splitTopBanner, fullBleed }

class LandingComponent extends StatelessWidget {
  final LandingEntity config;
  final bool isLoading;
  final LoginVM loginVM;

  const LandingComponent({
    Key? key,
    required this.config,
    required this.isLoading,
    required this.loginVM,
  }) : super(key: key);

  _LayoutMode _decideLayoutMode(BuildContext context, LandingEntity config) {
    final isLargeDisplay = EnvironmentProvider.instance.isLargeDisplay;
    // TODO: Add isMediumDisplay if available

    if (!isLargeDisplay) return _LayoutMode.stacked;

    final ratio = config.largeDisplayBannerRatio.clamp(0.0, 1.0);
    if (ratio <= 0.01) return _LayoutMode.stacked;
    if (ratio >= 0.95) return _LayoutMode.fullBleed;

    return config.bannerOnLeftSide
        ? _LayoutMode.splitLeftBanner
        : _LayoutMode.splitTopBanner;
  }

  @override
  Widget build(BuildContext context) {
    final registerOrOpenAccountVisible =
        AppVariables.store!.state.enableSignupActivation!;
    final guestCashierEnabled = AppVariables.store!.state.enableGuestUser!;
    final getStartedVisible = AppVariables.store!.state.enableSignup!;

    final mode = _decideLayoutMode(context, config);

    return Scaffold(
      backgroundColor:
          Theme.of(context).extension<AppliedSurface>()?.primary ??
          Colors.white,
      resizeToAvoidBottomInset: true,
      body: isLoading
          ? loadingWithMessage('Getting things ready...')
          : switch (mode) {
              _LayoutMode.stacked => _buildStacked(
                context: context,
                registerOrOpenAccountVisible: registerOrOpenAccountVisible,
                guestCashierEnabled: guestCashierEnabled,
                getStartedVisible: getStartedVisible,
              ),
              _LayoutMode.splitLeftBanner => _buildSplitLeft(
                context: context,
                registerOrOpenAccountVisible: registerOrOpenAccountVisible,
                guestCashierEnabled: guestCashierEnabled,
                getStartedVisible: getStartedVisible,
              ),
              _LayoutMode.splitTopBanner => _buildSplitTop(
                context: context,
                registerOrOpenAccountVisible: registerOrOpenAccountVisible,
                guestCashierEnabled: guestCashierEnabled,
                getStartedVisible: getStartedVisible,
              ),
              _LayoutMode.fullBleed => _buildFullBleed(
                context: context,
                registerOrOpenAccountVisible: registerOrOpenAccountVisible,
                guestCashierEnabled: guestCashierEnabled,
                getStartedVisible: getStartedVisible,
              ),
            },
    );
  }

  Widget _buildStacked({
    required BuildContext context,
    required bool registerOrOpenAccountVisible,
    required bool guestCashierEnabled,
    required bool getStartedVisible,
  }) {
    return Container(
      decoration: config.decorationEnabled ? _backgroundDecoration() : null,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: config.alignTop
                ? MainAxisAlignment.start
                : MainAxisAlignment.center,
            children: _sharedContentChildren(
              context: context,
              registerOrOpenAccountVisible: registerOrOpenAccountVisible,
              guestCashierEnabled: guestCashierEnabled,
              getStartedVisible: getStartedVisible,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSplitLeft({
    required BuildContext context,
    required bool registerOrOpenAccountVisible,
    required bool guestCashierEnabled,
    required bool getStartedVisible,
  }) {
    final ratio = config.largeDisplayBannerRatio.clamp(0.3, 0.6);
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * ratio,
          child: BannerPanel(),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _sharedContentChildren(
                context: context,
                registerOrOpenAccountVisible: registerOrOpenAccountVisible,
                guestCashierEnabled: guestCashierEnabled,
                getStartedVisible: getStartedVisible,
                removeTopVisuals: false,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSplitTop({
    required BuildContext context,
    required bool registerOrOpenAccountVisible,
    required bool guestCashierEnabled,
    required bool getStartedVisible,
  }) {
    return Column(
      children: [
        Expanded(flex: 4, child: BannerPanel()),
        Expanded(
          flex: 6,
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _sharedContentChildren(
                context: context,
                registerOrOpenAccountVisible: registerOrOpenAccountVisible,
                guestCashierEnabled: guestCashierEnabled,
                getStartedVisible: getStartedVisible,
                removeTopVisuals: false,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFullBleed({
    required BuildContext context,
    required bool registerOrOpenAccountVisible,
    required bool guestCashierEnabled,
    required bool getStartedVisible,
  }) {
    return Stack(
      children: [
        Positioned.fill(child: BannerPanel()),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: _sharedContentChildren(
                context: context,
                registerOrOpenAccountVisible: registerOrOpenAccountVisible,
                guestCashierEnabled: guestCashierEnabled,
                getStartedVisible: getStartedVisible,
                removeTopVisuals: true,
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _sharedContentChildren({
    required BuildContext context,
    bool registerOrOpenAccountVisible = false,
    bool guestCashierEnabled = false,
    bool getStartedVisible = false,
    bool removeTopVisuals = false,
  }) {
    final useBanner = config.bannerComponent.toLowerCase().contains('banner');
    final useWelcome = config.welcomeComponent.toLowerCase().contains(
      'welcome',
    );
    final useTC = config.termsAndConditionsComponent.toLowerCase().contains(
      'terms',
    );

    final children = <Widget>[];
    if (!removeTopVisuals) {
      if (useBanner) {
        children.add(banner(templateKey: config.bannerComponent));
      } else {
        children.add(logo(templateKey: config.bannerComponent));
      }
      if (useWelcome) {
        children.add(const SizedBox(height: 24));
        children.add(welcome(template: config.welcomeComponent));
      }
      children.add(const SizedBox(height: 48));
    }

    children.add(loginControl());

    if (getStartedVisible) {
      children.add(const SizedBox(height: 12));
      children.add(createAccount(context));
    }
    if (registerOrOpenAccountVisible) {
      children.add(const SizedBox(height: 12));
      children.add(registerOrOpenAccount(context, loginVM));
    }
    if (guestCashierEnabled) {
      children.add(const SizedBox(height: 12));
      children.add(guestCashierLogin(context, loginVM));
    }
    if (useTC) {
      children.add(const SizedBox(height: 24));
      children.add(
        termsAndConditions(template: config.termsAndConditionsComponent),
      );
    }

    return children;
  }

  BoxDecoration _backgroundDecoration() => const BoxDecoration(
    image: DecorationImage(
      image: AssetImage(AppAssets.appBackgroundLoginPng), // Adjust as needed
      fit: BoxFit.cover,
      alignment: Alignment.topCenter,
    ),
  );

  Widget loginControl() {
    String text = config.loginControlText.isNotEmpty
        ? config.loginControlText
        : 'LOG IN';

    return ButtonPrimary(
      text: text,
      buttonTextSize: PrimaryButtonTextSize.small,
      onTap: (BuildContext context) {
        Navigator.pushNamed(context, LoginPage.route);
      },
      widgetOnBrandedSurface: config.useReverseColours,
    );
  }

  Widget createAccount(BuildContext context) {
    final textField = config.createAccountText.isNotEmpty
        ? config.createAccountText
        : 'CREATE ACCOUNT';
    return ButtonSecondary(
      text: textField,
      upperCase: false,
      onTap: (context) {
        Navigator.of(context).push(
          CustomRoute(
            builder: (BuildContext context) {
              return RegisterPage(decorationEnabled: config.decorationEnabled);
            },
          ),
        );
        // }
      },
      widgetOnBrandedSurface: config.useReverseColours,
    );
  }

  Widget registerOrOpenAccount(BuildContext context, LoginVM vm) {
    return ButtonSecondary(
      text: 'REGISTER',
      widgetOnBrandedSurface: config.useReverseColours,
      onTap: (BuildContext ctx) async {
        await thirdPartyActivations(context, vm);
      },
    );
  }

  Widget guestCashierLogin(BuildContext context, LoginVM vm) {
    return ButtonSecondary(
      text: 'SELL NOW',
      buttonTextSize: PrimaryButtonTextSize.small,
      widgetOnBrandedSurface: config.useReverseColours,
      onTap: (BuildContext ctx) async {
        Navigator.of(context).push(
          CustomRoute(
            builder: (BuildContext context) {
              return const GuestLoginPage(autoSignIn: true);
            },
          ),
        );
      },
    );
  }

  Future<void> thirdPartyActivations(BuildContext context, LoginVM vm) async {
    bool? activationStatus = await activationClientStatus(
      context: context,
      store: vm.store!,
    );
    //Todo(Brandon): With multiple cohorts, refactor process to get device information dependant on cohort and device type
    var details = AppVariables.store!.state.deviceState.deviceDetails;
    String merchantId = details?.merchantId ?? '';
    if (activationStatus == true) {
      haveActivationOptionRoute(globalNavigatorKey.currentContext!, merchantId);
    } else {
      cannotAccessRoute(globalNavigatorKey.currentContext!);
    }
  }

  Future cannotAccessRoute(BuildContext context) => Navigator.of(context).push(
    CustomRoute(
      builder: (BuildContext context) {
        return const ActivationOfflinePage();
      },
    ),
  );

  Future haveActivationOptionRoute(BuildContext context, String merchantId) {
    return Navigator.of(context).push(
      CustomRoute(
        builder: (BuildContext context) {
          return GettingStartedPage(merchantId: merchantId);
        },
      ),
    );
  }

  Widget flexibleWithMaxHeight({required Widget child, double height = 48}) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        constraints: BoxConstraints(maxHeight: height),
        child: child,
      ),
    );
  }
}
