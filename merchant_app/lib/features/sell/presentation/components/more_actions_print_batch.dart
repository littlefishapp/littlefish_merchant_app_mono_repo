import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/services/modal_service.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/string_form_field.dart';
import 'package:littlefish_merchant/features/pos/data/data_source/pos_service.dart';
import 'package:littlefish_merchant/features/sell/presentation/components/select_batch_report_page.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/ui/online_store/shared/routes/custom_route.dart';
import 'package:littlefish_payments/models/shared/payment_gateway.dart';

import '../../../../common/presentaion/components/app_progress_indicator.dart';
import '../../../../common/presentaion/components/dialogs/common_dialogs.dart';
import '../../../../common/presentaion/components/icon_text_tile.dart';
import '../../../../injector.dart';

class MoreActionsPrintBatch extends StatefulWidget {
  const MoreActionsPrintBatch({Key? key}) : super(key: key);

  @override
  State<MoreActionsPrintBatch> createState() => _MoreActionsPrintBatchState();
}

class _MoreActionsPrintBatchState extends State<MoreActionsPrintBatch> {
  @override
  Widget build(BuildContext context) {
    return IconTextTile(
      icon: Icon(
        Icons.print,
        color: Theme.of(context).extension<AppliedTextIcon>()?.secondary,
      ),
      text: context.paragraphMedium('Reprint Batch'),
      onTap: () async {
        final modalService = getIt<ModalService>();
        String batchNumber = '';

        bool? isAccepted = await modalService.showActionModal(
          context: context,
          title: 'Print Batch',
          description:
              'Enter the batch you would like to reprint. If no batch is entered, the last batch will be reprinted.',
          acceptText: 'Confrim',
          cancelText: 'No, Cancel',
          status: StatusType.destructive,
          customWidget: StringFormField(
            enabled: true,
            useOutlineStyling: true,
            onSaveValue: (value) {
              batchNumber = value ?? '';
            },
            onChanged: (value) => batchNumber = value,
            hintText: 'Please Select specific batch you would like to print',
            labelText: 'Batch Number',
            initialValue: batchNumber,
          ),
        );

        if (isAccepted != true) return;

        showPopupDialog(
          context: context,
          content: FutureBuilder(
            future: PosService.fromStore(store: AppVariables.store)
                .reprintBatch(
                  batchNumber: batchNumber,
                  option: BatchPrintOption.previousBatch,
                ),
            builder:
                (
                  BuildContext context,
                  AsyncSnapshot<PaymentPrintResult> snapshot,
                ) {
                  if (snapshot.hasData) {
                    final result = snapshot.data!;

                    if (result.isSuccess) {
                      WidgetsBinding.instance.addPostFrameCallback(
                        (_) async => await showMessageDialog(
                          context,
                          'Batch Reprint Successful',
                          Icons.done,
                        ).then((value) => Navigator.of(context).pop()),
                      );
                    } else {
                      WidgetsBinding.instance.addPostFrameCallback(
                        (_) async => await showMessageDialog(
                          context,
                          'Batch Reprint Unsuccessful\n${result.statusDescription}',
                          Icons.cancel,
                        ).then((value) => Navigator.of(context).pop()),
                      );
                    }

                    Navigator.of(context).pop();
                  }
                  return const AppProgressIndicator();
                },
          ),
        );
      },
    );
  }
}
