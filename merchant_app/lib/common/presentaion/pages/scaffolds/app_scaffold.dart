import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/app_device_incompatibility.dart';
import 'package:littlefish_merchant/common/presentaion/components/keyboard_dismissal_utility.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/common/presentaion/components/drawers/app_main_drawer.dart';
import 'package:littlefish_merchant/common/presentaion/components/bottomNavBar/bottom_navbar.dart';
import 'package:littlefish_merchant/shared/constants/semantics_constants.dart';
import 'package:littlefish_merchant/tools/security/app_security_validation.dart';
import '../../../../app/theme/applied_system/applied_text_icon.dart';
import '../../../../services/route_service.dart';
import '../../components/custom_app_bar.dart';
import 'profile_navbar_actions.dart';

const bool _enableProfileActionDefault = true;

class AppScaffold extends StatefulWidget {
  final String title;
  final Widget? titleWidget;
  final bool centreTitle;
  final NavbarType navbarType;
  final Widget? subTitleWidget;
  final Widget? floatWidget;
  final Color? backgroundColor;
  final Widget? navBar;
  final int navigationIndex;
  final Widget body;
  final bool displayFloat;
  final bool displayAppBar;
  final bool displaySearchBar;
  final bool displayNavBar;
  final bool displayNavDrawer;
  final bool displayBackNavigation;
  final Function? floatAction;
  final Function(String value)? onSearch;
  final Function()? onBackPressed;
  final IconData floatIcon;
  final Key? floatIconKey;
  final FloatingActionButtonLocation floatLocation;
  final List<Widget>? actions;
  final List<Widget>? persistentFooterButtons;
  final Key? scaffoldKey;
  final Key? drawerKey;
  final Function? onRefresh;
  final bool hasDrawer;
  final bool? resizeToAvoidBottomPadding;
  final bool? enableProfileAction;
  final PreferredSizeWidget? alternativeAppBar;

  const AppScaffold({
    Key? key,
    this.scaffoldKey,
    this.drawerKey,
    this.title = '',
    this.titleWidget,
    this.onBackPressed,
    required this.body,
    this.subTitleWidget,
    this.floatIconKey,
    this.centreTitle = false,
    this.displayNavBar = false,
    this.displayBackNavigation = true,
    this.navbarType = NavbarType.advanced,
    this.backgroundColor,
    this.navigationIndex = 0,
    this.onRefresh,
    this.displayFloat = false,
    this.floatAction,
    this.floatIcon = Icons.more_horiz,
    this.displayAppBar = true,
    this.displaySearchBar = false,
    this.displayNavDrawer = false,
    this.hasDrawer = false,
    this.onSearch,
    this.floatLocation = FloatingActionButtonLocation.centerDocked,
    this.actions,
    this.navBar,
    this.floatWidget,
    this.persistentFooterButtons,
    this.resizeToAvoidBottomPadding,
    this.enableProfileAction = _enableProfileActionDefault,
    this.alternativeAppBar,
  }) : super(key: key);

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends RouteAwareWidget<AppScaffold>
    with WidgetsBindingObserver {
  final GlobalKey profileNavKey = GlobalKey();
  late bool displayFloat;
  bool isManagement = true;
  int selectedIndex = 0;

  /// NOTE: [JAILBREAK] AND [ROOT] DETECTION
  bool _showIncompatibilityScreen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    displayFloat = widget.displayFloat;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (!AppVariables.isPOSBuild) {
        _performIntegrityCheck();
      }
    }
  }

  Future<void> _performIntegrityCheck() async {
    try {
      bool deviceIntegritySecure = await AppSecurityValidation()
          .checkDeviceIntegrity();

      if (!deviceIntegritySecure) {
        if (mounted) {
          setState(() {
            _showIncompatibilityScreen = true;
          });
        }

        // If device requirements are not met, show a message and exit the app
        // Automatically exit the app after 30 seconds
        Future.delayed(const Duration(seconds: 30), () async {
          SystemNavigator.pop();
          exit(0);
        });
      } else {
        // Device is secure, ensure we're not showing incompatibility screen
        if (_showIncompatibilityScreen && mounted) {
          setState(() {
            _showIncompatibilityScreen = false;
          });
        }
      }
    } catch (e) {
      debugPrint('Error during integrity check: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // JAILBREAK & ROOT DETECTION
    if (_showIncompatibilityScreen) {
      return const AppDeviceIncompatibility();
    }

    bool showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;
    final appliedTextIconTheme = Theme.of(context).extension<AppliedTextIcon>();
    final onSurfaceColor = appliedTextIconTheme?.primaryHeader;
    final textColor = appliedTextIconTheme?.primaryHeader;
    final iconColor = appliedTextIconTheme?.primaryHeader;

    if (!widget.displayFloat) {
      displayFloat = false;
    } else {
      displayFloat = showFab;
    }

    var appBarActions = widget.actions;

    if (widget.onRefresh != null) {
      appBarActions ??= <Widget>[];

      appBarActions.add(
        IconButton(
          icon: Icon(Icons.refresh, color: iconColor),
          onPressed: () => widget.onRefresh!(),
        ),
      );
    }

    bool showProfileAction =
        widget.enableProfileAction ?? _enableProfileActionDefault;
    if (appBarActions != null) {
      if (AppVariables.store!.state.enableProfileNavBar == true &&
          showProfileAction) {
        final newActionsList = List.from(appBarActions);
        newActionsList.add(ProfileNavbarActions(key: profileNavKey));
        appBarActions = List.from(newActionsList);
      }
    } else {
      if (AppVariables.store!.state.enableProfileNavBar == true &&
          showProfileAction) {
        appBarActions = [];
        appBarActions.add(ProfileNavbarActions(key: profileNavKey));
      }
    }

    var floatingActionButton2 = widget.floatWidget;

    Widget title;
    if (widget.titleWidget != null) {
      title = widget.titleWidget!;
      if (title is Text) {
        final titleString = title.data ?? '';
        title = context.labelLarge(
          titleString,
          color: textColor,
          isSemiBold: true,
        );
      } else {
        title = widget.titleWidget!;
      }
    } else if (widget.title.isNotEmpty) {
      title = context.labelLarge(
        widget.title,
        color: textColor,
        isSemiBold: true,
      );
    } else {
      title = context.labelLarge('', isBold: true);
    }
    return wrapWithPopScope(
      context,
      KeyboardDismissalUtility(
        content: Theme(
          data: Theme.of(context).copyWith(
            dividerTheme: const DividerThemeData(color: Colors.transparent),
          ),
          child: SafeArea(
            top: false,
            bottom: true,
            child: Scaffold(
              backgroundColor:
                  widget.backgroundColor ??
                  Theme.of(context).colorScheme.background,
              key: widget.scaffoldKey,
              drawer: widget.hasDrawer ? const AppMainDrawer() : null,
              persistentFooterButtons: widget.persistentFooterButtons,
              appBar: widget.displayAppBar && widget.alternativeAppBar == null
                  ? CustomAppBar(
                      // elevation: isSBSA ? 0 : 1,
                      surfaceTintColor: Colors.transparent,
                      centerTitle: widget.centreTitle,
                      shadowColor: Theme.of(
                        context,
                      ).colorScheme.onSecondary.withOpacity(0.3),
                      automaticallyImplyLeading: widget.displayBackNavigation,
                      semanticsIdentifier: widget.displayNavDrawer
                          ? SemanticsConstants.kBurgerMenu
                          : widget.displayBackNavigation
                          ? SemanticsConstants.kBack
                          : null,
                      semanticsLabel: widget.displayNavDrawer
                          ? SemanticsConstants.kBurgerMenu
                          : widget.displayBackNavigation
                          ? SemanticsConstants.kBack
                          : null,
                      leading: widget.displayNavDrawer
                          ? Builder(
                              builder: (context) {
                                return IconButton(
                                  key: widget.drawerKey,
                                  splashRadius: 128,
                                  icon: Icon(Icons.menu, color: onSurfaceColor),
                                  onPressed: () =>
                                      Scaffold.of(context).openDrawer(),
                                );
                              },
                            )
                          : widget.displayBackNavigation
                          ? Builder(
                              builder: (context) {
                                return IconButton(
                                  icon: Icon(
                                    Platform.isIOS
                                        ? Icons.arrow_back_ios
                                        : Icons.arrow_back,
                                    color: onSurfaceColor,
                                  ),
                                  onPressed: () => widget.onBackPressed != null
                                      ? widget.onBackPressed!()
                                      : Navigator.of(context).pop(),
                                );
                              },
                            )
                          : null,
                      title: title,
                      actions: appBarActions,
                      bottom: widget.subTitleWidget == null
                          ? null
                          : PreferredSize(
                              preferredSize: Size.fromHeight(
                                widget.subTitleWidget == null ? 45.0 : 72.0,
                              ),
                              child: widget.subTitleWidget!,
                            ),
                    )
                  : widget.displayAppBar && widget.alternativeAppBar != null
                  ? widget.alternativeAppBar!
                  : null,
              bottomNavigationBar: widget.displayNavBar
                  ? widget.navBar ?? const BottomNavBar()
                  : null,
              body: widget.backgroundColor != null
                  ? Stack(
                      children: <Widget>[
                        Container(
                          color: Theme.of(
                            context,
                          ).extension<AppliedSurface>()?.primary,
                        ),
                        widget.body,
                      ],
                    )
                  : widget.body,
              floatingActionButton: displayFloat ? floatingActionButton2 : null,
              floatingActionButtonLocation: displayFloat
                  ? widget.floatLocation
                  : null,
              resizeToAvoidBottomInset: widget.resizeToAvoidBottomPadding,
            ),
          ),
        ),
      ),
    );
  }
}
