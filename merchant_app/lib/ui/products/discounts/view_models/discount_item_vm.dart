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
import 'package:littlefish_merchant/common/presentaion/components/completers.dart';
import 'package:littlefish_merchant/common/view_models/store_collection_viewmodel.dart';

class DiscountVM extends StoreItemViewModel<CheckoutDiscount?, DiscountState> {
  DiscountVM.fromStore(Store<AppState> store) : super.fromStore(store);

  @override
  loadFromStore(Store<AppState> store, {BuildContext? context}) {
    this.store = store;
    state = store.state.discountState;
    item = store.state.discountUIState!.item;
    isNew = item?.isNew ?? false;

    onAdd = (item, ctx) {
      if (key == null || key!.currentState == null) return;

      if (key!.currentState!.validate()) {
        key!.currentState!.save();

        //now let us kick off the dispatch to do the work
        store.dispatch(
          createOrUpdateDiscount(
            item: item!,
            completer: snackBarCompleter(
              ctx!,
              '${item.displayName} saved successfully!',
              shouldPop: item.isNew,
            ),
          ),
        );
      }
    };

    isLoading = store.state.productState.isLoading ?? false;
    hasError = store.state.productState.hasError ?? false;

    errorMessage = state!.errorMessage;
  }
}
