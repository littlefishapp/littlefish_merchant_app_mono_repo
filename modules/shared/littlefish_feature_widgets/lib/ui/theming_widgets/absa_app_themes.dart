import 'package:flutter/material.dart';

const _kLightPrimary = Color(0xFF00008c);
const _kLightOnPrimary = Color(0xFFFFFFFF);
const _kLightSecondary = Color(0xFF90a4ae);
const _kLightOnSecondary = Color(0xff606060);

const _kDarkPrimary = Color(0xFFfaa521);
const _kDarkOnPrimary = Color(0xFFFFFFFF);
const _kDarkSecondary = Color(0xFF90a4ae);
const _kDarkOnSecondary = Color(0xff606060);

ThemeData buildLightThemeABSA(String language) {
  var colorScheme = const ColorScheme.light().copyWith(
    primary: _kLightPrimary,
    onPrimary: _kLightOnPrimary,
    secondary: _kLightSecondary,
    onSecondary: _kLightOnSecondary,
  );

  var iconTheme = IconThemeData(color: colorScheme.primary);

  var tabBarTheme = ThemeData.light(useMaterial3: true).tabBarTheme.copyWith(
    indicatorColor: colorScheme.primary,
    labelColor: colorScheme.primary,
    unselectedLabelColor: colorScheme.primary.withOpacity(0.37),
    indicatorSize: TabBarIndicatorSize.tab,
  );

  var appBarTheme = ThemeData.light(useMaterial3: true).appBarTheme.copyWith(
    backgroundColor: colorScheme.onPrimary,
    foregroundColor: colorScheme.primary,
    actionsIconTheme: iconTheme,
  );

  var base = ThemeData.light(useMaterial3: true).copyWith(
    colorScheme: colorScheme,
    appBarTheme: appBarTheme,
    iconTheme: iconTheme,
    tabBarTheme: tabBarTheme,
  );

  base.copyWith(
    textTheme: base.textTheme.copyWith(
      bodyMedium: base.textTheme.bodyMedium!.copyWith(color: _kLightOnPrimary),
      bodyLarge: base.textTheme.bodyMedium!.copyWith(color: _kLightOnPrimary),
      bodySmall: base.textTheme.bodyMedium!.copyWith(color: _kLightOnPrimary),
      titleLarge: base.textTheme.titleLarge!.copyWith(color: _kLightOnPrimary),
      titleMedium: base.textTheme.titleLarge!.copyWith(color: _kLightOnPrimary),
      labelMedium: base.textTheme.labelMedium!.copyWith(
        color: _kLightOnPrimary,
      ),
      labelSmall: base.textTheme.labelSmall!.copyWith(color: _kLightOnPrimary),
    ),
  );

  return base;
}

ThemeData buildDarkThemeABSA(String language) {
  var colorScheme = const ColorScheme.dark().copyWith(
    primary: _kDarkPrimary,
    onPrimary: _kDarkOnPrimary,
    secondary: _kDarkSecondary,
    onSecondary: _kDarkOnSecondary,
  );

  var iconTheme = IconThemeData(color: colorScheme.primary);

  var tabBarTheme = ThemeData.light(useMaterial3: true).tabBarTheme.copyWith(
    indicatorColor: colorScheme.primary,
    labelColor: colorScheme.primary,
    unselectedLabelColor: colorScheme.primary.withOpacity(0.37),
    indicatorSize: TabBarIndicatorSize.tab,
  );

  var appBarTheme = ThemeData.light(useMaterial3: true).appBarTheme.copyWith(
    backgroundColor: colorScheme.onPrimary,
    foregroundColor: colorScheme.primary,
    actionsIconTheme: iconTheme,
  );

  var base = ThemeData.light(useMaterial3: true).copyWith(
    colorScheme: colorScheme,
    appBarTheme: appBarTheme,
    iconTheme: iconTheme,
    tabBarTheme: tabBarTheme,
  );

  base.copyWith(
    textTheme: base.textTheme.copyWith(
      bodyMedium: base.textTheme.bodyMedium!.copyWith(color: _kLightOnPrimary),
      bodyLarge: base.textTheme.bodyMedium!.copyWith(color: _kLightOnPrimary),
      bodySmall: base.textTheme.bodyMedium!.copyWith(color: _kLightOnPrimary),
      titleLarge: base.textTheme.titleLarge!.copyWith(color: _kLightOnPrimary),
      titleMedium: base.textTheme.titleLarge!.copyWith(color: _kLightOnPrimary),
      labelMedium: base.textTheme.labelMedium!.copyWith(
        color: _kLightOnPrimary,
      ),
      labelSmall: base.textTheme.labelSmall!.copyWith(color: _kLightOnPrimary),
    ),
  );

  return base;
}
