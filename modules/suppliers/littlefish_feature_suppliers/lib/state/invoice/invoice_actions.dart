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
import 'package:littlefish_merchant/models/suppliers/supplier_invoice.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/services/supplier_service.dart';
import 'package:littlefish_merchant/ui/invoicing/invoice_page.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/app/custom_route.dart';

late InvoiceService service;

ThunkAction<AppState> getInvoices({
  bool refresh = false,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);
      var state = store.state.invoiceState;

      store.dispatch(InvoiceSetLoadingAction(true));

      if (!refresh && (state.invoices?.length ?? 0) > 0) {
        store.dispatch(InvoiceSetLoadingAction(false));
        return;
      }

      await service
          .getInvoices()
          .catchError((e) {
            store.dispatch(InvoicesLoadFailure(e.toString()));
            store.dispatch(InvoiceSetLoadingAction(false));

            completer?.complete();
            return <SupplierInvoice>[];
          })
          .then((result) {
            store.dispatch(InvoicesLoadedAction(result));
            store.dispatch(InvoiceSetLoadingAction(false));

            completer?.complete();
          });
    });
  };
}

ThunkAction<AppState> createInvoice(BuildContext ctx) {
  return (Store<AppState> store) async {
    Future(() async {
      store.dispatch(InvoiceSetLoadingAction(true));

      store.dispatch(InvoiceCreateAction());

      store.dispatch(InvoiceSetLoadingAction(false));

      if (store.state.isLargeDisplay ?? false) {
        showPopupDialog(
          context: ctx,
          content: const InvoicePage(embedded: true),
        );
      } else {
        Navigator.of(ctx).push(
          CustomRoute(
            maintainState: true,
            builder: (BuildContext context) => const InvoicePage(),
          ),
        );
      }
    });
  };
}

ThunkAction<AppState> editInvoice(BuildContext ctx, SupplierInvoice item) {
  return (Store<AppState> store) async {
    Future(() async {
      store.dispatch(InvoiceSetLoadingAction(true));

      store.dispatch(setUIInvoice(item));

      store.dispatch(InvoiceSetLoadingAction(false));

      if (store.state.isLargeDisplay ?? false) {
        // showDialog(
        //   context: ctx,
        //   builder: (ctx) => ProductModifierPage(),
        // );
      } else {
        Navigator.of(ctx).push(
          CustomRoute(
            maintainState: true,
            builder: (BuildContext context) => const InvoicePage(),
          ),
        );
      }
    });
  };
}

ThunkAction<AppState> updateOrSaveInvoice(
  SupplierInvoice? invoice, {
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      store.dispatch(InvoiceSetLoadingAction(true));

      await service
          .addOrUpdateInvoice(invoice: invoice!)
          .catchError((e) {
            store.dispatch(InvoicesLoadFailure(e.toString()));
            store.dispatch(InvoiceSetLoadingAction(false));

            //notify the error if there is a completer present
            completer?.completeError(e, StackTrace.current);
            return SupplierInvoice();
          })
          .then((result) {
            store.dispatch(InvoiceChangedAction(result, ChangeType.updated));
            store.dispatch(InvoiceSetLoadingAction(false));
            if (completer != null && !completer.isCompleted)
              completer.complete();
          });
    });
  };
}

ThunkAction<AppState> removeInvoice(
  SupplierInvoice? invoice, {
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      store.dispatch(InvoiceSetLoadingAction(true));

      await service
          .removeInvoice(invoice!)
          .catchError((e) {
            store.dispatch(InvoicesLoadFailure(e.toString()));
            store.dispatch(InvoiceSetLoadingAction(false));

            //notify the error if there is a completer present
            completer?.completeError(e, StackTrace.current);
            return false;
          })
          .then((result) {
            if (result) {
              store.dispatch(InvoiceChangedAction(invoice, ChangeType.removed));
              store.dispatch(InvoiceSetLoadingAction(false));
              if (completer != null && !completer.isCompleted)
                completer.complete();
            }
          });
    });
  };
}

ThunkAction<AppState> setUIInvoice(
  SupplierInvoice invoice, {
  bool isNew = false,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      store.dispatch(InvoiceSetLoadingAction(true));
      if (isNew) {
        store.dispatch(InvoiceCreateAction());
      } else {
        store.dispatch(InvoiceSelectAction(invoice));
      }

      store.dispatch(InvoiceSetLoadingAction(false));
    });
  };
}

_initializeService(Store<AppState> store) {
  service = InvoiceService(
    store: store,
    baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
    token: store.state.authState.token,
    businessId: store.state.currentBusinessId,
  );
}

class InvoicesLoadedAction {
  List<SupplierInvoice> value;

  InvoicesLoadedAction(this.value);
}

class InvoiceSetLoadingAction {
  bool value;

  InvoiceSetLoadingAction(this.value);
}

class InvoiceChangedAction {
  SupplierInvoice? item;

  ChangeType type;

  InvoiceChangedAction(this.item, this.type);
}

class InvoicesLoadFailure {
  String value;

  InvoicesLoadFailure(this.value);
}

//UI ACTIONS
class InvoiceSelectAction {
  SupplierInvoice value;

  InvoiceSelectAction(this.value);
}

class InvoiceCreateAction {}
