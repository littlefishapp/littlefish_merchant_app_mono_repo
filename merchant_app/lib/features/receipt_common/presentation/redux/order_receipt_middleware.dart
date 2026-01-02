import 'package:littlefish_merchant/features/receipt_common/data/data_source/order_receipt_data_source.dart';
import 'package:littlefish_merchant/features/receipt_common/presentation/redux/order_receipt_actions.dart';
import 'package:littlefish_merchant/models/security/authentication/api_base_response.dart';
import 'package:littlefish_merchant/shared/exceptions/general_error.dart';
import 'package:redux/redux.dart';

import '../../../../injector.dart';
import '../../../../redux/app/app_state.dart';

List<Middleware<AppState>> createOrderReceiptMiddleware() {
  return [
    TypedMiddleware<AppState, SendEmailReceiptAction>(
      _sendEmailReceiptAction(),
    ).call,
    TypedMiddleware<AppState, SendSmsReceiptAction>(
      _sendSmsReceiptAction(),
    ).call,
  ];
}

Middleware<AppState> _sendEmailReceiptAction() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    final act = action as SendEmailReceiptAction;
    store.dispatch(const SetOrderReceiptStateIsLoadingAction(true));

    try {
      ApiBaseResponse sendEmailResponse = await getIt<OrderReceiptDataSource>()
          .sendEmailReceipt(
            businessId: act.businessId,
            email: act.customer.email,
            firstName: act.customer.firstName,
            order: act.order!.copyWith(
              customer: act.customer,
              transactions: [act.transaction.copyWith(customer: act.customer)],
            ),
            transaction: act.transaction.copyWith(customer: act.customer),
          );

      if (sendEmailResponse.success == true) {
        store.dispatch(const SetOrderReceiptStateHasSentAction(true));
      } else {
        GeneralError error = GeneralError(
          message: sendEmailResponse.error ?? 'Could not send email',
        );
        store.dispatch(SetOrderReceiptErrorAction(error));
        store.dispatch(const SetOrderReceiptStateHasSentAction(false));
      }
    } catch (e) {
      GeneralError error = GeneralError(message: 'Could not send email');
      store.dispatch(SetOrderReceiptErrorAction(error));
      store.dispatch(const SetOrderReceiptStateHasSentAction(false));
    } finally {
      store.dispatch(const SetOrderReceiptStateIsLoadingAction(false));
    }

    next(action);
  };
}

Middleware<AppState> _sendSmsReceiptAction() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    final act = action as SendSmsReceiptAction;
    store.dispatch(const SetOrderReceiptStateIsLoadingAction(true));
    try {
      ApiBaseResponse sendSmsResponse = await getIt<OrderReceiptDataSource>()
          .sendSMSReceipt(
            businessId: act.businessId,
            mobileNumber: act.customer.mobileNumber,
            order: act.order!.copyWith(
              customer: act.customer,
              transactions: [act.transaction.copyWith(customer: act.customer)],
            ),
            transaction: act.transaction.copyWith(customer: act.customer),
          );

      if (sendSmsResponse.success == true) {
        store.dispatch(const SetOrderReceiptStateHasSentAction(true));
      } else {
        GeneralError error = GeneralError(
          message: sendSmsResponse.error ?? 'Could not send sms',
        );
        store.dispatch(SetOrderReceiptErrorAction(error));
        store.dispatch(const SetOrderReceiptStateHasSentAction(false));
      }
    } catch (e) {
      GeneralError error = GeneralError(message: 'Could not send sms');
      store.dispatch(SetOrderReceiptErrorAction(error));
      store.dispatch(const SetOrderReceiptStateHasSentAction(false));
    } finally {
      store.dispatch(const SetOrderReceiptStateIsLoadingAction(false));
    }
    next(action);
  };
}
