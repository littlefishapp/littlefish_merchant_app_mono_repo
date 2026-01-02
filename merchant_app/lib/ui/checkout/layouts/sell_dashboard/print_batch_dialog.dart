import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_core/logging/services/logger_service.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/features/pos/data/data_source/pos_service.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_payments/models/shared/payment_gateway.dart';
import 'package:redux/redux.dart';

LoggerService _logger = LittleFishCore.instance.get<LoggerService>();

class PrintBatchDialogue extends StatefulWidget {
  static const route = '/print-batch-dialogue';
  final String batchNumber;
  const PrintBatchDialogue({super.key, this.batchNumber = ''});

  @override
  State<PrintBatchDialogue> createState() => _PrintBatchDialogueState();
}

class _PrintBatchDialogueState extends State<PrintBatchDialogue> {
  var isTablet = false;
  late final Future<PaymentPrintResult> _printFuture;

  @override
  void initState() {
    super.initState();
    _printFuture = printBatch();
  }

  Future<PaymentPrintResult> printBatch() async {
    debugPrint('#### PrintBatchDialogue: printBatch entry');

    PosService paymentService = PosService.fromStore(store: AppVariables.store);
    final result = await paymentService.reprintBatch(
      batchNumber: widget.batchNumber,
      option: BatchPrintOption.previousBatch,
    );
    debugPrint('#### PrintBatchDialogue: futureAction result: $result');
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
                  '#### PrintBatchDialogue: '
                  '${snapshot.connectionState}',
                );
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError || snapshot.data == null) {
                    if (snapshot.hasError) {
                      _logger.error(
                        'PrintBatchDialogue',
                        'PrintBatchDialogue error',
                        error: snapshot.error,
                      );
                    } else {
                      _logger.error(
                        'PrintBatchDialogue',
                        'PrintBatchDialogue: No data was returned when '
                            'attempting to print the last card receipt.',
                      );
                    }
                    WidgetsBinding.instance.addPostFrameCallback((_) async {
                      await showMessageDialog(
                        context,
                        'Unable to print the batch, please try again.',
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
                          'Batch Printed Successfully',
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
                          'Failed to print the batch:\nReason: '
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
    return AppScaffold(title: 'Print Batch', body: scaffoldBody());
  }

  Widget tabletScaffold({
    required BuildContext context,
    required Store<AppState> store,
    required BoxConstraints constraints,
  }) {
    return AppScaffold(title: 'Print Batch', body: scaffoldBody());
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
