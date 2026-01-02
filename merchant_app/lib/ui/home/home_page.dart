// removed ignore: depend_on_referenced_packages
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/ui/home/pages/home_dashboard_page.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:redux/redux.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/shared/constants/permission_name_constants.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:littlefish_merchant/ui/online_store/orders/orders_home_page.dart';
import 'package:littlefish_merchant/models/security/access_management/module.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/user/user_state.dart';
import 'package:littlefish_merchant/ui/home/home_vm.dart';
import 'package:littlefish_merchant/ui/home/pages/home_board_page.dart';
import 'package:littlefish_merchant/ui/home/widgets/all_menu_page.dart';
import 'package:littlefish_merchant/ui/home/widgets/favorites_page.dart';
import 'package:littlefish_merchant/ui/home/widgets/home_action.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/common/presentaion/components/list_leading_tile.dart';
import '../../common/presentaion/components/bottomNavBar/bottom_navbar.dart';
import '../../common/presentaion/components/app_navbar.dart';

class HomePage extends StatefulWidget {
  static const route = 'home/home';

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeVM? vm;

  late int _selectedIndex;

  PageController? _controller;

  final GlobalKey _burgerNav = GlobalKey();
  final GlobalKey _floatIconKey = GlobalKey();

  List<NavbarItem> navMenuOptions = [];

  NavbarItem? get _currentNavOption {
    if (navMenuOptions.isEmpty) return null;

    return navMenuOptions[_selectedIndex];
  }

  @override
  void initState() {
    _selectedIndex = 0;
    _controller = PageController(initialPage: _selectedIndex);
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, HomeVM>(
      converter: (store) => HomeVM.fromStore(store),
      builder: (ctx, vm) {
        this.vm = vm;

        if (EnvironmentProvider.instance.isLargeDisplay!) {
          return scaffoldTablet(context, vm, StoreProvider.of<AppState>(ctx));
        } else {
          return scaffold(context, vm, StoreProvider.of<AppState>(ctx));
        }
      },
    );
  }

  AppScaffold scaffoldTablet(context, HomeVM vm, Store<AppState> store) =>
      AppScaffold(
        enableProfileAction: false,
        drawerKey: _burgerNav,
        displayNavBar: false,
        displayAppBar: _currentNavOption?.hasAppBar ?? true,
        hasDrawer: true,
        displayNavDrawer: true,
        displayBackNavigation: vm.store!.state.enableSideNavDrawer!,
        navBar: const BottomNavBar(page: PageType.home),
        body: dashBoardBody(context, vm.store!, vm),
      );

  AppScaffold scaffold(context, HomeVM vm, Store<AppState> store) =>
      AppScaffold(
        drawerKey: _burgerNav,
        displayNavBar: AppVariables.store!.state.enableBottomNavBar!,
        displayAppBar: _currentNavOption?.hasAppBar ?? true,
        hasDrawer: AppVariables.store!.state.enableSideNavDrawer!,
        displayNavDrawer: AppVariables.store!.state.enableSideNavDrawer!,
        displayBackNavigation: vm.store!.state.enableSideNavDrawer!,
        navBar: const BottomNavBar(page: PageType.home),
        body: bodyMobile(context, store, vm),
        enableProfileAction: true,
      );

  Widget bodyMobile(
    BuildContext context,
    Store<AppState> store,
    HomeVM vm,
  ) => Column(
    children: [
      Expanded(
        child: PageView(
          controller: _controller,
          physics: const NeverScrollableScrollPhysics(),
          children:
              (vm.viewMode ?? UserViewingMode.pointOfSale) ==
                        UserViewingMode.pointOfSale
                    ? mobileMenu(store)
                    : <Widget>[
                        vm.isDefaultHomeContent ||
                                AppVariables
                                    .isPOSBuild //ToDo: change this to correct version and layout management
                            ? const HomeBoardPage()
                            : const HomeDashboardPage(),
                      ]
                ..addAll(mobileMenu(store)),
        ),
      ),
    ],
  );

  Widget dashBoardBody(
    BuildContext context,
    Store<AppState> store,
    HomeVM vm,
  ) => Column(
    children: [
      Expanded(
        child: PageView(
          controller: _controller,
          physics: const NeverScrollableScrollPhysics(),
          children:
              (vm.viewMode ?? UserViewingMode.pointOfSale) ==
                        UserViewingMode.pointOfSale
                    ? mobileMenu(store)
                    : <Widget>[
                        (store.state.isLargeDisplay ?? false)
                            ? const HomeDashboardPage()
                            : vm
                                  .isDefaultHomeContent //ToDo: change this to correct version and layout management
                            ? const HomeBoardPage()
                            : const HomeDashboardPage(),
                      ]
                ..addAll(mobileMenu(store)),
        ),
      ),
    ],
  );

  List<Widget> mobileMenu(store) => [
    if (userHasPermission(allowOrder)) const OrdersHomePage(),
    FavoritesPage(
      parentContext: context,
      isLargeDisplay: store.state.isLargeDisplay ?? false,
      accessManager: store?.state?.authState?.accessManager,
    ),
    const AllMenuPage(),
  ];

  Row tabletMenu(context, Store<AppState> store, HomeVM vm) => Row(
    children: [
      Expanded(
        child: Container(
          color: Colors.grey.shade50,
          child: Scrollbar(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: <Widget>[
                  Container(
                    color: Colors.grey.shade50,
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: FavoritesPage(
                        parentContext: context,
                        isLargeDisplay: true,
                        accessManager: store.state.authState.accessManager,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      const Expanded(child: AllMenuPage()),
      Container(),
    ],
  );

  Container actionsGrid(context, bool isLargeDisplay) {
    AccessManager accessManager = StoreProvider.of<AppState>(
      context,
    ).state.authState.accessManager!;

    var shortcuts = accessManager.getShortcuts();

    var actions = shortcuts
        .map(
          (qa) => HomeAction(
            icon: qa.icon,
            title: qa.name,
            color: Theme.of(context).colorScheme.primary,
            isLargeDisplay: isLargeDisplay,
            // onTap: qa.action == null ? null : () => qa.action(context),
            route: qa.route,
          ),
        )
        .toList();

    return Container(
      child: isLargeDisplay
          ? Container(
              color: Colors.white,
              margin: const EdgeInsets.only(
                top: 16,
                bottom: 16,
                left: 8,
                right: 8,
              ),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) => Container(
                    constraints: BoxConstraints.tight(
                      Size(104, MediaQuery.of(context).size.height / 3.5),
                    ),
                    child: actions[index],
                  ),
                  itemCount: actions.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      const CommonDivider(height: 0.5),
                ),
              ),
            )
          : Container(
              color: Colors.white,
              margin: const EdgeInsets.only(
                top: 16,
                bottom: 16,
                left: 8,
                right: 8,
              ),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 104,
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) => Container(
                    constraints: BoxConstraints.tight(
                      Size(MediaQuery.of(context).size.width / 3.5, 96),
                    ),
                    child: actions[index],
                  ),
                  itemCount: actions.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      const VerticalDivider(),
                ),
              ),
            ),
    );
  }

  Container quickActions(context, bool isLargeDisplay) {
    AccessManager accessManager = StoreProvider.of<AppState>(
      context,
    ).state.authState.accessManager!;

    var shortcuts = accessManager.getAllQuickActions();

    return Container(
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: GridView.count(
        physics: const BouncingScrollPhysics(),
        crossAxisCount: isLargeDisplay ? 6 : 2,
        mainAxisSpacing: isLargeDisplay ? 0 : 8,
        crossAxisSpacing: isLargeDisplay ? 0 : 0,
        childAspectRatio: 1.5,
        shrinkWrap: true,
        children: shortcuts
            .map(
              (qa) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                child: Material(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.white,
                  elevation: 2,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(4),
                    onTap: (qa.route != null)
                        ? () => Navigator.of(context).pushNamedAndRemoveUntil(
                            qa.route!,
                            ModalRoute.withName(HomePage.route),
                          )
                        : () {
                            if (qa.action == null) {
                              showComingSoon(context: context);
                            } else {
                              Navigator.of(context).pop();
                              qa.action!(context);
                            }
                          },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          qa.icon,
                          color: Theme.of(context).colorScheme.primary,
                          size: 54,
                        ),
                        const SizedBox(height: 4),
                        Text(qa.name!),
                      ],
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  GroupedListView<NavbarItem, String?> allMenuOptions(
    BuildContext context,
    bool isLargeDisplay,
  ) {
    var store = StoreProvider.of<AppState>(context);

    AccessManager accessManager = store.state.authState.accessManager!;

    var isOnline = store.state.hasInternet;

    var options = accessManager
        .getAllMenuOptions()
        .map(
          (m) => NavbarItem(
            route: m.route,
            icon: m.icon,
            text: m.name,
            allowOffline: m.allowOffline,
            specialDisplay: m.specialItem,
            subItems: m.items
                ?.map(
                  (o) => NavbarItem(
                    route: o.route,
                    icon: o.icon,
                    text: o.name,
                    allowOffline: o.allowOffline,
                    specialDisplay: o.specialItem,
                  ),
                )
                .toList(),
          ),
        )
        .toList();

    return GroupedListView(
      sort: true,
      physics: const BouncingScrollPhysics(),
      elements: options,
      //group by general / quick terms or the category section
      groupBy: (dynamic option) {
        var opt = option as NavbarItem;

        if (opt.subItems == null || opt.subItems!.isEmpty) {
          return opt.text;
        } else {
          return opt.text;
        }
      },
      itemBuilder: (BuildContext context, NavbarItem element) =>
          element.subItems == null || element.subItems!.isEmpty
          ? listMenuItem(context, element, isOnline)
          : Column(
              children: element.subItems!
                  .map((n) => listMenuItem(context, n, isOnline))
                  .toList(),
            ),
      groupSeparatorBuilder: (String? value) => Container(
        color: Colors.grey.shade50,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Text(
          value!,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade400,
          ),
        ),
      ),
    );
  }

  Widget listMenuItem(context, option, isOnline) => ListTile(
    tileColor: Theme.of(context).colorScheme.background,
    onTap: (isOnline || option.allowOffline)
        ? () {
            if (option.route == HomePage.route) {
              Navigator.of(context).pushNamed(
                option.route,
                arguments: ModalRoute.withName(option.route!),
              );
            }

            if (option.route != null && option.route.isNotEmpty) {
              Navigator.of(context).pushNamed(option.route);
            }
          }
        : () {
            showMessageDialog(
              context,
              'this feature is only available when you are online',
              MdiIcons.wifi,
            );
          },
    leading: ListLeadingIconTile(
      icon: option.icon,
      color: Theme.of(context).colorScheme.secondary,
    ),
    trailing: Icon(Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_forward),
    title: Text(option.text),
  );
}
