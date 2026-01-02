import 'dart:async';

import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_core/logging/services/logger_service.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/features/order_common/data/model/customer.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order_transaction.dart';
import 'package:littlefish_merchant/features/receipt_common/data/data_source/lf_order_receipt_data_source.dart';
import 'package:littlefish_merchant/features/receipt_common/data/data_source/order_receipt_data_source.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_refund.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_transaction.dart';
import 'package:littlefish_merchant/models/security/authentication/api_base_response.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/shared/exceptions/general_error.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:redux/redux.dart';

final LittleFishCore core = LittleFishCore.instance;

LoggerService logger = LittleFishCore.instance.get<LoggerService>();

class InitializeReceiptStateAction {
  final Customer? customer;
  final Order? order;
  final OrderTransaction? transaction;

  InitializeReceiptStateAction(this.order, this.transaction, this.customer);
}

class SetOrderReceiptStateIsLoadingAction {
  final bool value;
  const SetOrderReceiptStateIsLoadingAction(this.value);
}

class ClearReceiptStateAction {
  const ClearReceiptStateAction();
}

class SetOrderReceiptStateHasSentAction {
  final bool value;
  const SetOrderReceiptStateHasSentAction(this.value);
}

class SetOrderReceiptErrorAction {
  GeneralError? error;

  SetOrderReceiptErrorAction(this.error);
}

class SendEmailReceiptAction {
  final String businessId;
  final Customer customer;
  final Order? order;
  final OrderTransaction transaction;

  SendEmailReceiptAction({
    this.order,
    required this.transaction,
    required this.businessId,
    required this.customer,
  });
}

class SendSmsReceiptAction {
  final String businessId;
  final Customer customer;
  final Order? order;
  final OrderTransaction transaction;

  SendSmsReceiptAction({
    this.order,
    required this.transaction,
    required this.businessId,
    required this.customer,
  });
}

class PrintReceiptAction {
  final Customer? customer;
  final Order? order;
  final OrderTransaction? transaction;

  PrintReceiptAction(this.order, this.transaction, this.customer);
}

class SetReceiptCustomerAction {
  final Customer? customer;

  SetReceiptCustomerAction(this.customer);
}

class SetReceiptOrderTransactionAction {
  final OrderTransaction? transaction;

  SetReceiptOrderTransactionAction(this.transaction);
}

class SetReceiptOrderAction {
  final Order? order;
  SetReceiptOrderAction(this.order);
}

ThunkAction<AppState> sendCheckoutSaleSmsReceipt({
  required CheckoutTransaction transaction,
  required String businessId,
  required String mobileNumber,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      try {
        ApiBaseResponse sendSmsResponse = await getIt<OrderReceiptDataSource>()
            .sendCheckoutSaleSMSReceipt(
              businessId: businessId,
              mobileNumber: mobileNumber,
              transaction: transaction,
            );

        if (sendSmsResponse.success == true) {
          completer?.complete(true);
        } else {
          logger.debug('sendCheckoutSaleSmsReceipt', 'Failed to send sale SMS');
          completer?.complete(false);
        }
      } catch (e) {
        logger.error(
          'sendCheckoutSaleSmsReceipt',
          '### aFailed to send sale SMS [$e]',
          error: e,
          stackTrace: StackTrace.current,
        );
        completer?.completeError(
          GeneralError(
            methodName: 'sendCheckoutSaleSmsReceipt',
            message: 'Failed to send SMS, please try again.',
            error: e,
          ),
        );
      }
    });
  };
}

ThunkAction<AppState> sendCheckoutRefundSmsReceipt({
  required Refund refund,
  required String businessId,
  required String mobileNumber,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      try {
        ApiBaseResponse sendSmsResponse = await getIt<OrderReceiptDataSource>()
            .sendCheckoutRefundSMSReceipt(
              businessId: businessId,
              mobileNumber: mobileNumber,
              transaction: refund,
            );

        if (sendSmsResponse.success == true) {
          completer?.complete(true);
        } else {
          logger.debug(
            'sendCheckoutRefundSmsReceipt',
            'Failed to send refund SMS',
          );
          completer?.complete(false);
        }
      } catch (e) {
        logger.error(
          'sendCheckoutRefundSmsReceipt',
          '### Failed to send sms [$e]',
          error: e,
          stackTrace: StackTrace.current,
        );
        completer?.completeError(
          GeneralError(
            methodName: 'sendCheckoutRefundSmsReceipt',
            message: 'Failed to send SMS, please try again.',
            error: e,
          ),
        );
      }
    });
  };
}

Future<void> registerService() async {
  try {
    if (!core.isRegistered<OrderReceiptDataSource>()) {
      core.registerLazyService<OrderReceiptDataSource>(
        () => LFOrderReceiptDataSource(
          baseUrl: AppVariables.store?.state.baseUrl ?? '',
        ),
      );
    }
  } catch (e) {
    logger.error(
      'order_receipt',
      '### order receipt: registerService error [$e]',
      error: e,
      stackTrace: StackTrace.current,
    );
  }
}
