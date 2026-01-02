// File: login_entity.dart
import 'package:equatable/equatable.dart';

class LoginEntity extends Equatable {
  final bool decorationEnabled;
  final bool showBannerOnKeyboardVisible;
  final bool showWelcomeOnKeyboardVisible;
  final String loginControlDisplayText;
  final bool loginControlOnBrandedSurface;
  final double largeDisplayBannerRatio;
  final bool bannerOnLeftSide;
  final bool navBackEnablediOS;
  final bool navBackEnabledAndroid;
  final bool navBackEnabledStack; // for non-large displays or fallback
  final String navBackText;
  final bool alignTop;
  final String bannerComponent;
  final String termsAndConditionsComponent;
  final String welcomeComponent;

  const LoginEntity({
    this.decorationEnabled = true,
    this.showBannerOnKeyboardVisible = true,
    this.showWelcomeOnKeyboardVisible = true,
    this.loginControlDisplayText = '',
    this.loginControlOnBrandedSurface = false,
    this.largeDisplayBannerRatio = 0.0,
    this.bannerOnLeftSide = true,
    this.navBackEnablediOS = false,
    this.navBackEnabledAndroid = false,
    this.navBackEnabledStack = false,
    this.navBackText = '',
    this.alignTop = false,
    this.bannerComponent = '',
    this.termsAndConditionsComponent = '',
    this.welcomeComponent = '',
  });

  @override
  List<Object?> get props => [
    decorationEnabled,
    showBannerOnKeyboardVisible,
    showWelcomeOnKeyboardVisible,
    loginControlDisplayText,
    loginControlOnBrandedSurface,
    largeDisplayBannerRatio,
    bannerOnLeftSide,
    navBackEnablediOS,
    navBackEnabledAndroid,
    navBackEnabledStack,
    navBackText,
    alignTop,
    bannerComponent,
    termsAndConditionsComponent,
    welcomeComponent,
  ];

  LoginEntity copyWith({
    bool? decorationEnabled,
    bool? showBannerOnKeyboardVisible,
    bool? showWelcomeOnKeyboardVisible,
    String? loginControlDisplayText,
    bool? loginControlOnBrandedSurface,
    double? largeDisplayBannerRatio,
    bool? bannerOnLeftSide,
    bool? navBackEnablediOS,
    bool? navBackEnabledAndroid,
    bool? navBackEnabledStack,
    String? navBackText,
    bool? alignTop,
    String? bannerComponent,
    String? termsAndConditionsComponent,
    String? welcomeComponent,
  }) {
    return LoginEntity(
      decorationEnabled: decorationEnabled ?? this.decorationEnabled,
      showBannerOnKeyboardVisible:
          showBannerOnKeyboardVisible ?? this.showBannerOnKeyboardVisible,
      showWelcomeOnKeyboardVisible:
          showWelcomeOnKeyboardVisible ?? this.showWelcomeOnKeyboardVisible,
      loginControlDisplayText:
          loginControlDisplayText ?? this.loginControlDisplayText,
      loginControlOnBrandedSurface:
          loginControlOnBrandedSurface ?? this.loginControlOnBrandedSurface,
      largeDisplayBannerRatio:
          largeDisplayBannerRatio ?? this.largeDisplayBannerRatio,
      bannerOnLeftSide: bannerOnLeftSide ?? this.bannerOnLeftSide,
      navBackEnablediOS: navBackEnablediOS ?? this.navBackEnablediOS,
      navBackEnabledAndroid:
          navBackEnabledAndroid ?? this.navBackEnabledAndroid,
      navBackEnabledStack: navBackEnabledStack ?? this.navBackEnabledStack,
      navBackText: navBackText ?? this.navBackText,
      alignTop: alignTop ?? this.alignTop,
      bannerComponent: bannerComponent ?? this.bannerComponent,
      termsAndConditionsComponent:
          termsAndConditionsComponent ?? this.termsAndConditionsComponent,
      welcomeComponent: welcomeComponent ?? this.welcomeComponent,
    );
  }
}
