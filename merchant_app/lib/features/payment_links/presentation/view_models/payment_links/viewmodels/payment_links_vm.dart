import 'dart:async';

import 'package:flutter/material.dart';
import 'package:littlefish_merchant/redux/business/business_actions.dart';
import 'package:redux/redux.dart';

import '../../../../../../common/view_models/store_collection_viewmodel.dart';
import '../../../../../../models/settings/accounts/linked_account.dart';
import '../../../../../../redux/app/app_state.dart';
import '../../../../../order_common/data/model/order.dart';
import '../actions/payment_links_actions.dart';
import '../state/payment_link_state.dart';
import '../thunks/payment_links_thunks.dart';

class PaymentLinksViewModel
    extends StoreCollectionViewModel<Order, PaymentLinksState> {
  PaymentLinksViewModel.fromStore(
    Store<AppState> store, {
    BuildContext? context,
  }) : super.fromStore(store, context: context);

  late final bool hasMore;
  late final int offset;
  late final int limit;
  int get totalRecords => state?.totalRecords ?? 0;

  late final void Function(
    String linkId,
    String businessId, {
    Completer<void>? completer,
    void Function(Exception)? onError,
  })
  onMarkAsSent;
  late final void Function(
    String linkId,
    String businessId, {
    Completer<void>? completer,
    void Function(Exception)? onError,
  })
  onMarkAsDisabled;
  late final void Function(Order request, void Function(Order)? onSuccess)
  onCreatePaymentLink;
  late final void Function(
    String linkId,
    String businessId, {
    Completer<void>? completer,
    void Function(Exception)? onError,
  })
  onSendLinkViaSms;

  late final void Function(
    String linkId,
    String businessId, {
    Completer<void>? completer,
    void Function(Exception)? onError,
  })
  onSendLinkViaEmail;

  late final void Function(
    LinkedAccount linkedAccount, {
    Completer<void>? completer,
    void Function(Exception)? onError,
  })
  requestActivation;

  @override
  void loadFromStore(Store<AppState> store, {BuildContext? context}) {
    this.store = store;
    state = store.state.paymentLinksState;
    hasMore = state?.hasMore ?? false;
    items = state?.links.toList() ?? [];
    isLoading = state?.isLoading ?? false;
    hasError = state?.hasError ?? false;
    offset = store.state.paymentLinksState.offset;
    limit = store.state.paymentLinksState.limit;

    onRefresh = () {
      store.dispatch(ResetPaymentLinksStateAction());
      store.dispatch(loadBusinessProfile(refresh: true));
      store.dispatch(SetPaymentLinksLoadingAction(true));
      store.dispatch(LoadMorePaymentLinksAction(offset: 0, limit: 50));
    };

    onMarkAsSent = (linkId, businessId, {completer, onError}) {
      store.dispatch(
        markPaymentLinkAsSentThunk(
          businessId: businessId,
          linkId: linkId,
          onError: onError,
          completer: completer,
        ),
      );
    };

    onMarkAsDisabled = (linkId, businessId, {completer, onError}) {
      store.dispatch(
        markPaymentLinkAsDisabledThunk(
          businessId: businessId,
          linkId: linkId,
          onError: onError,
          completer: completer,
        ),
      );
    };

    onCreatePaymentLink = (request, onSuccess) {
      store.dispatch(
        createPaymentLinkThunk(request: request, onSuccess: onSuccess),
      );
    };

    onSendLinkViaSms = (linkId, businessId, {completer, onError}) {
      store.dispatch(
        sendPaymentLinkViaSmsThunk(
          businessId: businessId,
          linkId: linkId,
          onSuccess: completer?.complete,
          onError: onError,
          completer: completer,
        ),
      );
    };

    onSendLinkViaEmail = (linkId, businessId, {completer, onError}) {
      store.dispatch(
        sendPaymentLinkViaEmailThunk(
          businessId: businessId,
          linkId: linkId,
          onSuccess: completer?.complete,
          onError: onError,
          completer: completer,
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

    final nextOffset = store?.state.paymentLinksState.offset ?? 0;
    final limit = store?.state.paymentLinksState.limit ?? 10;

    store?.dispatch(
      LoadMorePaymentLinksAction(offset: nextOffset, limit: limit),
    );
  }

  List<Order> filteredByStatus(PaymentLinkStatus? status) {
    if (status == null) {
      return (items ?? [])
          .where((link) => link.type != OrderType.invoice)
          .toList();
    }

    return (items ?? []).where((link) {
      if (link.type == OrderType.invoice) return false;

      if (status == PaymentLinkStatus.paid) {
        return link.financialStatus == FinancialStatus.paid;
      }

      if (status == PaymentLinkStatus.sent) {
        return link.paymentLinkStatus == PaymentLinkStatus.sent &&
            link.financialStatus != FinancialStatus.paid;
      }

      return link.paymentLinkStatus == status;
    }).toList();
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
