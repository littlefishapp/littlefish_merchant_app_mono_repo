// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/products/product_modifier.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/product/product_actions.dart';
import 'package:littlefish_merchant/redux/product/product_state.dart';
import 'package:littlefish_merchant/common/presentaion/components/completers.dart';
import 'package:littlefish_merchant/common/view_models/store_collection_viewmodel.dart';

class ModifiersViewModel
    extends StoreCollectionViewModel<ProductModifier, ProductState> {
  ModifiersViewModel.fromStore(Store<AppState> store) : super.fromStore(store);

  @override
  loadFromStore(Store<AppState> store, {BuildContext? context}) {
    this.store = store;
    state = store.state.productState;
    items = state!.modifiers;
    selectedItem = store.state.modifierUIState!.item;
    isNew = selectedItem?.isNew ?? false;
    isLoading = state!.isLoading ?? false;
    hasError = state!.hasError ?? false;

    onRefresh = () => store.dispatch(initializeModifiers(refresh: true));

    onRemove = (item, ctx) => store.dispatch(
      removeModifier(
        item: item,
        completer: snackBarCompleter(
          context!,
          'Modifier removed successfully',
          shouldPop: true,
        ),
      ),
    );

    onAdd = (item, ctx) {
      store.dispatch(
        addOrUpdateModifier(
          item: item,
          completer: snackBarCompleter(
            context!,
            '${item.displayName} added successfully',
            shouldPop: true,
          ),
        ),
      );
    };
  }
}
