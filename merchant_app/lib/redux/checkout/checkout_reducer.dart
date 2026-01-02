// removed ignore: depend_on_referenced_packages

import 'package:decimal/decimal.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_discount.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_refund.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_refund_item.dart';
import 'package:redux/redux.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_cart_item.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/models/stock/stock_variance.dart';
import 'package:littlefish_merchant/redux/auth/auth_actions.dart';
import 'package:littlefish_merchant/redux/checkout/checkout_actions.dart';
import 'package:littlefish_merchant/redux/checkout/checkout_state.dart';
import 'package:uuid/uuid.dart';

final checkoutReducer = combineReducers<CheckoutState>([
  TypedReducer<CheckoutState, CheckoutSetLoadingAction>(onSetLoading).call,
  TypedReducer<CheckoutState, CheckoutSetFailureAction>(onCheckoutFailure).call,
  TypedReducer<CheckoutState, CheckoutSetCustomerAction>(onSetCustomer).call,
  TypedReducer<CheckoutState, CheckoutSetTicketAction>(onSetTicket).call,
  TypedReducer<CheckoutState, CheckoutSetPaymentTypeAction>(
    onSetPaymentType,
  ).call,
  TypedReducer<CheckoutState, ClearPaymentTypeAction>(
    onClearPaymentTypeAction,
  ).call,
  TypedReducer<CheckoutState, CheckoutTypeSetAmountTenderedAction>(
    onSetAmountTendered,
  ).call,
  TypedReducer<CheckoutState, CheckoutAddProductAction>(
    onAddProductToSale,
  ).call,
  TypedReducer<CheckoutState, CheckoutAddCustomSaleAction>(
    addAddCustomSale,
  ).call,
  TypedReducer<CheckoutState, CheckoutReduceCustomSaleQuantityAction>(
    reduceCustomSaleQuantity,
  ).call,
  TypedReducer<CheckoutState, CheckoutRemoveItemAction>(onVoidItem).call,
  TypedReducer<CheckoutState, CheckoutClearAction>(onClear).call,
  TypedReducer<CheckoutState, CheckoutRemoveItemsAction>(onRemoveItems).call,
  TypedReducer<CheckoutState, CheckoutAddItemsToCart>(onAddItems).call,
  TypedReducer<CheckoutState, CheckoutAddItemToCart>(onAddItem).call,
  TypedReducer<CheckoutState, CheckoutPushSaleCompletedAction>(
    onCheckoutCompleted,
  ).call,
  TypedReducer<CheckoutState, CheckoutAddCombos>(onAddCombos).call,
  TypedReducer<CheckoutState, CheckoutSetCustomAmount>(onSetCustomAmount).call,
  // TypedReducer<CheckoutState, AppSettingsSetSalesTaxAction>(onSetSalesTax).call,
  TypedReducer<CheckoutState, CheckoutSetCustomDescription>(
    onSetCustomDescription,
  ).call,
  TypedReducer<CheckoutState, SignoutAction>(onClearState).call,
  TypedReducer<CheckoutState, CheckoutSetKeyPadIndexAction>(
    onSetKeypadIndex,
  ).call,
  TypedReducer<CheckoutState, CheckoutSetDiscountAction>(onSetDiscount).call,
  TypedReducer<CheckoutState, CardPaymentResponseAction>(
    onCardPaymentResponse,
  ).call,
  TypedReducer<CheckoutState, CheckoutSetCurrentActionAmount>(
    onCheckoutSetCurrectActionAmount,
  ).call,
  TypedReducer<CheckoutState, CheckoutSetWithdrawalAmountAction>(
    onSetWithdrawalAmount,
  ).call,
  TypedReducer<CheckoutState, CheckoutSetCashbackAmountAction>(
    onSetCashbackAmount,
  ).call,
  TypedReducer<CheckoutState, CheckoutSetDiscountTabIndexAction>(
    onSetDiscountTabIndex,
  ).call,
  TypedReducer<CheckoutState, CardPaymentResponseAction>(
    onCardPaymentResponse,
  ).call,
  TypedReducer<CheckoutState, CheckoutSetTipAction>(onSetTip).call,
  TypedReducer<CheckoutState, CheckoutSetTipTabIndexAction>(
    onSetTipTabIndex,
  ).call,
  TypedReducer<CheckoutState, CheckoutClearTipAction>(onClearTip).call,
  TypedReducer<CheckoutState, CheckoutClearDiscountAction>(
    onClearCheckoutDiscount,
  ).call,
  TypedReducer<CheckoutState, SetCheckoutSortOptionsAction>(
    onSetSortOptions,
  ).call,
  TypedReducer<CheckoutState, ClearRefund>(_onClearRefund).call,
  TypedReducer<CheckoutState, CreateQuickRefund>(_onCreateQuickRefund).call,
  TypedReducer<CheckoutState, SetQuickRefundAmount>(
    _onSetQuickRefundAmount,
  ).call,
  TypedReducer<CheckoutState, SetQuickRefundDescription>(
    _onSetQuickRefundDescription,
  ).call,
  TypedReducer<CheckoutState, SetQuickRefundCustomer>(
    _onSetQuickRefundCustomer,
  ).call,
  TypedReducer<CheckoutState, SetVariantSelectionLoadingAction>(
    _onSetVariantSelectionLoadingAction,
  ).call,
  TypedReducer<CheckoutState, SetCheckoutProductVariantAction>(
    _onSetCheckoutProductVariantAction,
  ).call,
  TypedReducer<CheckoutState, ClearCheckoutProductVariantAction>(
    _onClearCheckoutProductVariant,
  ).call,
]);

CheckoutState _onClearCheckoutProductVariant(
  CheckoutState state,
  ClearCheckoutProductVariantAction action,
) => state.rebuild((b) => b.productVariant = null);

CheckoutState _onSetVariantSelectionLoadingAction(
  CheckoutState state,
  SetVariantSelectionLoadingAction action,
) => state.rebuild((b) => b.productVariantIsLoading = action.value);

CheckoutState _onSetCheckoutProductVariantAction(
  CheckoutState state,
  SetCheckoutProductVariantAction action,
) => state.rebuild((b) => b.productVariant = action.value);

CheckoutState _onClearRefund(CheckoutState state, ClearRefund action) =>
    state.rebuild((b) => b.quickRefund = null);

CheckoutState _onSetQuickRefundCustomer(
  CheckoutState state,
  SetQuickRefundCustomer action,
) => state.rebuild((b) {
  b.quickRefund!.customerName = action.value?.displayName;
  b.quickRefund!.customerId = action.value?.id;
  b.quickRefund!.customerEmail = action.value?.email;
  b.quickRefund!.customerMobile = action.value?.mobileNumber;
});

CheckoutState _onSetQuickRefundAmount(
  CheckoutState state,
  SetQuickRefundAmount action,
) => state.rebuild((b) {
  Decimal value = action.value ?? Decimal.zero;
  b.quickRefund?.totalRefund = value.toDouble();
  if (b.quickRefund!.items == null || b.quickRefund!.items!.isEmpty) {
    b.quickRefund!.items = [
      RefundItem(
        displayName: 'Quick Refund',
        quantity: 1,
        itemValue: value.toDouble(),
        itemCost: 0,
        itemTotalCost: 0,
        itemTotalValue: value.toDouble(),
        checkoutCartItemId: const Uuid().v4(),
      ),
    ];
  } else {
    b.quickRefund!.items![0].itemValue = value.toDouble();
    b.quickRefund!.items![0].itemTotalValue = value.toDouble();
  }
});

CheckoutState _onSetQuickRefundDescription(
  CheckoutState state,
  SetQuickRefundDescription action,
) => state.rebuild((b) => b.quickRefund?.description = action.value);

CheckoutState _onCreateQuickRefund(
  CheckoutState state,
  CreateQuickRefund action,
) => state.rebuild(
  (b) => b.quickRefund = Refund.create(
    userId: action.userId,
    userName: action.username,
    businessId: action.businessId,
    isQuickRefund: true,
  )..id = const Uuid().v4(),
);

CheckoutState onCardPaymentResponse(
  CheckoutState state,
  CardPaymentResponseAction action,
) => state.rebuild((b) => b.paymentType!.paid = action.paid);

CheckoutState onSetWithdrawalAmount(
  CheckoutState state,
  CheckoutSetWithdrawalAmountAction action,
) => state.rebuild((b) => b.withdrawalAmount = action.value);

CheckoutState onSetCashbackAmount(
  CheckoutState state,
  CheckoutSetCashbackAmountAction action,
) => state.rebuild((b) => b.cashbackAmount = action.value);

// CheckoutState onSetSalesTax(
//   CheckoutState state,
//   AppSettingsSetSalesTaxAction action,
// ) =>
//     state.rebuild((b) => b.salesTax = action.value);

CheckoutState onSetCustomDescription(
  CheckoutState state,
  CheckoutSetCustomDescription action,
) => state.rebuild((b) => b.customDescription = action.value);

CheckoutState onSetCustomAmount(
  CheckoutState state,
  CheckoutSetCustomAmount action,
) => state.rebuild((b) => b.customAmount = action.value);

CheckoutState onClearState(CheckoutState state, SignoutAction action) =>
    state.rebuild((b) {
      b.isLoading = false;
      b.hasError = false;
      b.errorMessage = null;

      b.customer = null;
      b.items = [];
      b.voidedItems = [];
    });

CheckoutState onSetLoading(
  CheckoutState state,
  CheckoutSetLoadingAction action,
) => state.rebuild((b) => b.isLoading = action.value);

CheckoutState onCheckoutFailure(
  CheckoutState state,
  CheckoutSetFailureAction action,
) => state.rebuild((b) {
  b.hasError = true;
  b.errorMessage = action.value;
});

CheckoutState onSetCustomer(
  CheckoutState state,
  CheckoutSetCustomerAction action,
) => state.rebuild((b) => b.customer = action.value);

CheckoutState onSetTicket(
  CheckoutState state,
  CheckoutSetTicketAction action,
) => state.rebuild((b) => b.ticket = action.value);

CheckoutState onSetPaymentType(
  CheckoutState state,
  CheckoutSetPaymentTypeAction action,
) => state.rebuild((b) {
  b.paymentType = action.value;
  if (b.paymentType?.name?.toLowerCase() != 'cash') {
    b.amountTendered = Decimal.parse(state.checkoutTotal.toString());
  }
});

CheckoutState onClearPaymentTypeAction(
  CheckoutState state,
  ClearPaymentTypeAction action,
) => state.rebuild((b) {
  b.paymentType = null;
});

CheckoutState onSetAmountTendered(
  CheckoutState state,
  CheckoutTypeSetAmountTenderedAction action,
) => state.rebuild((b) => b.amountTendered = action.value);

CheckoutState onAddProductToSale(
  CheckoutState state,
  CheckoutAddProductAction action,
) {
  var updatedCart = _addProduct(
    action.product,
    action.variance,
    state.items!.toList(),
    quantity: action.quantity,
    variableAmount: action.product.isVariable ? action.variableAmount : null,
    onlyAddOneIfNotInCart: action.onlyAddOneIfNotInCart ?? true,
  );

  // updatedCart = _recalculateAllItemTaxes(updatedCart, state);

  return state.rebuild((b) => b.items = updatedCart);

  // return state.rebuild((b) {
  //   b.items = _addProduct(
  //     action.product,
  //     action.variance,
  //     b.items!,
  //     quantity: action.quantity,
  //     variableAmount: action.product.isVariable ? action.variableAmount : null,
  //     onlyAddOneIfNotInCart: action.onlyAddOneIfNotInCart ?? true,
  //   );
  // });
}

CheckoutState addAddCustomSale(
  CheckoutState state,
  CheckoutAddCustomSaleAction action,
) {
  var updatedCart = _addCustomSale(
    state.items!.toList(),
    action.value,
    description: action.description,
  );

  // updatedCart = _recalculateAllItemTaxes(updatedCart, state);

  return state.rebuild((b) {
    b.items = updatedCart;
    b.customAmount = Decimal.zero;
    b.customDescription = '';
  });
  // return state.rebuild(
  //     (b) {
  //       b.items = _addCustomSale(
  //         b.items!,
  //         action.value,
  //         description: action.description,
  //       );

  //       b.customAmount = 0.0;
  //       b.customDescription = '';
  //     },
  //   );
}

CheckoutState reduceCustomSaleQuantity(
  CheckoutState state,
  CheckoutReduceCustomSaleQuantityAction action,
) {
  var updatedCart = _reduceCustomSaleQuantity(
    state.items!.toList(),
    action.value,
    description: action.description,
  );

  // updatedCart = _recalculateAllItemTaxes(updatedCart, state);

  return state.rebuild((b) {
    b.items = updatedCart;
    b.customAmount = Decimal.zero;
    b.customDescription = '';
  });
  // return state.rebuild(
  //     (b) {
  //       b.items = _reduceCustomSaleQuantity(
  //         b.items!,
  //         action.value,
  //         description: action.description,
  //       );

  //       b.customAmount = 0.0;
  //       b.customDescription = '';
  //     },
  //   );
}

CheckoutState onCheckoutSetCurrectActionAmount(
  CheckoutState state,
  CheckoutSetCurrentActionAmount action,
) => state.rebuild((b) => b.currentCheckoutActionAmount = action.value);

CheckoutState onVoidItem(
  CheckoutState state,
  CheckoutRemoveItemAction action,
) => state.rebuild((b) {
  b.items = _voidItem(b.items!, action.value);
  b.voidedItems = List.from(b.voidedItems!)..add(action.value);
});

CheckoutState onSetSortOptions(
  CheckoutState state,
  SetCheckoutSortOptionsAction action,
) => state.rebuild((b) {
  b.sortBy = action.type;
  b.sortOrder = action.order;
});

CheckoutState onAddItems(CheckoutState state, CheckoutAddItemsToCart action) =>
    state.rebuild(
      (b) => b.items = List.from(
        _addItems(b.items, action.value as List<CheckoutCartItem>) as Iterable,
      ),
    );

CheckoutState onAddItem(CheckoutState state, CheckoutAddItemToCart action) =>
    state.rebuild((b) => b.items = _addItem(b.items, action.value));

CheckoutState onCheckoutCompleted(
  CheckoutState state,
  CheckoutPushSaleCompletedAction action,
) {
  var newSate = state.rebuild(
    (b) => b.lastTransactionNumber = action.transaction.transactionNumber,
  );
  return action.success
      ? onClear(
          newSate,
          CheckoutClearAction(action.transaction.transactionNumber),
        )
      : state;
}

CheckoutState onClear(CheckoutState state, CheckoutClearAction action) =>
    state.rebuild(
      (b) => b
        ..replace(
          CheckoutState(transactionNumber: action.lastTransactionNumber),
        ),
    );

CheckoutState onClearCheckoutDiscount(
  CheckoutState state,
  CheckoutClearDiscountAction action,
) => state.rebuild((b) {
  b.discount = CheckoutDiscount(
    isNew: false,
    minValue: 0,
    maxValue: 0,
    value: 0,
    type: null,
  );
});

CheckoutState onRemoveItems(
  CheckoutState state,
  CheckoutRemoveItemsAction action,
) => state.rebuild((b) {
  b.items = [];
  // b.voidedItems = List.from(b.voidedItems!)..clear();
});

CheckoutState onAddCombos(CheckoutState state, CheckoutAddCombos action) {
  return state.rebuild((b) {
    for (var c in action.cartItems) {
      var index = b.items!.indexWhere((i) => i.id == c.id);

      if (c.quantity <= 0) {
        b.items = b.items?..removeAt(index);
      } else {
        b.items = b.items?..[index].quantity = c.quantity;
      }
    }

    //now lets go through the combos...
    for (var combo in action.value) {
      b.items = _addItem(b.items, CheckoutCartItem.fromCombo(combo!, 1));
    }
  });
}

List<CheckoutCartItem> _voidItem(
  List<CheckoutCartItem> state,
  CheckoutCartItem item,
) {
  state.removeWhere((ci) => ci.id == item.id);
  return state;
}

List<CheckoutCartItem> _addCustomSale(
  List<CheckoutCartItem> cartItems,
  Decimal amount, {
  String? description = 'Custom Sale',
}) {
  final desc = description == null || description.isEmpty
      ? 'Custom Sale'
      : description;
  final existingItemIndex = cartItems.indexWhere(
    (i) => i.itemValue == amount && i.description == desc,
  );

  final updatedCart = List.of(cartItems);

  if (existingItemIndex != -1) {
    updatedCart[existingItemIndex].quantity += 1;
  } else {
    final item = CheckoutCartItem.fromCustomSale(amount.toDouble(), desc);
    updatedCart.add(item);
  }
  return updatedCart;
}

// List<CheckoutCartItem> _addCustomSale(
//   List<CheckoutCartItem> state,
//   double amount, {
//   String? description = 'Custom Sale',
// }) {
//   description =
//       description == null || description.isEmpty ? 'Custom Sale' : description;

//   // Check if custom item already in cart based on amount and description,
//   // if in the cart then increase it's quantity, otherwise add new custom item.
//   int existingItemIndex = state.indexWhere(
//     (i) => i.itemValue == amount && i.description == description,
//   );

//   bool hasItem = existingItemIndex > -1;

//   if (hasItem) {
//     var existingItem = state[existingItemIndex];

//     existingItem.quantity += 1;

//     state[existingItemIndex] = existingItem;

//     return state;
//   } else {
//     CheckoutCartItem item =
//         CheckoutCartItem.fromCustomSale(amount, description);
//     List<CheckoutCartItem> newList = List.from(state);
//     newList.add(item);

//     return newList;
//   }
// }

List<CheckoutCartItem> _reduceCustomSaleQuantity(
  List<CheckoutCartItem> cartItems,
  Decimal amount, {
  String? description = 'Custom Sale',
}) {
  final desc = description == null || description.isEmpty
      ? 'Custom Sale'
      : description;
  final existingItemIndex = cartItems.indexWhere(
    (i) => i.itemValue == amount && i.description == desc,
  );

  final updatedCart = List.of(cartItems);

  if (existingItemIndex != -1) {
    final item = updatedCart[existingItemIndex];
    item.quantity -= 1;
    if (item.quantity <= 0) {
      updatedCart.removeAt(existingItemIndex);
    }
  }

  return updatedCart;
}

// List<CheckoutCartItem> _reduceCustomSaleQuantity(
//   List<CheckoutCartItem> state,
//   double amount, {
//   String? description = 'Custom Sale',
// }) {
//   description =
//       description == null || description.isEmpty ? 'Custom Sale' : description;

//   // Check if custom item already in cart based on amount and description,
//   // if in the cart then decrease it's quantity, otherwise return current state.
//   int existingItemIndex = state.indexWhere(
//     (i) => i.itemValue == amount && i.description == description,
//   );
//   bool hasItem = existingItemIndex > -1;

//   if (hasItem) {
//     var existingItem = state[existingItemIndex];

//     existingItem.quantity -= 1;

//     state[existingItemIndex] = existingItem;

//     return state;
//   }

//   return state;
// }

List<CheckoutCartItem>? _addItems(
  List<CheckoutCartItem>? state,
  List<CheckoutCartItem> items,
) {
  for (var i in items) {
    state = _addItem(state, i);
  }

  return state;
}

List<CheckoutCartItem>? _addItem(
  List<CheckoutCartItem>? state,
  CheckoutCartItem cartItem,
) {
  if (cartItem.isCombo ?? false) {
    bool hasItem = state!.any((i) => i.comboId == cartItem.comboId);

    if (hasItem) {
      var existingItemIndex = state.indexWhere(
        (i) => i.comboId == cartItem.comboId,
      );

      var existingItem = state[existingItemIndex];

      existingItem.quantity += cartItem.quantity;

      state[existingItemIndex] = existingItem;

      if (state[existingItemIndex].quantity == 0) {
        _voidItem(state, state[existingItemIndex]);
      }

      return state;
    } else {
      final newList = List.from(state);
      newList.add(cartItem);
      state = List.from(newList);

      return state;
    }
  } else {
    bool hasItem = state!.any(
      (i) => i.productId == cartItem.productId && i.barcode == cartItem.barcode,
    );

    if (hasItem) {
      var existingItemIndex = state.indexWhere(
        (i) =>
            i.productId == cartItem.productId && i.barcode == cartItem.barcode,
      );

      var existingItem = state[existingItemIndex];

      existingItem.quantity += cartItem.quantity;

      state[existingItemIndex] = existingItem;

      return state;
    } else {
      final newList = List.from(state);
      newList.add(cartItem);
      state = List.from(newList);

      return state;
    }
  }
}

// List<CheckoutCartItem> _addProduct(
//   StockProduct product,
//   StockVariance? variance,
//   List<CheckoutCartItem> cartItems,
//   CheckoutState state, {
//   double quantity = 1,
//   double? variableAmount,
//   bool onlyAddOneIfNotInCart = true,
// }) {
//   bool hasItem = cartItems
//       .any((i) => i.productId == product.id && i.barcode == variance!.barcode);

//   CheckoutCartItem item;

//   if (hasItem) {
//     var existingItemIndex = cartItems.indexWhere(
//       (i) => i.productId == product.id && i.barcode == variance!.barcode,
//     );

//     item = cartItems[existingItemIndex];

//     item.quantity += quantity;

//     cartItems[existingItemIndex] = item;

//     if (item.quantity <= 0) _voidItem(cartItems, item);

//     return cartItems;
//   } else {
//     var item = CheckoutCartItem.fromProduct(
//       product,
//       variance ?? product.regularVariance!,
//       variablePrice: variableAmount,
//       quantity: onlyAddOneIfNotInCart ? 1 : quantity,
//     );

//     // CheckoutCartItem(
//     //   cartIndex: state.length + 1,
//     //   description: product.displayName ?? "Cash Sale",
//     //   productId: product.id,
//     //   itemValue: variance?.sellingPrice ?? product.regularPrice,
//     //   quantity: 1,
//     //   varianceId: variance?.id ?? product.regularVariance.id,
//     // )..barcode = variance.barcode;

//     List<CheckoutCartItem> newList = List.from(cartItems);
//     newList.add(item);

//     return newList;
//   }
// }

List<CheckoutCartItem> _addProduct(
  StockProduct product,
  StockVariance? variance,
  List<CheckoutCartItem> cartItems, {
  double quantity = 1,
  double? variableAmount,
  bool onlyAddOneIfNotInCart = true,
}) {
  final effectiveVariance = variance ?? product.regularVariance!;

  final existingItemIndex = cartItems.indexWhere(
    (item) =>
        item.productId == product.id &&
        item.barcode == effectiveVariance.barcode,
  );

  final updatedCart = List.of(cartItems);

  if (existingItemIndex != -1) {
    final existingItem = updatedCart[existingItemIndex];
    final newQuantity = existingItem.quantity + quantity;

    if (newQuantity <= 0) {
      updatedCart.removeAt(existingItemIndex);
    } else {
      existingItem.quantity = newQuantity;
    }
  } else {
    final newItem = CheckoutCartItem.fromProduct(
      product,
      effectiveVariance,
      variablePrice: variableAmount,
      quantity: onlyAddOneIfNotInCart ? 1 : quantity,
    );
    updatedCart.add(newItem);
  }

  return updatedCart;
}

// List<CheckoutCartItem> _recalculateAllItemTaxes(
//   List<CheckoutCartItem> cartItems,
//   CheckoutState state,
// ) {
//   if (cartItems.isEmpty) {
//     return [];
//   }

//   final productsInCart = state.getStockProductsInCart(cartItems);
//   final allTaxes =
//       AppVariables.store?.state.appSettingsState.salesTaxesList ?? [];
//   final totalDiscount = state.totalDiscount ?? 0.0;

//   for (final item in cartItems) {
//     final calculatedTax = TaxCalculationService.calculateTaxForItem(
//       item: item,
//       allCartItems: cartItems,
//       totalCartDiscount: totalDiscount,
//       productsInCart: productsInCart,
//       allAvailableTaxes: allTaxes,
//     );
//     item.itemTax = calculatedTax;
//   }

//   return cartItems;
// }

CheckoutState onSetKeypadIndex(
  CheckoutState state,
  CheckoutSetKeyPadIndexAction action,
) => state.rebuild((b) => b.keypadIndex = action.value);

CheckoutState onSetDiscount(
  CheckoutState state,
  CheckoutSetDiscountAction action,
) => state.rebuild((b) => b.discount = action.value);

CheckoutState onSetDiscountTabIndex(
  CheckoutState state,
  CheckoutSetDiscountTabIndexAction action,
) => state.rebuild((b) => b.discountTabIndex = action.index);

CheckoutState onSetTip(CheckoutState state, CheckoutSetTipAction action) =>
    state.rebuild((b) => b.tip = action.tip);

CheckoutState onSetTipTabIndex(
  CheckoutState state,
  CheckoutSetTipTabIndexAction action,
) => state.rebuild((b) => b.tipTabIndex = action.index);

CheckoutState onClearTip(CheckoutState state, CheckoutClearTipAction action) =>
    state.rebuild((b) => b.tip = null);
