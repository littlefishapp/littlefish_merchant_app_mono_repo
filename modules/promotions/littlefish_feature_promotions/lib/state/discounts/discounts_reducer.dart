// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_discount.dart';
import 'package:littlefish_merchant/redux/discounts/discounts_actions.dart';
import 'package:littlefish_merchant/redux/discounts/discounts_state.dart';

// import '../auth/auth_actions.dart';

final discountReducer = combineReducers<DiscountState>([
  TypedReducer<DiscountState, DiscountsLoadingAction>(onSetLoading).call,
  TypedReducer<DiscountState, DiscountChangedAction>(onDiscountChanged).call,
  TypedReducer<DiscountState, DiscountsLoadedAction>(onDiscountsLoaded).call,
  TypedReducer<DiscountState, DiscountsErrorAction>(onDiscountError).call,
  // TypedReducer<DiscountState, SignoutAction>(onClearState).call,
]);

// DiscountState onClearState(DiscountState state, SignoutAction action) =>
//     state.rebuild((b) {
//       b.isLoading = false;
//       b.hasError = false;
//       b.errorMessage = null;
//       b.discounts = [];
//     });

DiscountState onSetLoading(
  DiscountState state,
  DiscountsLoadingAction action,
) => state.rebuild((b) => b.isLoading = action.value);

DiscountState onDiscountChanged(
  DiscountState state,
  DiscountChangedAction action,
) => state.rebuild((b) {
  state.rebuild(
    (b) => b.discounts = action.type == ChangeType.removed
        ? _removeDiscount(action.value, b.discounts)
        : _addOrUpdateDiscount(action.value, b.discounts),
  );
});

DiscountState onDiscountsLoaded(
  DiscountState state,
  DiscountsLoadedAction action,
) => state.rebuild((b) {
  b.discounts = action.value;
});

DiscountState onDiscountError(
  DiscountState state,
  DiscountsErrorAction action,
) => state.rebuild((b) {
  b.errorMessage = action.value;
  b.hasError = b.errorMessage != null;
});

final discountsUIReducer = combineReducers<DiscountUIState>([
  TypedReducer<DiscountUIState, CreateDiscountAction>(onCreateDiscount).call,
  TypedReducer<DiscountUIState, SelectDiscountAction>(onSelectDiscount).call,
]);

DiscountUIState onCreateDiscount(
  DiscountUIState state,
  CreateDiscountAction action,
) => state.rebuild((b) {
  b.item = CheckoutDiscount.create();
});

DiscountUIState onSelectDiscount(
  DiscountUIState state,
  SelectDiscountAction action,
) => state.rebuild((b) {
  b.item = action.value;
});

List<CheckoutDiscount> _addOrUpdateDiscount(
  CheckoutDiscount value,
  List<CheckoutDiscount>? state,
) {
  var index = state!.indexWhere((p) => p.id == value.id);
  if (index >= 0) {
    state[index] = value;
  } else {
    state.add(value);
  }

  return state;
}

List<CheckoutDiscount> _removeDiscount(
  CheckoutDiscount value,
  List<CheckoutDiscount>? state,
) {
  state!.removeWhere((p) => p.id == value.id);

  return state;
}
