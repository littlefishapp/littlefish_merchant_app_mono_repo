import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/ui/home/widgets/home_online_store_card.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/tools/hex_color.dart';
import 'package:littlefish_merchant/ui/online_store/orders/widgets/filtered_orders_screen.dart';
import 'package:littlefish_merchant/ui/online_store/services/service_factory.dart';
import 'package:littlefish_merchant/ui/online_store/viewmodels/manage_store_vm.dart';
import '../../../app/app.dart';
import '../../../common/presentaion/components/cards/card_neutral.dart';
import '../../../features/ecommerce_shared/models/checkout/checkout_order.dart';
import '../../../features/ecommerce_shared/models/store/store.dart';
import '../../../common/presentaion/components/app_progress_indicator.dart';

class OrdersHomePage extends StatefulWidget {
  static const String route = '/order-home-page';

  const OrdersHomePage({Key? key}) : super(key: key);

  @override
  State<OrdersHomePage> createState() => _OrdersHomePageState();
}

class _OrdersHomePageState extends State<OrdersHomePage> {
  Store? item;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      displayNavBar: AppVariables.store!.state.enableBottomNavBar!,
      title: 'Online Orders',
      hasDrawer: AppVariables.store!.state.enableSideNavDrawer!,
      displayNavDrawer: AppVariables.store!.state.enableSideNavDrawer!,
      displayBackNavigation: AppVariables.store!.state.enableSideNavDrawer!,

      //  navBar: const BottomNavBar(page: PageType.orders),
      // TODO, inject actions, controlled from a single component.
      body: StoreConnector<AppState, ManageStoreVM>(
        converter: (store) => ManageStoreVM.fromStore(store),
        builder: (BuildContext context, ManageStoreVM vm) {
          item ??= vm.item;

          return vm.store!.state.storeState.store == null
              ? const Center(child: HomeOnlineStoreCard(removeElevation: true))
              : ListView(
                  physics: const BouncingScrollPhysics(),
                  children: <Widget>[
                    const SizedBox(height: 8),
                    StreamBuilder<QuerySnapshot<Object?>>(
                      stream: ServiceFactory().getOrdersStatusesStream(
                        vm.store!.state.storeState.store!,
                      ),
                      builder: (ctx, snapshot) {
                        if (snapshot.hasData != true) {
                          return const AppProgressIndicator();
                        }

                        var statuses = snapshot.data!.docs
                            .map(
                              (e) => OrderStatus.fromJson(
                                e.data() as Map<String, dynamic>,
                              ),
                            )
                            .toList();
                        return _renderLayout(context, vm, statuses);
                      },
                    ),
                  ],
                );
        },
      ),
    );
  }

  Container _renderLayout(
    context,
    ManageStoreVM vm,
    List<OrderStatus> statuses,
  ) {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 16, left: 8, right: 8),
      child: Material(
        borderRadius: BorderRadius.circular(8),
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: statuses.length,
          itemBuilder: (ctx, index) {
            return statusTile(statuses[index], vm);
          },
        ),
      ),
    );
  }

  ListTile statusTile(OrderStatus status, ManageStoreVM vm) => ListTile(
    tileColor: Theme.of(context).colorScheme.background,
    trailing: CardNeutral(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: HexColor(status.color!)),
      ),
      // ele: 44,
      // borderColor: HexColor(status.color!),
      child: SizedBox(
        width: 40,
        height: 40,
        child: Align(
          alignment: Alignment.center,
          child: Text(
            status.totalOrders.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    ),
    title: Text('${status.displayName!} orders'),
    subtitle: Text(status.description!, style: const TextStyle(fontSize: 12)),
    onTap: () {
      vm.setOrderFilterStatus([status.name]);

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) =>
              FilteredOrdersScreen(status: status.displayName!),
        ),
      );
    },
  );
}
