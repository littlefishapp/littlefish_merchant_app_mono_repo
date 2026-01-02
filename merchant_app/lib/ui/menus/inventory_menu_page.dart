import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/inventory/grv/pages/stock_receivables_page.dart';
import 'package:littlefish_merchant/ui/inventory/stock_take/pages/stock_take_list_page.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/common/presentaion/components/long_text.dart';

import '../../app/app.dart';

class InventoryMenuPage extends StatelessWidget {
  static const String route = 'inventory/menu';

  const InventoryMenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isTablet = EnvironmentProvider.instance.isLargeDisplay ?? false;
    final showSideNav =
        isTablet || (AppVariables.store!.state.enableSideNavDrawer ?? false);

    return AppScaffold(
      title: 'Manage Stock',
      enableProfileAction: !showSideNav,
      hasDrawer: showSideNav,
      displayNavDrawer: showSideNav,
      body: StoreBuilder<AppState>(
        builder: (BuildContext context, Store<AppState> vm) => ListView(
          physics: const BouncingScrollPhysics(),
          children: <Widget>[
            const CommonDivider(),
            settingItem(
              context,
              'Record Stock Take',
              StockTakeListPage.route,
              icon: Icons.list,
              subtitle: 'View or perform a stock take',
            ),
            if (AppVariables.store!.state.enableReceiveStock ?? true) ...[
              const CommonDivider(),
              settingItem(
                context,
                'Receive Stock',
                StockReceivablesPage.route,
                icon: Icons.queue,
                subtitle: 'Recieve and update stock levels',
              ),
            ],
            // CommonDivider(),
            // settingItem(context, "Receive Stock", null,
            //     icon: Icons.business,
            //     subtitle: "receive and account for stocks", action: () {
            //   AppVariables.store!.dispatch(
            //     newGoodsRecievable(context),
            //   );
            // }),
            const CommonDivider(),
            // settingItem(
            //   context,
            //   "Record Damaged Stock",
            //   null,
            //   icon: Icons.business,
            //   subtitle: "Update inventory by recording damaged products.",
            //   action: () => AppVariables.store!.dispatch(newStockTake(
            //       context: context, type: StockRunType.damagedStock)),
            // ),
            // CommonDivider(),
            // settingItem(
            //   context,
            //   "Record Stolen Stock",
            //   null,
            //   icon: Icons.business,
            //   subtitle: "Update inventory by recording stolen products.",
            //   action: () => AppVariables.store!.dispatch(
            //       newStockTake(context: context, type: StockRunType.theft)),
            // ),
            // CommonDivider(),
            // settingItem(
            //   context,
            //   "Record Lost Stock",
            //   null,
            //   icon: Icons.business,
            //   subtitle: "Update inventory by recording lost products.",
            //   action: () => AppVariables.store!.dispatch(
            //       newStockTake(context: context, type: StockRunType.loss)),
            // ),
            // CommonDivider(),
            // settingItem(
            //   context,
            //   "Record Returned Stock",
            //   null,
            //   icon: Icons.business,
            //   subtitle: "Update inventory by recording returned products.",
            //   action: () => AppVariables.store!.dispatch(newStockTake(
            //       context: context, type: StockRunType.returnedStock)),
            // ),
            // CommonDivider(),
          ],
        ),
      ),
    );
  }

  ListTile settingItem(
    context,
    String title,
    String? route, {
    Function? action,
    IconData? icon,
    String? subtitle,
  }) => ListTile(
    tileColor: Theme.of(context).colorScheme.background,
    // title: context.labelSmall(
    //   title,
    //   isBold: true,
    //   alignLeft: true,
    //   color: Theme.of(context).extension<AppliedTextIcon>()?.primary,
    // ),
    // subtitle: subtitle == null || subtitle.isEmpty ? null : context.labelXSmall(subtitle,
    //   alignLeft: true,
    //   color: Theme.of(context).extension<AppliedTextIcon>()?.secondary,
    // ),
    title: Text(title),
    subtitle: subtitle == null || subtitle.isEmpty ? null : LongText(subtitle),
    trailing: route == null && action == null
        ? null
        : Icon(
            Platform.isAndroid ? Icons.arrow_forward : Icons.arrow_forward_ios,
          ),
    onTap: route == null && action == null
        ? null
        : () {
            if (action != null) action();

            if (route != null) Navigator.of(context).pushNamed(route);
          },
  );
}
