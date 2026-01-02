import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_button.dart';
import 'package:littlefish_merchant/common/presentaion/components/bottomNavBar/bottom_navbar_vm.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';

import 'icon_definitions.dart';
import 'models/config_classes.dart';
import 'page_navigation.dart';

class BottomNavBar extends StatefulWidget {
  final PageType? page;
  const BottomNavBar({Key? key, this.page}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    /***
     ** TODO add functionality to support default workspace.
      * So we need to save the currently selected space into pref storage.
      * When dispatching the selected, also save it to shared prefs
      * On Boot up, check shared_prefs if anything is selected then dispatch an event to set default workspace.
     */

    return StoreConnector<AppState, BottomNavBarVM>(
      converter: (store) => BottomNavBarVM.fromStore(store),
      builder: (ctx, vm) {
        var workspaceList = vm.workspaceState?.workspaces ?? [];
        if (workspaceList.isEmpty) {
          // TODO(lampian): workaround for sb - need to address cause of exception
          debugPrint('### bottomnavbar workspace is empty ');
          return const SizedBox.shrink();
        }
        var selectedWorkspace = vm.workspaceState?.selectedWorkspace;
        WorkSpaceData storeWorkspace = selectedWorkspace == null
            ? WorkSpaceData.fromWorkspace(workspaceList[0])
            : WorkSpaceData.fromWorkspace(selectedWorkspace);
        int? index = widget.page != null
            ? getPageIndex(widget.page!, storeWorkspace.navbarConfig)
            : null;

        var pageExists = storeWorkspace.navbarConfig.where(
          (item) => item.pageType == widget.page,
        );
        if (pageExists.isEmpty) index = null;

        // TODO(lampian): migrate to M3 preferred NavigationBar
        // return NavigationBar(
        //   destinations: const [
        //     NavigationDestination(icon: Icon(Icons.abc), label: 'label1'),
        //     NavigationDestination(icon: Icon(Icons.ac_unit), label: 'label2'),
        //   ],
        // );
        final appliedButtonTheme = Theme.of(context).extension<AppliedButton>();
        return BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedItemColor: appliedButtonTheme?.primaryDefault,
          selectedLabelStyle: TextStyle(
            color: appliedButtonTheme?.primaryDefault,
            fontSize: 12,
          ),
          unselectedLabelStyle: TextStyle(
            color: appliedButtonTheme?.neutralDefault,
            fontSize: 12,
          ),
          selectedIconTheme: IconThemeData(
            color: appliedButtonTheme?.primaryDefault,
            size: 24,
          ),
          unselectedIconTheme: IconThemeData(
            color: appliedButtonTheme?.neutralDefault,
            size: 24,
          ),
          type: BottomNavigationBarType.fixed,
          currentIndex: index ?? 0,
          onTap: (index) {
            navigateToPage(
              storeWorkspace.navbarConfig[index].pageType,
              context,
            );
          },
          items: _buildNavItems(context, storeWorkspace),
        );
      },
    );
  }

  List<BottomNavigationBarItem> _buildNavItems(
    BuildContext context,
    WorkSpaceData storeWorkspace,
  ) {
    List<BottomNavigationBarItem> items = [];
    for (var navBarConfig in storeWorkspace.navbarConfig) {
      items.add(
        bottomNavigationBarItem(
          icon: getIconForPageType(
            pageType: navBarConfig.pageType,
            active: false,
          ),
          activeIcon: getIconForPageType(
            pageType: navBarConfig.pageType,
            active: true,
          ),
          label: navBarConfig.description,
          context: context,
        ),
      );
    }

    return items;
  }

  BottomNavigationBarItem bottomNavigationBarItem({
    required IconData activeIcon,
    required IconData icon,
    required String label,
    required BuildContext context,
  }) {
    return BottomNavigationBarItem(
      activeIcon: Icon(activeIcon),
      icon: Icon(icon),
      label: label,
    );
  }
}

enum PageType {
  home,
  sell,
  sales,
  orderFulfillment,
  products,
  stock,
  eStore,
  more,
  getPaid,
}
