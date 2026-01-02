import 'package:flutter/material.dart';
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_core/logging/services/logger_service.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/features/pos/data/data_source/pos_service.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_payments/managers/payments_manager.dart';
import 'package:littlefish_payments/models/shared/payment_gateway.dart';

import '../../../../common/presentaion/components/app_progress_indicator.dart';
import '../../../../common/presentaion/components/dialogs/common_dialogs.dart';
import '../../../../common/presentaion/components/icon_text_tile.dart';
import '../../../../injector.dart';

LoggerService _logger = LittleFishCore.instance.get<LoggerService>();

class MoreActionsPrintLastReceipt extends StatefulWidget {
  static const route = 'more_actions_print_last_receipt';
  const MoreActionsPrintLastReceipt({Key? key}) : super(key: key);

  @override
  State<MoreActionsPrintLastReceipt> createState() =>
      _MoreActionsPrintLastReceiptState();
}

class _MoreActionsPrintLastReceiptState
    extends State<MoreActionsPrintLastReceipt> {
  @override
  Widget build(BuildContext context) {
    return IconTextTile(
      icon: Icon(
        Icons.receipt_long_outlined,
        color: Theme.of(context).extension<AppliedTextIcon>()?.secondary,
      ),
      text: context.paragraphMedium('Print Last Card Receipt'),
      onTap: () async {
        if (AppVariables.hasPrinter &&
            cardPaymentRegistered == CardPaymentRegistered.pos) {
          showPopupDialog(
            context: context,
            content: FutureBuilder<PaymentPrintResult?>(
              future: _printLastReceipt(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const AppProgressIndicator();
                }

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
                    });
                    Navigator.pop(context);
                    return const SizedBox.shrink();
                  }

                  final result = snapshot.data!;
                  if (result.isSuccess) {
                    WidgetsBinding.instance.addPostFrameCallback(
                      (_) async => await showMessageDialog(
                        context,
                        'Last Receipt Printed Successfully',
                        Icons.done,
                      ),
                    );
                    Navigator.pop(context); //Close dialog
                    Navigator.pop(context); //Close Bottom sheet
                    return const AppProgressIndicator();
                  } else {
                    WidgetsBinding.instance.addPostFrameCallback((_) async {
                      await showMessageDialog(
                        context,
                        'Failed to print last card receipt:\nReason: ${result.statusDescription}',
                        LittleFishIcons.info,
                      );
                    });
                    Navigator.pop(context);
                    return const SizedBox.shrink();
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

  Future<PaymentPrintResult?> _printLastReceipt() async {
    final result = PaymentManager().printPaymentReceipt(
      channel: PaymentChannel.pos,
      transactionId: '',
      merchantId: AppVariables.merchantId,
      paymentType: PaymentType.card,
      printOption: ReceiptPrintOption.printLastReceipt,
    );

    return result;
  }
}
