// Flutter imports:
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/features/order_common/data/model/customer.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order_transaction.dart';
import 'package:littlefish_merchant/features/pos/presentation/pages/order_pos_print_page.dart';
import 'package:littlefish_merchant/features/receipt_common/presentation/redux/order_receipt_actions.dart';
import 'package:littlefish_merchant/features/receipt_common/presentation/redux/order_receipt_state.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_merchant/shared/exceptions/general_error.dart';

// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/common/view_models/store_collection_viewmodel.dart';

class OrderReceiptVM
    extends StoreCollectionViewModel<Order, OrderReceiptState> {
  OrderReceiptVM.fromStore(Store<AppState> store) : super.fromStore(store);

  Function(BuildContext context)? printReceipt;
  Function(Customer customer)? sendSmsReceipt;
  Function(Customer customer)? sendEmailReceipt;
  Function()? clearReceiptState;
  Function(Customer customer)? setCustomer;
  Function(bool value)? setHasReceiptSent;
  Function(GeneralError? error)? setReceiptError;
  Order? currentOrder;
  OrderTransaction? currentTransaction;
  Customer? customer;
  double? lastTransactionNumber;
  GeneralError? error;
  late bool hasSent;

  @override
  loadFromStore(Store<AppState> store, {BuildContext? context}) {
    this.store = store;
    state = store.state.orderReceiptState;
    isLoading = state!.isLoading;
    customer = state!.customer;
    hasSent = state!.hasSent;
    error = state!.error;
    lastTransactionNumber = store.state.checkoutState.lastTransactionNumber;
    currentTransaction = state?.currentTransaction;
    currentOrder = state?.currentOrder;
    printReceipt = (ctx) async {
      if (AppVariables.hasPrinter &&
          cardPaymentRegistered == CardPaymentRegistered.pos) {
        await showPopupDialog(
          context: ctx,
          content: OrderPosPrintPage(
            isRefund: false,
            parentContext: ctx,
            transaction: currentTransaction!,
          ),
        );
      }
    };
    sendEmailReceipt = (cust) {
      store.dispatch(
        SendEmailReceiptAction(
          businessId:
              currentOrder?.businessId ?? currentTransaction?.businessId ?? '',
          transaction: currentTransaction!,
          order: currentOrder,
          customer: cust,
        ),
      );
    };
    sendSmsReceipt = (cust) {
      store.dispatch(
        SendSmsReceiptAction(
          businessId:
              currentOrder?.businessId ?? currentTransaction?.businessId ?? '',
          transaction: currentTransaction!,
          order: currentOrder,
          customer: cust,
        ),
      );
    };
    setCustomer = (customer) =>
        store.dispatch(SetReceiptCustomerAction(customer));
    setHasReceiptSent = (value) {
      store.dispatch(SetOrderReceiptStateHasSentAction(value));
    };

    setReceiptError = (error) {
      store.dispatch(SetOrderReceiptErrorAction(error));
    };

    clearReceiptState = () {
      store.dispatch(const ClearReceiptStateAction());
    };
  }
}
