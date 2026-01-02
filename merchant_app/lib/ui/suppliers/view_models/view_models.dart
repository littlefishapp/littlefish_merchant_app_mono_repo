// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/suppliers/supplier.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/suppliers/supplier_state.dart';
import 'package:littlefish_merchant/common/presentaion/components/completers.dart';
import 'package:littlefish_merchant/common/view_models/store_collection_viewmodel.dart';

import 'package:littlefish_merchant/redux/suppliers/supplier_actions.dart'
    as service;

import '../../../features/ecommerce_shared/models/store/store.dart' as e_store;

class SuppliersVM extends StoreCollectionViewModel<Supplier?, SupplierState> {
  SuppliersVM.fromStore(Store<AppState> store) : super.fromStore(store);

  @override
  loadFromStore(Store<AppState> store, {BuildContext? context}) {
    state = store.state.supplierState;
    items = state!.suppliers;

    onRefresh = () => store.dispatch(service.getSuppliers(refresh: true));
    onRemove = (item, ctx) => store.dispatch(service.removeSupplier(item));

    onAdd = (item, ctx) => store.dispatch(service.updateOrSaveSupplier(item));

    onSetSelected = (item) => store.dispatch(service.setUISupplier(item));

    selectedItem = store.state.supplierUIState!.item?.item;
    isNew = store.state.supplierUIState!.item?.isNew;

    isLoading = state!.isLoading ?? false;
    hasError = state!.hasError ?? false;
  }
}

class SupplierVM extends StoreItemViewModel<Supplier?, SupplierState> {
  SupplierVM.fromStore(Store<AppState> store) : super.fromStore(store) {
    if (item != null) item = item;
  }

  Function? saveAddress;

  @override
  loadFromStore(Store<AppState> store, {BuildContext? context}) {
    state = store.state.supplierState;

    onRemove = (item, ctx) {
      store.dispatch(
        service.removeSupplier(
          item,
          completer: snackBarCompleter(
            ctx!,
            '${item!.displayName} was removed',
            shouldPop: !(store.state.isLargeDisplay ?? true),
          ),
        ),
      );
    };

    onAdd = (item, ctx) {
      if (key != null) {
        if (key!.currentState!.validate()) {
          key!.currentState!.save();
          store.dispatch(
            service.updateOrSaveSupplier(
              item,
              completer: snackBarCompleter(
                ctx!,
                '${item!.displayName} saved successfully!',
                shouldPop: true,
              ),
            ),
          );
        }
      } else {
        store.dispatch(
          service.updateOrSaveSupplier(
            item,
            completer: snackBarCompleter(
              ctx!,
              '${item!.displayName} saved successfully!',
              shouldPop: true,
            ),
          ),
        );
      }
    };
    isLoading = state!.isLoading ?? false;
    hasError = state!.hasError ?? false;

    item = store.state.supplierUIState!.item?.item;
    isNew = store.state.supplierUIState!.item?.isNew;

    saveAddress =
        (e_store.StoreAddress addr, formKey, context, String addressId) {
          item!.address = addr;
        };
  }
}
