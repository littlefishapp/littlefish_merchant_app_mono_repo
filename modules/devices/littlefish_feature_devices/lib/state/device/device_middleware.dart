import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:littlefish_auth/littlefish_auth_manager.dart';
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_core/logging/services/logger_service.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/injectors/terminal_injector.dart';
import 'package:littlefish_merchant/bootstrap.dart';
import 'package:littlefish_merchant/features/linked_devices/presentation/bloc/single_linked_device_bloc.dart';
import 'package:littlefish_merchant/features/linked_devices/presentation/bloc/linkeddevices_bloc.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_transaction.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';

import 'package:littlefish_merchant/redux/business/business_actions.dart';
import 'package:littlefish_merchant/redux/checkout/process_payment_helper.dart';
import 'package:littlefish_merchant/redux/device/device_actions.dart';
import 'package:littlefish_merchant/redux/linked_account/linked_account_actions.dart';
import 'package:littlefish_merchant/redux/product/product_actions.dart';
import 'package:littlefish_payments/managers/terminal_manager.dart';
import 'package:redux/redux.dart';

class DeviceMiddleware extends MiddlewareClass<AppState> {
  bool _isBusy = false;

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    if (_isBusy) {
      return;
    }

    final LoggerService logger = LittleFishCore.instance.get<LoggerService>();

    final LittlefishAuthManager authManager = LittlefishAuthManager.instance;

    try {
      if (action is SetSelectedBusinessAction) {
        if (action.value != null) {
          _isBusy = true;
          await TerminalInjector.inject(
            callback: (event) async {
              await eventsDispatcher(
                store: store,
                event: event.type,
                data: event.data,
              );
            },
          );
        }
      }

      if (authManager.isAuthenticated &&
          AppVariables.businessId.isNotEmpty &&
          TerminalManager.instance.thisTerminal?.businessId !=
              AppVariables.businessId) {
        _isBusy = true;
        await TerminalInjector.inject(
          callback: (event) async {
            await eventsDispatcher(
              store: store,
              event: event.type,
              data: event.data,
            );
          },
        );
      }
    } catch (e) {
      if (e is StateError && e.message.contains('No element')) {
        debugPrint('### DeviceMiddleware - AppVariables - no element');
        logger.debug('DeviceMiddleware', 'AppVariables - no element');
      } else {
        logger.warning(
          'DeviceMiddleware',
          'Unexpected error in DeviceMiddleware',
          error: e,
          stackTrace: StackTrace.current,
        );
      }
    } finally {
      _isBusy = false;
    }
  }

  Future<void> eventsDispatcher({
    required Store<AppState> store,
    required String event,
    dynamic data,
  }) async {
    final context = globalNavigatorKey.currentContext!;
    if (event.contains('updateProductsV1')) {
      if (data is Map && data.containsKey('data')) {
        final ids = data['data'];
        if (ids is List<String>) {
          for (final item in ids) {
            debugPrint('### DeviceMiddleware - updateProductsV1 - $item');
            store.dispatch(fetchAndSetProductById(item));
          }
        }
      }
    } else if (event.contains('updateCategoriesV1')) {
      if (data is Map && data.containsKey('data')) {
        final ids = data['data'];
        if (ids is List<String>) {
          debugPrint('### DeviceMiddleware - updateCategoriesV1 - $ids');
          store.dispatch(initializeCategories(refresh: true));
        }
      }
    } else if (event.contains('updateRolesV1')) {
      if (data is Map && data.containsKey('data')) {
        final ids = data['data'];
        if (ids is List<String>) {
          debugPrint('### DeviceMiddleware - updateRolesV1 - $ids');
          store.dispatch(loadRolesAndPermissions);
        }
      }
    } else if (event.contains('registerTerminalProviderRequestV1')) {
      if (data is Map && data.containsKey('data')) {
        final response = data['data'];
        String senderDeviceId = response?.sourceTerminalId ?? '';
        String thisDeviceId = response.destinationTerminalId ?? '';
        debugPrint('### DeviceMiddleware - registerTerminalProviderRequestV1 ');
        store.dispatch(
          registerTerminalProvider(
            deviceSenderId: senderDeviceId,
            deviceId: thisDeviceId,
          ),
        );
      }
    } else if (event.contains('registerTerminalProviderResponseV1')) {
      if (data is Map && data.containsKey('data')) {
        final response = data['data'];
        String senderDeviceId = response?.sourceTerminalId ?? '';
        String thisDeviceId = response.destinationTerminalId ?? '';
        String message = response.message ?? '';
        bool success = response.success ?? false;
        debugPrint('### DeviceMiddleware - registerTerminalProviderResponseV1');
        BuildContext context = globalNavigatorKey.currentContext!;
        context.read<SingleLinkedDeviceBloc>().add(
          RegisterTerminalProviderResponseEvent(
            deviceId: thisDeviceId,
            message: message,
            success: success,
            senderDeviceId: senderDeviceId,
          ),
        );
      }
    } else if (event.contains('updateLinkedAccountV1')) {
      debugPrint('### DeviceMiddleware - updateLinkedAccountV1');
      store.dispatch(updateLinkedAccount());
    } else if (event.contains('pushSalesV1')) {
      if (data is Map && data.containsKey('data')) {
        final saleMap = data['data'];
        final checkouttransaction = CheckoutTransaction.fromJson(saleMap);
        PaymentProcessHelper().processPurchase(
          context: context,
          transaction: checkouttransaction,
          paymentType: CardTransactionType.purchase,
          cashbackAmount: null,
          store: store,
          destinationTerminalId: checkouttransaction.deviceId ?? 'unknown',
        );

        debugPrint('### Signalr DeviceMiddleware - pushSalesV1 - saleMap');
      }
    } else if (event.contains('updateSalesV1')) {
      if (data is Map && data.containsKey('data')) {
        final saleMap = data['data'];
        final checkouttransaction = CheckoutTransaction.fromJson(saleMap);
        final additionData = checkouttransaction.additionalInfo;
        var transactionOk = true;
        if (additionData != null) {
          if (additionData.containsKey('status')) {
            final value = additionData['status'];
            if (value is String) {
              if (value.toLowerCase().contains('failed')) {
                transactionOk = false;
              }
            }
          }
        }

        if (transactionOk) {
          debugPrint('### SignalR DeviceMiddleware - updateSalesV1 - success');
          context.read<LinkedDevicesBloc>().add(
            CompletePushSaleTerminalEvent(),
          );
          store.dispatch(pushTerminalSale(transaction: checkouttransaction));
        } else {
          debugPrint('### SignalR DeviceMiddleware - updateSalesV1 - error');
          context.read<LinkedDevicesBloc>().add(
            HandleErrorPushSaleTerminalEvent(),
          );
        }
      }
    }
  }
}
