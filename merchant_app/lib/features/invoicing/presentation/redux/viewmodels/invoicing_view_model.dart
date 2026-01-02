import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/redux/business/business_actions.dart';
import 'package:redux/redux.dart';
import 'package:littlefish_merchant/models/customers/customer.dart';
import '../../../../../common/view_models/store_collection_viewmodel.dart';
import '../../../../../models/sales/checkout/checkout_discount.dart';
import '../../../../../models/settings/accounts/linked_account.dart';
import '../../../../../redux/app/app_state.dart';
import '../../../../../redux/checkout/checkout_actions.dart';
import '../actions/invoicing_actions.dart';
import '../state/invoicing_state.dart';
import '../thunks/invoicing_thunks.dart';

class InvoicingViewModel
    extends StoreCollectionViewModel<Order, InvoicingState> {
  InvoicingViewModel.fromStore(Store<AppState> store, {BuildContext? context})
    : super.fromStore(store, context: context);

  Customer? customer;
  double? totalAmount;
  CheckoutDiscount? discount;
  late final bool hasMore;
  late final int offset;
  late final int limit;
  int get totalRecords => state?.totalRecords ?? 0;

  List<StockProduct>? get selectedProducts => state?.selectedProducts.toList();
  DateTime? get dueDate => state?.dueDate;
  String? get notes => state?.notes;
  Map<String, int> get selectedQuantities =>
      state?.selectedQuantities.asMap() ?? {};

  late final void Function(Order request, void Function(Order)? onSuccess)
  onCreateDraftInvoice;
  late final void Function(Order request, void Function(Order)? onSuccess)
  onUpdateDraftInvoice;
  late final void Function(
    String invoiceId,
    String businessId, {
    Completer<void>? completer,
    void Function(Exception)? onError,
  })
  onMarkAsSent;
  late final void Function(
    Order request, {
    Completer<void>? completer,
    void Function(Exception)? onError,
  })
  onMarkAsDiscarded;
  late final void Function(
    String invoiceId,
    String businessId, {
    Completer<void>? completer,
    void Function(Exception)? onError,
  })
  onSendLinkViaSms;
  late final void Function(
    String invoiceId,
    String businessId, {
    Completer<void>? completer,
    void Function(Exception)? onError,
  })
  onSendLinkViaEmail;
  late final void Function(Order request, void Function(Order)? onSuccess)
  onCreateInvoice;
  late final void Function(Order request, void Function(Order)? onSuccess)
  onUpdateInvoice;
  late Function(Customer? customer) setCustomer;
  late final void Function(
    LinkedAccount linkedAccount, {
    Completer<void>? completer,
    void Function(Exception)? onError,
  })
  requestActivation;

  late final void Function({
    required String orderId,
    required String businessId,
    required void Function(File file) onSuccess,
    void Function(Exception)? onError,
  })
  downloadPdf;

  void Function(Map<String, int>) get setSelectedQuantities =>
      (quantities) => store?.dispatch(SetSelectedQuantitiesAction(quantities));

  void Function(List<StockProduct>) get setSelectedProducts =>
      (products) => store?.dispatch(SetInvoiceSelectedProductsAction(products));

  void Function(DateTime) get setDueDate =>
      (date) => store?.dispatch(SetInvoiceDueDateAction(date));

  void Function(String) get setNotes =>
      (notes) => store?.dispatch(SetInvoiceNotesAction(notes));

  void setDiscount(CheckoutDiscount discount) {
    store?.dispatch(SetInvoiceDiscountAction(discount));
  }

  @override
  void loadFromStore(Store<AppState> store, {BuildContext? context}) {
    this.store = store;
    state = store.state.invoicingState;

    items = state?.invoices.toList() ?? [];
    isLoading = state?.isLoading ?? false;
    hasError = state?.hasError ?? false;
    hasMore = state?.hasMore ?? false;
    customer = store.state.checkoutState.customer;
    setCustomer = (value) => store.dispatch(CheckoutSetCustomerAction(value));
    totalAmount = store.state.invoicingState.totalAmount ?? 0;
    discount = store.state.invoicingState.discount;
    offset = store.state.invoicingState.offset;
    limit = store.state.invoicingState.limit;

    onRefresh = () {
      store.dispatch(ResetInvoicesStateAction());
      store.dispatch(loadBusinessProfile(refresh: true));
      store.dispatch(LoadMoreInvoicesAction(offset: 0, limit: 50));
    };

    onCreateDraftInvoice = (request, onSuccess) {
      store.dispatch(
        createDraftInvoiceThunk(request: request, onSuccess: onSuccess),
      );
    };

    onUpdateDraftInvoice = (request, onSuccess) {
      store.dispatch(
        updateDraftInvoiceThunk(request: request, onSuccess: onSuccess),
      );
    };

    onCreateInvoice = (request, onSuccess) {
      store.dispatch(
        createInvoiceThunk(request: request, onSuccess: onSuccess),
      );
    };

    onUpdateInvoice = (request, onSuccess) {
      store.dispatch(
        updateInvoiceThunk(request: request, onSuccess: onSuccess),
      );
    };

    onMarkAsSent = (invoiceId, businessId, {completer, onError}) {
      store.dispatch(
        markInvoiceAsSentThunk(
          businessId: businessId,
          orderId: invoiceId,
          onError: onError,
          completer: completer,
        ),
      );
    };

    onMarkAsDiscarded = (request, {completer, onError}) {
      store.dispatch(
        markInvoiceAsDiscardedThunk(
          request: request,
          onError: onError,
          completer: completer,
        ),
      );
    };

    onSendLinkViaSms = (invoiceId, businessId, {completer, onError}) {
      store.dispatch(
        sendInvoiceViaSmsThunk(
          businessId: businessId,
          orderId: invoiceId,
          onSuccess: completer?.complete,
          onError: onError,
          completer: completer,
        ),
      );
    };

    onSendLinkViaEmail = (invoiceId, businessId, {completer, onError}) {
      store.dispatch(
        sendInvoiceViaEmailThunk(
          businessId: businessId,
          orderId: invoiceId,
          onSuccess: completer?.complete,
          onError: onError,
          completer: completer,
        ),
      );
    };

    downloadPdf =
        ({
          required String orderId,
          required String businessId,
          required void Function(File file) onSuccess,
          void Function(Exception)? onError,
        }) {
          store.dispatch(
            downloadInvoicePdfThunk(
              orderId: orderId,
              businessId: businessId,
              onSuccess: onSuccess,
              onError: onError,
            ),
          );
        };

    requestActivation = (linkedAccount, {completer, onError}) {
      store.dispatch(
        requestPaymentLinksActivation(
          linkedAccount: linkedAccount,
          onSuccess: completer?.complete,
          onError: onError,
          completer: completer,
        ),
      );
    };
  }

  void loadMore(BuildContext context) {
    if (isLoading! || !(state?.hasMore ?? true)) return;

    final nextOffset = store?.state.invoicingState.offset ?? 0;
    final limit = store?.state.invoicingState.limit ?? 50;

    store?.dispatch(LoadMoreInvoicesAction(offset: nextOffset, limit: limit));
  }

  List<Order> filteredByStatus(OrderStatus? status) {
    if (status == null) return items ?? [];
    return (items ?? []).where((link) => link.orderStatus == status).toList();
  }

  LinkedAccount getDefaultOnlinePaymentsAccount() {
    return LinkedAccount.fromJson({
      'providerType': 2,
      'providerName': 'OnlinePayments',
      'enabled': false,
      'deleted': false,
      'linkedAccountType': 0,
      'hasQRCode': true,
      'isQRCodeEnabled': true,
      'config': '{}',
      'createdBy': '',
      'dateCreated': DateTime.now().toIso8601String(),
    });
  }
}
