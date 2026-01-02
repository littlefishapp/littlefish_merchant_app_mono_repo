import 'package:flutter/cupertino.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:redux/redux.dart';
import '../../../../models/sales/checkout/checkout_tip.dart';
import '../../../order_common/data/model/order.dart';
import '../../../order_common/data/model/order_discount.dart';
import '../../../order_common/data/model/order_line_item.dart';
import '../../../order_common/data/model/order_transaction.dart';
import 'sell_actions.dart';
import 'sell_state.dart';

final sellReducer = combineReducers<SellState>([
  TypedReducer<SellState, SetOrderStateIsLoadingAction>(
    _setOrderStateIsLoadingAction,
  ).call,
  TypedReducer<SellState, ResetCartAction>(_resetCartAction).call,
  TypedReducer<SellState, UpdateItemQuantityInCartAction>(
    _updateItemQuantityInCartAction,
  ).call,
  TypedReducer<SellState, AddItemToCartAction>(_addItemToCartAction).call,
  TypedReducer<SellState, RemoveItemFromCartAction>(
    _removeItemFromCartAction,
  ).call,
  TypedReducer<SellState, SaveOrderToStateAction>(_saveOrderToStateAction).call,
  TypedReducer<SellState, SaveDraftOrderToStateAction>(
    _saveDraftOrderToStateAction,
  ).call,
  TypedReducer<SellState, RemoveDraftOrderFromStateAction>(
    _removeDraftOrderFromStateAction,
  ).call,
  TypedReducer<SellState, SetOrderTotalTipAmountAction>(
    _setOrderTipAmountAction,
  ).call,
  TypedReducer<SellState, AddTransactionTipAmountAction>(
    _setTransactionTipAmountAction,
  ).call,
  TypedReducer<SellState, SetTipTabAction>(_setTipTabAction).call,
  TypedReducer<SellState, AddDiscountAmountAction>(
    _addDiscountAmountAction,
  ).call,
  TypedReducer<SellState, SetDiscountTabAction>(_setDiscountTabAction).call,
  TypedReducer<SellState, SetCheckoutTabAction>(_setCheckoutTabAction).call,
  TypedReducer<SellState, DiscardDiscountAction>(_discardDiscountAction).call,
  TypedReducer<SellState, SetSellSortOptionsAction>(_onSetSortOptions).call,
  TypedReducer<SellState, SetSearchValueAction>(_setSearchValue).call,
  TypedReducer<SellState, ClearCheckoutTipAction>(_clearCheckoutTipAction).call,
  TypedReducer<SellState, SaveOrderTotalWithdrawalAmountAction>(
    _setOrderTotalWithdrawalAmountAction,
  ).call,
  TypedReducer<SellState, ClearOrderTotalWithdrawalAmountAction>(
    _clearOrderTotalWithdrawalAmountAction,
  ).call,
  TypedReducer<SellState, SaveTransactionWithdrawalAmountAction>(
    _setTransactionWithdrawalAmountAction,
  ).call,
  TypedReducer<SellState, ClearTransactionWithdrawalAmountAction>(
    _clearTransactionWithdrawalAmountAction,
  ).call,
  TypedReducer<SellState, AddQuickSaleAction>(_addQuickSaleAction).call,
  TypedReducer<SellState, SaveOrderTransactionToStateAction>(
    _setOrderTransactionInStateAction,
  ).call,
  TypedReducer<SellState, SetCustomerAction>(_setCustomerAction).call,
  TypedReducer<SellState, SetCashbackAmountAction>(
    _setCashbackAmountAction,
  ).call,
  TypedReducer<SellState, SetContinueToPaymentValueAction>(
    _setContinueToPaymentValueAction,
  ).call,
  TypedReducer<SellState, SetPaymentTypeAction>(_setPaymentTypeAction).call,
  TypedReducer<SellState, LoadPaymentTypesAction>(_loadPaymentTypesAction).call,
  TypedReducer<SellState, SetSellErrorStateAction>(_setErrorStateAction).call,
  TypedReducer<SellState, SetCheckoutTipAction>(_setCheckoutTipAction).call,
  TypedReducer<SellState, DiscardTipAction>(_discardTipAction).call,
  TypedReducer<SellState, SellResetErrorStateAction>(
    _resetErrorStateAction,
  ).call,
  TypedReducer<SellState, SetOrderFailureAction>(_setOrderFailureAction).call,
  TypedReducer<SellState, ResetOrderFailureAction>(
    _resetOrderFailureAction,
  ).call,
  TypedReducer<SellState, SetTransactionFailureAction>(
    _setTransactionFailureAction,
  ).call,
  TypedReducer<SellState, ResetTransactionFailureAction>(
    _resetTransactionFailureAction,
  ).call,
  TypedReducer<SellState, SetPushFailedTrxFailureAction>(
    _setPushFailedTrxFailureAction,
  ).call,
  TypedReducer<SellState, ResetSetPushFailedTrxFailureAction>(
    _resetPushFailureTransactionErrorAction,
  ).call,
  TypedReducer<SellState, SetOrderErrorDialogAsActive>(
    _setOrderErrorDialogActiveAction,
  ).call,
  TypedReducer<SellState, SetTransactionErrorDialogAsActive>(
    _setTransactionErrorDialogActiveAction,
  ).call,
  TypedReducer<SellState, SetPushFailedTrxFailureDialogAsActive>(
    _setPushFailedTrxFailureDialogAsActiveAction,
  ).call,
  TypedReducer<SellState, ResetPurchasePaymentMethodPageUIState>(
    _resetPurchasePaymentMethodPageUIState,
  ).call,
  TypedReducer<SellState, DiscardCashbackAmountAction>(
    _discardCashbackAmountAction,
  ).call,
  TypedReducer<SellState, SetOrderTransactionTypeAction>(
    _setOrderTransactionTypeAction,
  ).call,
  TypedReducer<SellState, SetWithdrawalAmountAction>(
    _setWithdrawalAmountAction,
  ).call,
  TypedReducer<SellState, SaveDraftOrdersToStateAction>(
    _saveDraftOrdersToStateAction,
  ).call,
]);

SellState _setOrderStateIsLoadingAction(
  SellState state,
  SetOrderStateIsLoadingAction action,
) => state.rebuild((s) => s.isLoading = action.value);

SellState _resetCartAction(SellState state, ResetCartAction action) =>
    state.rebuild((s) {
      s.items = <OrderLineItem>[];
      s.totalAmountOutstanding = 0;
      s.totalAmountPaid = 0;
      s.subtotalPrice = 0;
      s.currentTotalPrice = 0;
      s.orderTotalWithdrawalAmount = 0;
      s.transactionWithdrawalAmount = 0;
      s.orderTotalTipAmount = 0;
      s.transactionTipAmount = 0;
      s.financialStatus = FinancialStatus.pending;
      s.orderStatus = OrderStatus.open;
      s.orderId = null;
      s.totalTax = 0;
      s.cartDiscount = null;
      s.selectedPaymentType = null;
      s.tags = <String>[];
      s.canContinueToPayment = false;
      s.currentOrder = null;
      s.transactions = <OrderTransaction>[];
      s.currentOrderTransaction = null;
      s.orderFailureDialogIsActive = false;
      s.transactionFailureDialogIsActive = false;
      s.pushFailedTrxFailureDialogIsActive = false;
      s.cashbackAmount = null;
      s.checkoutTip = null;
      s.uiState = action.uiState ?? s.uiState;
      s.totalDiscount = 0.0;
    });

SellState _updateItemQuantityInCartAction(
  SellState state,
  UpdateItemQuantityInCartAction action,
) {
  return state.rebuild((s) {
    if (action.item.quantity == 0) {
      _removeOrderLineItem(s, action.item);
    } else {
      _updateOrderLineItemQuantity(
        s: s,
        item: action.item,
        quantity: action.item.quantity,
      );
    }
  });
}

SellState _addItemToCartAction(SellState state, AddItemToCartAction action) =>
    state.rebuild((s) => _addOrderLineItem(s, action.item));

SellState _removeItemFromCartAction(
  SellState state,
  RemoveItemFromCartAction action,
) => state.rebuild((s) => _removeOrderLineItem(s, action.item));

SellState _saveOrderToStateAction(
  SellState state,
  SaveOrderToStateAction action,
) => state.rebuild((s) {
  s.currentOrder = action.value;
  s.orderId = action.value.id;
  s.orderStatus = action.value.orderStatus;
  s.uiState = PurchasePaymentMethodPageState.orderCreated;
});

SellState _saveDraftOrderToStateAction(
  SellState state,
  SaveDraftOrderToStateAction action,
) => state.rebuild((s) {
  s.drafts = List<Order>.from(s.drafts!)..add(action.order);
});

SellState _removeDraftOrderFromStateAction(
  SellState state,
  RemoveDraftOrderFromStateAction action,
) => state.rebuild((s) {
  s.drafts = List<Order>.from(s.drafts ?? <Order>[])
    ..removeWhere((item) => item.id == action.order.id);
});

SellState _setOrderTipAmountAction(
  SellState state,
  SetOrderTotalTipAmountAction action,
) => state.rebuild((s) => s..orderTotalTipAmount = action.value);

SellState _setTransactionTipAmountAction(
  SellState state,
  AddTransactionTipAmountAction action,
) => state.rebuild((s) {
  s.transactionTipAmount = action.value;
});

SellState _setTipTabAction(SellState state, SetTipTabAction action) =>
    state.rebuild((s) => s.tipTabIndex = action.value);

SellState _addDiscountAmountAction(
  SellState state,
  AddDiscountAmountAction action,
) => state.rebuild((s) {
  s.cartDiscount = OrderDiscount.cart(action.value, action.type);
  //Todo(Brandon): Update amount with product discounts

  double total = (s.subtotalPrice ?? 0) - action.value;
  double discountValue = action.value;
  if (action.type == DiscountValueType.percentage) {
    total = (s.subtotalPrice ?? 0) * (1 - action.value / 100);
    discountValue = (s.subtotalPrice ?? 0) * (action.value / 100);
  }

  s.currentTotalPrice = s.totalAmountOutstanding =
      total + (s.cashbackAmount ?? 0) + (s.totalTax ?? 0);
  s.totalDiscount = discountValue;
});

SellState _setDiscountTabAction(SellState state, SetDiscountTabAction action) =>
    state.rebuild((s) => s.discountTabIndex = action.value);

SellState _discardDiscountAction(
  SellState state,
  DiscardDiscountAction action,
) => state.rebuild((s) {
  s.cartDiscount = const OrderDiscount();
  s.totalDiscount = 0.0;
});

SellState _setCheckoutTabAction(SellState state, SetCheckoutTabAction action) =>
    state.rebuild((s) => s.checkoutTabIndex = action.value);

SellState _setOrderTransactionInStateAction(
  SellState state,
  SaveOrderTransactionToStateAction action,
) => state.rebuild((s) {
  s.currentOrderTransaction = action.value;
  if (action.transactionSucceeded) {
    s.uiState = PurchasePaymentMethodPageState.transactionCompleted;
  }
});

SellState _setCustomerAction(SellState state, SetCustomerAction action) =>
    state.rebuild((s) => s.customer = action.value);

SellState _setCashbackAmountAction(
  SellState state,
  SetCashbackAmountAction action,
) => state.rebuild((s) {
  var cashbackAmount = (action.value);
  var currentTotalPrice = (s.currentTotalPrice ?? 0);
  if (isNotZeroOrNull(s.orderTotalWithdrawalAmount)) {
    currentTotalPrice -= s.orderTotalWithdrawalAmount ?? 0;
  }
  s.cashbackAmount = cashbackAmount;
  s.orderTotalWithdrawalAmount = cashbackAmount;
  currentTotalPrice += cashbackAmount;
  s.currentTotalPrice = currentTotalPrice < 0 ? 0 : currentTotalPrice;
  s.orderTransactionType = OrderTransactionType.purchaseCashback;
});

SellState _discardCashbackAmountAction(
  SellState state,
  DiscardCashbackAmountAction action,
) => state.rebuild((s) {
  var cashbackAmount = (s.cashbackAmount ?? 0);
  var currentTotalPrice = (s.currentTotalPrice ?? 0);

  currentTotalPrice = currentTotalPrice - cashbackAmount;
  s.currentTotalPrice = currentTotalPrice < 0 ? 0 : currentTotalPrice;
  s.cashbackAmount = 0;
  s.orderTotalWithdrawalAmount = 0;
  s.orderTransactionType = OrderTransactionType.purchase;
});

SellState _setCheckoutTipAction(SellState state, SetCheckoutTipAction action) =>
    state.rebuild((s) {
      s.checkoutTip = action.tip;
      var tipAmount = 0.0;
      var currentTotalPrice = (s.currentTotalPrice ?? 0);
      if (isNotZeroOrNull(s.orderTotalTipAmount)) {
        currentTotalPrice -= s.orderTotalTipAmount ?? 0;
      }
      if (action.tip.value != null) {
        switch (action.tip.type) {
          case TipType.fixedAmount:
            tipAmount = action.tip.value!;
            break;
          case TipType.percentage:
            tipAmount = ((action.tip.value! / 100) * (s.subtotalPrice ?? 0));
            break;
          case null:
            break;
        }
      }

      s.orderTotalTipAmount = tipAmount;
      currentTotalPrice += tipAmount;
      s.currentTotalPrice = currentTotalPrice;
    });

SellState _setContinueToPaymentValueAction(
  SellState state,
  SetContinueToPaymentValueAction action,
) => state.rebuild((s) => s.canContinueToPayment = action.value);

SellState _setPaymentTypeAction(SellState state, SetPaymentTypeAction action) =>
    state.rebuild((s) => s.selectedPaymentType = action.value);

SellState _setErrorStateAction(
  SellState state,
  SetSellErrorStateAction action,
) => state.rebuild((s) {
  s.hasError = true;
  s.errorMessage = action.errorMessage;
  s.transactionFailureReason = action.failureReason;

  debugPrintStack(stackTrace: action.stackTrace);
});

SellState _setPushFailedTrxFailureAction(
  SellState state,
  SetPushFailedTrxFailureAction action,
) => state.rebuild((s) {
  s.hasError = true;
  s.errorMessage = action.errorMessage;
  s.transactionFailureReason = action.failureReason;
  s.uiState = PurchasePaymentMethodPageState.pushFailedTransactionFailure;

  debugPrintStack(stackTrace: action.stackTrace);
});

SellState _resetPushFailureTransactionErrorAction(
  SellState state,
  ResetSetPushFailedTrxFailureAction action,
) => state.rebuild((s) {
  s.hasError = false;
  s.uiState = PurchasePaymentMethodPageState.orderCreated;
});

SellState _setOrderFailureAction(
  SellState state,
  SetOrderFailureAction action,
) => state.rebuild((s) {
  s.hasError = true;
  s.errorMessage = action.errorMessage;
  s.transactionFailureReason = action.failureReason;
  s.uiState = PurchasePaymentMethodPageState.orderFailure;
  debugPrintStack(stackTrace: action.stackTrace);
});

SellState _resetOrderFailureAction(
  SellState state,
  ResetOrderFailureAction action,
) => state.rebuild((s) {
  s.hasError = false;
  s.uiState = (s.orderId?.isEmpty ?? true)
      ? PurchasePaymentMethodPageState.initial
      : PurchasePaymentMethodPageState.orderCreated;
  s.orderFailureDialogIsActive = false;
});

SellState _setTransactionFailureAction(
  SellState state,
  SetTransactionFailureAction action,
) => state.rebuild((s) {
  s.hasError = true;
  s.errorMessage = action.errorMessage;
  s.transactionFailureReason = action.failureReason;
  s.uiState = PurchasePaymentMethodPageState.transactionFailure;

  debugPrintStack(stackTrace: action.stackTrace);
});

SellState _resetTransactionFailureAction(
  SellState state,
  ResetTransactionFailureAction action,
) => state.rebuild((s) {
  s.hasError = false;
  s.uiState = PurchasePaymentMethodPageState.orderCreated;
  s.transactionFailureDialogIsActive = false;
});

SellState _loadPaymentTypesAction(
  SellState state,
  LoadPaymentTypesAction action,
) => state.rebuild((s) => s.availablePaymentTypes = action.value);

SellState _discardTipAction(SellState state, DiscardTipAction action) =>
    state.rebuild((s) {
      var currentTotalPrice = (s.currentTotalPrice ?? 0);
      s.checkoutTip = null;
      currentTotalPrice = currentTotalPrice - (s.orderTotalTipAmount ?? 0);
      s.currentTotalPrice = currentTotalPrice < 0 ? 0 : currentTotalPrice;
      s.orderTotalTipAmount = 0;
    });

SellState _resetErrorStateAction(
  SellState state,
  SellResetErrorStateAction action,
) => state.rebuild((s) {
  s.hasError = false;
});

SellState _setOrderErrorDialogActiveAction(
  SellState state,
  SetOrderErrorDialogAsActive action,
) => state.rebuild((s) {
  s.orderFailureDialogIsActive = true;
});

SellState _setTransactionErrorDialogActiveAction(
  SellState state,
  SetTransactionErrorDialogAsActive action,
) => state.rebuild((s) => s.transactionFailureDialogIsActive = true);

SellState _setPushFailedTrxFailureDialogAsActiveAction(
  SellState state,
  SetPushFailedTrxFailureDialogAsActive action,
) => state.rebuild((s) => s.pushFailedTrxFailureDialogIsActive = true);

SellState _resetPurchasePaymentMethodPageUIState(
  SellState state,
  ResetPurchasePaymentMethodPageUIState action,
) => state.rebuild((s) => s.uiState = PurchasePaymentMethodPageState.initial);

SellState _addQuickSaleAction(SellState state, AddQuickSaleAction action) =>
    state.rebuild((s) {
      s.subtotalPrice = action.total;
      s.currentTotalPrice = action.total;
      s.totalAmountOutstanding = action.total;
      s.items = [action.quickSale];
      s.canContinueToPayment = true;
      s.orderStatus = OrderStatus.open;
    });

SellState _setOrderTotalWithdrawalAmountAction(
  SellState state,
  SaveOrderTotalWithdrawalAmountAction action,
) => state.rebuild((s) => s..orderTotalWithdrawalAmount = action.amount);

SellState _setTransactionWithdrawalAmountAction(
  SellState state,
  SaveTransactionWithdrawalAmountAction action,
) => state.rebuild((s) {
  s.transactionWithdrawalAmount = action.amount;
});

SellState _clearTransactionWithdrawalAmountAction(
  SellState state,
  ClearTransactionWithdrawalAmountAction action,
) => state.rebuild((s) => s..transactionWithdrawalAmount = 0);

SellState _onSetSortOptions(SellState state, SetSellSortOptionsAction action) {
  return state.rebuild((p0) {
    p0.sortBy = action.sortBy;
    p0.sortOrder = action.sortOrder;
  });
}

SellState _setSearchValue(SellState state, SetSearchValueAction action) {
  return state.rebuild((p0) => p0.searchText = action.value);
}

SellState _clearCheckoutTipAction(
  SellState state,
  ClearCheckoutTipAction action,
) => state.rebuild((s) => s..checkoutTip = CheckoutTip.create());

SellState _clearOrderTotalWithdrawalAmountAction(
  SellState state,
  ClearOrderTotalWithdrawalAmountAction action,
) => state.rebuild((s) => s..orderTotalWithdrawalAmount = 0);

void _removeOrderLineItem(SellStateBuilder s, OrderLineItem item) {
  s.items ??= <OrderLineItem>[];

  var itemList = List<OrderLineItem>.from(s.items!);
  final index = s.items!.indexWhere((e) => e.productId == item.productId);
  if (index < 0) {
    return;
  }
  itemList.removeAt(index);
  s.items = itemList;
  _updateCartTotals(s, item);
  _updateDiscountTotals(
    s,
    s.cartDiscount?.value ?? 0,
    s.cartDiscount?.type ?? DiscountValueType.undefined,
  );
}

SellState _setOrderTransactionTypeAction(
  SellState state,
  SetOrderTransactionTypeAction action,
) => state.rebuild((s) {
  s.orderTransactionType = action.orderTransactionType;
});

SellState _setWithdrawalAmountAction(
  SellState state,
  SetWithdrawalAmountAction action,
) => state.rebuild((s) {
  s.currentTotalPrice = action.amount;
  s.transactionWithdrawalAmount = action.amount;
  s.orderTotalWithdrawalAmount = action.amount;
});

void _updateDiscountTotals(
  SellStateBuilder s,
  double value,
  DiscountValueType type,
) {
  double total = (s.subtotalPrice ?? 0) - value;
  double discountValue = value;
  if (type == DiscountValueType.percentage) {
    total = (s.subtotalPrice ?? 0) * (1 - value / 100);
    discountValue = (s.subtotalPrice ?? 0) * (value / 100);
  }

  s.currentTotalPrice = s.totalAmountOutstanding =
      total + (s.cashbackAmount ?? 0) + (s.totalTax ?? 0);
  s.totalDiscount = discountValue;
}

void _updateCartTotals(SellStateBuilder s, OrderLineItem item) {
  s.subtotalPrice = s.items!.fold(
    0,
    (previousValue, e) => (previousValue ?? 0) + e.subtotalPrice,
  );

  if (item.taxable) {
    s.totalTax = (s.totalTax ?? 0) + (item.taxInfo.price);
  }

  var total = s.subtotalPrice!;

  //NOTE: Currently calculations do not take the Split Payments use-case into account so values are 1-to-1
  //i.e. transactionLevelTipAmount == orderLevelTipAmount. The same applies for discount, withdrawal, currentTotalPrice and amountOutStanding amounts.
  if (s.cartDiscount != null) {
    final discount = _calculateDiscount(s.cartDiscount!, s.subtotalPrice!);
    total += discount;
    s.totalDiscount = discount;
  }
  _updateDiscountTotals(
    s,
    s.cartDiscount?.value ?? 0,
    s.cartDiscount?.type ?? DiscountValueType.undefined,
  );
  if (s.checkoutTip != null) {
    final tip = _calculateTipAmount(s.checkoutTip!, s.subtotalPrice!);
    total += tip;
    s.orderTotalTipAmount = tip;
  }

  s.currentTotalPrice = s.totalAmountOutstanding =
      total + (s.orderTotalWithdrawalAmount ?? 0);
  //TODO (team) implement Tax correctly. Currently on backend Tax is added to total which isn't the case if
  //tax amount is inclusive, there is currently no taxInclusive concept on the Order object.
}

void _addOrderLineItem(SellStateBuilder s, OrderLineItem item) {
  s.items ??= <OrderLineItem>[];

  final index = s.items!.indexOf(item);
  var itemList = List<OrderLineItem>.from(s.items!);

  index == -1 ? itemList.add(item) : itemList[index] = item;
  s.items = itemList;
  _updateCartTotals(s, item);
}

void _updateOrderLineItemQuantity({
  required SellStateBuilder s,
  required OrderLineItem item,
  required double quantity,
}) {
  s.items ??= <OrderLineItem>[];

  final index = s.items!.indexWhere((e) => e.productId == item.productId);
  if (index < 0.0) {
    return;
  }

  var itemList = List<OrderLineItem>.from(s.items!);
  final currentItem = itemList[index];
  final newItem = currentItem.copyWith(
    quantity: quantity,
    subtotalPrice: (currentItem.unitPrice * quantity),
  );
  itemList[index] = newItem;
  s.items = itemList;
  _updateCartTotals(s, newItem);
}

double _calculateDiscount(OrderDiscount discount, double total) {
  if (discount.type == DiscountValueType.fixedAmount) {
    return total - discount.value;
  }

  return total - (total * discount.value / 100);
}

double _calculateTipAmount(CheckoutTip currentTip, double subtotal) {
  double tipAmount = 0.0;

  if (currentTip.value != null) {
    switch (currentTip.type) {
      case TipType.fixedAmount:
        tipAmount = currentTip.value!;
        break;
      case TipType.percentage:
        tipAmount = ((currentTip.value! / 100) * (subtotal));
        break;
      case null:
        break;
    }
  }

  return tipAmount;
}

SellState _saveDraftOrdersToStateAction(
  SellState state,
  SaveDraftOrdersToStateAction action,
) => state.rebuild((s) {
  s.drafts = List.from(action.orders);
});
