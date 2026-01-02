// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/products/product_combo.dart';
import 'package:littlefish_merchant/models/shared/form_view_model.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/product/product_actions.dart';
import 'package:littlefish_merchant/redux/product/product_state.dart';
import 'package:littlefish_merchant/common/presentaion/components/completers.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/view_models/store_collection_viewmodel.dart';
import 'package:littlefish_icons/littlefish_icons.dart';

class ComboViewModel extends StoreItemViewModel<ProductCombo?, ProductState> {
  ComboViewModel.fromStore(Store<AppState> store) : super.fromStore(store);

  late FormManager form;

  @override
  loadFromStore(Store<AppState> store, {BuildContext? context}) {
    this.store = store;
    state = store.state.productState;
    item = store.state.combosUIState!.item;
    isNew = item!.isNew ?? false;

    isLoading = state!.isLoading;
    hasError = state!.hasError;
    errorMessage = state!.errorMessage;

    onAdd = (item, ctx) {
      if (key?.currentState != null && !key!.currentState!.validate()) {
        return;
      }

      //if there is a key save it.
      key?.currentState?.save();

      if (this.item!.name == null || this.item!.name!.isEmpty) {
        showMessageDialog(
          ctx!,
          'Please enter a name for your combo',
          LittleFishIcons.info,
        );
        return;
      }

      if (this.item!.items == null || this.item!.items!.isEmpty) {
        showMessageDialog(
          ctx!,
          'Please add some products to your combo',
          LittleFishIcons.info,
        );
        return;
      }

      //all is ok, we should proceed to save the item
      store.dispatch(
        addOrUpdateCombo(
          item: item,
          completer: snackBarCompleter(
            Navigator.of(ctx!).context,
            '${item!.displayName} saved successfully!',
            shouldPop: item.isNew,
          ),
        ),
      );
    };
  }
}
