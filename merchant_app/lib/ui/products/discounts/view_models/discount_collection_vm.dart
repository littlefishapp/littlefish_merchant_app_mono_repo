// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/sales/checkout/checkout_discount.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/discounts/discounts_actions.dart';
import 'package:littlefish_merchant/redux/discounts/discounts_state.dart';
import 'package:littlefish_merchant/common/view_models/store_collection_viewmodel.dart';

class DiscountsVM
    extends StoreCollectionViewModel<CheckoutDiscount, DiscountState> {
  DiscountsVM.fromStore(Store<AppState> store) : super.fromStore(store);

  @override
  loadFromStore(Store<AppState> store, {BuildContext? context}) {
    this.store = store;
    state = store.state.discountState;
    items = List.from(state!.discounts!);
    selectedItem = store.state.discountUIState!.item;

    onRefresh = () => store.dispatch(getDiscounts(refresh: true));

    // this.onRemove = (item, ctx) => store.dispatch(removeProduct(item: item));

    // this.onAdd = (item, ctx) {};

    isLoading = store.state.productState.isLoading ?? false;
    hasError = store.state.productState.hasError ?? false;

    errorMessage = state!.errorMessage;
  }
}
