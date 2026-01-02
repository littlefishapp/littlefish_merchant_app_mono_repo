import 'package:flutter/cupertino.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/ui/checkout/sell_page.dart';
import 'package:littlefish_merchant/ui/menus/more_control_menu_page.dart';
import 'package:littlefish_merchant/features/order_fulfilment%20/presentation/pages/order_fulfillment_home_page.dart';
import 'package:littlefish_merchant/ui/online_store/tools.dart';
import 'package:littlefish_merchant/ui/products/products/management/products_management_page.dart';
import 'package:littlefish_merchant/ui/products/products/management/stock_management_page.dart';
import '../../../../environment/environment_config.dart';
import '../../../../features/payment_links/presentation/pages/get_paid_page.dart';
import '../../../../ui/home/home_page.dart';
import '../../../../ui/sales/sales_page.dart';
import 'bottom_navbar.dart';
import 'models/config_classes.dart';

void navigateToPage(PageType? pageType, BuildContext context) {
  switch (pageType) {
    case PageType.home:
      Navigator.pushNamed(context, HomePage.route);
      break;
    case PageType.sell:
      var state = AppVariables.store!.state;
      final sellNowModuleDisabled =
          state.enableNewSale == EnableOption.disabled;
      if (sellNowModuleDisabled) {
        Navigator.pushNamed(context, HomePage.route);
      } else {
        Navigator.pushNamed(context, SellPage.route);
      }
      break;
    case PageType.sales:
      Navigator.pushNamed(context, SalesPage.route);
      break;
    case PageType.orderFulfillment:
      Navigator.pushNamed(context, OrderFulfillmentHomePage.route);
      break;
    case PageType.getPaid:
      Navigator.pushNamed(context, GetPaidPage.route);
      break;
    case PageType.products:
      Navigator.pushNamed(context, ProductsManagementPage.route);
      break;
    case PageType.stock:
      Navigator.pushNamed(context, StockManagementPage.route);
      break;
    case PageType.eStore:
      Navigator.pushNamed(
        context,
        getOnlineStoreRoute(
          AppVariables.store!.state.storeState.store?.isConfigured ?? false,
        ),
      );
      break;
    case PageType.more:
      Navigator.pushNamed(context, MoreControlMenuPage.route);
      break;
    case null:
      Navigator.pushNamed(context, SalesPage.route);
      break;
  }
}

int getPageIndex(PageType page, List<NavBarConfig> navBarConfig) {
  int index = -1;
  for (int i = 0; i < navBarConfig.length; i++) {
    if (page == navBarConfig[i].pageType) {
      index = i;
      break;
    }
  }
  return index;
}
