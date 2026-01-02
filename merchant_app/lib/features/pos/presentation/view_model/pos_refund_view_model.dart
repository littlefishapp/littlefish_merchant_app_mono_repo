// removed ignore: depend_on_referenced_packages, implementation_imports

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:littlefish_interfaces/pos_result_interface.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_payments/models/shared/payment_gateway.dart';
import 'package:littlefish_payments/models/shared/payment_result.dart';
import 'package:redux/src/store.dart';

import '../../../../common/view_models/store_collection_viewmodel.dart';
import '../../data/data_source/pos_service.dart';

class PosRefundVM extends StoreViewModel<AppState> {
  late Decimal amount;
  late POSResultInterface cResponse;
  late PosService _posService;

  PosRefundVM.fromStore(Store<AppState>? store, {BuildContext? context})
    : super.fromStore(store, context: context);

  @override
  loadFromStore(Store<AppState>? store, {BuildContext? context}) {
    _posService = PosService.fromStore(store: store);

    isLoading ??= false;
  }

  Future<PaymentPrintResult> printCustomerCopy(String refNum) async {
    return await _posService.printCustomerCopy(refNum);
  }

  Future<PaymentPrintResult> printMerchantCopy(String refNum) async {
    return await _posService.printMerchantCopy(refNum);
  }

  Future<PaymentPrintResult> printBothCustomerAndMerchantCopy(
    String refNum,
  ) async {
    return await _posService.printBothCustomerAndMerchantCopy(refNum);
  }

  Future<PaymentResult?> refund(String? ref) async {
    if (amount == Decimal.zero) {
      return null;
    }

    return await _posService.refund(amount: amount, reference: ref);
  }

  setAmount(Decimal amount) => this.amount = amount;
}
