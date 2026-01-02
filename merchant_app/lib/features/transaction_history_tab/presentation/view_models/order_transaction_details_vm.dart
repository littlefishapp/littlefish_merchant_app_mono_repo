import 'package:flutter/widgets.dart';
import 'package:littlefish_core/business/models/business_user.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order_transaction.dart';
import 'package:littlefish_merchant/features/order_transaction_history/presentation/redux/state/order_transaction_history_state.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:redux/redux.dart';

import 'package:littlefish_merchant/common/view_models/store_collection_viewmodel.dart';

class OrderTransactionDetailsVM
    extends
        StoreCollectionViewModel<
          OrderTransaction,
          OrderTransactionHistoryState
        > {
  OrderTransactionDetailsVM.fromStore(Store<AppState> store)
    : super.fromStore(store);

  OrderTransaction? transaction;

  Order? order;

  BusinessUser? seller;

  @override
  loadFromStore(Store<AppState> store, {BuildContext? context}) {
    this.store = store;
    state = store.state.orderTransactionHistoryState;
    isLoading = state!.isLoading;
    transaction = state!.currentTransaction;
    order = state!.currentOrder;
    seller = state!.transactionConsultant;
  }
}
