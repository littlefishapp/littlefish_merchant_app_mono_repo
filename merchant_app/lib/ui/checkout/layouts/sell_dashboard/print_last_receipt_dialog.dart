import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_core/logging/services/logger_service.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_payments/managers/payments_manager.dart';
import 'package:littlefish_payments/models/shared/payment_gateway.dart';
import 'package:redux/redux.dart';

LoggerService _logger = LittleFishCore.instance.get<LoggerService>();

class PrintLastReceiptDialogue extends StatefulWidget {
  static const route = '/print-last-receipt-dialogue';
  const PrintLastReceiptDialogue({super.key});

  @override
  State<PrintLastReceiptDialogue> createState() =>
      _PrintLastReceiptDialogueState();
}

class _PrintLastReceiptDialogueState extends State<PrintLastReceiptDialogue> {
  var isTablet = false;
  late final Future<PaymentPrintResult> _printFuture;

  @override
  void initState() {
    super.initState();
    _printFuture = _printLastReceipt();
  }

  Future<PaymentPrintResult> _printLastReceipt() async {
    final PaymentPrintResult result = await PaymentManager()
        .printPaymentReceipt(
          channel: PaymentChannel.pos,
          transactionId: '',
          merchantId: 'merchantId', //ToDo: get the right merchant Id from state
          paymentType: PaymentType.card,
          printOption: ReceiptPrintOption.printLastReceipt,
        );
    debugPrint(
      '### PrintLastReceiptDialogue: '
      'futureAction result: ${result.isSuccess}',
    );
    return result;
  }

  @override
  Widget build(BuildContext context) {
    isTablet = EnvironmentProvider.instance.isLargeDisplay ?? false;
    return StoreBuilder(
      builder: (BuildContext context, Store<AppState> store) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return FutureBuilder<PaymentPrintResult>(
              future: _printFuture,
              builder: (context, snapshot) {
                debugPrint(
                  '#### PrintLastReceiptDialogue: '
                  '${snapshot.connectionState}',
                );

                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError || snapshot.data == null) {
                    if (snapshot.hasError) {
                      _logger.error(
                        'PrintLastReceiptButton',
                        'PrintLastReceiptButton error',
                        error: snapshot.error,
                      );
                    } else {
                      _logger.error(
                        'PrintLastReceiptButton',
                        'PrintLastReceiptButton: No data was returned when attempting to print the last card receipt.',
                      );
                    }
                    WidgetsBinding.instance.addPostFrameCallback((_) async {
                      await showMessageDialog(
                        context,
                        'Unable to print the last card receipt, please try again.',
                        LittleFishIcons.error,
                        status: StatusType.destructive,
                      );
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    });
                    // return const SizedBox.shrink();
                  } else {
                    final result = snapshot.data!;
                    if (result.isSuccess) {
                      WidgetsBinding.instance.addPostFrameCallback((_) async {
                        await showMessageDialog(
                          context,
                          'Last Receipt Printed Successfully',
                          Icons.done,
                        );
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      });
                    } else {
                      WidgetsBinding.instance.addPostFrameCallback((_) async {
                        await showMessageDialog(
                          context,
                          'Failed to print last card receipt:\nReason: '
                          '${result.statusDescription}',
                          LittleFishIcons.info,
                        );
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      });
                    }
                  }
                }

                return isTablet
                    ? tabletScaffold(
                        context: context,
                        store: store,
                        constraints: constraints,
                      )
                    : mobileScaffold(
                        context: context,
                        store: store,
                        constraints: constraints,
                      );
              },
            );
          },
        );
      },
    );
  }

  Widget mobileScaffold({
    required BuildContext context,
    required Store<AppState> store,
    required BoxConstraints constraints,
  }) {
    return AppScaffold(title: 'Print Last Receipt', body: scaffoldBody());
  }

  Widget tabletScaffold({
    required BuildContext context,
    required Store<AppState> store,
    required BoxConstraints constraints,
  }) {
    return AppScaffold(title: 'Print Last Receipt', body: scaffoldBody());
  }

  Widget loadingScaffold() {
    return const AppScaffold(body: AppProgressIndicator());
  }

  Widget scaffoldBody() {
    return Container(
      color: Theme.of(context).extension<AppliedSurface>()!.primary,
      child: const AppProgressIndicator(),
    );
  }
}
