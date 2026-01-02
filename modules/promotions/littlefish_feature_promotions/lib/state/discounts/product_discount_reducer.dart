// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/products/product_discount.dart';
import 'package:littlefish_merchant/redux/discounts/product_discounts_actions.dart';
import 'package:littlefish_merchant/redux/discounts/product_discount_state.dart';
import 'package:littlefish_merchant/models/enums.dart';

final productDiscountReducer = combineReducers<ProductDiscountState>([
  TypedReducer<ProductDiscountState, ProductDiscountsLoadingAction>(
    onSetLoading,
  ).call,
  TypedReducer<ProductDiscountState, ProductDiscountChangedAction>(
    onProductDiscountChanged,
  ).call,
  TypedReducer<ProductDiscountState, ProductDiscountsLoadedAction>(
    onProductDiscountsLoaded,
  ).call,
  TypedReducer<ProductDiscountState, ProductDiscountsErrorAction>(
    onProductDiscountError,
  ).call,
  TypedReducer<ProductDiscountState, SelectProductDiscountAction>(
    onSelectProductDiscount,
  ).call,
]);

ProductDiscountState onSetLoading(
  ProductDiscountState state,
  ProductDiscountsLoadingAction action,
) => state.rebuild((b) => b.isLoading = action.value);

ProductDiscountState onProductDiscountChanged(
  ProductDiscountState state,
  ProductDiscountChangedAction action,
) => state.rebuild((b) {
  state.rebuild(
    (b) => b.discounts = action.type == ChangeType.removed
        ? _removeDiscount(action.value, b.discounts)
        : _addOrUpdateDiscount(action.value, b.discounts),
  );
});

ProductDiscountState onProductDiscountsLoaded(
  ProductDiscountState state,
  ProductDiscountsLoadedAction action,
) => state.rebuild((b) {
  b.discounts ??= [];
  for (ProductDiscount discount in action.value) {
    int index = b.discounts!.indexWhere((element) => element.id == discount.id);
    if (index != -1) {
      b.discounts?[index] = discount;
    } else if (index == -1) {
      final newList = List.from(b.discounts!);
      newList.add(discount);
      b.discounts = List.from(newList);
    }
  }
});

ProductDiscountState onProductDiscountError(
  ProductDiscountState state,
  ProductDiscountsErrorAction action,
) => state.rebuild((b) {
  b.errorMessage = action.value;
  b.hasError = b.errorMessage != null;
});

ProductDiscountState onSelectProductDiscount(
  ProductDiscountState state,
  SelectProductDiscountAction action,
) => state.rebuild((b) {
  b.currentDiscount = action.value;
});

_addOrUpdateDiscount(ProductDiscount value, List<ProductDiscount>? state) {
  var index = state!.indexWhere((p) => p.id == value.id);
  if (index >= 0) {
    state[index] = value;
  } else {
    final newList = List.from(state);
    newList.add(value);
    state = List.from(newList);
  }

  return state;
}

_removeDiscount(ProductDiscount value, List<ProductDiscount>? state) {
  state!.removeWhere((p) => p.id == value.id);

  return state;
}
