import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:littlefish_merchant/common/view_models/store_collection_viewmodel.dart';
import 'package:littlefish_merchant/features/order_common/data/model/customer.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order_line_item.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order_refund.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order_refund_line_item.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order_transaction.dart';
import 'package:littlefish_merchant/features/order_common/data/model/payment_type.dart';
import 'package:littlefish_merchant/features/order_refund/redux/state/order_refund_state.dart';
import 'package:littlefish_merchant/models/security/user/user_profile.dart';
import 'package:littlefish_merchant/models/store/business_profile.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:redux/redux.dart';

class OrderRefundVM
    extends StoreCollectionViewModel<OrderRefund, RefundOrderState> {
  OrderRefundVM.fromStore(Store<AppState> store) : super.fromStore(store);

  Order? currentOrder;

  BusinessProfile? businessProfile;

  UserProfile? userProfile;

  OrderTransaction? currentOrderTransaction;

  PaymentType? selectedPaymentType;

  Customer? customer;

  String? transactionFailureReason;

  bool? orderFailureDialogIsActive;

  bool? transactionFailureDialogIsActive;

  bool? pushFailedTrxFailureDialogIsActive;

  late List<OrderTransaction> transactions;

  late List<OrderRefundLineItem> refundItems;

  late bool canContinueToPayment;

  late List<PaymentType> availablePaymentTypes;

  late double currentTotalRefundPrice;

  late double orderLineItemTotalPrice;

  late double currentTotalDiscountAmount;

  late double totalAmountOutstanding;

  late double totalAmountPaid;

  late List<OrderTransaction> Function(Order order) getCurrentOrderTransactions;

  late double Function(Order order, String orderLineItemId)
  getLineItemQuantityRefunded;

  late double Function(Order order, String orderLineItemId)
  getLineItemTotalAmountRefunded;

  late OrderLineItem? Function(Order order, String orderLineItemId)
  getOrderLineItemById;

  late void Function(Order order) setCurrentOrder;

  @override
  loadFromStore(Store<AppState> store, {BuildContext? context}) {
    store = store;
    state = store.state.refundOrderState;
    isLoading = state!.isLoading;
    hasError = state!.hasError;
    currentOrder = state!.currentOrder;
    currentOrderTransaction = state!.currentOrderTransaction;
    selectedPaymentType = state!.selectedPaymentType;
    customer = state!.customer;
    transactionFailureReason = state!.transactionFailureReason;
    transactionFailureDialogIsActive = state!.transactionFailureDialogIsActive;
    pushFailedTrxFailureDialogIsActive =
        state!.pushFailedTrxFailureDialogIsActive;
    businessProfile = store.state.businessState.profile;
    userProfile = store.state.userState.profile;
    availablePaymentTypes = state!.availablePaymentTypes;
    canContinueToPayment = state!.canContinueToPayment;
    errorMessage = state!.errorMessage;
    currentTotalRefundPrice = state!.currentTotalRefundPrice;
    orderLineItemTotalPrice = state!.orderLineItemTotalPrice;
    currentTotalDiscountAmount = state!.currentTotalDiscountAmount;
    totalAmountPaid = state!.totalAmountPaid;
    refundItems = state!.refundItems;
    transactions = state!.transactions;

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
  }
}
