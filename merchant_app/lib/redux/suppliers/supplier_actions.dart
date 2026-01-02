// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

// Project imports:
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/suppliers/supplier.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/services/supplier_service.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/app/custom_route.dart';
import 'package:littlefish_merchant/ui/suppliers/supplier_page.dart';

late SupplierService service;

ThunkAction<AppState> getSuppliers({
  bool refresh = false,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);
      var state = store.state.supplierState;

      store.dispatch(SetSupplierStateLoadingAction(true));

      if (!refresh && (state.suppliers?.length ?? 0) > 0) {
        //logger.debug(this,'suppliers already loaded, no search');
        store.dispatch(SetSupplierStateLoadingAction(false));
        return;
      }

      await service
          .getSuppliers()
          .catchError((e) {
            store.dispatch(SetSupplierStateFailureAction(e.toString()));
            store.dispatch(SetSupplierStateLoadingAction(false));

            completer?.completeError(e);
            return <Supplier>[];
          })
          .then((result) {
            store.dispatch(SetSuppliersLoadedAction(result));
            store.dispatch(SetSupplierStateLoadingAction(false));

            completer?.complete();
          });
    });
  };
}

ThunkAction<AppState> createSupplier(BuildContext ctx) {
  return (Store<AppState> store) async {
    Future(() async {
      store.dispatch(SetSupplierStateLoadingAction(true));

      store.dispatch(SupplierCreateAction());

      store.dispatch(SetSupplierStateLoadingAction(false));

      if (store.state.isLargeDisplay ?? false) {
        showPopupDialog(context: ctx, content: const SupplierPage());
      } else {
        Navigator.of(ctx).push(
          CustomRoute(
            maintainState: true,
            builder: (BuildContext context) => const SupplierPage(),
          ),
        );
      }
    });
  };
}

ThunkAction<AppState> editSupplier(BuildContext ctx, Supplier item) {
  return (Store<AppState> store) async {
    Future(() async {
      store.dispatch(SetSupplierStateLoadingAction(true));

      store.dispatch(SupplierSelectAction(item));

      store.dispatch(SetSupplierStateLoadingAction(false));

      if (store.state.isLargeDisplay ?? false) {
        // showDialog(
        //   context: ctx,
        //   builder: (ctx) => ProductModifierPage(),
        // );
      } else {
        Navigator.of(ctx).push(
          CustomRoute(
            maintainState: true,
            builder: (BuildContext context) => const SupplierPage(),
          ),
        );
      }
    });
  };
}

ThunkAction<AppState> updateOrSaveSupplier(
  Supplier? supplier, {
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      store.dispatch(SetSupplierStateLoadingAction(true));

      await service
          .addOrUpdateSupplier(supplier: supplier!)
          .catchError((e) {
            store.dispatch(SetSupplierStateFailureAction(e.toString()));
            store.dispatch(SetSupplierStateLoadingAction(false));

            //notify the error if there is a completer present
            completer?.completeError(e, StackTrace.current);
            return Supplier();
          })
          .then((result) {
            store.dispatch(
              SupplierChangedAction(
                result,
                ChangeType.updated,
                completer: completer,
              ),
            );
            store.dispatch(SetSupplierStateLoadingAction(false));
            if (completer != null && !completer.isCompleted)
              completer.complete();
          });
    });
  };
}

ThunkAction<AppState> removeSupplier(
  Supplier? supplier, {
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      store.dispatch(SetSupplierStateLoadingAction(true));

      await service
          .removeSupplier(supplier!)
          .catchError((e) {
            store.dispatch(SetSupplierStateFailureAction(e.toString()));
            store.dispatch(SetSupplierStateLoadingAction(false));

            //notify the error if there is a completer present
            completer?.completeError(e, StackTrace.current);
            return false;
          })
          .then((result) {
            if (result) {
              store.dispatch(
                SupplierChangedAction(
                  supplier,
                  ChangeType.removed,
                  // completer: completer,
                ),
              );
              store.dispatch(SetSupplierStateLoadingAction(false));
              if (completer != null && !completer.isCompleted)
                completer.complete();
            }
          });
    });
  };
}

ThunkAction<AppState> setUISupplier(Supplier? supplier, {bool isNew = false}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      store.dispatch(SetSupplierStateLoadingAction(true));
      if (isNew) {
        store.dispatch(SupplierCreateAction());
      } else {
        store.dispatch(SupplierSelectAction(supplier));
      }
      store.dispatch(SetSupplierStateLoadingAction(false));
    });
  };
}

_initializeService(Store<AppState> store) {
  service = SupplierService(
    store: store,
    baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
    token: store.state.authState.token,
    businessId: store.state.currentBusinessId,
  );
}

class SupplierChangedAction {
  Supplier? value;

  ChangeType type;

  Completer? completer;

  SupplierChangedAction(this.value, this.type, {this.completer});
}

class SetSuppliersLoadedAction {
  List<Supplier?> value;

  SetSuppliersLoadedAction(this.value);
}

class SetSupplierStateFailureAction {
  String value;

  SetSupplierStateFailureAction(this.value);
}

class SetSupplierStateLoadingAction {
  bool value;

  SetSupplierStateLoadingAction(this.value);
}

//UI ACTIONS

class SupplierSelectAction {
  Supplier? value;

  SupplierSelectAction(this.value);
}

class SupplierCreateAction {}
