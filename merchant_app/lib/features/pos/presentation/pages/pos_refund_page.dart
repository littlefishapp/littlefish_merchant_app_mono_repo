// remove ignore_for_file: use_build_context_synchronously

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_core/logging/services/logger_service.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/shared/constants/permission_name_constants.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:littlefish_payments/models/shared/payment_result.dart';

import '../../../../common/presentaion/components/app_progress_indicator.dart';
import '../../../../common/presentaion/components/dialogs/common_dialogs.dart';
import '../../../../common/presentaion/pages/scaffolds/app_simple_scaffold.dart';
import '../../../../models/enums.dart';
import '../conponents/pos_print_options_widget.dart';
import '../view_model/pos_refund_view_model.dart';
import 'pos_payment_page.dart';

class PosRefundPage extends StatefulWidget {
  final Decimal amount;
  final BuildContext? parentContext;
  final int backButtonTimeout;
  final bool transactionIsSaving;
  final VoidCallback saveRefund;
  final VoidCallback onCompleteClosedScreenFunction;
  final bool runOnCompleteClosedScreenFunction;

  const PosRefundPage(
    this.amount, {
    Key? key,
    this.backButtonTimeout = 60,
    this.transactionIsSaving = false,
    required this.saveRefund,
    required this.onCompleteClosedScreenFunction,
    this.runOnCompleteClosedScreenFunction = true,
    this.parentContext,
  }) : super(key: key);

  @override
  State<PosRefundPage> createState() => _PosRefundPageState();
}

class _PosRefundPageState extends State<PosRefundPage> {
  PosRefundVM? vm;
  BuildContext? parentContext;
  Map<String, dynamic>? options;
  final bool _allowBack = false;
  final bool _canDismissPopUp = false;

  LoggerService get logger => LittleFishCore.instance.get<LoggerService>();

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
    vm ??=
        PosRefundVM.fromStore(
            StoreProvider.of<AppState>(context),
            context: context,
          )
          ..onLoadingChanged = () {
            if (mounted) setState(() {});
          }
          ..setAmount(widget.amount);

    return PopScope(
      onPopInvoked: (didPop) => _willPopHandler(context),
      child: AppSimpleAppScaffold(
        title: 'Refund',
        titleIsWidget: true,
        isEmbedded: true,
        body: FutureBuilder<PaymentResult?>(
          future: vm!.refund(null),
          builder: (BuildContext context, AsyncSnapshot<PaymentResult?> snapshot) {
            if (!snapshot.hasData) return const AppProgressIndicator();

            final result = snapshot.data!;

            if (result.transactionStatus != PaymentStatus.processed) {
              _paymentUnsuccessful(context, result.statusCode);
              return const AppProgressIndicator();
            }

            WidgetsBinding.instance.addPostFrameCallback((_) async {
              await _posSavingTransactionDialog(context, result);
              if (!widget.transactionIsSaving) {
                try {
                  if (AppVariables.hasPrinter &&
                      !isVerifone &&
                      userHasPermission(allowPrintReceipt)) {
                    var printOption = await _posPrintDialog(context);
                    _printDialogHandler(result, printOption);
                  } else {
                    // For Verifone devices or devices without printer, proceed directly to completion
                    _printDialogHandler(result, PosPrintOptions.none);
                  }
                } catch (e) {
                  logger.error(
                    this,
                    'Error printing refund',
                    error: e,
                    stackTrace: StackTrace.current,
                  );
                }
              }
            });

            return const AppProgressIndicator();
          },
        ),
      ),
    );
  }

  _posPrintDialog(BuildContext context) => showPopupDialog<PosPrintOptions?>(
    height: (MediaQuery.of(context).size.height * 0.65),
    context: context,
    content: PopScope(
      canPop: _canDismissPopUp,
      onPopInvoked: (didPop) {
        return;
      },
      child: PosPrintOptionsWidget(printOptions),
    ),
    borderDismissable: false,
  );

  _posSavingTransactionDialog(BuildContext context, PaymentResult item) async {
    widget.saveRefund();
    if (widget.transactionIsSaving) {
      return await showPopupDialog(
        height: (MediaQuery.of(context).size.height * 0.65),
        context: context,
        content: PopScope(
          canPop: !widget.transactionIsSaving,
          onPopInvoked: (didPop) {
            return;
          },
          child: const Column(
            children: [
              Center(child: Text('Saving Transaction... Please wait')),
            ],
          ),
        ),
      );
    }
  }

  _printDialogHandler(PaymentResult result, PosPrintOptions value) async {
    await printOptionsHandler(result, value, vm);

    if (widget.runOnCompleteClosedScreenFunction) {
      widget.onCompleteClosedScreenFunction();
    } else {
      Navigator.pop(context, _paymentResultObject(result));
    }
  }

  _willPopHandler(BuildContext context) {
    if (_allowBack) {
      Navigator.pop(context, {'proceed': false, 'paid': false});
      return true;
    } else {
      return false;
    }
  }

  _paymentUnsuccessful(BuildContext context, String? message) =>
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await showMessageDialog(
          context,
          'Payment Unsuccessful\n$message',
          Icons.cancel,
        );
        Navigator.of(context).pop({'proceed': false, 'paid': false});
      });

  _paymentResultObject(
    PaymentResult result, {
    bool refund = true,
    bool proceed = true,
  }) => {
    'proceed': proceed,
    'refund': refund,
    'providerPaymentReference': result.transactionReference,
    'batchNumber': result.batchNumber,
    'referenceNumber': result.traceId,
    'status': result.status,
  };

  Future<void> printOptionsHandler(
    PaymentResult result,
    PosPrintOptions value,
    PosRefundVM? vm,
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
}
