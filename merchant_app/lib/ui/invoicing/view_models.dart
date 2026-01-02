// Flutter imports:

// Package imports:
import 'package:flutter/material.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/suppliers/supplier_invoice.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/invoice/invoice_state.dart';
import 'package:littlefish_merchant/common/presentaion/components/completers.dart';
import 'package:littlefish_merchant/common/view_models/store_collection_viewmodel.dart';

import 'package:littlefish_merchant/redux/invoice/invoice_actions.dart'
    as service;

class InvoicesVM
    extends StoreCollectionViewModel<SupplierInvoice, InvoiceState> {
  InvoicesVM.fromStore(Store<AppState> store) : super.fromStore(store);

  @override
  loadFromStore(Store<AppState> store, {BuildContext? context}) {
    this.store = store;
    state = store.state.invoiceState;
    items = state!.invoices;

    onRefresh = () => store.dispatch(service.getInvoices(refresh: true));
    onRemove = (item, ctx) => store.dispatch(
      service.removeInvoice(
        item,
        completer: snackBarCompleter(ctx, 'invoice was removed!'),
      ),
    );

    onAdd = (item, ctx) => store.dispatch(service.updateOrSaveInvoice(item));

    onSetSelected = (item) => store.dispatch(service.setUIInvoice(item));

    selectedItem = store.state.invoiceUIState!.item?.item;
    isNew = store.state.supplierUIState!.item?.isNew;

    isLoading = state!.isLoading ?? false;
    hasError = state!.hasError ?? false;
  }
}

class InvoiceVM extends StoreItemViewModel<SupplierInvoice?, InvoiceState> {
  InvoiceVM.fromStore(Store<AppState> store) : super.fromStore(store);

  @override
  loadFromStore(Store<AppState> store, {BuildContext? context}) {
    this.store = store;
    state = store.state.invoiceState;
    isLoading = state!.isLoading ?? false;
    hasError = state!.hasError ?? false;

    item = store.state.invoiceUIState!.item?.item;
    isNew = item!.isNew ?? store.state.invoiceUIState!.item?.isNew;

    onRemove = (item, ctx) => store.dispatch(
      service.removeInvoice(
        item,
        completer: snackBarCompleter(context!, 'invoice was removed'),
      ),
    );

    onAdd = (item, ctx) {
      if (key != null) {
        if (key!.currentState!.validate()) {
          key!.currentState!.save();
          store.dispatch(
            service.updateOrSaveInvoice(
              item,
              completer: snackBarCompleter(
                ctx!,
                'invoice saved successfully!',
                shouldPop: true,
              ),
            ),
          );
        }
      } else {
        store.dispatch(
          service.updateOrSaveInvoice(
            item,
            completer: snackBarCompleter(
              ctx!,
              'invoice saved successfully!',
              shouldPop: true,
            ),
          ),
        );
      }
    };
  }
}
