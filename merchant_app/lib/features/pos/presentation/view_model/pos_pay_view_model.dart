// removed ignore: depend_on_referenced_packages

import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:flutter/widgets.dart';
import 'package:littlefish_merchant/models/settings/accounts/linked_account.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/sales/sales_actions.dart';
import 'package:littlefish_merchant/ui/settings/pages/accounts/utils/linked_account_utils.dart';
import 'package:littlefish_payments/models/registration/payment_provider_device_info.dart';
import 'package:littlefish_payments/models/shared/payment_gateway.dart';
import 'package:littlefish_payments/models/shared/payment_result.dart';
import 'package:littlefish_payments/models/terminal/terminal_enrol_data.dart';

import 'package:redux/redux.dart';

import '../../../../common/view_models/store_collection_viewmodel.dart';
import '../../data/data_source/pos_service.dart';

class PosPayVM extends StoreViewModel<AppState> {
  late PosService posPayService;

  @override
  PosPayVM.fromStore(Store<AppState>? store, {BuildContext? context})
    : super.fromStore(store, context: context);

  @override
  loadFromStore(Store<AppState>? store, {BuildContext? context}) {
    posPayService = PosService.fromStore(store: store);
    this.store = store;
    state = store?.state;

    isLoading ??= false;
  }

  Future<BalanceInquiryResult> balanceInquiry() async {
    return await posPayService.balanceInquiry();
  }

  Future<PaymentResult?> charge(Decimal amount) async {
    store!.dispatch(SetSalesLoadingStateAction(true));
    try {
      final result = await posPayService.charge(amount: amount);
      if (result == null) {
        store!.dispatch(SetSalesLoadingStateAction(false));
      }

      return result;
    } catch (e) {
      store!.dispatch(SetSalesLoadingStateAction(false));
      rethrow;
    }
  }

  Future<PaymentResult?> withdraw(Decimal amount) async {
    return await posPayService.withdraw(amount: amount);
  }

  Future<PaymentResult?> purchaseWithCashBack(
    Decimal amount,
    Decimal cashBackAmount,
  ) async {
    return await posPayService.purchaseWithCashBack(
      amount: amount,
      cashBackAmount: cashBackAmount,
    );
  }

  Future<PaymentPrintResult> printBothCustomerAndMerchantCopy(
    String refNum,
  ) async {
    return await posPayService.printBothCustomerAndMerchantCopy(refNum);
  }

  Future<PaymentPrintResult> printCustomerCopy(String refNum) async {
    return await posPayService.printCustomerCopy(refNum);
  }

  Future<PaymentPrintResult> printMerchantCopy(String refNum) async {
    return await posPayService.printMerchantCopy(refNum);
  }

  Future<PaymentPrintResult> reprint(String refNum) async {
    return await posPayService.reprint(refNum);
  }

  Future<PaymentResult?> refund(Decimal refundAmount, String? ref) async {
    store!.dispatch(SetSalesLoadingStateAction(true));
    try {
      final result = await posPayService.refund(
        amount: refundAmount,
        reference: ref,
      );
      if (result == null) {
        store!.dispatch(SetSalesLoadingStateAction(false));
      }

      return result;
    } catch (e) {
      store!.dispatch(SetSalesLoadingStateAction(false));
      rethrow;
    }
  }

  Future<TerminalEnrolData> enrollDevice() async {
    return await posPayService.enrollDevice('');
  }

  Future<bool> unEnrollDevice() async {
    return await posPayService.unEnrollDevice();
  }

  Future<bool> isDeviceEnrolled() async {
    return await posPayService.isDeviceEnrolled();
  }

  Future<bool> validateDeviceCorrectlyLinked() async {
    return await posPayService.validateDeviceCorrectlyLinked();
  }

  Future<PaymentProviderDeviceInfo?> getProviderDeviceInfo() async {
    return await posPayService.getProviderDeviceInfo();
  }

  Future<LinkedAccount?> updateLinkedAccount({LinkedAccount? account}) async {
    var result = await posPayService.updateLinkedAccount(
      account: LinkedAccountUtils.getPMLinkedAccount(linkedAccount: account),
    );
    if (result != null) {
      return LinkedAccount.fromProvider(result);
    } else {
      return null;
    }
  }

  Future<LinkedAccount?> getLinkedAccount() async {
    var result = await posPayService.getLinkedAccount();
    if (result != null) {
      return LinkedAccount.fromProvider(result);
    } else {
      return null;
    }
  }
}
