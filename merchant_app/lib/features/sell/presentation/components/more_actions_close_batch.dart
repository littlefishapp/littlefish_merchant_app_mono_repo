import 'package:flutter/material.dart';
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_core/logging/services/logger_service.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/icon_text_tile.dart';
import 'package:littlefish_merchant/features/pos/data/data_source/pos_service.dart';
import 'package:littlefish_payments/models/shared/payment_gateway.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_payments/models/shared/payment_result.dart';

import '../../../../common/presentaion/components/app_progress_indicator.dart';
import '../../../../common/presentaion/components/dialogs/common_dialogs.dart';

LoggerService _logger = LittleFishCore.instance.get<LoggerService>();

class MoreActionsCloseBatch extends StatelessWidget {
  const MoreActionsCloseBatch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconTextTile(
      icon: Icon(
        Icons.receipt_long,
        color: Theme.of(context).extension<AppliedTextIcon>()?.secondary,
      ),
      text: context.paragraphMedium('Close Batch'),
      onTap: () async {
        Navigator.of(context).pop();
        showPopupDialog(
          context: context,
          content: FutureBuilder<SettlementResult>(
            future: PosService.fromStore(
              store: AppVariables.store,
            ).closeBatch(),
            builder:
                (
                  BuildContext context,
                  AsyncSnapshot<SettlementResult> snapshot,
                ) {
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
                        );
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      });
                    } else {
                      final result = snapshot.data!;

                      if (result.paymentStatus == PaymentStatus.processed) {
                        WidgetsBinding.instance.addPostFrameCallback(
                          (_) => showMessageDialog(
                            context,
                            'Batch Close Successful',
                            Icons.done,
                          ).then((value) => Navigator.of(context).pop()),
                        );
                      } else {
                        WidgetsBinding.instance.addPostFrameCallback(
                          (_) => showMessageDialog(
                            context,
                            'Batch Close Unsuccessful\n${result.statusDescription}',
                            Icons.cancel,
                          ).then((value) => Navigator.of(context).pop()),
                        );
                      }
                    }
                  }

                  return const AppProgressIndicator();
                },
          ),
        );
      },
    );
  }
}
