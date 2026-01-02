// flutter imports
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/features/sell/presentation/redux/sell_actions.dart';
// remove ignore: implementation_imports
import 'package:redux/src/store.dart';

// project imports
import 'package:littlefish_merchant/features/order_common/data/model/order.dart';
import 'package:littlefish_merchant/features/order_transaction_history/presentation/redux/actions/order_transaction_history_actions.dart';
import 'package:littlefish_merchant/common/view_models/store_collection_viewmodel.dart';
import 'package:littlefish_merchant/features/order_transaction_history/presentation/redux/state/order_transaction_history_state.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';

import '../../../order_common/data/model/order_filter.dart';

class OrderFulfillmentDetailsVM
    extends StoreCollectionViewModel<int, OrderTransactionHistoryState> {
  OrderFulfillmentDetailsVM.fromStore(Store<AppState> store)
    : super.fromStore(store);

  late Function(FulfillmentStatus? fulfillmentStatus) getAllOrdersCount;
  late Function() getAllFulfillmentOrdersCount;
  late Function(Order order) updateOrder;
  late Function(String orderId) confirmOrder;
  late Function(Order order) updateOrderShipperDetails;
  late Function(Order order, String reason) cancelOrder;
  late Function(Order order, String reason) markFailedDelivery;
  late Function(Order order) markReadyForDeliveryOrCollection;
  late Function(Order order) confirmDeliveryOrCollection;
  late Function() refreshOrders;

  @override
  loadFromStore(Store<AppState> store, {BuildContext? context}) {
    this.store = store;
    state = store.state.orderTransactionHistoryState;
    isLoading = state!.isLoading;
    hasError = state!.hasError;
    onResetErorr = () => store.dispatch(ResetOrderHistoryErrorAction());
    updateOrder = (order) {
      store.dispatch(UpdateOrderAction(order));
      store.dispatch(UpdateStateOrderAction(order: order));
    };
    confirmOrder = (orderId) {
      store.dispatch(ConfirmOrderAction(orderId));
    };
    updateOrderShipperDetails = (order) {
      store.dispatch(UpdateOrderShipperDetailsAction(order));
    };
    cancelOrder = (order, reason) {
      store.dispatch(CancelOrderAction(order, reason));
      store.dispatch(UpdateStateOrderAction(order: order));
    };
    markReadyForDeliveryOrCollection = (order) {
      store.dispatch(MarkReadyForDeliveryOrCollectionAction(order));
    };
    confirmDeliveryOrCollection = (order) {
      store.dispatch(ConfirmDeliveryOrCollectionAction(order));
    };

    markFailedDelivery = (order, reason) {
      store.dispatch(MarkFailedDeliveryAction(order, reason));
    };
    refreshOrders = () =>
        store.dispatch(InitializeTransactionOrderHistoryAction(refresh: true));
    getAllOrdersCount = (fulfillmentStatus) => store.dispatch(
      GetAllOrdersCountAction(
        OrderFilter().copyWith(
          financialStatuses: const [FinancialStatus.paid],
          orderStatus: OrderStatus.closed,
          orderSource: OrderSource.online,
        ),
      ),
    );
    getAllFulfillmentOrdersCount = () => store.dispatch(
      GetAllFulfillmentOrdersCountAction(
        OrderFilter().copyWith(
          financialStatuses: const [FinancialStatus.paid],
          orderStatus: OrderStatus.closed,
          orderSource: OrderSource.online,
        ),
      ),
    );
  }
}
