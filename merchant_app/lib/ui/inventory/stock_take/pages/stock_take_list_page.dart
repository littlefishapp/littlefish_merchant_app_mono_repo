// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';

// Project imports:
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/inventory/inventory_actions.dart';
import 'package:littlefish_merchant/ui/inventory/stock_take/pages/stock_take_page.dart';
import 'package:littlefish_merchant/ui/inventory/stock_take/widgets/stock_take_list.dart';
import 'package:littlefish_merchant/ui/inventory/view_models/view_models.dart';
import 'package:littlefish_merchant/common/presentaion/components/decorated_text.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';

import '../../../../common/presentaion/components/buttons/footer_buttons_icon_primary.dart';
import '../../../../models/stock/stock_take_item.dart';

class StockTakeListPage extends StatelessWidget {
  static const String route = 'inventory/adjustments';

  const StockTakeListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, StockTakeListVM>(
      onInit: (store) => store.dispatch(getStockRuns()),
      converter: (store) => StockTakeListVM.fromStore(store),
      builder: (BuildContext context, StockTakeListVM vm) =>
          EnvironmentProvider.instance.isLargeDisplay!
          ? scaffoldLandscape(context, vm)
          : scaffold(context, vm),
    );
  }

  Widget scaffoldLandscape(context, StockTakeListVM vm) {
    const showSideNav = true;
    return AppScaffold(
      title: 'Inventory Adjustments',
      enableProfileAction: !showSideNav,
      hasDrawer: false,
      displayNavDrawer: false,
      body: !vm.isLoading!
          ? Row(
              children: <Widget>[
                Expanded(flex: 4, child: stockList(context, vm)),
                const VerticalDivider(width: 0.5),
                Expanded(
                  flex: 4,
                  child:
                      vm.selectedItem != null &&
                          !(vm.selectedItem!.isNew ?? false)
                      ? const StockTakePage()
                      : const Center(
                          child: DecoratedText(
                            'Select Run',
                            alignment: Alignment.center,
                            fontSize: 24,
                          ),
                        ),
                ),
              ],
            )
          : const AppProgressIndicator(),
    );
  }

  Widget scaffold(BuildContext context, StockTakeListVM vm) {
    return AppScaffold(
      persistentFooterButtons: [addCustomerRefresh(context, vm)],
      title: 'Inventory Adjustments',
      body: !vm.isLoading!
          ? stockList(context, vm)
          : const AppProgressIndicator(),
    );
  }

  StockTakeList stockList(context, StockTakeListVM vm) => StockTakeList(
    items: vm.items,
    selectedItem: vm.selectedItem,
    onTap: (item) {
      if (EnvironmentProvider.instance.isLargeDisplay!) {
        vm.onSetSelected(item);
      } else {
        vm.onSetSelected(item);
        Navigator.of(context).pushNamed(StockTakePage.route, arguments: item);
      }
    },
  );

  Widget addCustomerRefresh(BuildContext context, StockTakeListVM vm) {
    return FooterButtonsIconPrimary(
      primaryButtonText: 'New Stock Take',
      onPrimaryButtonPressed: (item) async {
        StoreProvider.of<AppState>(
          context,
        ).dispatch(newStockTake(type: StockRunType.reCount, context: context));
      },
      secondaryButtonIcon: Icons.refresh,
      onSecondaryButtonPressed: (context) async {
        vm.onRefresh();
      },
    );
  }
}
