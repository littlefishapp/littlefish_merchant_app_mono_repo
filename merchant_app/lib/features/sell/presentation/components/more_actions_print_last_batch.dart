import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/features/pos/data/data_source/pos_service.dart';
import 'package:littlefish_payments/models/shared/payment_gateway.dart';
import 'package:littlefish_icons/littlefish_icons.dart';

import '../../../../common/presentaion/components/app_progress_indicator.dart';
import '../../../../common/presentaion/components/dialogs/common_dialogs.dart';
import '../../../../common/presentaion/components/icon_text_tile.dart';
import '../../../../injector.dart';

class MoreActionsPrintLastBatch extends StatefulWidget {
  const MoreActionsPrintLastBatch({Key? key}) : super(key: key);

  @override
  State<MoreActionsPrintLastBatch> createState() =>
      _MoreActionsPrintLastBatchState();
}

class _MoreActionsPrintLastBatchState extends State<MoreActionsPrintLastBatch> {
  @override
  Widget build(BuildContext context) {
    return IconTextTile(
      icon: Icon(
        Icons.receipt_long_outlined,
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.7),
      ),
      text: context.paragraphMedium('Print Last Batch Report'),
      onTap: () async {
        if (cardPaymentRegistered == CardPaymentRegistered.pos) {
          showPopupDialog(
            context: context,
            content: FutureBuilder<PaymentPrintResult?>(
              future: _printLastBatchReport(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const AppProgressIndicator();
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    WidgetsBinding.instance.addPostFrameCallback((_) async {
                      await showMessageDialog(
                        context,
                        'Failed to print last batch report:\nReason: ${snapshot.error}',
                        LittleFishIcons.info,
                      );
                      Navigator.pop(context);
                    });
                    return const SizedBox.shrink();
                  }
                  if (!snapshot.hasData) {
                    WidgetsBinding.instance.addPostFrameCallback((_) async {
                      await showMessageDialog(
                        context,
                        'Failed to print last batch report:\nReason: '
                        'No response from the device',
                        LittleFishIcons.info,
                      );
                    });

                    Navigator.pop(context);
                  }

                  final result = snapshot.data!;

                  if (result.isSuccess) {
                    WidgetsBinding.instance.addPostFrameCallback((_) async {
                      await showMessageDialog(
                        context,
                        'Batch report printed successfully',
                        LittleFishIcons.info,
                      );
                    });
                    Navigator.pop(context); //Close dialog
                    Navigator.pop(context); //Close Bottom sheet

                    return const AppProgressIndicator();
                  } else {
                    WidgetsBinding.instance.addPostFrameCallback((_) async {
                      await showMessageDialog(
                        context,
                        'Failed to print last batch report:\nReason: '
                        '${result.statusDescription}',
                        LittleFishIcons.info,
                      );
                    });

                    Navigator.pop(context);
                  }
                }
                return const AppProgressIndicator();
              },
            ),
          );
        }
      },
    );
  }

  Future<PaymentPrintResult?> _printLastBatchReport() async {
    PosService paymentService = PosService.fromStore(store: AppVariables.store);
    return paymentService.reprintBatch(option: BatchPrintOption.previousBatch);
  }
}
