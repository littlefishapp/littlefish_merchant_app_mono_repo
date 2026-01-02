// Flutter imports:
// remove ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/services/modal_service.dart';
import 'package:littlefish_merchant/injector.dart';

// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/stock/stock_category.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/product/product_actions.dart';
import 'package:littlefish_merchant/redux/product/product_selectors.dart';
import 'package:littlefish_merchant/redux/product/product_state.dart';
import 'package:littlefish_merchant/common/presentaion/components/completers.dart';
import 'package:littlefish_merchant/common/view_models/store_collection_viewmodel.dart';

import '../../../../features/ecommerce_shared/models/store/store_product.dart';

class CategoriesViewModel
    extends StoreCollectionViewModel<StockCategory, ProductState> {
  CategoriesViewModel.fromStore(Store<AppState> store) : super.fromStore(store);

  @override
  loadFromStore(Store<AppState> store, {BuildContext? context}) {
    this.store = store;
    state = store.state.productState;

    isLoading = state!.isLoading;
    hasError = state!.hasError;
    errorMessage = state!.errorMessage;

    onSetPreviousItem = (value) => previousItem = value;

    items = categoriesSelector(store.state);

    selectedItem = store.state.categoriesUIState!.item;
    isNew = selectedItem?.isNew ?? false;

    onRefresh = () => store.dispatch(initializeCategories(refresh: true));

    onRemove = (item, ctx) async {
      StoreProductCategory? onlineCategory;

      if (store.state.storeState.productCategories != null) {
        try {
          onlineCategory = store.state.storeState.productCategories!
              .where((element) => element.categoryId == item.id)
              .first;
        } catch (e) {
          onlineCategory = null;
        }
      }

      bool? syncChangesToOnlineStore = false;
      bool? syncChangesToOnlineStore2;
      bool promptUser = false;
      // bool promptUser2 = false;

      if (onlineCategory != null && !onlineCategory.deleted!) {
        promptUser = true;
      }

      if (promptUser) {
        syncChangesToOnlineStore = await getIt<ModalService>().showActionModal(
          context: context!,
          title: 'Delete Category?',
          description:
              'Do you want to delete/unpublish the ${item.displayName} category from your Online Store as well?',
        );
      }

      if (syncChangesToOnlineStore ?? false) {
        syncChangesToOnlineStore2 = await getIt<ModalService>().showActionModal(
          context: ctx,
          title: 'Unpublish Category Products?',
          description:
              'Do you want to unpublish the online products associated with the ${item.displayName} category as well?',
        );
      }

      //if (promptUser) item.deleted = syncChangesToOnlineStore;

      store.dispatch(
        removeCategory(
          item: item,
          ecommerceUpdate: (syncChangesToOnlineStore ?? false),
          deleteProducts: (syncChangesToOnlineStore2 ?? false),
          completer: snackBarCompleter(ctx, '${item.displayName} deleted'),
        ),
      );
    };

    onAdd = (item, ctx) => store.dispatch(
      addCategory(
        category: item,
        completer: snackBarCompleter(
          ctx,
          '${item.displayName} added successfully!',
          shouldPop: item.isNew! ? true : false,
        ),
      ),
    );
  }
}
