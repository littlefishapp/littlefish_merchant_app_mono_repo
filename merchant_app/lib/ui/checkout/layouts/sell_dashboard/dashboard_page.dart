import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:littlefish_core/configuration/config_service.dart';
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/app/theme/ui_state_data.dart';
import 'package:littlefish_merchant/bootstrap.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/cards/card_neutral.dart';
import 'package:littlefish_merchant/common/presentaion/components/custom_app_bar.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/services/modal_service.dart';
import 'package:littlefish_merchant/common/presentaion/components/icon_text_tile.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_merchant/models/shared/image_representable.dart';
import 'package:littlefish_merchant/redux/auth/auth_actions.dart';
import 'package:littlefish_merchant/ui/checkout/layouts/sell_dashboard/custom_bottom_modal_sheet.dart';
import 'package:littlefish_merchant/ui/checkout/layouts/sell_dashboard/dash_board_header_info.dart';
import 'package:littlefish_merchant/ui/checkout/layouts/sell_dashboard/dashboard_actions.dart';
import 'package:littlefish_merchant/ui/checkout/layouts/sell_dashboard/dashboard_header.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/checkout/layouts/sell_dashboard/sell_view_item.dart';
import 'package:littlefish_merchant/ui/security/login/login_page.dart';
import 'package:redux/redux.dart';

class DashboardPage extends StatefulWidget {
  static const route = 'checkout/sell-dashboard';

  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final LittleFishCore core = LittleFishCore.instance;
  var tileWidthToUse = 100.0;
  var isTablet = false;
  var isGuest = false;
  late DashBoardHeaderInfo dashboardHeaderInfo;
  var guestLoginControlIsEnabled = true;

  @override
  void initState() {
    super.initState();
    final ConfigService configService = core.get<ConfigService>();
    guestLoginControlIsEnabled = configService.getBoolValue(
      key: 'sell_layout_guest_login_control',
      defaultValue: true,
    );
    debugPrint('### SellPage layout: $guestLoginControlIsEnabled');
  }

  @override
  Widget build(BuildContext context) {
    isTablet = EnvironmentProvider.instance.isLargeDisplay ?? false;
    return StoreBuilder(
      builder: (BuildContext context, Store<AppState> store) {
        isGuest = AppVariables.isInGuestMode;
        return LayoutBuilder(
          builder: (context, constraints) {
            dashboardHeaderInfo = getDashBoardHeaderInfo();
            return isTablet
                ? tabletScaffold(
                    context: context,
                    store: store,
                    constraints: constraints,
                  )
                : mobileScaffold(
                    context: context,
                    store: store,
                    constraints: constraints,
                  );
          },
        );
      },
    );
  }

  Widget mobileScaffold({
    required BuildContext context,
    required Store<AppState> store,
    required BoxConstraints constraints,
  }) {
    final availableWidth = constraints.maxWidth;
    final availableHeight = constraints.maxHeight;
    tileWidthToUse = availableWidth * 0.8 / 2;
    final showLoginControl = isGuest && guestLoginControlIsEnabled;
    return AppScaffold(
      alternativeAppBar: dashboardAppBar() as PreferredSizeWidget,
      titleWidget: Image.asset(UIStateData().appLogo, width: 24),
      centreTitle: true,
      backgroundColor: Colors.transparent,
      displayBackNavigation: false,
      enableProfileAction: false,
      displayNavDrawer: true,
      hasDrawer: true,
      persistentFooterButtons: showLoginControl ? footerButton() : [],
      body: Container(
        color: Theme.of(context).extension<AppliedSurface>()!.brandSubTitle,
        child: ListView(
          children: [
            DashboardHeader(info: dashboardHeaderInfo),
            staggeredGrid(context: context, store: store, isTablet: false),
          ],
        ),
      ),
    );
  }

  Widget tabletScaffold({
    required BuildContext context,
    required Store<AppState> store,
    required BoxConstraints constraints,
  }) {
    final availableWidth = constraints.maxWidth;
    final availableHeight = constraints.maxHeight;
    final showLoginControl = isGuest && guestLoginControlIsEnabled;
    tileWidthToUse = availableWidth * 0.8 / 2;
    return AppScaffold(
      alternativeAppBar: dashboardAppBar() as PreferredSizeWidget,
      titleWidget: Image.asset(UIStateData().appLogo, width: 24),
      centreTitle: true,
      backgroundColor: Colors.transparent,
      displayBackNavigation: false,
      enableProfileAction: false,
      displayNavDrawer: true,
      hasDrawer: true,
      persistentFooterButtons: showLoginControl ? footerButton() : [],
      body: Container(
        color: Theme.of(context).extension<AppliedSurface>()!.brandSubTitle,
        child: ListView(
          children: [
            DashboardHeader(info: dashboardHeaderInfo),
            staggeredGrid(context: context, store: store, isTablet: true),
          ],
        ),
      ),
    );
  }

  Widget staggeredGrid({
    required BuildContext context,
    required Store<AppState> store,
    bool isTablet = false,
  }) {
    final options = DashBoardActions().dashBoardActions(
      context: context,
      store: store,
      isGuestMode: isGuest,
    );

    final listTiles = buildListTiles(options);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StaggeredGrid.count(
        crossAxisCount: isTablet ? 6 : 2,
        crossAxisSpacing: isTablet ? 12.0 : 4,
        mainAxisSpacing: isTablet ? 12 : 4,
        children: listTiles,
      ),
    );
  }

  List<Widget> buildListTiles(List<SellViewItem> sellViewItems) {
    List<Widget> tiles = [];
    for (final item in sellViewItems) {
      // if (item.route.isEmpty) continue;
      if (item.name.isEmpty) continue;
      final tile = gridTile(
        context: context,
        icon: item.iconData ?? Icons.dashboard,
        iconString: item.icon,
        title: item.displayName,
        onTap: () async {
          if (item.subItems.isNotEmpty) {
            final modalItems = item.subItems.map((e) => modalItem(e)).toList();
            // final modalItems = [testPrintLast()];
            showCustomBottomSheet(context: context, items: modalItems);
          } else if (item.route.isNotEmpty) {
            Navigator.of(context).pushNamed(item.route);
          } else if (item.action != null) {
            await item.action!(context);
          }
        },
      );
      tiles.add(tile);
    }

    return tiles;
  }

  Widget gridTile({
    required BuildContext context,
    IconData icon = Icons.dashboard,
    String iconString = '',
    String title = 'Dashboard',
    required Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: StaggeredGridTile.count(
        crossAxisCellCount: 1,
        mainAxisCellCount: 1,
        child: AspectRatio(
          aspectRatio: 1,
          child: CardNeutral(
            elevation: AppVariables.appDefaultElevation,
            margin: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AnyImageRepresentable(
                  name: iconString,
                  iconData: icon,
                  width: 48,
                ).buildWidget(),
                const SizedBox(height: 8),
                context.labelLarge(
                  title,
                  color: Theme.of(
                    context,
                  ).extension<AppliedTextIcon>()!.secondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void logOutCallback(BuildContext c) async {
    bool? result = await getIt<ModalService>().showActionModal(
      context: context,
      title: 'Logout',
      acceptText: 'Yes, Logout',
      cancelText: 'No, Cancel',
      description: 'Are you sure you want to go?',
    );

    if ((result ?? false) && c.mounted) {
      StoreProvider.of<AppState>(c).dispatch(signOut(reason: 'user-signout'));
    }
  }

  DashBoardHeaderInfo getDashBoardHeaderInfo() {
    LittleFishCore core = LittleFishCore.instance;

    final fallBack = const DashBoardHeaderInfo().toJson();
    final ConfigService configService = core.get<ConfigService>();
    final jsonInfo = configService.getObjectValue(
      key: 'config_dashboard_info',
      defaultValue: fallBack,
    );
    final info = const DashBoardHeaderInfo().fromJson(jsonInfo);
    final infoWithBusinessName = info.copyWith(
      subtitle: AppVariables.businessName,
    );
    return infoWithBusinessName;
  }

  Widget dashboardAppBar() {
    final appliedTextIconTheme = Theme.of(context).extension<AppliedTextIcon>();
    final onSurfaceColor = appliedTextIconTheme?.primaryHeader;
    return CustomAppBar(
      title: Image.asset(UIStateData().appLogo, width: 24),
      centerTitle: true,
      elevation: 0.0,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      overrideShadowColor: true,
      leading: Builder(
        builder: (context) {
          return IconButton(
            splashRadius: 128,
            icon: Icon(Icons.menu, color: onSurfaceColor),
            onPressed: () => Scaffold.of(context).openDrawer(),
          );
        },
      ),
    );
  }

  // Widget testPrintLast() {
  //   return modalItem(
  //     SellViewItem(
  //       displayName: 'Print Batch Receipt',
  //       name: 'printLastReceipt',
  //       iconData: Icons.receipt_long_sharp,
  //       route: PrintBatchDialogue.route,
  //     ),
  //   );
  // }

  Widget modalItem(SellViewItem item) {
    return IconTextTile(
      icon: Icon(item.iconData ?? Icons.dashboard),
      text: context.paragraphMedium(item.displayName),
      onTap: () async {
        final contextToUse = globalNavigatorKey.currentContext ?? context;
        if (item.route.isNotEmpty) {
          await Navigator.of(contextToUse).pushNamed(item.route);
          if (contextToUse.mounted) {
            Navigator.pop(contextToUse);
          }
        } else if (item.action != null) {
          await item.action!(contextToUse);
        }
      },
    );
  }

  List<Widget> footerButton() {
    return [
      ButtonPrimary(
        text: 'SIGN IN',
        onTap: (context) {
          StoreProvider.of<AppState>(
            context,
          ).dispatch(signOut(reason: 'user-signout'));
          Navigator.pushNamed(context, LoginPage.route);
        },
      ),
    ];
  }
}
