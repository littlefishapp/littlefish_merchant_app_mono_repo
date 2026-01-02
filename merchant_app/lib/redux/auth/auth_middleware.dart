import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_core/logging/services/logger_service.dart';
import 'package:littlefish_merchant/models/device/terminal_details.dart';
import 'package:littlefish_merchant/redux/auth/auth_actions.dart';
import 'package:littlefish_merchant/redux/business/business_actions.dart';
import 'package:littlefish_merchant/redux/device/device_actions.dart';
import 'package:littlefish_merchant/tools/helpers/auth_helper.dart';
import 'package:littlefish_payments/gateways/pos_payment_gateway.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';

class TokenRefreshMiddleware extends MiddlewareClass<AppState> {
  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    final logger = LittleFishCore.instance.get<LoggerService>();

    try {
      await AuthHelper.refreshToken(store: store);
    } catch (e) {
      logger.error(
        'TokenRefreshMiddleware',
        'Error refreshing token: $e',
        error: e,
        stackTrace: StackTrace.current,
      );
    }
  }
}

class AuthMiddleware extends MiddlewareClass<AppState> {
  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    final logger = LittleFishCore.instance.get<LoggerService>();

    if (action is SetSelectedBusinessAction ||
        action is InitializeDeviceDetailsAction) {
      store.dispatch(SetAuthLoadingAction(true));
      try {
        String businessId = action is SetSelectedBusinessAction
            ? action.value?.id ?? ''
            : action is InitializeDeviceDetailsAction
            ? action.value ?? ''
            : '';
        _loadDeviceDetails(store, businessId);
        store.dispatch(SetAuthLoadingAction(false));
      } catch (e) {
        store.dispatch(SetAuthLoadingAction(false));
        store.dispatch(GuestLogonFailureAction('Error loading device details'));
        logger.error(
          'AuthMiddleware',
          'Error loading device details: $e',
          error: e,
          stackTrace: StackTrace.current,
        );
      }
    }
  }

  _loadDeviceDetails(Store<AppState> store, String? businessId) async {
    final core = LittleFishCore.instance;

    if (core.isRegistered<POSPaymentGateway>()) {
      final POSPaymentGateway gateway = core.get<POSPaymentGateway>();
      final details = await gateway.getTerminalInfo(businessId ?? '');
      store.dispatch(SetDeviceDetails(TerminalDetails(details)));
    }
  }
}
