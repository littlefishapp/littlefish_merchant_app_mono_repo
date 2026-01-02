// File: loading_entity.dart
import 'package:equatable/equatable.dart';

class LoadingEntity extends Equatable {
  final String loadingText;
  final bool useReverseColours;
  final bool decorationEnabled;
  final double largeDisplayBannerRatio;
  final bool bannerOnLeftSide;
  final String bannerComponent;
  final String termsAndConditionsComponent;
  final String welcomeComponent;
  final String loginControlComponent;
  final String progressComponent;
  final bool alignTop;

  const LoadingEntity({
    this.loadingText = 'Loading...',
    this.useReverseColours = false,
    this.decorationEnabled = true,
    this.largeDisplayBannerRatio = 0.0,
    this.bannerOnLeftSide = true,
    this.bannerComponent = '',
    this.termsAndConditionsComponent = '',
    this.welcomeComponent = '',
    this.loginControlComponent = '',
    this.progressComponent = '',
    this.alignTop = false,
  });

  @override
  List<Object?> get props => [
    loadingText,
    useReverseColours,
    decorationEnabled,
    largeDisplayBannerRatio,
    bannerOnLeftSide,
    bannerComponent,
    termsAndConditionsComponent,
    welcomeComponent,
    loginControlComponent,
    progressComponent,
    alignTop,
  ];

  LoadingEntity copyWith({
    String? loadingText,
    bool? useReverseColours,
    bool? decorationEnabled,
    double? largeDisplayBannerRatio,
    bool? bannerOnLeftSide,
    String? bannerComponent,
    String? termsAndConditionsComponent,
    String? welcomeComponent,
    String? loginControlComponent,
    String? progressComponent,
    bool? alignTop,
  }) {
    return LoadingEntity(
      loadingText: loadingText ?? this.loadingText,
      useReverseColours: useReverseColours ?? this.useReverseColours,
      decorationEnabled: decorationEnabled ?? this.decorationEnabled,
      largeDisplayBannerRatio:
          largeDisplayBannerRatio ?? this.largeDisplayBannerRatio,
      bannerOnLeftSide: bannerOnLeftSide ?? this.bannerOnLeftSide,
      bannerComponent: bannerComponent ?? this.bannerComponent,
      termsAndConditionsComponent:
          termsAndConditionsComponent ?? this.termsAndConditionsComponent,
      welcomeComponent: welcomeComponent ?? this.welcomeComponent,
      loginControlComponent:
          loginControlComponent ?? this.loginControlComponent,
      progressComponent: progressComponent ?? this.progressComponent,
      alignTop: alignTop ?? this.alignTop,
    );
  }
}
