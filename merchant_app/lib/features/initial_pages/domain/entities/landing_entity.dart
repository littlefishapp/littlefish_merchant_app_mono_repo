import 'package:equatable/equatable.dart';

class LandingEntity extends Equatable {
  final bool decorationEnabled;
  final bool useReverseColours;
  final String loginControlText;
  final String createAccountText;
  final double largeDisplayBannerRatio;
  final bool bannerOnLeftSide;
  final String bannerComponent;
  final String termsAndConditionsComponent;
  final String welcomeComponent;
  final String loginControlComponent;
  final bool alignTop;

  const LandingEntity({
    this.decorationEnabled = true,
    this.loginControlText = '',
    this.useReverseColours = false,
    this.createAccountText = '',
    this.largeDisplayBannerRatio = 0.0,
    this.bannerOnLeftSide = true,
    this.bannerComponent = '',
    this.termsAndConditionsComponent = '',
    this.welcomeComponent = '',
    this.loginControlComponent = '',
    this.alignTop = false,
  });
  @override
  List<Object?> get props => [
    decorationEnabled,
    loginControlText,
    useReverseColours,
    createAccountText,
    largeDisplayBannerRatio,
    bannerOnLeftSide,
    bannerComponent,
    termsAndConditionsComponent,
    welcomeComponent,
    loginControlComponent,
    alignTop,
  ];
  LandingEntity copyWith({
    bool? decorationEnabled,
    String? loginControlText,
    String? createAccountText,
    bool? useReverseColours,
    double? largeDisplayBannerRatio,
    bool? bannerOnLeftSide,
    String? bannerComponent,
    String? termsAndConditionsComponent,
    String? welcomeComponent,
    String? loginControlComponent,
    bool? alignTop,
  }) {
    return LandingEntity(
      decorationEnabled: decorationEnabled ?? this.decorationEnabled,
      loginControlText: loginControlText ?? this.loginControlText,
      createAccountText: createAccountText ?? this.createAccountText,
      useReverseColours: useReverseColours ?? this.useReverseColours,
      largeDisplayBannerRatio:
          largeDisplayBannerRatio ?? this.largeDisplayBannerRatio,
      bannerOnLeftSide: bannerOnLeftSide ?? this.bannerOnLeftSide,
      bannerComponent: bannerComponent ?? this.bannerComponent,
      termsAndConditionsComponent:
          termsAndConditionsComponent ?? this.termsAndConditionsComponent,
      welcomeComponent: welcomeComponent ?? this.welcomeComponent,
      loginControlComponent:
          loginControlComponent ?? this.loginControlComponent,
      alignTop: alignTop ?? this.alignTop,
    );
  }
}
