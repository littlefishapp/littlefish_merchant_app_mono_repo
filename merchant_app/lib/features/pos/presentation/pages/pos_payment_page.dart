// remove ignore_for_file: use_build_context_synchronously

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_core_utils/error/error_code_manager.dart';
import 'package:littlefish_core_utils/error/models/error_codes/transaction_error_codes.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/bootstrap.dart';
import 'package:littlefish_merchant/features/order_common/data/model/payment_result_constants.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_transaction.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/shared/constants/permission_name_constants.dart';
import 'package:littlefish_merchant/ui/checkout/sell_page.dart';
import 'package:littlefish_merchant/ui/sales/pages/refund_complete_page.dart';
import 'package:littlefish_payments/models/shared/payment_result.dart';

import '../../../../common/presentaion/components/app_progress_indicator.dart';
import '../../../../common/presentaion/components/dialogs/common_dialogs.dart';
import '../../../../common/presentaion/pages/scaffolds/app_scaffold.dart';
import '../../../../models/sales/checkout/checkout_refund.dart';
import '../../../../redux/checkout/checkout_actions.dart';
import '../../../../tools/helpers.dart';
import '../../../../ui/checkout/pages/checkout_complete_page.dart';
import '../../../../ui/sales/pages/void_complete_page.dart';
import '../conponents/pos_print_options_widget.dart';
import '../view_model/pos_pay_view_model.dart';
import 'package:littlefish_core/logging/services/logger_service.dart';
import 'package:littlefish_core/core/littlefish_core.dart';

class PosPaymentPage extends StatefulWidget {
  final CheckoutTransaction? transaction;
  final BuildContext? parentContext;
  final int backButtonTimeout;
  final bool transactionIsSaving;
  final Function(dynamic result) saveSale;
  final Function(PaymentResult? paymentresult)? onError;
  final CardTransactionType paymentType;

  final Decimal amount;
  final Decimal cashBackAmount;
  final void Function(BuildContext context)? onNavigate;
  final bool isV2;
  final bool canPrint;
  final String? refundReference;

  final Refund? refund;

  const PosPaymentPage({
    super.key,
    required this.saveSale,
    required this.paymentType,
    this.onError,
    this.transaction,
    this.parentContext,
    this.backButtonTimeout = 60,
    this.transactionIsSaving = false,
    required this.cashBackAmount,
    required this.amount,
    this.refund,
    this.onNavigate,
    this.isV2 = false,
    this.canPrint = true,
    this.refundReference,
  });

  @override
  State<PosPaymentPage> createState() => _PosPaymentPageState();
}

class PosPrintDisplayItem {
  final String name;
  final PosPrintOptions value;

  const PosPrintDisplayItem(this.name, this.value);
}

class _PosPaymentPageState extends State<PosPaymentPage> {
  LoggerService get logger => LittleFishCore.instance.get<LoggerService>();
  PosPayVM? vm;
  CheckoutTransaction? transaction;
  BuildContext? parentContext;
  var _allowBack = false;
  bool _canDismissPopUp = false;
  bool _transactionModalIsActive = false;
  final List<PosPrintDisplayItem> printOptions = [
    const PosPrintDisplayItem(
      'Print Customer Receipt',
      PosPrintOptions.customer,
    ),
    const PosPrintDisplayItem(
      'Print Merchant Receipt',
      PosPrintOptions.merchant,
    ),
    const PosPrintDisplayItem('Print Both Receipts', PosPrintOptions.both),
    const PosPrintDisplayItem('None', PosPrintOptions.none),
  ];

  @override
  Widget build(BuildContext context) {
    transaction = widget.transaction;
    parentContext = widget.parentContext;
    vm ??=
        PosPayVM.fromStore(
            StoreProvider.of<AppState>(context),
            context: context,
          )
          ..onLoadingChanged = () {
            if (mounted) setState(() {});
          };

    return PopScope(
      canPop: _allowBack,
      child: AppScaffold(
        title: 'Payment in progress...',
        displayAppBar: false,
        body: FutureBuilder<PaymentResult?>(
          future: _paymentTypeFutureFactory(),
          builder: (BuildContext context, AsyncSnapshot<PaymentResult?> snapshot) {
            if (snapshot.hasError) {
              String errorMessage = ErrorCodeManager.getUserMessage(
                snapshot.error ??
                    TransactionErrorCodes.unknownUnsuccessfulCardError,
              );
              if (snapshot.error is PlatformException) {
                final error = snapshot.error as PlatformException;
                _paymentUnsuccessful(
                  context,
                  error.code,
                  isWithdrawal:
                      widget.paymentType == CardTransactionType.withdrawal,
                  deviceMessage: errorMessage,
                );
              } else {
                _paymentUnsuccessful(
                  context,
                  'ERROR',
                  isWithdrawal:
                      widget.paymentType == CardTransactionType.withdrawal,
                  deviceMessage: errorMessage,
                );

                logger.error(
                  this,
                  'An unexpected error occurred during payment',
                  error: snapshot.error,
                  stackTrace: StackTrace.current,
                );
              }
            }

            if ((snapshot.hasData == false) &&
                snapshot.connectionState != ConnectionState.done) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppProgressIndicator(),
                    SizedBox(height: 24),
                    Text('...Payment In Progress...'),
                  ],
                ),
              );
            }

            final result = snapshot.data!;

            if (result.transactionStatus != PaymentStatus.processed) {
              _paymentUnsuccessful(
                context,
                result.statusCode,
                isWithdrawal:
                    widget.paymentType == CardTransactionType.withdrawal,
                deviceMessage: result.statusDescription,
                paymentResult: result,
              );
              return const AppProgressIndicator();
            }

            WidgetsBinding.instance.addPostFrameCallback((_) async {
              try {
                await _posSavingTransactionDialog(context, result);
              } catch (e) {
                logger.error(
                  this,
                  'An error occurred saving transaction: ${result.amount}, ${result.traceId}',
                  error: e,
                  stackTrace: StackTrace.current,
                );
              }
              if (!widget.transactionIsSaving) {
                if (_transactionModalIsActive) {
                  Navigator.of(context).pop();
                }
                try {
                  if (AppVariables.hasPrinter &&
                      AppVariables.canPrintMerchantAndCustomerCopy &&
                      userHasPermission(allowPrintReceipt)) {
                    var printOption = await _posPrintDialog(context);
                    _printDialogHandler(result, printOption);
                  } else {
                    if (AppVariables.hasPrinter && AppVariables.isPOSBuild) {
                      logger.info(
                        this,
                        'Checking print conditions...\n'
                        'Build is: ${AppVariables.appFlavour}\n'
                        'Has Printer: ${AppVariables.hasPrinter} \n'
                        'Can Print Merchant and Customer Copy: ${AppVariables.canPrintMerchantAndCustomerCopy} \n'
                        'User Has Permission: ${userHasPermission(allowPrintReceipt)}\n'
                        'MerchantID: ${AppVariables.merchantId}\n'
                        'TerminalID: ${AppVariables.deviceInfo?.terminalId ?? ''}',
                      );
                    }
                    // For Verifone devices or devices without printer, proceed directly to completion
                    _printDialogHandler(result, PosPrintOptions.none);
                  }
                } catch (e) {
                  logger.error(
                    this,
                    'Error printing receipt',
                    error: e,
                    stackTrace: StackTrace.current,
                  );
                }
              }
            });
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppProgressIndicator(),
                  SizedBox(height: 24),
                  Text('...Printing...'),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: widget.backButtonTimeout), () {
      // Code to be executed after 60 seconds
      _allowBack = true;
    });
  }

  _paymentResultObject(
    PaymentResult item, {
    bool paid = true,
    bool proceed = true,
  }) {
    return {
      'proceed': proceed,
      'paid': paid,
      'providerPaymentReference': item.traceId,
      'batchNumber': item.batchNumber,
      'referenceNumber': item.transactionReference,
      'status': item.status,
      'authCode': item.authCode,
      'entry': item.entry,
      'cardType': item.paymentMethod,
      // Additional fields
      'refNum': item.transactionReference,
      'entryMode': item.entryMode,
      'maskedPAN': item.maskedPan,
      'uti': item.uti,
      'traceID': item.traceId,
      'tid': item.terminalId,
      'mid': item.merchantId,
      'authResponse': item.authResponse,
      'authResponseCode': item.authResponseCode,
      'rrn': item.rrn,
      'stan': item.stan,
      'aid': item.aid,
      'tvr': item.tvr,
      'tsi': item.tsi,
      'cvr': item.cvr,
    };
  }

  _paymentUnsuccessful(
    BuildContext context,
    String? message, {
    bool? isWithdrawal,
    String? deviceMessage,
    PaymentStatus? paymentstatus,
    PaymentResult? paymentResult,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final resultMessage =
          deviceMessage ?? broadPOSMessageLookUp(message ?? '');

      BuildContext ctx = context.mounted
          ? context
          : globalNavigatorKey.currentContext!;

      await showMessageDialog(
        ctx,
        ErrorCodeManager.getUserMessage(
          isWithdrawal == true
              ? 'Cash Withdrawal Unsuccessful\n$resultMessage'
              : 'Transaction Unsuccessful\n$resultMessage',
        ),
        Icons.cancel,
      );

      if (widget.onError != null) {
        await widget.onError!(paymentResult);
      }

      Navigator.of(context).pop({'proceed': false, 'paid': false});
    });
  }

  _getErrorResponse(PaymentResult? result, String? errorCode, String? message) {
    if (result != null) {
      return _paymentResultObject(result, paid: false, proceed: false);
    } else {
      return {
        PaymentResultConstant.proceed: false,
        PaymentResultConstant.paid: false,
        PaymentResultConstant.errorCode:
            errorCode ??
            TransactionErrorCodes.unknownUnsuccessfulCardError.code,
        PaymentResultConstant.errorMessage:
            message ??
            TransactionErrorCodes.unknownUnsuccessfulCardError.message,
      };
    }
  }

  Future<void> printOptionsHandler(
    PaymentResult result,
    PosPrintOptions value,
    PosPayVM? vm,
  ) async {
    switch (value) {
      case PosPrintOptions.customer:
        await vm?.printCustomerCopy(result.transactionReference);
        break;
      case PosPrintOptions.merchant:
        await vm?.printMerchantCopy(result.transactionReference);
        break;
      case PosPrintOptions.both:
        await vm?.printBothCustomerAndMerchantCopy(result.transactionReference);
        break;
      case PosPrintOptions.none:
      default:
        break;
      //do nothing
    }
  }

  _posPrintDialog(BuildContext context) async =>
      await showPopupDialog<PosPrintOptions?>(
        height: (MediaQuery.of(context).size.height * 0.65),
        context: context,
        content: PopScope(
          canPop: _canDismissPopUp,
          child: Container(
            margin: const EdgeInsets.all(8),
            child: PosPrintOptionsWidget(printOptions),
          ),
        ),
        borderDismissable: false,
      );

  _posSavingTransactionDialog(
    BuildContext context,
    PaymentResult result,
  ) async {
    await widget.saveSale(_paymentResultObject(result));
    if (widget.transactionIsSaving) {
      _transactionModalIsActive = true;
      return await showPopupDialog(
        height: (MediaQuery.of(context).size.height * 0.65),
        context: context,
        content: PopScope(
          canPop: !widget.transactionIsSaving,
          child: const Column(
            children: [
              Center(child: Text('Saving Transaction... Please wait')),
            ],
          ),
        ),
      );
    }
  }

  Future<PaymentResult?> _paymentTypeFutureFactory() {
    Decimal amount = widget.isV2
        ? widget.amount
        : Decimal.parse((transaction?.checkoutTotal ?? 0).toString());
    switch (widget.paymentType) {
      case CardTransactionType.purchase:
        return vm!.charge(amount);
      case CardTransactionType.purchaseWithCashback:
        return vm!.purchaseWithCashBack(
          (amount - widget.cashBackAmount),
          widget.cashBackAmount,
        );
      case CardTransactionType.withdrawal:
        return vm!.withdraw(amount);
      case CardTransactionType.refund:
      case CardTransactionType.voided:
        return vm!.refund(
          Decimal.parse(((widget.refund?.totalRefund ?? 0).toString())),
          widget.refundReference ?? '',
        );
      default:
        return vm!.charge(amount);
    }
  }

  _printDialogHandler(PaymentResult result, PosPrintOptions value) async {
    try {
      try {
        await printOptionsHandler(result, value, vm);
      } on PlatformException catch (ee) {
        logger.warning(
          this,
          'Unable to print due to, code:${ee.code}:${ee.message}',
        );
      } catch (e) {
        logger.error(
          this,
          'An unexpected error occurred during printing',
          error: e,
          stackTrace: StackTrace.current,
        );

        rethrow;
      }
      _canDismissPopUp = true;

      if (widget.onNavigate != null) {
        widget.onNavigate!(context);
        return;
      }

      if (transaction == null) return;

      switch (widget.paymentType) {
        case CardTransactionType.purchase:
        case CardTransactionType.purchaseWithCashback:
        case CardTransactionType.withdrawal:
          Navigator.of(context)
              .pushNamedAndRemoveUntil(
                CheckoutCompletePage.route,
                ModalRoute.withName(SellPage.route),
                arguments: {
                  'transaction': transaction,
                  'customer': AppVariables.store!.state.customerstate
                      .getCustomerById(id: transaction!.customerId ?? ''),
                  'isWithdrawal':
                      widget.paymentType == CardTransactionType.withdrawal,
                },
              )
              .then(
                (_) => AppVariables.store!.dispatch(
                  CheckoutSetLoadingAction(false),
                ),
              );
          break;
        case CardTransactionType.voided:
          Navigator.of(context).pushNamedAndRemoveUntil(
            VoidCompletePage.route,
            ModalRoute.withName(SellPage.route),
            arguments: {
              'transaction': transaction,
              'customer': AppVariables.store!.state.customerstate
                  .getCustomerById(id: transaction!.customerId ?? ''),
            },
          );
          break;
        case CardTransactionType.refund:
          Navigator.of(context)
              .pushNamedAndRemoveUntil(
                RefundCompletePage.route,
                ModalRoute.withName(SellPage.route),
                arguments: {
                  'refund': widget.refund!,
                  'customer': AppVariables.store!.state.customerstate
                      .getCustomerById(id: widget.refund!.customerId ?? ''),
                },
              )
              .then(
                (_) => AppVariables.store!.dispatch(
                  CheckoutSetLoadingAction(false),
                ),
              );
      }
    } catch (e) {
      logger.error(
        this,
        'An unexoected error occurred, whilst printing receipt',
        error: e,
        stackTrace: StackTrace.current,
      );
    }
  }
}
