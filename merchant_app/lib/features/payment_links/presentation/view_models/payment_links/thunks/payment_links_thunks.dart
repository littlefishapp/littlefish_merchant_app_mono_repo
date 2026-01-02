import 'dart:async';

import 'package:flutter/material.dart';
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_core/logging/services/logger_service.dart';
import 'package:littlefish_core_utils/error/models/error_codes/payment_links_error_codes.dart';
import 'package:littlefish_core_utils/httpErrors/models/api_error.dart';
import 'package:littlefish_merchant/bootstrap.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_core_utils/error/models/error_code.dart';
import 'package:littlefish_merchant/features/payment_links/data/datasource/payment_links_data_source.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:redux/redux.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:redux_thunk/redux_thunk.dart';

import '../../../../../../models/settings/accounts/linked_account.dart';
import '../../../../../../redux/app/app_actions.dart';
import '../../../../../../redux/auth/auth_actions.dart';
import '../../../../../../redux/business/business_actions.dart';
import '../../../../../../services/business_service.dart';
import '../../../../../order_common/data/model/order.dart';
import '../actions/payment_links_actions.dart';

LoggerService _logger = LittleFishCore.instance.get<LoggerService>();

ThunkAction<AppState> markPaymentLinkAsSentThunk({
  required String businessId,
  required String linkId,
  void Function(Exception)? onError,
  Completer<void>? completer,
}) {
  return (Store<AppState> store) async {
    try {
      final ds = PaymentLinksDataSource();
      await ds.markPaymentLinkAsSent(businessId: businessId, linkId: linkId);
      completer?.complete();
    } on ApiErrorException catch (e) {
      // structured backend message
      onError?.call(e);
      completer?.completeError(e);
      _logger.error(
        'markPaymentLinkAsSentThunk',
        e.error.detail ??
            PaymentLinksErrorCodes.markPaymentLinkAsSentError.message,
        error: e,
      );
      await showMessageDialog(
        globalNavigatorKey.currentContext!,
        e.error.userMessage,
        LittleFishIcons.error,
        status: StatusType.destructive,
      );
      store.dispatch(SetPaymentLinksLoadingAction(false));
    } catch (e) {
      if (onError != null && e is Exception) onError(e);
      if (completer != null) {
        completer.completeError(e is Exception ? e : Exception(e.toString()));
      }
      _logger.error(
        'markPaymentLinkAsSentThunk',
        PaymentLinksErrorCodes.markPaymentLinkAsSentError.message,
        error: e,
      );
      await _showError(
        'markPaymentLinkAsSentThunk',
        PaymentLinksErrorCodes.markPaymentLinkAsSentError,
      );
      store.dispatch(SetPaymentLinksLoadingAction(false));
    }
  };
}

ThunkAction<AppState> markPaymentLinkAsDisabledThunk({
  required String businessId,
  required String linkId,
  void Function(Exception)? onError,
  Completer<void>? completer,
}) {
  return (Store<AppState> store) async {
    try {
      final ds = PaymentLinksDataSource();
      await ds.markPaymentLinkAsDisabled(
        businessId: businessId,
        linkId: linkId,
      );
      completer?.complete();
    } on ApiErrorException catch (e) {
      onError?.call(e);
      completer?.completeError(e);
      _logger.error(
        'markPaymentLinkAsDisabledThunk',
        e.error.detail ??
            PaymentLinksErrorCodes.markPaymentLinkAsDisabledError.message,
        error: e,
      );
      await showMessageDialog(
        globalNavigatorKey.currentContext!,
        e.error.userMessage,
        LittleFishIcons.error,
        status: StatusType.destructive,
      );
      store.dispatch(SetPaymentLinksLoadingAction(false));
    } catch (e) {
      if (onError != null && e is Exception) onError(e);
      if (completer != null) {
        completer.completeError(e is Exception ? e : Exception(e.toString()));
      }
      _logger.error(
        'markPaymentLinkAsDisabledThunk',
        PaymentLinksErrorCodes.markPaymentLinkAsDisabledError.message,
        error: e,
      );
      await _showError(
        'markPaymentLinkAsDisabledThunk',
        PaymentLinksErrorCodes.markPaymentLinkAsDisabledError,
      );
      store.dispatch(SetPaymentLinksLoadingAction(false));
    }
  };
}

ThunkAction<AppState> createPaymentLinkThunk({
  required Order request,
  void Function(Order)? onSuccess,
}) {
  return (Store<AppState> store) async {
    store.dispatch(SetPaymentLinksLoadingAction(true));
    try {
      final ds = PaymentLinksDataSource();
      final Order newLink = await ds.createPaymentLink(request: request);

      onSuccess?.call(newLink);
      store.dispatch(ResetPaymentLinksStateAction());
      store.dispatch(LoadMorePaymentLinksAction(offset: 0, limit: 50));
      store.dispatch(SetPaymentLinksLoadingAction(false));
    } on ApiErrorException catch (e) {
      store.dispatch(SetPaymentLinksLoadingAction(false));
      _logger.error(
        'createPaymentLinkThunk',
        e.error.detail ?? PaymentLinksErrorCodes.createPaymentLinkError.message,
        error: e,
      );
      await showMessageDialog(
        globalNavigatorKey.currentContext!,
        e.error.userMessage,
        LittleFishIcons.error,
        status: StatusType.destructive,
      );
    } catch (e) {
      store.dispatch(SetPaymentLinksLoadingAction(false));
      _logger.error(
        'createPaymentLinkThunk',
        PaymentLinksErrorCodes.createPaymentLinkError.message,
        error: e,
      );
      await _showError(
        'createPaymentLinkThunk',
        PaymentLinksErrorCodes.createPaymentLinkError,
      );
    }
  };
}

ThunkAction<AppState> sendPaymentLinkViaSmsThunk({
  required String businessId,
  required String linkId,
  void Function()? onSuccess,
  void Function(Exception)? onError,
  Completer<void>? completer,
}) {
  return (Store<AppState> store) async {
    store.dispatch(SetPaymentLinksLoadingAction(true));
    try {
      final ds = PaymentLinksDataSource();
      await ds.sendPaymentLinkViaSms(businessId: businessId, linkId: linkId);

      onSuccess?.call();
      completer?.complete();
      store.dispatch(SetPaymentLinksLoadingAction(false));
    } on ApiErrorException catch (e) {
      onError?.call(e);
      completer?.completeError(e);
      store.dispatch(SetPaymentLinksLoadingAction(false));
      _logger.error(
        'sendPaymentLinkViaSmsThunk',
        e.error.detail ??
            PaymentLinksErrorCodes.sendPaymentLinkViaSmsError.message,
        error: e,
      );
      await showMessageDialog(
        globalNavigatorKey.currentContext!,
        e.error.userMessage,
        LittleFishIcons.error,
        status: StatusType.destructive,
      );
    } catch (e) {
      if (onError != null && e is Exception) onError(e);
      if (completer != null) completer.completeError(e);
      store.dispatch(SetPaymentLinksLoadingAction(false));
      _logger.error(
        'sendPaymentLinkViaSmsThunk',
        PaymentLinksErrorCodes.sendPaymentLinkViaSmsError.message,
        error: e,
      );
      await _showError(
        'sendPaymentLinkViaSmsThunk',
        PaymentLinksErrorCodes.sendPaymentLinkViaSmsError,
      );
    }
  };
}

ThunkAction<AppState> sendPaymentLinkViaEmailThunk({
  required String businessId,
  required String linkId,
  void Function()? onSuccess,
  void Function(Exception)? onError,
  Completer<void>? completer,
}) {
  return (Store<AppState> store) async {
    store.dispatch(SetPaymentLinksLoadingAction(true));
    try {
      final ds = PaymentLinksDataSource();
      await ds.sendPaymentLinkViaEmail(businessId: businessId, linkId: linkId);

      onSuccess?.call();
      completer?.complete();
      store.dispatch(SetPaymentLinksLoadingAction(false));
    } on ApiErrorException catch (e) {
      onError?.call(e);
      completer?.completeError(e);
      store.dispatch(SetPaymentLinksLoadingAction(false));
      _logger.error(
        'sendPaymentLinkViaEmailThunk',
        e.error.detail ??
            PaymentLinksErrorCodes.sendPaymentLinkViaEmailError.message,
        error: e,
      );
      await showMessageDialog(
        globalNavigatorKey.currentContext!,
        e.error.userMessage,
        LittleFishIcons.error,
        status: StatusType.destructive,
      );
    } catch (e) {
      if (onError != null && e is Exception) onError(e);
      if (completer != null) {
        completer.completeError(e is Exception ? e : Exception(e.toString()));
      }
      store.dispatch(SetPaymentLinksLoadingAction(false));
      _logger.error(
        'sendPaymentLinkViaEmailThunk',
        PaymentLinksErrorCodes.sendPaymentLinkViaEmailError.message,
        error: e,
      );
      await _showError(
        'sendPaymentLinkViaEmailThunk',
        PaymentLinksErrorCodes.sendPaymentLinkViaEmailError,
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
    store.dispatch(SetPaymentLinksLoadingAction(true));
    try {
      businessProfileService = BusinessService(
        store: store,
        baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
        token: store.state.authState.token,
        businessId: store.state.currentBusinessId,
      );

      final businessId = store.state.currentBusinessId;
      final ds = PaymentLinksDataSource();

      await ds.requestPaymentLinksActivation(
        businessId: businessId,
        linkedAccount: linkedAccount,
      );

      final result = await businessProfileService.getBusinessProfile();
      store.dispatch(BusinessProfileLoadedAction(result));
      store.dispatch(RebuildAccessManagerAction());

      store.dispatch(SetPaymentLinksLoadingAction(false));
      onSuccess?.call();
      completer?.complete();
    } on ApiErrorException catch (e) {
      if (onError != null) onError(e);
      completer?.completeError(e);
      // NOTE: original comment said "did not clear loading here" — but we did set loading to true at the top,
      // so we should clear it here to avoid spinner stuck
      store.dispatch(SetPaymentLinksLoadingAction(false));
      _logger.error(
        'requestPaymentLinksActivation',
        e.error.detail ??
            PaymentLinksErrorCodes.requestPaymentLinksActivationError.message,
        error: e,
      );
      await showMessageDialog(
        globalNavigatorKey.currentContext!,
        e.error.userMessage,
        LittleFishIcons.error,
        status: StatusType.destructive,
      );
    } catch (e) {
      if (onError != null && e is Exception) onError(e);
      completer?.completeError(e is Exception ? e : Exception(e.toString()));
      // (Original file did not clear loading here; leaving as-is per your preference.)
      store.dispatch(SetPaymentLinksLoadingAction(false));
      _logger.error(
        'requestPaymentLinksActivation',
        PaymentLinksErrorCodes.requestPaymentLinksActivationError.message,
        error: e,
      );
      await _showError(
        'requestPaymentLinksActivation',
        PaymentLinksErrorCodes.requestPaymentLinksActivationError,
      );
    }
  };
}

ThunkAction<AppState> resetAndLoadPaymentLinksThunk() {
  return (Store<AppState> store) async {
    final businessId = store.state.businessState.businessId;
    if (businessId == null) return;

    final ds = PaymentLinksDataSource();

    store.dispatch(ResetPaymentLinksStateAction());

    try {
      final result = await ds.fetchPaymentLinksPaginated(
        businessId: businessId,
        offset: 0,
        limit: 10,
      );

      store.dispatch(
        LoadPaymentLinksSuccessAction(
          result.items,
          result.items.length,
          result.totalRecords,
        ),
      );
    } on ApiErrorException catch (e) {
      store.dispatch(SetPaymentLinksLoadingAction(false));
      _logger.error(
        'resetAndLoadPaymentLinksThunk',
        e.error.detail ??
            PaymentLinksErrorCodes.resetAndLoadPaymentLinksError.message,
        error: e,
      );
      await showMessageDialog(
        globalNavigatorKey.currentContext!,
        e.error.userMessage,
        LittleFishIcons.error,
        status: StatusType.destructive,
      );
    } catch (e) {
      store.dispatch(SetPaymentLinksLoadingAction(false));
      _logger.error(
        'resetAndLoadPaymentLinksThunk',
        PaymentLinksErrorCodes.resetAndLoadPaymentLinksError.message,
        error: e,
      );
      await _showError(
        'resetAndLoadPaymentLinksThunk',
        PaymentLinksErrorCodes.resetAndLoadPaymentLinksError,
      );
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
