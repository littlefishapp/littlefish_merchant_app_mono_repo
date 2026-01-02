// remove ignore_for_file: implementation_imports
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/features/order_transaction_history/presentation/redux/actions/order_transaction_history_actions.dart';
import 'package:littlefish_merchant/features/order_transaction_history/presentation/redux/order_transaction_utilities.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:redux/src/store.dart';
import 'package:littlefish_merchant/app/custom_route.dart';
import 'package:littlefish_merchant/common/presentaion/components/bottomNavBar/bottom_navbar.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/features/order_fulfilment%20/presentation/components/order_fulfillment_list_tile.dart';
import 'package:littlefish_merchant/features/order_fulfilment%20/presentation/pages/order_list_page.dart';
import 'package:littlefish_merchant/features/order_fulfilment%20/presentation/viewmodels/order_fulfillment_details_vm.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';

import '../../../order_common/data/model/order.dart';
import '../../../order_common/data/model/order_filter.dart';

class OrderFulfillmentHomePage extends StatefulWidget {
  static const String route = 'business/order-fulfillment-home-page';
  const OrderFulfillmentHomePage({super.key});

  @override
  State<OrderFulfillmentHomePage> createState() =>
      _OrderFulfillmentHomePageState();
}

class _OrderFulfillmentHomePageState extends State<OrderFulfillmentHomePage> {
  bool isLoading = true;
  int allOrders = 0;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, OrderFulfillmentDetailsVM>(
      converter: (Store<AppState> store) {
        return OrderFulfillmentDetailsVM.fromStore(store);
      },
      onInit: (store) async {
        store.dispatch(
          GetAllOrdersCountAction(
            OrderFilter().copyWith(
              financialStatuses: const [FinancialStatus.paid],
              orderStatus: OrderStatus.closed,
              orderSource: OrderSource.online,
              capturedChannels: const [CapturedChannel.web],
            ),
          ),
        );
        store.dispatch(
          GetAllFulfillmentOrdersCountAction(
            OrderFilter().copyWith(
              financialStatuses: const [FinancialStatus.paid],
              orderStatus: OrderStatus.closed,
              orderSource: OrderSource.online,
              capturedChannels: const [CapturedChannel.web],
            ),
          ),
        );
      },
      onDidChange:
          (
            OrderFulfillmentDetailsVM? previousVM,
            OrderFulfillmentDetailsVM vm,
          ) {
            if (vm.state != null &&
                vm.state!.allFulfillmentOrdersCount.isNotEmpty) {
              setState(() {
                isLoading = false;
              });
            }
          },
      builder: (BuildContext context, OrderFulfillmentDetailsVM vm) {
        final isTablet = EnvironmentProvider.instance.isLargeDisplay ?? false;
        return AppScaffold(
          title: 'Order Fulfillment',
          enableProfileAction: !isTablet,
          displayNavBar: EnvironmentProvider.instance.isLargeDisplay!
              ? false
              : vm.store!.state.enableBottomNavBar!,
          hasDrawer: EnvironmentProvider.instance.isLargeDisplay!
              ? true
              : vm.store!.state.enableSideNavDrawer!,
          displayNavDrawer: EnvironmentProvider.instance.isLargeDisplay!
              ? true
              : vm.store!.state.enableSideNavDrawer!,
          navBar: const BottomNavBar(page: PageType.orderFulfillment),
          body: _body(vm),
        );
      },
    );
  }

  Widget _body(OrderFulfillmentDetailsVM vm) {
    if (isLoading) {
      return const Center(child: AppProgressIndicator());
    }

    return Column(
      children: [
        OrderFulfillmentListTile(
          title: 'All Orders',
          subtitle: 'All orders are listed here',
          trailingText: vm.state!.allFulfillmentOrdersCount.values
              .reduce((value, element) => value + element)
              .toString(),
          onTap: () {
            Navigator.push(
              context,
              CustomRoute(
                builder: (ctx) => const OrderListPage(title: 'All Orders'),
              ),
            );
          },
        ),
        const CommonDivider(),
        Expanded(
          child: ListView.builder(
            itemCount: vm.state!.allFulfillmentOrdersCount.length,
            itemBuilder: (context, index) {
              String status = vm.state!.allFulfillmentOrdersCount.keys
                  .elementAt(index);
              int count = vm.state!.allFulfillmentOrdersCount[status] ?? 0;
              return Column(
                children: [
                  OrderFulfillmentListTile(
                    title: status,
                    subtitle:
                        OrderTransactionUtilities.getFulfillmentStatusTextForOrdersCount(
                          status,
                        ),
                    trailingText: count.toString(),
                    onTap: () {
                      Navigator.push(
                        context,
                        CustomRoute(
                          builder: (ctx) => OrderListPage(
                            title: '$status Orders',
                            fulfillmentStatus:
                                OrderTransactionUtilities.getFulfillmentStatusForClickedOrdersCount(
                                  status,
                                ),
                          ),
                        ),
                      );
                    },
                  ),
                  const CommonDivider(),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
