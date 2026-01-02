import 'package:littlefish_merchant/models/sales/checkout/checkout_tip.dart';

import 'package:littlefish_merchant/features/sell/presentation/redux/sell_state.dart';

import '../../../order_common/data/model/customer.dart';
import '../../../../models/enums.dart';
import '../../../order_common/data/model/order.dart';
import '../../../order_common/data/model/order_discount.dart';
import '../../../order_common/data/model/order_line_item.dart';
import '../../../order_common/data/model/order_refund.dart';
import '../../../order_common/data/model/order_transaction.dart';
import '../../../order_common/data/model/payment_type.dart';

class UpdateOrderAction {
  final Order order;

  const UpdateOrderAction(this.order);
}

class CreateOrderAction {
  final Order order;

  const CreateOrderAction(this.order);
}

class DiscardOrderAction {
  final Order order;

  const DiscardOrderAction(this.order);
}

class CreateDraftOrderAction {
  final Order order;

  const CreateDraftOrderAction(this.order);
}

class UpdateDraftOrderAction {
  final Order order;

  const UpdateDraftOrderAction(this.order);
}

class SaveDraftOrderToStateAction {
  final Order order;

  const SaveDraftOrderToStateAction(this.order);
}

class RemoveDraftOrderFromStateAction {
  final Order order;

  const RemoveDraftOrderFromStateAction(this.order);
}

class SaveWithdrawalAction {
  final OrderTransaction transaction;

  const SaveWithdrawalAction(this.transaction);
}

class SaveOrderTotalWithdrawalAmountAction {
  final double amount;
  const SaveOrderTotalWithdrawalAmountAction(this.amount);
}

class SaveTransactionWithdrawalAmountAction {
  final double amount;

  const SaveTransactionWithdrawalAmountAction(this.amount);
}

class SavePurchaseAction {
  final OrderTransaction transaction;

  const SavePurchaseAction(this.transaction);
}

class SaveFailedTransactionAction {
  final OrderTransaction transaction;

  const SaveFailedTransactionAction(this.transaction);
}

class SaveVoidedTransactionAction {
  final OrderTransaction transaction;

  const SaveVoidedTransactionAction(this.transaction);
}

class SavePartialPurchaseOrderAction {
  final OrderTransaction transaction;

  const SavePartialPurchaseOrderAction(this.transaction);
}

class SavePurchaseWithWithdrawalAction {
  final OrderTransaction purchase;
  final OrderTransaction withdrawal;

  const SavePurchaseWithWithdrawalAction({
    required this.purchase,
    required this.withdrawal,
  });
}

class SaveRefundOrderAction {
  final OrderTransaction purchase;
  final OrderRefund refund;

  const SaveRefundOrderAction({required this.purchase, required this.refund});
}

class SaveOrderToStateAction {
  final Order value;

  SaveOrderToStateAction(this.value);
}

class SavePartialRefundOrderAction {
  final OrderTransaction purchase;
  final OrderRefund refund;

  const SavePartialRefundOrderAction({
    required this.purchase,
    required this.refund,
  });
}

class AddTransactionTipAmountAction {
  final double value;

  const AddTransactionTipAmountAction(this.value);
}

class SetOrderTotalTipAmountAction {
  final double value;

  const SetOrderTotalTipAmountAction(this.value);
}

class SetTipTabAction {
  final int value;

  const SetTipTabAction(this.value);
}

class AddDiscountAmountAction {
  final double value;
  final DiscountValueType type;

  const AddDiscountAmountAction(this.value, this.type);
}

class DiscardTipAction {
  const DiscardTipAction();
}

class SetDiscountTabAction {
  final int value;

  const SetDiscountTabAction(this.value);
}

class DiscardDiscountAction {
  const DiscardDiscountAction();
}

class SetOrderStateIsLoadingAction {
  final bool value;

  const SetOrderStateIsLoadingAction(this.value);
}

class SetOrderIdAction {
  final String value;

  const SetOrderIdAction(this.value);
}

class AddItemToCartAction {
  final OrderLineItem item;

  const AddItemToCartAction(this.item);
}

class RemoveItemFromCartAction {
  final OrderLineItem item;

  const RemoveItemFromCartAction(this.item);
}

class UpdateItemQuantityInCartAction {
  final OrderLineItem item;
  final double value;

  const UpdateItemQuantityInCartAction(this.item, this.value);
}

class SetCheckoutTabAction {
  final int value;

  const SetCheckoutTabAction(this.value);
}

class ResetCartAction {
  final PurchasePaymentMethodPageState? uiState;

  const ResetCartAction({this.uiState});
}

class AddQuickSaleAction {
  double total;
  OrderLineItem quickSale;

  AddQuickSaleAction(this.quickSale, this.total);
}

class SetSearchValueAction {
  final String? value;

  const SetSearchValueAction(this.value);
}

class SetCheckoutTipAction {
  final CheckoutTip tip;

  SetCheckoutTipAction(this.tip);
}

class ClearCheckoutTipAction {
  ClearCheckoutTipAction();
}

class ClearOrderTotalWithdrawalAmountAction {
  const ClearOrderTotalWithdrawalAmountAction();
}

class ClearTransactionWithdrawalAmountAction {
  const ClearTransactionWithdrawalAmountAction();
}

class SetSellSortOptionsAction {
  final SortBy sortBy;
  final SortOrder sortOrder;

  SetSellSortOptionsAction(this.sortBy, this.sortOrder);
}

class SaveOrderTransactionToStateAction {
  final OrderTransaction value;
  final bool transactionSucceeded;

  SaveOrderTransactionToStateAction(
    this.value, {
    this.transactionSucceeded = false,
  });
}

class LoadPaymentTypesAction {
  final List<PaymentType> value;

  LoadPaymentTypesAction(this.value);
}

class SetContinueToPaymentValueAction {
  final bool value;

  SetContinueToPaymentValueAction(this.value);
}

class SetCustomerAction {
  final Customer? value;

  SetCustomerAction(this.value);
}

class SetCashbackAmountAction {
  final double value;

  SetCashbackAmountAction(this.value);
}

class SetPaymentTypeAction {
  final PaymentType value;

  SetPaymentTypeAction(this.value);
}

class SetOrderTransactionTypeAction {
  final OrderTransactionType orderTransactionType;

  SetOrderTransactionTypeAction(this.orderTransactionType);
}

class SetWithdrawalAmountAction {
  final double amount;

  SetWithdrawalAmountAction(this.amount);
}

class SetSellErrorStateAction {
  String? errorMessage;
  String? failureReason;
  StackTrace? stackTrace;

  SetSellErrorStateAction({
    this.errorMessage,
    this.stackTrace,
    this.failureReason,
  });
}

class SellResetErrorStateAction {
  SellResetErrorStateAction();
}

class SavePurchaseFailureAction {
  final OrderTransaction transaction;
  final String failureReason;

  const SavePurchaseFailureAction(
    this.transaction, {
    required this.failureReason,
  });
}

class SetOrderFailureAction {
  String failureReason;
  String? errorMessage;
  StackTrace? stackTrace;

  SetOrderFailureAction({
    required this.failureReason,
    this.errorMessage,
    this.stackTrace,
  });
}

class ResetOrderFailureAction {
  ResetOrderFailureAction();
}

class SetTransactionFailureAction {
  String failureReason;
  String? errorMessage;
  StackTrace? stackTrace;

  SetTransactionFailureAction({
    required this.failureReason,
    this.errorMessage,
    this.stackTrace,
  });
}

class ResetTransactionFailureAction {
  ResetTransactionFailureAction();
}

class SetPushFailedTrxFailureAction {
  String failureReason;
  String? errorMessage;
  StackTrace? stackTrace;

  SetPushFailedTrxFailureAction({
    required this.failureReason,
    this.errorMessage,
    this.stackTrace,
  });
}

class DiscardCashbackAmountAction {
  DiscardCashbackAmountAction();
}

class ResetSetPushFailedTrxFailureAction {
  ResetSetPushFailedTrxFailureAction();
}

class SetOrderErrorDialogAsActive {
  SetOrderErrorDialogAsActive();
}

class SetTransactionErrorDialogAsActive {
  SetTransactionErrorDialogAsActive();
}

class SetPushFailedTrxFailureDialogAsActive {
  SetPushFailedTrxFailureDialogAsActive();
}

class ResetPurchasePaymentMethodPageUIState {
  ResetPurchasePaymentMethodPageUIState();
}

class GetDraftOrdersAction {}

class SaveDraftOrdersToStateAction {
  final List<Order> orders;

  SaveDraftOrdersToStateAction(this.orders);
}
