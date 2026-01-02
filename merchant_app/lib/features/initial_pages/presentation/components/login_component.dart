// File: login_component.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/app/theme/lf_app_themes.dart';
import 'package:littlefish_merchant/common/presentaion/components/banner_panel.dart';
import 'package:littlefish_merchant/features/initial_pages/data/data_source/banner_data_source.dart';
import 'package:littlefish_merchant/features/initial_pages/data/data_source/logo_data_source.dart';
import 'package:littlefish_merchant/features/initial_pages/data/data_source/welcome_data_source.dart';
import 'package:littlefish_merchant/features/initial_pages/domain/entities/login_entity.dart';
import 'package:littlefish_merchant/features/initial_pages/domain/use_case/banner.dart';
import 'package:littlefish_merchant/features/initial_pages/domain/use_case/loading.dart';
import 'package:littlefish_merchant/features/initial_pages/domain/use_case/logo.dart';
import 'package:littlefish_merchant/features/initial_pages/domain/use_case/welcome.dart';
import 'package:littlefish_merchant/models/assets/app_assets.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/ui/security/login/login_form.dart';
import 'package:littlefish_merchant/ui/security/login/viewmodels/login_viewmodel.dart';

enum _LayoutMode { stacked, splitLeftBanner, splitTopBanner, fullBleed }

class LoginComponent extends StatelessWidget {
  final LoginEntity config;
  final void Function(String?, String?) onSubmit;
  final void Function(bool?) onValidate;
  final bool isLoading;
  final LoginVM loginVM;

  const LoginComponent({
    Key? key,
    required this.config,
    required this.onSubmit,
    required this.onValidate,
    required this.isLoading,
    required this.loginVM,
  }) : super(key: key);

  _LayoutMode _decideLayoutMode(BuildContext context, LoginEntity config) {
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
    return Theme(
      data: lfCustomTheme(context: context, language: 'en'),
      child: KeyboardVisibilityBuilder(
        builder: (context, isKeyboardVisible) {
          final mode = _decideLayoutMode(context, config);

          return Scaffold(
            backgroundColor:
                Theme.of(context).extension<AppliedSurface>()?.primary ??
                Colors.white,
            resizeToAvoidBottomInset: true,
            body: isLoading
                ? loadingWithMessage('Preparing to sign you in...')
                : switch (mode) {
                    _LayoutMode.stacked => _buildStacked(
                      context,
                      isKeyboardVisible,
                    ),
                    _LayoutMode.splitLeftBanner => _buildSplitLeft(
                      context,
                      isKeyboardVisible,
                    ),
                    _LayoutMode.splitTopBanner => _buildSplitTop(
                      context,
                      isKeyboardVisible,
                    ),
                    _LayoutMode.fullBleed => _buildFullBleed(
                      context,
                      isKeyboardVisible,
                    ),
                  },
          );
        },
      ),
    );
  }

  Widget _buildStacked(BuildContext context, bool isKeyboardVisible) {
    final hasBanner = config.bannerComponent.toLowerCase().contains('banner');
    return Container(
      decoration: config.decorationEnabled ? _backgroundDecoration() : null,
      child: SafeArea(
        child: Padding(
          padding: hasBanner ? EdgeInsets.zero : const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: config.alignTop && !isKeyboardVisible
                ? MainAxisAlignment.start
                : MainAxisAlignment.center,
            children: _sharedContentChildren(context, isKeyboardVisible),
          ),
        ),
      ),
    );
  }

  Widget _buildSplitLeft(BuildContext context, bool isKeyboardVisible) {
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
                context,
                isKeyboardVisible,
                removeTopVisuals: false,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSplitTop(BuildContext context, bool isKeyboardVisible) {
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
                context,
                isKeyboardVisible,
                removeTopVisuals: false,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFullBleed(BuildContext context, bool isKeyboardVisible) {
    return Stack(
      children: [
        Positioned.fill(child: BannerPanel()),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: _sharedContentChildren(
                context,
                isKeyboardVisible,
                removeTopVisuals: false,
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _sharedContentChildren(
    BuildContext context,
    bool isKeyboardVisible, {
    bool removeTopVisuals = false,
  }) {
    final children = <Widget>[];

    final addBannerOnKBVisible =
        config.showBannerOnKeyboardVisible || !isKeyboardVisible;
    final addBanner =
        config.bannerComponent.toLowerCase().contains('banner') &&
        addBannerOnKBVisible;

    final addLogoOnKBVisible =
        config.showBannerOnKeyboardVisible || !isKeyboardVisible;
    final addLogo =
        config.bannerComponent.toLowerCase().contains('logo') &&
        addLogoOnKBVisible;

    final addWelcomeOnKBVisible =
        config.showWelcomeOnKeyboardVisible || !isKeyboardVisible;
    final addWelcome =
        config.welcomeComponent != 'none' &&
        config.welcomeComponent.isNotEmpty &&
        addWelcomeOnKBVisible;

    if (!removeTopVisuals) {
      if (addBanner) {
        children.add(banner(templateKey: config.bannerComponent));
      } else if (addLogo) {
        children.add(logo(templateKey: config.bannerComponent));
      }

      if (addWelcome) {
        children.add(welcome(template: loginWelcome));
      }

      // Add terms and conditions component if specified
      if (config.termsAndConditionsComponent != 'none' &&
          config.termsAndConditionsComponent.isNotEmpty) {
        // Assuming there's a termsAndConditions widget similar to banner/welcome/logo
        // For now, I will just add a placeholder Text widget
        children.add(
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              config.termsAndConditionsComponent,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
    }

    children.add(
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: LoginForm(
          parentContext: context,
          vm: loginVM,
          onSubmit: onSubmit,
          onValidate: onValidate,
          loginControlText: config.loginControlDisplayText,
          loginControlOnBrandedSurface: config.loginControlOnBrandedSurface,
        ),
      ),
    );

    // Add the "Return to previous page" link if enabled
    // if (_shouldShowNavBack(config)) {
    //   children.add(
    //     Padding(
    //       padding: const EdgeInsets.only(right: 8.0),
    //       child: Align(
    //         alignment: Alignment.centerRight,
    //         child: TextButton(
    //           onPressed: () {
    //             Navigator.of(context).pop();
    //           },
    //           child: Text(
    //             config.navBackText,
    //             style: Theme.of(context).textTheme.labelSmall,
    //           ),
    //         ),
    //       ),
    //     ),
    //   );
    // }

    return children;
  }

  BoxDecoration _backgroundDecoration() => const BoxDecoration(
    color: Colors.white,
    image: DecorationImage(
      image: AssetImage(AppAssets.appBackgroundLoginPng),
      fit: BoxFit.fitWidth,
      alignment: Alignment.topCenter,
    ),
  );

  bool _shouldShowNavBack(LoginEntity config) {
    final isLargeDisplay = EnvironmentProvider.instance.isLargeDisplay;
    final platform = defaultTargetPlatform;

    if (isLargeDisplay) {
      // On large displays (split/full-bleed), use platform-specific flags
      if (platform == TargetPlatform.iOS) {
        return config.navBackEnablediOS;
      } else if (platform == TargetPlatform.android) {
        return config.navBackEnabledAndroid;
      }
    }
    // On mobile/small displays (stacked layout)
    return config.navBackEnabledStack;
  }
}
