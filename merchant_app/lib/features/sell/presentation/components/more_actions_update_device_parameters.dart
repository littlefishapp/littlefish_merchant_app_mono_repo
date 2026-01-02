import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/features/pos/data/data_source/pos_service.dart';

import '../../../../common/presentaion/components/app_progress_indicator.dart';
import '../../../../common/presentaion/components/dialogs/common_dialogs.dart';
import '../../../../common/presentaion/components/icon_text_tile.dart';

class MoreActionsUpdateDeviceParameters extends StatefulWidget {
  const MoreActionsUpdateDeviceParameters({Key? key}) : super(key: key);

  @override
  State<MoreActionsUpdateDeviceParameters> createState() =>
      _MoreActionsUpdateDeviceParameters();
}

class _MoreActionsUpdateDeviceParameters
    extends State<MoreActionsUpdateDeviceParameters> {
  @override
  Widget build(BuildContext context) {
    return IconTextTile(
      icon: Icon(
        Icons.settings,
        color: Theme.of(context).extension<AppliedTextIcon>()?.secondary,
      ),
      text: context.paragraphMedium('Update Device Parameters'),
      onTap: () async {
        Navigator.of(context).pop();
        showPopupDialog(
          context: context,
          content: FutureBuilder<bool>(
            future: PosService.fromStore(
              store: AppVariables.store,
            ).updateDeviceParameters(),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const AppProgressIndicator();
              }
              if (snapshot.hasError) {
                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  await showMessageDialog(
                    context,
                    'Failed to update device parameters:\nReason: ${snapshot.error}',
                    Icons.cancel,
                  );
                  Navigator.of(context).pop();
                });
                return const SizedBox.shrink();
              }
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData && snapshot.data == true) {
                  WidgetsBinding.instance.addPostFrameCallback((_) async {
                    await showMessageDialog(
                      context,
                      'Device parameters updated successfully',
                      Icons.done,
                    );
                    Navigator.of(context).pop();
                  });
                } else {
                  WidgetsBinding.instance.addPostFrameCallback((_) async {
                    await showMessageDialog(
                      context,
                      'Failed to update device parameters',
                      Icons.cancel,
                    );
                    Navigator.of(context).pop();
                  });
                }
                return const SizedBox.shrink();
              }
              return const AppProgressIndicator();
            },
          ),
        );
      },
    );
  }
}
