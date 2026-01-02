// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
// removed ignore: depend_on_referenced_packages, implementation_imports
import 'package:redux/src/store.dart';
import 'package:uuid/uuid.dart';

// Project imports:
import 'package:littlefish_merchant/models/settings/payments/payment_type.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/store/store_actions.dart';
import 'package:littlefish_merchant/redux/store/store_state.dart';
import 'package:littlefish_merchant/ui/online_store/common/constants/order_status_contants.dart';
import 'package:littlefish_merchant/ui/online_store/services/littlefish/services/store_service_cf.dart';
import 'package:littlefish_merchant/common/presentaion/components/completers.dart';
import 'package:littlefish_merchant/common/view_models/store_collection_viewmodel.dart';

import '../../../features/ecommerce_shared/models/checkout/checkout_order.dart';
import '../../../features/ecommerce_shared/models/store/store.dart' as store_ui;

class ManageOrderVM extends StoreItemViewModel<store_ui.Store, StoreState> {
  ManageOrderVM.fromStore(Store<AppState> store) : super.fromStore(store);

  store_ui.Store? get currentStore => store!.state.storeState.store;
  StoreServiceCF? service;

  List<PaymentType> get paymentTypes => store!
      .state
      .appSettingsState
      .paymentTypes
      .where((p) => p.enabled! && !p.name!.contains('credit'))
      .toList();

  @override
  loadFromStore(Store<AppState> store, {BuildContext? context}) {
    this.store = store;
    state = store.state.storeState;
    service = StoreServiceCF(store: store);
    item = state!.store!;
    isLoading = state?.isLoading ?? false;

    hasError = state?.hasError ?? false;
  }

  completeOrder(
    ctx,
    CheckoutOrder order, {
    required PaymentType paymentType,
    String? reference,
  }) async {
    // isLoading = true;

    order.paymentStatus = 'paid';
    order.paymentType = paymentType.name;
    order.payments!.add(
      OrderPayment(
        amount: order.orderValue,
        paidBy: order.customerName,
        date: DateTime.now(),
        id: const Uuid().v4(),
        paymentType: paymentType.name,
        paymentReference: reference ?? const Uuid().v4(),
      ),
    );

    store!.dispatch(
      updateOrderAction(
        order,
        OrderStatusConstants.complete,
        completer: snackBarCompleter(ctx, 'Order updated', shouldPop: true),
      ),
    );
    // }
  }
}
