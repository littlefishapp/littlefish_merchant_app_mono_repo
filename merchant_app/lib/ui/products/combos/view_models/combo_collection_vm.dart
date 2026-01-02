// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/products/product_combo.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/product/product_actions.dart';
import 'package:littlefish_merchant/redux/product/product_selectors.dart';
import 'package:littlefish_merchant/redux/product/product_state.dart';
import 'package:littlefish_merchant/common/presentaion/components/completers.dart';
import 'package:littlefish_merchant/common/view_models/store_collection_viewmodel.dart';

class CombosViewModel
    extends StoreCollectionViewModel<ProductCombo, ProductState> {
  CombosViewModel.fromStore(Store<AppState> store) : super.fromStore(store);

  @override
  loadFromStore(Store<AppState> store, {BuildContext? context}) {
    this.store = store;
    state = store.state.productState;
    isLoading = state!.isLoading;
    hasError = state!.hasError;
    errorMessage = state!.errorMessage;

    items = combosSelector(store.state);
    selectedItem = store.state.combosUIState!.item;
    isNew = selectedItem?.isNew ?? false;

    onRefresh = () => store.dispatch(initializeCombos(refresh: true));

    onRemove = (item, ctx) => store.dispatch(
      removeCombo(
        item: item,
        completer: snackBarCompleter(
          ctx,
          '${item.displayName} removed successfully',
        ),
      ),
    );

    onAdd = (item, ctx) => store.dispatch(
      addOrUpdateCombo(
        item: item,
        completer: snackBarCompleter(
          ctx,
          '${item.displayName} saved successfully!',
          shouldPop: true,
        ),
      ),
    );
  }
}
