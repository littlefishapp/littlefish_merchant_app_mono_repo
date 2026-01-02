// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/products/product_modifier.dart';
import 'package:littlefish_merchant/models/shared/form_view_model.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/product/product_actions.dart';
import 'package:littlefish_merchant/redux/product/product_state.dart';
import 'package:littlefish_merchant/common/presentaion/components/completers.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/view_models/store_collection_viewmodel.dart';
import 'package:littlefish_icons/littlefish_icons.dart';

class ModifierViewModel
    extends StoreItemViewModel<ProductModifier?, ProductState> {
  ModifierViewModel.fromStore(Store<AppState> store) : super.fromStore(store) {
    item = item;
  }

  late FormManager form;

  @override
  loadFromStore(Store<AppState> store, {BuildContext? context}) {
    this.store = store;
    state = store.state.productState;
    item = store.state.modifierUIState!.item;
    isLoading = state!.isLoading;
    hasError = state!.hasError;
    errorMessage = state!.errorMessage;

    onAdd = (item, ctx) {
      if (key != null && key!.currentState!.validate()) {
        key!.currentState!.save();

        if (item!.modifiers == null || item.modifiers!.isEmpty) {
          showMessageDialog(ctx!, 'Please add modifiers', LittleFishIcons.info);
          return;
        }

        if (item.multiSelect! && item.maxSelection! <= 0) {
          showMessageDialog(
            ctx!,
            'Please enter the max amount of options',
            LittleFishIcons.info,
          );
          return;
        }

        store.dispatch(
          addOrUpdateModifier(
            item: item,
            completer: snackBarCompleter(
              ctx!,
              '${item.displayName} added successfully',
              shouldPop: item.isNew,
            ),
          ),
        );
      }
    };
  }
}
