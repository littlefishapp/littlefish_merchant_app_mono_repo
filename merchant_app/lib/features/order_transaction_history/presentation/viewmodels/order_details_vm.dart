import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:littlefish_core/business/models/business_user.dart';
import 'package:littlefish_merchant/common/view_models/store_collection_viewmodel.dart';
import 'package:littlefish_merchant/environment/environment_config.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order_line_item.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order_refund.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order_refund_line_item.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order_transaction.dart';
import 'package:littlefish_merchant/features/order_transaction_history/presentation/redux/actions/order_transaction_history_actions.dart';
import 'package:littlefish_merchant/features/order_transaction_history/presentation/redux/state/order_transaction_history_state.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_transaction.dart';

import 'package:littlefish_merchant/models/security/user/user_profile.dart';
import 'package:littlefish_merchant/models/store/business_profile.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/checkout/checkout_actions.dart';
import 'package:littlefish_merchant/shared/constants/permission_name_constants.dart';
import 'package:littlefish_merchant/shared/exceptions/general_error.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:redux/redux.dart';

class OrderDetailsVM
    extends StoreCollectionViewModel<Order, OrderTransactionHistoryState> {
  OrderDetailsVM.fromStore(Store<AppState> store) : super.fromStore(store);

  Order? order;

  OrderTransaction? transaction;

  BusinessProfile? businessProfile;

  BusinessUser? orderConsultant;

  UserProfile? userProfile;

  double? lastTransactionNumber;

  CheckoutTransaction? checkoutTransaction;

  late int orderDetailsPageTabIndex;

  late List<OrderTransaction> allTransactions;

  late List<OrderTransaction> Function(Order order) getCurrentOrderTransactions;

  late double Function(Order order, String orderLineItemId)
  getLineItemQuantityRefunded;

  late double Function(Order order, String orderLineItemId)
  getLineItemTotalAmountRefunded;

  late OrderLineItem? Function(Order order, String orderLineItemId)
  getOrderLineItemById;

  late void Function(Order order) setCurrentOrder;

  late void Function(int index) setOrderDetailsPageTabIndex;

  late void Function(BuildContext ctx) initiateSaleReturn;

  late void Function(BuildContext ctx) initiateVoidSale;

  late void Function(String transactionId) fetchAndSetCheckoutTransaction;

  late bool Function() canReturnOrder;
  late bool Function() canVoidOrder;
  late bool Function() isRefundEnabled;
  late bool Function() isVoidEnabled;

  GeneralError? error;

  @override
  loadFromStore(Store<AppState> store, {BuildContext? context}) {
    store = store;
    state = store.state.orderTransactionHistoryState;
    order = state!.currentOrder;
    businessProfile = store.state.businessState.profile;
    userProfile = store.state.userState.profile;
    transaction = state?.currentTransaction;
    allTransactions = store.state.orderTransactionHistoryState.transactions;
    isRefundEnabled = () {
      switch (store.state.enableTransactionsRefundSale) {
        case EnableOption.notSet:
        case EnableOption.disabled:
          return false;
        case EnableOption.enabled:
          return true;
        case EnableOption.enabledForV1:
          return _isCheckoutTransactionRefundVisible(checkoutTransaction);
        case EnableOption.enabledForV2:
          return userHasPermission(allowItemRefund);
        default:
          return false;
      }
    };
    isVoidEnabled = () {
      switch (store.state.enableVoidSale) {
        case EnableOption.notSet:
        case EnableOption.disabled:
          return false;
        case EnableOption.enabled:
          return true;
        case EnableOption.enabledForV1:
          return _isCheckoutTransactionVoidVisible(checkoutTransaction);
        case EnableOption.enabledForV2:
          return userHasPermission(allowVoidSale);
        default:
          return false;
      }
    };

    orderConsultant = state!.orderConsultant;
    orderDetailsPageTabIndex = state!.orderDetailsPageTabIndex;
    checkoutTransaction = state!.checkoutTransaction;
    error = state!.error;

    canReturnOrder = () {
      return isRefundEnabled() &&
          _canMakeCheckoutTransactionRefund(checkoutTransaction);
    };

    canVoidOrder = () {
      return isVoidEnabled() &&
          _canVoidCheckoutTransaction(checkoutTransaction);
    };

    setOrderDetailsPageTabIndex = (index) =>
        store.dispatch(SetOrderDetailsPageTabIndexAction(index));

    getCurrentOrderTransactions = (order) {
      List<OrderTransaction> transactions = allTransactions
          .where((t) => t.orderId == order.id)
          .toList();

      return transactions;
    };

    getLineItemQuantityRefunded = (order, orderLineItemId) {
      double quantityRefunded = 0;
      for (OrderRefund refund in order.refunds) {
        for (OrderRefundLineItem refundItem in refund.refundLineItems) {
          if (refundItem.orderLineItem.id == orderLineItemId) {
            quantityRefunded = refundItem.quantity;
          }
        }
      }
      return quantityRefunded;
    };

    getLineItemTotalAmountRefunded = (order, orderLineItemId) {
      OrderLineItem? orderLineItem = getOrderLineItemById(
        order,
        orderLineItemId,
      );
      if (orderLineItem == null) return 0;

      double itemTotalValueRefunded = 0;
      for (OrderRefund refund in order.refunds) {
        for (OrderRefundLineItem refundItem in refund.refundLineItems) {
          if (refundItem.orderLineItem.id == orderLineItemId) {
            itemTotalValueRefunded =
                refundItem.quantity * orderLineItem.unitPrice;
          }
        }
      }
      return itemTotalValueRefunded;
    };

    getOrderLineItemById = (order, orderLineItemId) {
      return order.orderLineItems.firstWhereOrNull(
        (item) => item.id == orderLineItemId,
      );
    };

    setCurrentOrder = (Order order) =>
        store.dispatch(SetCurrentOrderAction(order));

    initiateSaleReturn = (ctx) {
      if (checkoutTransaction != null) {
        store.dispatch(
          initiateSaleReturnJourneyAction(ctx, checkoutTransaction!),
        );
      }
    };

    initiateVoidSale = (ctx) {
      if (checkoutTransaction != null) {
        store.dispatch(
          initiateVoidSaleJourneyAction(ctx, checkoutTransaction!),
        );
      }
    };

    fetchAndSetCheckoutTransaction = (String transactionId) =>
        store.dispatch(FetchCheckoutTransactionAction(transactionId));
  }

  bool _isCheckoutTransactionRefundVisible(CheckoutTransaction? transaction) {
    if (transaction == null) return true;
    final sellNowModuleDisabled =
        store?.state.enableNewSale == EnableOption.disabled;
    if (sellNowModuleDisabled) {
      return false;
    }
    return isZeroOrNull(transaction.withdrawalAmount) &&
        userHasPermission(allowItemRefund) &&
        !transaction.isQuickRefund;
  }

  bool _isCheckoutTransactionVoidVisible(CheckoutTransaction? transaction) {
    if (transaction == null) return true;
    var voidSaleDisabled = store?.state.enableVoidSale == EnableOption.disabled;
    if (voidSaleDisabled) {
      return false;
    }
    return (isZeroOrNull(transaction.withdrawalAmount) &&
        userHasPermission(allowVoidSale));
  }

  bool _canMakeCheckoutTransactionRefund(CheckoutTransaction? transaction) {
    if (transaction == null) return false;
    if (transaction.isCancelled) return false;
    if (transaction.isQuickRefund) return false;
    if (transaction.isFullyRefunded) return false;
    return true;
  }

  bool _canVoidCheckoutTransaction(CheckoutTransaction? transaction) {
    if (transaction == null) return false;
    if (transaction.isCancelled) return false;
    if (transaction.isQuickRefund) return false;
    if (transaction.isFullyRefunded) return false;
    if (transaction.isRefunded) return false;
    return true;
  }

  String getRefundDisabledReason() {
    if (checkoutTransaction == null) return 'Order information not found.';
    if (checkoutTransaction!.isCancelled) {
      return 'This order has been voided and cannot be refunded.';
    }
    if (checkoutTransaction!.isQuickRefund) {
      return 'This order cannot be refunded.';
    }
    if (checkoutTransaction!.isFullyRefunded) {
      return 'This order has already been fully refunded.';
    }
    return 'This order cannot be refunded.';
  }

  String getVoidDisabledReason() {
    if (checkoutTransaction == null) return 'Order information not found.';
    if (checkoutTransaction!.isCancelled) {
      return 'This order has already been voided.';
    }
    if (checkoutTransaction!.isQuickRefund) {
      return 'Quick refunds cannot be voided.';
    }
    if (checkoutTransaction!.isRefunded) {
      if (checkoutTransaction!.isFullyRefunded) {
        return 'This order has been fully refunded and cannot be voided.';
      } else {
        return 'This order has been partially refunded and cannot be voided.';
      }
    }
    return 'This order cannot be voided.';
  }
}
