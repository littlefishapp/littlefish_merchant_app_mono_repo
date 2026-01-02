// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';

// Project imports:
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/inventory/inventory_actions.dart';
import 'package:littlefish_merchant/ui/inventory/grv/pages/stock_receivable_page.dart';
import 'package:littlefish_merchant/ui/inventory/grv/widgets/stock_receivable_list.dart';
import 'package:littlefish_merchant/ui/inventory/view_models/view_models.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/decorated_text.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';

import '../../../../common/presentaion/pages/scaffolds/app_scaffold.dart';

class StockReceivablesPage extends StatelessWidget {
  static const String route = 'inventory/goods-received';

  const StockReceivablesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, GRVListVM>(
      onInit: (store) => store.dispatch(getReceivables()),
      converter: (store) => GRVListVM.fromStore(store),
      builder: (BuildContext context, GRVListVM vm) =>
          EnvironmentProvider.instance.isLargeDisplay!
          ? scaffoldLandscape(context, vm)
          : scaffold(context, vm),
    );
  }

  AppSimpleAppScaffold scaffoldLandscape(context, GRVListVM vm) =>
      AppSimpleAppScaffold(
        title: 'Goods Received',
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              vm.onRefresh();
            },
          ),
        ],
        body: !vm.isLoading!
            ? Row(
                children: <Widget>[
                  Expanded(flex: 4, child: list(context, vm)),
                  const VerticalDivider(width: 0.5),
                  Expanded(
                    flex: 4,
                    child:
                        vm.selectedItem != null &&
                            !(vm.selectedItem!.isNew ?? false)
                        ? const StockReceivablePage()
                        : const Center(
                            child: DecoratedText(
                              'Select GRV',
                              alignment: Alignment.center,
                              fontSize: 24,
                            ),
                          ),
                  ),
                ],
              )
            : const AppProgressIndicator(),
      );

  Widget scaffold(BuildContext context, GRVListVM vm) {
    return AppScaffold(
      title: 'Goods Received',
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.refresh,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          onPressed: () {
            vm.onRefresh();
          },
        ),
      ],
      body: !vm.isLoading! ? list(context, vm) : const AppProgressIndicator(),
    );
  }

  GoodsRecievableList list(context, GRVListVM vm) => GoodsRecievableList(
    items: vm.items,
    selectedItem: vm.selectedItem,
    onTap: (item) {
      if (EnvironmentProvider.instance.isLargeDisplay!) {
        vm.onSetSelected(item);
      } else {
        vm.onSetSelected(item);
        Navigator.of(
          context,
        ).pushNamed(StockReceivablePage.route, arguments: item);
      }
    },
  );
}
