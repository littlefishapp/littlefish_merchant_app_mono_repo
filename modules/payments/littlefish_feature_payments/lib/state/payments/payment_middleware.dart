import 'package:flutter/foundation.dart';
import 'package:littlefish_core/hardware/printers/drivers/pos_printer.dart';
import 'package:littlefish_core/hardware/scanners/littlefish_scanner.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/payments/payment_actions.dart';
import 'package:littlefish_payments/gateways/pos_payment_gateway.dart';
import 'package:littlefish_payments/models/shared/payment_gateway.dart';
import 'package:redux/redux.dart';
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_core/logging/services/logger_service.dart';

class PaymentsMiddleware extends MiddlewareClass<AppState> {
  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    final LoggerService logger = LittleFishCore.instance.get<LoggerService>();
    LittleFishCore core = LittleFishCore.instance;

    if (action is ValidatePaymentHardwareAction) {
      if (AppVariables.hasPrinterInitialized == false) {
        try {
          POSPaymentGateway gateway = core.get<POSPaymentGateway>();

          debugPrint(
            '#### PaymentsMiddleware POS Payment Gateway: getPOSPrinter called',
          );
          gateway
              .getPOSPrinter()
              .then((printer) {
                logger.info(
                  'payments.payment_middleware',
                  'Payment hardware validated: POS Printer initialized.',
                );
                AppVariables.hasPrinter = true;
                AppVariables.hasPrinterInitialized = true;
                core.registerLazyService<POSPrinter>(() => printer);
                debugPrint('#### PaymentsMiddlewarePOS Printer initialized: ');
              })
              .catchError((e) {
                debugPrint(
                  '#### PaymentsMiddleware POS Printer initialization error: $e',
                );
                logger.error(
                  'payments.payment_middleware',
                  'Error initializing POS Printer',
                  error: e,
                  stackTrace: e is Error ? e.stackTrace : null,
                );
              });
        } catch (e) {
          debugPrint('#### payments.payment_middleware: $e');
          logger.error(
            'payments.payment_middleware',
            'Error validating payment hardware',
            error: e,
            stackTrace: e is Error ? e.stackTrace : null,
          );
        }
      } else {
        debugPrint('#### payments.payment_middleware: hw already initialized.');
        logger.info(
          'payments.payment_middleware',
          'Payment hardware already validated.',
        );
      }
      if (AppVariables.hasScannerInitialized == false) {
        try {
          POSPaymentGateway gateway = core.get<POSPaymentGateway>();

          gateway
              .getPOSScanner()
              .then((scanner) {
                logger.info(
                  'payments.payment_middleware',
                  'Payment hardware validated: POS Scanner initialized.',
                );
                AppVariables.hasScanner = true;
                AppVariables.hasScannerInitialized = true;
                core.registerLazyService<LittleFishScanner>(() => scanner);
              })
              .catchError((e) {
                logger.error(
                  'payments.payment_middleware',
                  'Error initializing POS Scanner',
                  error: e,
                  stackTrace: e is Error ? e.stackTrace : null,
                );
              });
        } catch (e) {
          logger.error(
            'payments.payment_middleware',
            'Error validating payment hardware (scanner)',
            error: e,
            stackTrace: e is Error ? e.stackTrace : null,
          );
        }
      } else {
        logger.info(
          'payments.payment_middleware',
          'Scanner already initialized.',
        );
      }
      if (AppVariables.hasPrinter &&
          !AppVariables.canPerformAction(PaymentGatewayAction.printReceipt)) {
        POSPaymentGateway gateway = core.get<POSPaymentGateway>();
        AppVariables.providerActions = gateway.getSupportedActions();
      }
    }
  }
}
