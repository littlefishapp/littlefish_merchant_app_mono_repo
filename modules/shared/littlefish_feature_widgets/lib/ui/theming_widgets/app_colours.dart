import 'package:flutter/material.dart';

class AppColours extends ThemeExtension<AppColours> {
  final Color appNeutral;
  final Color appNeutralDeEmphasized1;
  final Color appSuccess;
  final Color appWarning;
  final Color appError;
  final Color appPrimary;
  final Color appOnNeutral;
  final Color appOnSuccess;
  final Color appOnWarning;
  final Color appOnError;
  final Color appOnPrimary;

  AppColours({
    this.appNeutral = Colors.black45,
    this.appNeutralDeEmphasized1 = Colors.grey,
    this.appSuccess = Colors.green,
    this.appWarning = Colors.orange,
    this.appError = Colors.red,
    this.appPrimary = Colors.greenAccent,
    this.appOnNeutral = Colors.white,
    this.appOnSuccess = Colors.white,
    this.appOnWarning = Colors.white,
    this.appOnError = Colors.white,
    this.appOnPrimary = Colors.white,
  });

  @override
  ThemeExtension<AppColours> copyWith({
    Color? neutral,
    Color? neutralDeEmphasized1,
    Color? success,
    Color? warning,
    Color? error,
    Color? active,
    Color? onNeutral,
    Color? onSuccess,
    Color? onWarning,
    Color? onError,
    Color? onPrimary,
  }) {
    return AppColours(
      appError: error ?? appError,
      appNeutral: neutral ?? appNeutral,
      appPrimary: active ?? appPrimary,
      appSuccess: success ?? appSuccess,
      appWarning: warning ?? appWarning,
      appOnError: onError ?? appError,
      appOnNeutral: onNeutral ?? appOnNeutral,
      appOnPrimary: onPrimary ?? appOnPrimary,
      appOnSuccess: onSuccess ?? appOnSuccess,
      appOnWarning: onWarning ?? appOnWarning,
    );
  }

  @override
  ThemeExtension<AppColours> lerp(
    covariant ThemeExtension<AppColours>? other,
    double t,
  ) {
    if (other is! AppColours) {
      return this;
    }
    return AppColours(
      appError: Color.lerp(appError, other.appError, t) ?? Colors.red,
      appNeutral: Color.lerp(appNeutral, other.appNeutral, t) ?? Colors.black45,
      appPrimary:
          Color.lerp(appPrimary, other.appPrimary, t) ?? Colors.greenAccent,
      appSuccess: Color.lerp(appSuccess, other.appSuccess, t) ?? Colors.green,
      appWarning: Color.lerp(appWarning, other.appWarning, t) ?? Colors.orange,
      appOnError: Color.lerp(appOnError, other.appOnError, t) ?? Colors.white,
      appOnNeutral:
          Color.lerp(appOnNeutral, other.appOnNeutral, t) ?? Colors.white,
      appOnPrimary:
          Color.lerp(appOnPrimary, other.appOnPrimary, t) ?? Colors.white,
      appOnSuccess:
          Color.lerp(appOnSuccess, other.appOnSuccess, t) ?? Colors.white,
      appOnWarning:
          Color.lerp(appOnWarning, other.appOnWarning, t) ?? Colors.white,
    );
  }
}
