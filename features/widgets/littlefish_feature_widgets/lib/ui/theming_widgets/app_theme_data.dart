import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_border.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_form_input.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_informational.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_navigation.dart';
import 'package:littlefish_merchant/app/theme/button_style_data.dart';

import 'applied_system/applied_button.dart';
import 'applied_system/applied_form_control.dart';
import 'applied_system/applied_surface.dart';
import 'applied_system/applied_text_icon.dart';
import 'modal_theme_config.dart';
import 'typography_data.dart';

enum ThemeDataType { none, light, dark }

class AppThemeData {
  final Color primary;
  final Color onPrimary;
  final Color secondary;
  final Color onSecondary;
  final Color background;
  final Color onBackground;
  final Color error;
  final Color onError;
  final Color tertiary;
  final Color onTertiary;
  final ThemeDataType themeType;
  final List<TypographyData> typography;
  final bool useGradient;
  final Color gradientStart;
  final Color gradientEnd;
  final Color appBarBackground;
  final bool enableSurfaceTint;
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
  final AppliedButton appliedButton;
  final AppliedFormControl appliedFormControl;
  final AppliedFormInput appliedFormInput;
  final AppliedNavigation appliedNavigation;
  final AppliedInformational appliedInformational;
  final AppliedTextIcon appliedTextIcon;
  final AppliedSurface appliedSurface;
  final AppliedBorder appliedBorder;
  final ModalThemeConfig modalThemeConfig;
  final ButtonStyleData buttonStyleData;
  final double appBarElevation;
  final bool useStatusBarDark;
  // ModalThemeData modalThemeData;

  AppThemeData({
    this.primary = Colors.black,
    this.onPrimary = Colors.black,
    this.secondary = Colors.black,
    this.onSecondary = Colors.black,
    this.background = Colors.black,
    this.onBackground = Colors.black,
    this.error = Colors.black,
    this.onError = Colors.black,
    this.tertiary = Colors.black,
    this.onTertiary = Colors.black,
    this.themeType = ThemeDataType.none,
    this.typography = const [],
    this.useGradient = false,
    this.gradientStart = Colors.white,
    this.gradientEnd = Colors.white,
    this.appBarBackground = Colors.white,
    this.enableSurfaceTint = false,
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
    this.appliedButton = const AppliedButton(),
    this.appliedFormControl = const AppliedFormControl(),
    this.appliedFormInput = const AppliedFormInput(),
    this.appliedNavigation = const AppliedNavigation(),
    this.appliedInformational = const AppliedInformational(),
    this.appliedTextIcon = const AppliedTextIcon(),
    this.appliedSurface = const AppliedSurface(),
    this.appliedBorder = const AppliedBorder(),
    this.modalThemeConfig = const ModalThemeConfig(),
    this.buttonStyleData = const ButtonStyleData(),
    this.appBarElevation = 0.0,
    this.useStatusBarDark = false,
    // this.modalThemeData = const ModalThemeData(),
  });

  AppThemeData copyWith({ButtonStyleData? buttonStyleData}) {
    return AppThemeData(
      primary: primary,
      onPrimary: onPrimary,
      secondary: secondary,
      onSecondary: onSecondary,
      background: background,
      onBackground: onBackground,
      error: error,
      onError: onError,
      tertiary: tertiary,
      onTertiary: onTertiary,
      themeType: themeType,
      typography: typography,
      useGradient: useGradient,
      gradientStart: gradientStart,
      gradientEnd: gradientEnd,
      appBarBackground: appBarBackground,
      enableSurfaceTint: enableSurfaceTint,
      appNeutral: appNeutral,
      appNeutralDeEmphasized1: appNeutralDeEmphasized1,
      appSuccess: appSuccess,
      appWarning: appWarning,
      appError: appError,
      appPrimary: appPrimary,
      appOnNeutral: appOnNeutral,
      appOnSuccess: appOnSuccess,
      appOnWarning: appOnWarning,
      appOnError: appOnError,
      appOnPrimary: appOnPrimary,
      appliedButton: appliedButton,
      appliedFormControl: appliedFormControl,
      appliedFormInput: appliedFormInput,
      appliedNavigation: appliedNavigation,
      appliedInformational: appliedInformational,
      appliedTextIcon: appliedTextIcon,
      appliedSurface: appliedSurface,
      appliedBorder: appliedBorder,
      modalThemeConfig: modalThemeConfig,
      // modalThemeData: modalThemeData,
      buttonStyleData: buttonStyleData ?? this.buttonStyleData,
      appBarElevation: appBarElevation,
      useStatusBarDark: useStatusBarDark,
    );
  }
}
