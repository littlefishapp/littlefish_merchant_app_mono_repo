import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/features/pos/presentation/pages/card_payment.dart';
import 'package:littlefish_merchant/features/sell/domain/helpers/transaction_result_mapper.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_transaction.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:littlefish_merchant/ui/checkout/viewmodels/checkout_viewmodels.dart';
import 'package:littlefish_payments/managers/terminal_manager.dart';
import 'package:littlefish_payments/models/shared/payment_result.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:redux/redux.dart';

class PaymentProcessHelper {
  Future<void> processPurchase({
    required BuildContext context,
    required CheckoutTransaction transaction,
    required CardTransactionType paymentType,
    required Decimal? cashbackAmount,
    required Store<AppState> store,
    required String destinationTerminalId,
  }) async {
    CheckoutVM vm = CheckoutVM.fromStore(store);
    await showPopupDialog(
      context: context,
      content: CardPayment(
        transaction: transaction,
        amount: Decimal.parse(transaction.checkoutTotal.toString()),
        refund: null,
        backButtonTimeout: 30,
        paymentType: paymentType,
        cashBackAmount: cashbackAmount ?? Decimal.zero,
        parentContext: context,
        // allowPrinting: AppVariables.isPOSBuild,
        transactionIsSaving: vm.state?.isLoading ?? false,
        saveSale: (result) {
          _processResult(
            vm: vm,
            result: result,
            transaction: transaction,
            goToCompletePage: AppVariables.isMobile ? true : false,
            context: context,
            destinationTerminalId: destinationTerminalId,
            //NB! previous logic below would never be true, as we do not do my pin pad builds or setup the payment provider, as such this is not valid.
            // cardPaymentRegistered == CardPaymentRegistered.myPinPad,
          );
        },
        onError: (paymentResult) {
          debugPrint(
            '### signalr PaymentProcessHelper processPurchase onError entry',
          );
          processErrorResult(
            transaction: transaction,
            paymentResult: paymentResult,
          );
        },
      ),
    );
  }

  void _processResult({
    required CheckoutVM vm,
    required result,
    required CheckoutTransaction transaction,
    required BuildContext context,
    bool goToCompletePage = true,
    String destinationTerminalId = '',
  }) {
    final proceed =
        result != null &&
            result is Map<String, dynamic> &&
            result.containsKey('proceed') &&
            result.containsKey('paid') &&
            result.containsKey('providerPaymentReference') &&
            transaction.paymentType != null
        ? result['proceed']
        : false;
    // if (result?['proceed'] == true) {
    if (proceed) {
      try {
        transaction.paymentType!.paid = safeParseBool(result['paid']);
        transaction.paymentType!.providerPaymentReference = safeParseString(
          result['providerPaymentReference'],
        );

        vm.onSetTransaction(
          TransactionResultMapper.setTransactionData(
            currentTransaction: transaction,
            resultMap: result,
            deviceDetails: vm.deviceDetails,
          ),
        );
        vm.setPaymentType(transaction.paymentType!);
        var navToCompletePage = result['paid'] ? goToCompletePage : false;

        vm.pushSale(
          context,
          goToCompletePage: navToCompletePage,
          destinationTerminalId: destinationTerminalId,
        );
      } on Exception catch (e) {
        debugPrint('Error processing payment result: $e');
        showMessageDialog(
          context,
          'Error processing payment result: $e',
          LittleFishIcons.error,
        );
      }
    } else if (vm.paymentType!.name!.toLowerCase() != 'card') {
      showMessageDialog(
        context,
        'Payment cancelled by user',
        LittleFishIcons.info,
      );
    }
  }

  void processErrorResult({
    required CheckoutTransaction transaction,
    required PaymentResult? paymentResult,
  }) {
    debugPrint('### signalr PaymentProcessHelper processErrorResult entry');

    var transactionstatus = '';
    if (paymentResult != null) {
      transactionstatus = paymentResult.transactionStatus.name;
    }
    final checkoutTransaction = CheckoutTransaction(
      amountChange: transaction.amountChange,
      amountTendered: transaction.amountTendered,
      cashbackAmount: transaction.cashbackAmount,
      items: transaction.items,
      paymentType: transaction.paymentType,
      sellerId: transaction.sellerId,
      sellerName: transaction.sellerName,
      totalTax: transaction.totalTax,
      totalValue: transaction.totalValue,
      countryCode: transaction.countryCode,
      currencyCode: transaction.currencyCode,
      deviceId: transaction.deviceId,
      customerEmail: transaction.customerEmail,
      customerId: transaction.customerId,
      customerName: transaction.customerName,
      customerMobile: transaction.customerMobile,
      id: transaction.id,
      isOnline: transaction.isOnline,
      pendingSync: transaction.pendingSync,
      refunds: transaction.refunds,
      taxInclusive: transaction.taxInclusive,
      ticketId: transaction.ticketId,
      ticketName: transaction.ticketName,
      tipAmount: transaction.tipAmount,
      totalCost: transaction.totalCost,
      totalDiscount: transaction.totalDiscount,
      totalMarkup: transaction.totalMarkup,
      totalRefund: transaction.totalRefund,
      totalRefundCost: transaction.totalRefundCost,
      transactionDate: transaction.transactionDate,
      transactionNumber: transaction.transactionNumber,
      withdrawalAmount: transaction.withdrawalAmount,
      additionalInfo: {
        'status': paymentResult?.status ?? '',
        'statusCode': paymentResult?.statusCode ?? '',
        'statusDescription': paymentResult?.statusDescription ?? '',
        'statusMessage': paymentResult?.statusMessage ?? '',
        'transactionStatus': transactionstatus,
      },
    );
    try {
      final json = checkoutTransaction.toJson();
      final encoded = jsonEncode(json);
      final b64 = base64.encode(encoded.codeUnits);
      final TerminalManager terminalManager = TerminalManager();
      terminalManager.updateSalesTranasaction(
        destinationTerminalId: checkoutTransaction.deviceId ?? '',
        b64Transaction: b64,
      );
    } catch (e) {
      debugPrint('### signalr PaymentProcessHelper processErrorResult $e');
    }
  }
}
