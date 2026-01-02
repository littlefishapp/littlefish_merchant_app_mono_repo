import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app/theme/app_bar_data_set.dart';
import '../../../app/theme/applied_system/applied_surface.dart';
import '../../../injector.dart';

// TODO(lampian): expand for use by other cohorts and diffent themes
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget>? actions;
  final bool automaticallyImplyLeading;
  final Color? backgroundColor;
  final PreferredSizeWidget? bottom;
  final bool centerTitle;
  final double elevation;
  final double height;
  final Widget? leading;
  final bool primary;
  final Color? shadowColor;
  final bool overrideShadowColor;
  final Color? surfaceTintColor;
  final Widget? title;
  final IconThemeData? iconTheme;
  final String? semanticsIdentifier;
  final String? semanticsLabel;

  const CustomAppBar({
    super.key,
    this.actions,
    this.automaticallyImplyLeading = true,
    this.backgroundColor,
    this.bottom,
    this.centerTitle = false,
    this.elevation = 0.0,
    this.leading,
    this.primary = true,
    this.shadowColor,
    this.surfaceTintColor,
    required this.title,
    this.iconTheme,
    this.height = 56,
    this.overrideShadowColor = false,
    this.semanticsIdentifier = 'defaultSemanticsIdentifier',
    this.semanticsLabel = 'defaultSemanticsLabel',
  });

  @override
  Widget build(BuildContext context) {
    final appliedSurface = Theme.of(context).extension<AppliedSurface>();
    final shadow = overrideShadowColor
        ? shadowColor
        : appliedSurface?.secondary ?? Colors.red;

    final appBarDataSet = getIt.get<AppBarDataSet>();
    final gradient1 = appBarDataSet.appBarGradientStart;
    final gradient2 = appBarDataSet.appBarGradientEnd;
    final useStatusBarDark = appBarDataSet.useStatusBarDark;

    final gradient = Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [gradient1, gradient2],
        ),
      ),
    );

    final overlay = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: useStatusBarDark
          ? Brightness.dark
          : Brightness.light,
      statusBarBrightness: useStatusBarDark
          ? Brightness.light
          : Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: useStatusBarDark
          ? Brightness.dark
          : Brightness.light,
    );

    return AppBar(
      systemOverlayStyle: overlay,
      actions: actions,
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: appBarDataSet.appBarBackground,
      bottom: bottom,
      centerTitle: centerTitle,
      leading: Semantics(
        identifier: semanticsIdentifier,
        label: semanticsLabel,
        child: leading,
      ),
      primary: primary,
      shadowColor: shadow,
      surfaceTintColor: appBarDataSet.appBarEnableSurfaceTint
          ? surfaceTintColor
          : Colors.transparent,
      title: title,
      iconTheme: iconTheme,
      flexibleSpace: appBarDataSet.appBarUseGradient ? gradient : null,
      leadingWidth: 32,
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, height);
}
