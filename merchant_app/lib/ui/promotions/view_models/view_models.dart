// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/promotions/promotion.dart';
import 'package:littlefish_merchant/models/shared/form_view_model.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/product/product_state.dart';
import 'package:littlefish_merchant/redux/promotions/promotions_actions.dart';
import 'package:littlefish_merchant/redux/promotions/promotions_state.dart';
import 'package:littlefish_merchant/common/presentaion/components/completers.dart';
import 'package:littlefish_merchant/common/view_models/store_collection_viewmodel.dart';

class PromotionListViewModel
    extends StoreCollectionViewModel<Promotion, PromotionsState> {
  PromotionListViewModel.fromStore(Store<AppState> store)
    : super.fromStore(store);

  @override
  loadFromStore(Store<AppState> store, {BuildContext? context}) {
    this.store = store;
    state = store.state.promotionsState;
    isLoading = state!.isLoading;
    hasError = state!.hasError;
    items = state!.items;

    onAdd = (item, ctx) => store.dispatch(
      updateOrCreatePromotion(
        item: item,
        completer: snackBarCompleter(
          ctx,
          '${item.displayName} updated successfully!',
          shouldPop: true,
        ),
      ),
    );

    onRemove = (item, ctx) => store.dispatch(
      removePromotion(
        item: item,
        completer: snackBarCompleter(
          ctx,
          '${item.displayName} removed successfully!',
          shouldPop: true,
        ),
      ),
    );

    onRefresh = () => store.dispatch(getPromotions(refresh: true));
  }
}

class PromotionViewModel
    extends StoreItemViewModel<Promotion?, PromotionsState> {
  PromotionViewModel.fromStore(
    Store<AppState> store,
    Promotion? value,
    this.form, {
    BuildContext? context,
    this.onRemovedAction,
  }) : super.fromStore(store, context: context) {
    if (value != null) item = value;
  }

  FormManager form;

  ProductState? productState;

  Function? onRemovedAction;

  @override
  loadFromStore(Store<AppState> store, {BuildContext? context}) {
    state = store.state.promotionsState;
    productState = store.state.productState;
    isLoading = state!.isLoading;
    hasError = state!.hasError;

    onAdd = (item, ctx) => store.dispatch(
      updateOrCreatePromotion(
        item: item,
        completer: snackBarCompleter(
          ctx!,
          '${item!.displayName} updated successfully!',
          shouldPop: !EnvironmentProvider.instance.isLargeDisplay!,
        ),
      ),
    );

    onRemove = (item, ctx) => store.dispatch(
      removePromotion(
        item: item,
        completer: snackBarCompleter(
          ctx,
          '${item!.displayName} removed successfully!',
          shouldPop: !EnvironmentProvider.instance.isLargeDisplay!,
          completerAction: onRemovedAction,
        ),
      ),
    );
  }
}
