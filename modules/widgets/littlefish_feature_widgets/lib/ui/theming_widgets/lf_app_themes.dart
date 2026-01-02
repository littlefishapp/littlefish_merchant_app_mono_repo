import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_core/logging/services/logger_service.dart';
import 'package:littlefish_merchant/app/theme/app_bar_data_set.dart';
import 'package:littlefish_merchant/app/theme/app_colours.dart';
import 'package:littlefish_merchant/app/theme/typography_data.dart';

import '../../injector.dart';
import 'app_theme_data.dart';
import 'typography_data_set.dart';

///
///   Default Font Size/Line Height
///   displayLarge	Roboto 57/64
///   displayMedium	Roboto 45/52
///   displaySmall	Roboto 36/44
///   headlineLarge	Roboto 32/40
///   headlineMedium	Roboto 28/36
///   headlineSmall	Roboto 24/32
///   titleLarge	New- Roboto Medium 22/28
///   titleMedium	Roboto Medium 16/24
///   titleSmall	Roboto Medium 14/20
///   bodyLarge	Roboto 16/24
///   bodyMedium	Roboto 14/20
///   bodySmall	Roboto 12/16
///   labelLarge	Roboto Medium 14/20
///   labelMedium	Roboto Medium 12/16
///   labelSmall	New Roboto Medium, 11/16
///
///   Relationship between TextStyle and TextTheme:
///         TextStyle headlineStyle = TextStyle(
///           fontSize: 72.0,
///           fontWeight: FontWeight.bold,
///           color: Colors.indigo,
///        );
///
///        TextTheme appTextTheme = TextTheme(
///          headline1: headlineStyle,
///          Other text styles...
///        );

// const kLightPrimary = Color(0xff3E7568);
// const kLightOnPrimary = lfWhite;
// const kLightSecondary = lfGrey1;
// const kLightOnSecondary = Color(0xff606060);
// const kLightTertiary = lfWhite;
// const kLightOnTertiary = Color(0xff606060);
// const kLightError = lfAerospaceOrange;
// const kLightonError = lfWhite;

// const kDarkPrimary = Color(0xFFfaa521);
// const kDarkOnPrimary = Color(0xFFFFFFFF);
// const kDarkSecondary = Color(0xFF90a4ae);
// const kDarkOnSecondary = Color(0xff606060);
// const kDarkTertiary = Color(0xFFE1880B);
// const kDarkOnTertiary = Color(0xff606060);

///   From material design color scheme
/// * Primary colors are used for key components across the UI, such as the FAB,
///   prominent buttons, and active states.
///
/// * Secondary colors are used for less prominent components in the UI, such as
///   filter chips, while expanding the opportunity for color expression.
///
/// * Tertiary colors are used for contrasting accents that can be used to
///   balance primary and secondary colors or bring heightened attention to
///   an element, such as an input field. The tertiary colors are left
///   for makers to use at their discretion and are intended to support
///   broader color expression in products.
/// background          A color that typically appears behind scrollable content.
/// primaryContainer    A color used for elements needing less emphasis than [primary].
/// SecondaryContainer  A color used for elements needing less emphasis than [secondary].
/// tertiaryContainer   A color used for elements needing less emphasis than [tertiary].
/// errorContainer      A color used for error elements needing less emphasis than [error].
/// surface             The background color for widgets like [Card].
/// surfaceVariant      A color variant of [surface] that can be used for differentiation
///                     against a component using [surface].
/// inverseSurface      A surface color used for displaying the reverse of what’s seen in the
///                     surrounding UI, for example in a SnackBar to bring attention to
///                     an alert.
/// inversePrimary      An accent color used for displaying a highlight color on
///                     [inverseSurface] backgrounds, like button text in a SnackBar.
/// surfaceTint         A color used as an overlay on a surface color to indicate
///                     a component's elevation.
/// primary             The color displayed most frequently across your app’s
///                     screens and components.
/// Secondary           An accent color used for less prominent components in the UI, such as
///                     filter chips, while expanding the opportunity for color expression.
/// tertiary            A color used as a contrasting accent that can balance [primary]
///                     and [secondary] colors or bring heightened attention to an element,
///                     such as an input field.
/// error               The color to use for input validation errors, e.g. for
///                     [InputDecoration.errorText].
/// outline             A utility color that creates boundaries and emphasis to
///                     improve usability.
/// outlineVariant      A utility color that creates boundaries for decorative elements
///                     when a 3:1 contrast isn’t required, such as for dividers or
///                     decorative elements.
/// shadow              A color use to paint the drop shadows of elevated components.
/// scrim               A color use to paint the scrim around of modal components.

LittleFishCore core = LittleFishCore.instance;

LoggerService get logger => LittleFishCore.instance.get<LoggerService>();

ThemeData buildLightThemeLF({
  String language = '',
  required AppThemeData appThemeData,
  required BuildContext context,
}) {
  // logger.debug(
  //     'theme-builder',
  //     '### buildLightThemeLF nr typo '
  //         'items ${appThemeData.typography.length}');

  var fontFamily = initialiseTypographyData(appThemeData.typography);
  var globalTextTheme = getGlobalTextTheme(context, fontFamily);
  initialiseAppBarData(
    appBarBackground: appThemeData.appBarBackground,
    enableSurfaceTint: appThemeData.enableSurfaceTint,
    gradientEnd: appThemeData.gradientEnd,
    gradientStart: appThemeData.gradientStart,
    useGradient: appThemeData.useGradient,
    useStatusBarDark: appThemeData.useStatusBarDark,
  );

  var colorScheme = const ColorScheme.light().copyWith(
    primary: appThemeData.appliedTextIcon.brand, // appThemeData.primary,
    onPrimary:
        appThemeData.appliedTextIcon.inversePrimary, // appThemeData.onPrimary,
    secondary: appThemeData.appliedTextIcon.secondary, //appThemeData.secondary,
    onSecondary: appThemeData
        .appliedTextIcon
        .inverseSecondary, //appThemeData.onSecondary,
    background: appThemeData.appliedSurface.primary, //appThemeData.background,
    onBackground:
        appThemeData.appliedSurface.inverse, //appThemeData.onBackground,
    error: appThemeData.appliedTextIcon.error, // appThemeData.error,
    onError: appThemeData.appliedTextIcon.errorAlt, // appThemeData.onError,
    tertiary: appThemeData.appliedTextIcon.accent, //appThemeData.tertiary,
    onTertiary:
        appThemeData.appliedTextIcon.accentAlt, //appThemeData.onTertiary,
  );

  var iconTheme = IconThemeData(color: appThemeData.appliedTextIcon.successAlt);

  var textButtonTheme = ThemeData.light(useMaterial3: true).textButtonTheme;

  var tabBarTheme = ThemeData.light(useMaterial3: true).tabBarTheme.copyWith();

  var appBarTheme = ThemeData.light(useMaterial3: true).appBarTheme.copyWith(
    backgroundColor: colorScheme.onPrimary,
    foregroundColor: colorScheme.primary,
    actionsIconTheme: iconTheme,
    elevation: appThemeData.appBarElevation,
  );

  var textTheme = ThemeData.light(useMaterial3: true).textTheme.copyWith(
    // bodyLarge: globalTextTheme.bodyLarge,
    // bodyMedium: globalTextTheme.bodyMedium,
    // bodySmall: globalTextTheme.bodySmall,
    // displayLarge: globalTextTheme.displayLarge,
    // displayMedium: globalTextTheme.displayMedium,
    // displaySmall: globalTextTheme.displaySmall,
    // labelLarge: globalTextTheme.labelLarge,
    // labelMedium: globalTextTheme.labelMedium,
    // labelSmall: globalTextTheme.labelSmall,
    // titleLarge: globalTextTheme.titleLarge,
    // titleMedium: globalTextTheme.titleMedium,
    // titleSmall: globalTextTheme.titleSmall,
    // headlineLarge: globalTextTheme.headlineLarge,
    // headlineMedium: globalTextTheme.headlineMedium,
    // headlineSmall: globalTextTheme.headlineSmall,
  );

  var floatingActionButtonTheme = ThemeData.light(useMaterial3: true)
      .floatingActionButtonTheme
      .copyWith(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      );

  final buttonStyleData = appThemeData.buttonStyleData;

  var elevatedButtonTheme = ElevatedButtonThemeData(
    style: ButtonStyle(
      shape: MaterialStateProperty.resolveWith<OutlinedBorder>((states) {
        if (states.contains(MaterialState.disabled)) {
          return RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonStyleData.radius),
            side: BorderSide(
              width: buttonStyleData.width,
              color: appThemeData.appliedButton.primaryDisabled,
            ),
          );
        }
        return RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(buttonStyleData.radius),
          side: BorderSide(
            width: buttonStyleData.width,
            color: appThemeData.appliedButton.primaryDefault,
          ),
        );
      }),
    ),
  );

  var base = ThemeData.light(useMaterial3: true).copyWith(
    colorScheme: colorScheme,
    appBarTheme: appBarTheme,
    iconTheme: iconTheme,
    tabBarTheme: tabBarTheme,
    textTheme: textTheme,
    floatingActionButtonTheme: floatingActionButtonTheme,
    textButtonTheme: textButtonTheme,
    elevatedButtonTheme: elevatedButtonTheme,
    extensions: [
      appThemeData.appliedButton,
      appThemeData.appliedFormControl,
      appThemeData.appliedFormInput,
      appThemeData.appliedInformational,
      appThemeData.appliedNavigation,
      appThemeData.appliedTextIcon,
      appThemeData.appliedBorder,
      appThemeData.appliedSurface,
    ],
  );

  return base;
}

ThemeData buildDarkThemeLF({
  String language = '',
  required AppThemeData appThemeData,
  required BuildContext context,
}) {
  // logger.debug(
  //     'theme-builder',
  //     '### buildDarkThemeLF nr typo '
  //         'items ${appThemeData.typography.length}');

  var fontFamily = initialiseTypographyData(appThemeData.typography);
  var globalTextTheme = getGlobalTextTheme(context, fontFamily);
  initialiseAppBarData(
    appBarBackground: appThemeData.appBarBackground,
    enableSurfaceTint: appThemeData.enableSurfaceTint,
    gradientEnd: appThemeData.gradientEnd,
    gradientStart: appThemeData.gradientStart,
    useGradient: appThemeData.useGradient,
    useStatusBarDark: appThemeData.useStatusBarDark,
  );
  var colorScheme = const ColorScheme.dark().copyWith(
    primary: appThemeData.primary,
    onPrimary: appThemeData.onPrimary,
    secondary: appThemeData.secondary,
    onSecondary: appThemeData.onSecondary,
    background: appThemeData.background,
    onBackground: appThemeData.onBackground,
    error: appThemeData.error,
    onError: appThemeData.onError,
    tertiary: appThemeData.tertiary,
    onTertiary: appThemeData.onTertiary,
  );

  var iconTheme = IconThemeData(color: colorScheme.primary);

  var textButtonTheme = ThemeData.dark(useMaterial3: true).textButtonTheme;

  var tabBarTheme = ThemeData.dark(useMaterial3: true).tabBarTheme.copyWith(
    indicatorColor: colorScheme.primary,
    labelColor: colorScheme.primary,
    unselectedLabelColor: colorScheme.secondary.withOpacity(0.35),
    indicatorSize: TabBarIndicatorSize.tab,
    tabAlignment: TabAlignment.start,
  );

  var appBarTheme = ThemeData.dark(useMaterial3: true).appBarTheme.copyWith(
    backgroundColor: colorScheme.onPrimary,
    foregroundColor: colorScheme.primary,
    actionsIconTheme: iconTheme,
    elevation: appThemeData.appBarElevation,
  );

  var textTheme = ThemeData.dark(useMaterial3: true).textTheme.copyWith(
    // bodyLarge: globalTextTheme.bodyLarge,
    // bodyMedium: globalTextTheme.bodyMedium,
    // bodySmall: globalTextTheme.bodySmall,
    // displayLarge: globalTextTheme.displayLarge,
    // displayMedium: globalTextTheme.displayMedium,
    // displaySmall: globalTextTheme.displaySmall,
    // labelLarge: globalTextTheme.labelLarge,
    // labelMedium: globalTextTheme.labelMedium,
    // labelSmall: globalTextTheme.labelSmall,
    // titleLarge: globalTextTheme.titleLarge,
    // titleMedium: globalTextTheme.titleMedium,
    // titleSmall: globalTextTheme.titleSmall,
    // headlineLarge: globalTextTheme.headlineLarge,
    // headlineMedium: globalTextTheme.headlineMedium,
    // headlineSmall: globalTextTheme.headlineSmall,
  );

  var floatingActionButtonTheme = ThemeData.dark(useMaterial3: true)
      .floatingActionButtonTheme
      .copyWith(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      );
  final buttonStyleData = appThemeData.buttonStyleData;

  var elevatedButtonTheme = ElevatedButtonThemeData(
    style: ButtonStyle(
      shape: MaterialStateProperty.resolveWith<OutlinedBorder>((states) {
        if (states.contains(MaterialState.disabled)) {
          return RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonStyleData.radius),
            side: BorderSide(
              width: 1,
              color: appThemeData.appliedButton.primaryDisabled,
            ),
          );
        }
        return RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(buttonStyleData.radius),
          side: BorderSide(
            width: 1,
            color: appThemeData.appliedButton.primaryDefault,
          ),
        );
      }),
    ),
  );

  var base = ThemeData.dark(useMaterial3: true).copyWith(
    colorScheme: colorScheme,
    appBarTheme: appBarTheme,
    iconTheme: iconTheme,
    tabBarTheme: tabBarTheme,
    textTheme: textTheme,
    floatingActionButtonTheme: floatingActionButtonTheme,
    textButtonTheme: textButtonTheme,
    elevatedButtonTheme: elevatedButtonTheme,
    extensions: [
      appThemeData.appliedButton,
      appThemeData.appliedFormControl,
      appThemeData.appliedFormInput,
      appThemeData.appliedInformational,
      appThemeData.appliedNavigation,
      appThemeData.appliedTextIcon,
      appThemeData.appliedBorder,
      appThemeData.appliedSurface,
    ],
  );

  return base;
}

ThemeData lfTheme(BuildContext context) {
  final appThemeData = getIt.get<AppThemeData>();
  return buildLightThemeLF(appThemeData: appThemeData, context: context);
}

ThemeData lfCustomTheme({
  required BuildContext context,
  required String language,
}) {
  // logger.debug('theme-builder', '### lfCustomTheme getIt AppThemeData');
  final appThemeData = getIt.get<AppThemeData>();
  var colorScheme = const ColorScheme.light().copyWith(
    primary: appThemeData.primary,
    onPrimary: appThemeData.onPrimary,
    secondary: appThemeData.secondary,
    onSecondary: appThemeData.onSecondary,
    error: appThemeData.error,
    onError: appThemeData.onError,
    tertiary: appThemeData.tertiary,
    onTertiary: appThemeData.onTertiary,
    background: appThemeData.tertiary,
    onBackground: appThemeData.onTertiary,
  );

  var iconTheme = IconThemeData(color: colorScheme.primary);

  var textButtonTheme = ThemeData.light(useMaterial3: true).textButtonTheme;

  var tabBarTheme = ThemeData.light(useMaterial3: true).tabBarTheme.copyWith(
    indicatorColor: colorScheme.primary,
    labelColor: colorScheme.primary,
    unselectedLabelColor: colorScheme.primary.withOpacity(0.37),
    indicatorSize: TabBarIndicatorSize.tab,
  );

  // TODO(lampian): not using appBarTheme as flexibleSpace can't be set but needed
  // var appBarTheme = ThemeData.light(useMaterial3: true).appBarTheme.copyWith(
  //       backgroundColor: colorScheme.onPrimary,
  //       foregroundColor: colorScheme.primary,
  //       actionsIconTheme: iconTheme,
  //       elevation: 0,

  //     );

  //var textTheme = ThemeData.light(useMaterial3: true).textTheme;
  var textTheme = Theme.of(context).textTheme;
  var floatingActionButtonTheme = ThemeData.light(useMaterial3: true)
      .floatingActionButtonTheme
      .copyWith(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      );

  final buttonStyleData = appThemeData.buttonStyleData;
  var elevatedButtonTheme = ElevatedButtonThemeData(
    style: ButtonStyle(
      shape: MaterialStateProperty.resolveWith<OutlinedBorder>((states) {
        if (states.contains(MaterialState.disabled)) {
          return RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonStyleData.radius),
            side: BorderSide(
              width: 1,
              color: appThemeData.appliedButton.primaryDisabled,
            ),
          );
        }
        return RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(buttonStyleData.radius),
          side: BorderSide(
            width: 1,
            color: appThemeData.appliedButton.primaryDefault,
          ),
        );
      }),
    ),
  );

  var base = ThemeData.light(useMaterial3: true).copyWith(
    scaffoldBackgroundColor: colorScheme.background,
    colorScheme: colorScheme,
    // TODO(lampian): see todo above, fix if flexiblespace becomes part of theme
    //appBarTheme: appBarTheme,
    iconTheme: iconTheme,
    tabBarTheme: tabBarTheme,
    textTheme: textTheme,
    floatingActionButtonTheme: floatingActionButtonTheme,
    textButtonTheme: textButtonTheme,
    elevatedButtonTheme: elevatedButtonTheme,
    extensions: [
      AppColours(
        appError: appThemeData.appError,
        appNeutral: appThemeData.appNeutral,
        appPrimary: appThemeData.appPrimary,
        appSuccess: appThemeData.appSuccess,
        appWarning: appThemeData.appWarning,
        appOnError: appThemeData.appOnError,
        appOnNeutral: appThemeData.appOnNeutral,
        appOnPrimary: appThemeData.appOnPrimary,
        appOnSuccess: appThemeData.appOnSuccess,
        appOnWarning: appThemeData.appOnWarning,
      ),

      appThemeData.appliedButton,
      appThemeData.appliedFormControl,
      appThemeData.appliedFormInput,
      appThemeData.appliedInformational,
      appThemeData.appliedNavigation,
      appThemeData.appliedTextIcon,
      appThemeData.appliedBorder,
      appThemeData.appliedSurface,
      // appThemeData.modalThemeData,
    ],
  );

  return base;
}

void initialiseAppBarData({
  final bool useGradient = false,
  final Color gradientStart = Colors.white,
  final Color gradientEnd = Colors.white,
  final Color appBarBackground = Colors.white,
  final bool enableSurfaceTint = false,
  final bool useStatusBarDark = false,
}) {
  final dataSet = AppBarDataSet();
  dataSet.appBarUseGradient = useGradient;
  dataSet.appBarGradientStart = gradientStart;
  dataSet.appBarGradientEnd = gradientEnd;
  dataSet.appBarBackground = appBarBackground;
  dataSet.appBarEnableSurfaceTint = enableSurfaceTint;
  dataSet.useStatusBarDark = useStatusBarDark;
  if (getIt.isRegistered<AppBarDataSet>()) {
    getIt.unregister<AppBarDataSet>();
  }
  getIt.registerSingleton<AppBarDataSet>(dataSet);
}

String initialiseTypographyData(List<TypographyData> items) {
  // logger.debug('theme-builder', '### app themes initialiseTypographyData');
  var dataSet = TypographyDataSet();
  var fontFamily = '';
  for (final item in items) {
    // TODO(lampian): should we be able to override the global text theme?
    // final fontFamily = getFontFamily(value: item.textStyle);
    switch (item.itemType) {
      case 'ios':
        if (Platform.isIOS) {
          fontFamily = item.fontFamily;
        }
        break;
      case 'android':
        if (Platform.isAndroid) {
          fontFamily = item.fontFamily;
        }
        break;
      case 'displyLarge':
        dataSet.displayLarge = item;
        break;
      case 'displyMedium':
        dataSet.displayMedium = item;
        break;
      case 'displySmall':
        dataSet.displaySmall = item;
        break;
      case 'displyXSmall':
        dataSet.displayXSmall = item;
        break;
      case 'headingXXLarge':
        dataSet.headinXXLarge = item;
        break;
      case 'headingXLarge':
        dataSet.headingXLarge = item;
        break;
      case 'headingLarge':
        dataSet.headingLarge = item;
        break;
      case 'headingMedium':
        dataSet.headingMedium = item;
        break;
      case 'headingSmall':
        dataSet.headingSmall = item;
        break;
      case 'headingXSmall':
        dataSet.headingXSmall = item;
        break;
      case 'labelLarge':
        dataSet.labelLarge = item;
        break;
      case 'labelMedium':
        dataSet.labelMedium = item;
        break;
      case 'labelSmall':
        dataSet.labelSmall = item;
        break;
      case 'labelXSmall':
        dataSet.labelXSmall = item;
        break;
      case 'paragraphLarge':
        dataSet.paragraphLarge = item;
        break;
      case 'paragraphMedium':
        dataSet.paragraphMedium = item;
        break;
      case 'paragraphSmall':
        dataSet.paragraphSmall = item;
        break;
      case 'paragraphXSmall':
        dataSet.paragraphXSmall = item;
        break;
      case 'button01':
        dataSet.button01SemiBold = item.semiBold;
        dataSet.button01ExtraBold = item.light;
        dataSet.button01Bold = item.bold;
        dataSet.button01FontSize = item.fontSize;
        // dataSet.button01FontFamily = fontFamily;
        break;
      case 'button02':
        dataSet.button02SemiBold = item.semiBold;
        dataSet.button02ExtraBold = item.light;
        dataSet.button02Bold = item.bold;
        dataSet.button02FontSize = item.fontSize;
        // dataSet.button02FontFamily = fontFamily;
        break;
    }
  }
  if (getIt.isRegistered<TypographyDataSet>()) {
    getIt.unregister<TypographyDataSet>();
  }
  getIt.registerSingleton<TypographyDataSet>(dataSet);
  return fontFamily;
}

TextTheme getGlobalTextTheme(BuildContext context, String value) {
  // logger.debug('theme-builder', '### lf app themes - set typeface to $value');
  TextTheme textTheme;
  switch (value) {
    case 'roboto':
      textTheme = GoogleFonts.robotoTextTheme();
      break;
    case 'sans':
      textTheme = GoogleFonts.openSansTextTheme();

      break;
    case 'pacifico':
      textTheme = GoogleFonts.pacificoTextTheme();
      break;

    case 'sf-pro':
      textTheme = Theme.of(context).textTheme.apply(fontFamily: 'SF-PRO');
      break;

    default:
      textTheme = GoogleFonts.robotoTextTheme();
  }
  return textTheme;
}

String? getFontFamily({required String value}) {
  String? fontFamily;
  switch (value) {
    case 'roboto':
      fontFamily = GoogleFonts.roboto().fontFamily;
      break;
    case 'lato':
      fontFamily = GoogleFonts.openSans().fontFamily;
      break;

    case 'pacifico':
      fontFamily = GoogleFonts.pacifico().fontFamily;
      break;

    default:
      //fontFamily = GoogleFonts.roboto().fontFamily;
      fontFamily = 'SF-Pro';
  }
  return fontFamily;
}

const Color successColor = Color(0xFF168335);
