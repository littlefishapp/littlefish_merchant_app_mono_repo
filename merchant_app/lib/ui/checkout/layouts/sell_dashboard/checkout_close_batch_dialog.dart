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
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_payments/models/shared/payment_gateway.dart';
import 'package:littlefish_payments/models/shared/payment_result.dart';
import 'package:redux/redux.dart';

LoggerService _logger = LittleFishCore.instance.get<LoggerService>();

class CheckoutCloseBatchDialog extends StatefulWidget {
  static const route = '/checkout-close-batch-dialog';
  const CheckoutCloseBatchDialog({super.key});

  @override
  State<CheckoutCloseBatchDialog> createState() =>
      _CheckoutCloseBatchDialogState();
}

class _CheckoutCloseBatchDialogState extends State<CheckoutCloseBatchDialog> {
  var isTablet = false;
  late Future<SettlementResult> _printFuture;

  @override
  void initState() {
    super.initState();
    _printFuture = printBatch();
  }

  Future<SettlementResult> printBatch() async {
    debugPrint('### CheckoutCloseBatchDialog: futureAction entry');
    try {
      final SettlementResult result = await PosService.fromStore(
        store: AppVariables.store,
      ).closeBatch();
      debugPrint(
        '### CheckoutCloseBatchDialog: futureAction result: $result  ',
      );

      debugPrint(
        '### CheckoutCloseBatchDialog: '
        'futureAction result: $result',
      );
      return result;
    } on Exception catch (e) {
      debugPrint('### CheckoutCloseBatchDialog: futureAction $e');
    }
    return SettlementResult(
      batchId: '',
      statusCode: '',
      statusDescription: '',
      statusMessage: '',
      paymentStatus: PaymentStatus.failed,
      userId: 'userId',
      transactionId: 'transactionId',
      reference: 'reference',
    );
  }

  @override
  Widget build(BuildContext context) {
    isTablet = EnvironmentProvider.instance.isLargeDisplay ?? false;
    return StoreBuilder(
      builder: (BuildContext context, Store<AppState> store) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return FutureBuilder<SettlementResult>(
              future: _printFuture,
              builder: (context, snapshot) {
                debugPrint(
                  '#### CheckoutCloseBatchDialog: '
                  '${snapshot.connectionState}',
                );
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError || snapshot.data == null) {
                    if (snapshot.hasError) {
                      _logger.error(
                        'CloseBatchDialogue',
                        'CloseBatchDialogue error',
                        error: snapshot.error,
                      );
                    } else {
                      _logger.error(
                        'CloseBatchDialogue',
                        'CloseBatchDialogue: No data was returned',
                      );
                    }
                    WidgetsBinding.instance.addPostFrameCallback((_) async {
                      await showMessageDialog(
                        context,
                        'Unable to close the batch, please try again.',
                        LittleFishIcons.error,
                        status: StatusType.destructive,
                      );
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    });
                  } else {
                    final result = snapshot.data!;
                    if (result.paymentStatus == PaymentStatus.processed) {
                      WidgetsBinding.instance.addPostFrameCallback((_) async {
                        await showMessageDialog(
                          context,
                          'Batch Close Successful',
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
                          'Batch Close Unsuccessful\n${result.statusMessage} ',
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
    return AppScaffold(title: 'Closing Batch', body: scaffoldBody());
  }

  Widget tabletScaffold({
    required BuildContext context,
    required Store<AppState> store,
    required BoxConstraints constraints,
  }) {
    return AppScaffold(title: 'Closing Batch', body: scaffoldBody());
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
