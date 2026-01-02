import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_core/logging/services/logger_service.dart';
import 'package:littlefish_core_utils/error/models/error_codes/invoicing_error_codes.dart';
import 'package:littlefish_core_utils/httpErrors/models/api_error.dart';
import 'package:littlefish_merchant/bootstrap.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_core_utils/error/models/error_code.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:redux/redux.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:redux_thunk/redux_thunk.dart';

import '../../../../../models/settings/accounts/linked_account.dart';
import '../../../../../redux/app/app_actions.dart';
import '../../../../../redux/auth/auth_actions.dart';
import '../../../../../redux/business/business_actions.dart';
import '../../../../../redux/checkout/checkout_actions.dart';
import '../../../../../services/business_service.dart';
import '../../../../order_common/data/model/order.dart';
import '../../../datasource/invoicing_data_source.dart';
import '../actions/invoicing_actions.dart';

LoggerService _logger = LittleFishCore.instance.get<LoggerService>();

ThunkAction<AppState> createDraftInvoiceThunk({
  required Order request,
  void Function(Order)? onSuccess,
}) {
  return (Store<AppState> store) async {
    store.dispatch(SetInvoicesLoadingAction(true));

    try {
      final ds = InvoicingDataSource();
      final Order newDraftInvoice = await ds.createDraftInvoice(
        request: request,
      );

      onSuccess?.call(newDraftInvoice);
      store.dispatch(ResetInvoicingStateAction());
      store.dispatch(CheckoutSetCustomerAction(null));
      store.dispatch(ResetInvoicesStateAction());
      store.dispatch(LoadMoreInvoicesAction(offset: 0, limit: 50));
    } on ApiErrorException catch (e) {
      _logger.error('createDraftInvoiceThunk', e.error.userMessage, error: e);
      await _showErrorMessage(e.error.userMessage);
    } catch (e) {
      _logger.error(
        'createDraftInvoiceThunk',
        InvoicingErrorCodes.createDraftInvoiceError.message,
        error: e,
      );
      await _showError(
        'createDraftInvoiceThunk',
        InvoicingErrorCodes.createDraftInvoiceError,
      );
    } finally {
      store.dispatch(SetInvoicesLoadingAction(false));
    }
  };
}

ThunkAction<AppState> updateDraftInvoiceThunk({
  required Order request,
  void Function(Order)? onSuccess,
}) {
  return (Store<AppState> store) async {
    store.dispatch(SetInvoicesLoadingAction(true));

    try {
      final ds = InvoicingDataSource();
      final Order newDraftInvoice = await ds.updateDraftInvoice(
        request: request,
      );

      onSuccess?.call(newDraftInvoice);
      store.dispatch(ResetInvoicesStateAction());
      store.dispatch(LoadMoreInvoicesAction(offset: 0, limit: 50));
    } on ApiErrorException catch (e) {
      _logger.error('updateDraftInvoiceThunk', e.error.userMessage, error: e);
      await _showErrorMessage(e.error.userMessage);
    } catch (e) {
      store.dispatch(SetInvoicesLoadingAction(false));
      _logger.error(
        'updateDraftInvoiceThunk',
        InvoicingErrorCodes.updateDraftInvoiceError.message,
        error: e,
      );
      await _showError(
        'updateDraftInvoiceThunk',
        InvoicingErrorCodes.updateDraftInvoiceError,
      );
    } finally {
      store.dispatch(SetInvoicesLoadingAction(false));
    }
  };
}

ThunkAction<AppState> createInvoiceThunk({
  required Order request,
  void Function(Order)? onSuccess,
}) {
  return (Store<AppState> store) async {
    store.dispatch(SetInvoicesLoadingAction(true));

    try {
      final ds = InvoicingDataSource();
      final Order newInvoice = await ds.createInvoice(request: request);

      onSuccess?.call(newInvoice);
      store.dispatch(ResetInvoicingStateAction());
      store.dispatch(CheckoutSetCustomerAction(null));
      store.dispatch(ResetInvoicesStateAction());
      store.dispatch(LoadMoreInvoicesAction(offset: 0, limit: 50));
    } on ApiErrorException catch (e) {
      _logger.error('createInvoiceThunk', e.error.userMessage, error: e);
      await _showErrorMessage(e.error.userMessage);
    } catch (e) {
      _logger.error(
        'createInvoiceThunk',
        InvoicingErrorCodes.createInvoiceError.message,
        error: e,
      );
      await _showError(
        'createInvoiceThunk',
        InvoicingErrorCodes.createInvoiceError,
      );
    } finally {
      store.dispatch(SetInvoicesLoadingAction(false));
    }
  };
}

ThunkAction<AppState> updateInvoiceThunk({
  required Order request,
  void Function(Order)? onSuccess,
}) {
  return (Store<AppState> store) async {
    store.dispatch(SetInvoicesLoadingAction(true));

    try {
      final ds = InvoicingDataSource();
      final Order newInvoice = await ds.updateInvoice(request: request);

      onSuccess?.call(newInvoice);
      store.dispatch(ResetInvoicingStateAction());
      store.dispatch(CheckoutSetCustomerAction(null));
      store.dispatch(ResetInvoicesStateAction());
      store.dispatch(LoadMoreInvoicesAction(offset: 0, limit: 50));
    } on ApiErrorException catch (e) {
      _logger.error('updateInvoiceThunk', e.error.userMessage, error: e);
      await _showErrorMessage(e.error.userMessage);
    } catch (e) {
      _logger.error(
        'updateInvoiceThunk',
        InvoicingErrorCodes.updateInvoiceError.message,
        error: e,
      );
      await _showError(
        'updateInvoiceThunk',
        InvoicingErrorCodes.updateInvoiceError,
      );
    } finally {
      store.dispatch(SetInvoicesLoadingAction(false));
    }
  };
}

ThunkAction<AppState> sendInvoiceViaSmsThunk({
  required String businessId,
  required String orderId,
  void Function()? onSuccess,
  void Function(Exception)? onError,
  Completer<void>? completer,
}) {
  return (Store<AppState> store) async {
    store.dispatch(SetInvoicesLoadingAction(true));
    try {
      final ds = InvoicingDataSource();
      await ds.sendInvoiceViaSms(businessId: businessId, invoiceId: orderId);

      onSuccess?.call();
      completer?.complete();
    } on ApiErrorException catch (e) {
      onError?.call(e);
      completer?.completeError(e);
      _logger.error('sendInvoiceViaSmsThunk', e.error.userMessage, error: e);
      await _showErrorMessage(e.error.userMessage);
    } catch (e) {
      if (onError != null && e is Exception) onError(e);
      if (completer != null) completer.completeError(e);
      _logger.error(
        'sendInvoiceViaSmsThunk',
        InvoicingErrorCodes.sendInvoiceViaSmsThunk.message,
        error: e,
      );
      await _showError(
        'sendInvoiceViaSmsThunk',
        InvoicingErrorCodes.sendInvoiceViaSmsThunk,
      );
    } finally {
      store.dispatch(SetInvoicesLoadingAction(false));
    }
  };
}

ThunkAction<AppState> sendInvoiceViaEmailThunk({
  required String businessId,
  required String orderId,
  void Function()? onSuccess,
  void Function(Exception)? onError,
  Completer<void>? completer,
}) {
  return (Store<AppState> store) async {
    store.dispatch(SetInvoicesLoadingAction(true));
    try {
      final ds = InvoicingDataSource();
      await ds.sendInvoiceViaEmail(businessId: businessId, invoiceId: orderId);

      onSuccess?.call();
      completer?.complete();
    } on ApiErrorException catch (e) {
      onError?.call(e);
      completer?.completeError(e);
      _logger.error('sendInvoiceViaEmailThunk', e.error.userMessage, error: e);
      await _showErrorMessage(e.error.userMessage);
    } catch (e) {
      if (onError != null && e is Exception) onError(e);
      if (completer != null) {
        completer.completeError(e is Exception ? e : Exception(e.toString()));
      }
      _logger.error(
        'sendInvoiceViaEmailThunk',
        InvoicingErrorCodes.sendInvoiceViaEmailThunk.message,
        error: e,
      );
      await _showError(
        'sendInvoiceViaEmailThunk',
        InvoicingErrorCodes.sendInvoiceViaEmailThunk,
      );
    } finally {
      store.dispatch(SetInvoicesLoadingAction(false));
    }
  };
}

ThunkAction<AppState> markInvoiceAsSentThunk({
  required String businessId,
  required String orderId,
  void Function(Exception)? onError,
  Completer<void>? completer,
}) {
  return (Store<AppState> store) async {
    try {
      final ds = InvoicingDataSource();

      await ds.markInvoiceAsSent(businessId: businessId, invoiceId: orderId);

      completer?.complete();
    } on ApiErrorException catch (e) {
      onError?.call(e);
      completer?.completeError(e);
      _logger.error('markInvoiceAsSentThunk', e.error.userMessage, error: e);
      await _showErrorMessage(e.error.userMessage);
    } catch (e) {
      if (onError != null && e is Exception) onError(e);
      if (completer != null) {
        completer.completeError(e is Exception ? e : Exception(e.toString()));
      }
      _logger.error(
        'markInvoiceAsSentThunk',
        InvoicingErrorCodes.markInvoiceAsSentError.message,
        error: e,
      );
      await _showError(
        'markInvoiceAsSentThunk',
        InvoicingErrorCodes.markInvoiceAsSentError,
      );
    }
  };
}

ThunkAction<AppState> markInvoiceAsDiscardedThunk({
  required Order request,
  void Function(Exception)? onError,
  Completer<void>? completer,
}) {
  return (Store<AppState> store) async {
    try {
      final ds = InvoicingDataSource();

      await ds.markInvoiceAsDiscarded(request: request);

      completer?.complete();
    } on ApiErrorException catch (e) {
      onError?.call(e);
      completer?.completeError(e);
      _logger.error(
        'markInvoiceAsDiscardedThunk',
        e.error.userMessage,
        error: e,
      );
      await _showErrorMessage(e.error.userMessage);
    } catch (e) {
      if (onError != null && e is Exception) onError(e);
      if (completer != null) {
        completer.completeError(e is Exception ? e : Exception(e.toString()));
      }
      _logger.error(
        'markInvoiceAsDiscardedThunk',
        InvoicingErrorCodes.markInvoiceAsDiscardedError.message,
        error: e,
      );
      await _showError(
        'markInvoiceAsDiscardedThunk',
        InvoicingErrorCodes.markInvoiceAsDiscardedError,
      );
    }
  };
}

ThunkAction<AppState> downloadInvoicePdfThunk({
  required String orderId,
  required String businessId,
  required void Function(File file) onSuccess,
  void Function(Exception)? onError,
}) {
  return (Store<AppState> store) async {
    store.dispatch(SetInvoicesLoadingAction(true));

    try {
      final ds = InvoicingDataSource();
      final file = await ds.downloadInvoicePdf(
        orderId: orderId,
        businessId: businessId,
      );
      onSuccess(file);
    } on ApiErrorException catch (e) {
      onError?.call(e);
      _logger.error('downloadInvoicePdfThunk', e.error.userMessage, error: e);
      await _showErrorMessage(e.error.userMessage);
    } catch (e) {
      onError?.call(Exception(e.toString()));
      _logger.error(
        'downloadInvoicePdfThunk',
        InvoicingErrorCodes.downloadInvoicePdfError.message,
        error: e,
      );
      await _showError(
        'downloadInvoicePdfThunk',
        InvoicingErrorCodes.downloadInvoicePdfError,
      );
    } finally {
      store.dispatch(SetInvoicesLoadingAction(false));
    }
  };
}

ThunkAction<AppState> resetAndLoadInvoicesThunk() {
  return (Store<AppState> store) async {
    final businessId = store.state.businessState.businessId;
    if (businessId == null) return;

    final ds = InvoicingDataSource();

    store.dispatch(ResetInvoicesStateAction());

    try {
      final result = await ds.fetchInvoicesPaginated(
        businessId: businessId,
        offset: 0,
        limit: 10,
      );

      store.dispatch(
        LoadInvoicesSuccessAction(
          result.items,
          result.items.length,
          result.totalRecords,
        ),
      );
    } on ApiErrorException catch (e) {
      store.dispatch(SetInvoicesLoadingAction(false));
      _logger.error('resetAndLoadInvoicesThunk', e.error.userMessage, error: e);
      await _showErrorMessage(e.error.userMessage);
    } catch (e) {
      store.dispatch(SetInvoicesLoadingAction(false));
      _logger.error(
        'resetAndLoadInvoicesThunk',
        InvoicingErrorCodes.resetAndLoadInvoicesError.message,
        error: e,
      );
      await _showError(
        'resetAndLoadInvoicesThunk',
        InvoicingErrorCodes.resetAndLoadInvoicesError,
      );
    }
  };
}

ThunkAction<AppState> requestPaymentLinksActivation({
  required LinkedAccount linkedAccount,
  void Function()? onSuccess,
  void Function(Exception)? onError,
  Completer<void>? completer,
}) {
  return (Store<AppState> store) async {
    store.dispatch(SetInvoicesLoadingAction(true));
    try {
      businessProfileService = BusinessService(
        store: store,
        baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
        token: store.state.authState.token,
        businessId: store.state.currentBusinessId,
      );

      final businessId = store.state.currentBusinessId;
      final ds = InvoicingDataSource();

      await ds.requestPaymentLinksActivation(
        businessId: businessId,
        linkedAccount: linkedAccount,
      );

      final result = await businessProfileService.getBusinessProfile();
      store.dispatch(BusinessProfileLoadedAction(result));
      store.dispatch(RebuildAccessManagerAction());

      onSuccess?.call();
      completer?.complete();
    } on ApiErrorException catch (e) {
      onError?.call(e);
      completer?.completeError(e);
      _logger.error(
        'requestPaymentLinksActivation',
        e.error.userMessage,
        error: e,
      );
      await _showErrorMessage(e.error.userMessage);
    } catch (e) {
      if (onError != null && e is Exception) onError(e);
      completer?.completeError(e is Exception ? e : Exception(e.toString()));
      _logger.error(
        'requestPaymentLinksActivation',
        InvoicingErrorCodes.requestPaymentLinksActivationError.message,
        error: e,
      );
      await _showError(
        'requestPaymentLinksActivation',
        InvoicingErrorCodes.requestPaymentLinksActivationError,
      );
    } finally {
      store.dispatch(SetInvoicesLoadingAction(false));
    }
  };
}

Future<void> _showError(String callingMethod, ErrorCode errorCode) async {
  await showMessageDialog(
    globalNavigatorKey.currentContext!,
    '${errorCode.code}\n${errorCode.message}',
    LittleFishIcons.error,
    status: StatusType.destructive,
  );
}

// helper that shows backend message directly
Future<void> _showErrorMessage(String message) async {
  await showMessageDialog(
    globalNavigatorKey.currentContext!,
    message,
    LittleFishIcons.error,
    status: StatusType.destructive,
  );
}
