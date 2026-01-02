// Flutter imports:
// remove ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/services/modal_service.dart';
import 'package:littlefish_merchant/injector.dart';

// Package imports:
import 'package:quiver/strings.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/shared/form_view_model.dart';
import 'package:littlefish_merchant/models/stock/stock_category.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/product/product_actions.dart';
import 'package:littlefish_merchant/redux/product/product_state.dart';
import 'package:littlefish_merchant/common/presentaion/components/completers.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/view_models/store_collection_viewmodel.dart';
import 'package:littlefish_icons/littlefish_icons.dart';

import '../../../../features/ecommerce_shared/models/store/store_product.dart';

class CategoryViewModel
    extends StoreItemViewModel<StockCategory, ProductState> {
  CategoryViewModel.fromStore(Store<AppState> store, {BuildContext? context})
    : super.fromStore(store, context: context);

  late FormManager form;

  List<StockProduct>? products;

  late Function(
    BuildContext ctx,
    StockCategory category,
    bool? shouldPop,
    bool canReset,
  )
  onUpdate;

  late Function(BuildContext ctx, StockCategory category) onDeleteCategoryItem;

  bool get hasImage => isNotBlank(item?.imageUri);

  late void Function(StockCategory category) onSetCategory;

  @override
  loadFromStore(Store<AppState> store, {BuildContext? context}) {
    this.store = store;
    state = store.state.productState;
    item = store.state.categoriesUIState!.item;
    isNew = item!.isNew ?? false;

    onSetCategory = (category) {
      store.dispatch(SetCategoryAction(category));
    };

    products = List.from(
      state!.products!.where((e) => e.categoryId == item!.id).toList(),
    );

    if (!isNew! &&
        (item!.products == null ||
            (item!.products!.isEmpty && item!.removedProducts.isEmpty))) {
      item!.products = state?.products
          ?.where((p) => p.categoryId != null && p.categoryId == item!.id)
          .map((p) => StockProduct.clone(product: p))
          .toList();
    }

    isLoading = state!.isLoading;
    hasError = state!.hasError;
    errorMessage = state!.errorMessage;

    onUpdate = (ctx, category, shouldPop, canReset) async {
      if (key?.currentState != null) {
        if (!key!.currentState!.validate()) return;
        key!.currentState!.save();

        StoreProductCategory? onlineCategory;
        StockCategory? stateCategory;

        if (store.state.storeState.productCategories != null) {
          try {
            onlineCategory = store.state.storeState.productCategories!
                .where((element) => element.categoryId == category.id)
                .first;
          } catch (e) {
            onlineCategory = null;
          }
        }

        if (store.state.productState.categories != null) {
          try {
            stateCategory = store.state.productState.categories!.firstWhere(
              (element) => element.id == category.id,
            );
          } catch (e) {
            stateCategory = null;
          }
        }

        bool? syncChangesToOnlineStore = false;
        bool? syncChangesToOnlineStore2;
        bool promptUser = false;
        bool promptUser2 = false;
        bool notify = false;

        if (onlineCategory != null &&
            stateCategory != null &&
            !onlineCategory.deleted! &&
            (stateCategory.isOnline ?? false)) {
          if (category.isOnline!) {
            promptUser = true;
          } else {
            if (store.state.storeState.products != null &&
                store.state.storeState.products!
                    .where((p) => p.baseCategoryId == item!.id)
                    .toList()
                    .isNotEmpty) {
              promptUser2 = true;
              syncChangesToOnlineStore = true;
              promptUser = false;
            }
          }
        } else if (category.isOnline!) {
          syncChangesToOnlineStore = true;
          notify = true;
        }

        if (promptUser) {
          syncChangesToOnlineStore = await getIt<ModalService>().showActionModal(
            context: context!,
            title: 'Sync Changes?',
            description:
                'Do you want to sync the changes on the ${category.displayName} category to your Online Store as well?',
          );
        }

        if (promptUser2) {
          syncChangesToOnlineStore2 = await getIt<ModalService>().showActionModal(
            context: context!,
            title: 'Unpublish Category Products?',
            description:
                'Do you want to unpublish the online products associated with the ${category.displayName} category as well?',
          );
          if ((syncChangesToOnlineStore2 ?? true)) {
            syncChangesToOnlineStore = true;
          }
        }

        if (notify) {
          await showMessageDialog(
            ctx,
            'Please note, all the products associated with this category will also be be published to your Online Store',
            LittleFishIcons.info,
          );
        }

        store.dispatch(
          updateCategoryAndProducts(
            ecommerceUpdate: (syncChangesToOnlineStore ?? false),
            updateProducts: (syncChangesToOnlineStore2 ?? true),
            category: category,
            deletedItems: category.removedProducts.map((p) => p.id).toList(),
            newItems: category.newProducts.map((p) => p.id).toList(),
            completer:
                snackBarCompleter(
                    context ?? ctx,
                    '${category.displayName} saved successfully!',
                    shouldPop: shouldPop ?? false,
                  )
                  ?..future.then((_) {
                    if (canReset) {
                      store.dispatch(ResetCategoryAction());
                    }
                  }),
          ),
        );
      } else {
        showMessageDialog(
          context ?? ctx,
          'Please make sure to be on the details tab, then click save',
          LittleFishIcons.info,
        );
      }
    };

    onDeleteCategoryItem = (ctx, category) async {
      StoreProductCategory? onlineCategory;
      StockCategory? stateCategory;

      if (store.state.storeState.productCategories != null) {
        try {
          onlineCategory = store.state.storeState.productCategories!
              .where((element) => element.categoryId == category.id)
              .first;
        } catch (e) {
          onlineCategory = null;
        }
      }

      if (store.state.productState.categories != null) {
        try {
          stateCategory = store.state.productState.categories!.firstWhere(
            (element) => element.id == category.id,
          );
        } catch (e) {
          stateCategory = null;
        }
      }

      bool? syncChangesToOnlineStore = false;
      bool? syncChangesToOnlineStore2;
      bool promptUser = false;
      bool promptUser2 = false;
      bool notify = false;

      if (onlineCategory != null &&
          stateCategory != null &&
          !onlineCategory.deleted! &&
          (stateCategory.isOnline ?? false)) {
        if (category.isOnline!) {
          promptUser = true;
        } else {
          if (store.state.storeState.products != null &&
              store.state.storeState.products!
                  .where((p) => p.baseCategoryId == item!.id)
                  .toList()
                  .isNotEmpty) {
            promptUser2 = true;
            syncChangesToOnlineStore = true;
            promptUser = false;
          }
        }
      } else if (category.isOnline!) {
        syncChangesToOnlineStore = true;
        notify = true;
      }

      if (promptUser) {
        syncChangesToOnlineStore = await getIt<ModalService>().showActionModal(
          context: context!,
          title: 'Sync changes?',
          description:
              'Do you want to delete/unpublish the ${category.displayName} category from your Online Store as well?',
        );
      }

      if (promptUser2) {
        syncChangesToOnlineStore2 = await getIt<ModalService>().showActionModal(
          context: ctx,
          title: 'Unpublish Category Products?',
          description:
              'Do you want to unpublish the online products associated with the ${category.displayName} category as well?',
        );

        if ((syncChangesToOnlineStore2 ?? true)) {
          syncChangesToOnlineStore = true;
        }
      }

      if (notify) {
        await showMessageDialog(
          ctx,
          'Please note, all the products associated with this category will also be be published to your Online Store',
          LittleFishIcons.info,
        );
      }

      store.dispatch(
        updateCategoryAndProducts(
          ecommerceUpdate: (syncChangesToOnlineStore ?? false),
          updateProducts: (syncChangesToOnlineStore2 ?? true),
          category: category,
          deletedItems: category.removedProducts.map((p) => p.id).toList(),
          newItems: category.newProducts.map((p) => p.id).toList(),
          completer: null,
        ),
      );
    };
  }

  bool get isStoreOnline => store!.state.storeState.store != null;
}
