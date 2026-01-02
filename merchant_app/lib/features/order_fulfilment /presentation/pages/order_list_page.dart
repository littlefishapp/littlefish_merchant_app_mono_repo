// flutter imports
// remove ignore_for_file: implementation_imports

import 'package:flutter/material.dart';

// package imports
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order_filter.dart';
import 'package:littlefish_merchant/features/order_fulfilment%20/presentation/pages/list_of_orders_page.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:redux/src/store.dart';

// project imports
import 'package:littlefish_merchant/features/order_transaction_history/presentation/redux/actions/order_transaction_history_actions.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/features/order_transaction_history/presentation/viewmodels/order_history_tab_vm.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';

class OrderListPage extends StatefulWidget {
  static const String route = 'order-list-page';

  final String title;
  final FulfillmentStatus? fulfillmentStatus;

  const OrderListPage({super.key, required this.title, this.fulfillmentStatus});

  @override
  State<OrderListPage> createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, OrderHistoryTabVM>(
      converter: (Store<AppState> store) {
        return OrderHistoryTabVM.fromStore(store);
      },
      onInit: (store) {
        store.dispatch(ClearFilteredOrdersAction());
        store.dispatch(
          SetOrderFiltersAction(
            OrderFilter(
              fulfillmentStatus: widget.fulfillmentStatus,
              financialStatuses: const [FinancialStatus.paid],
              orderStatus: OrderStatus.closed,
              capturedChannels: const [CapturedChannel.web],
            ),
          ),
        );
        if (widget.fulfillmentStatus == null) {
          store.dispatch(
            GetFilteredOrdersAction(
              OrderFilter().copyWith(
                financialStatuses: const [FinancialStatus.paid],
                orderStatus: OrderStatus.closed,
                capturedChannels: const [CapturedChannel.web],
              ),
              searchText: null,
              updateStateLoading: true,
              offset: 0,
            ),
          );
        } else {
          store.dispatch(
            GetFilteredOrdersAction(
              OrderFilter().copyWith(
                fulfillmentStatus: widget.fulfillmentStatus,
                financialStatuses: const [FinancialStatus.paid],
                orderStatus: OrderStatus.closed,
                capturedChannels: const [CapturedChannel.web],
              ),
              searchText: null,
              updateStateLoading: true,
              offset: 0,
            ),
          );
        }
      },
      builder: (BuildContext context, OrderHistoryTabVM vm) {
        return scaffold(context, vm);
      },
    );
  }

  Widget scaffold(BuildContext context, OrderHistoryTabVM vm) {
    final isTablet = EnvironmentProvider.instance.isLargeDisplay ?? false;
    return AppScaffold(
      displayBackNavigation: true,
      title: widget.title,
      enableProfileAction: !isTablet,
      body: ListOfOrdersPage(orders: vm.displayedOrders),
    );
  }
}
