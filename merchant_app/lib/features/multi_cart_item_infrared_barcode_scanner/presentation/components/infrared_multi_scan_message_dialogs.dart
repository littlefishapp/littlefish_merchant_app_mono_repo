import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/services/modal_service.dart';
import 'package:littlefish_merchant/injector.dart';

import '../../../../common/presentaion/components/dialogs/common_dialogs.dart';

class InfraredMultiScanMessageDialogs {
  static Future<bool?> productNotFoundDialog(BuildContext context) async {
    return await showCustomMessageDialog(
      title: 'Product not found',
      context: context,
      buttonText: 'Return to Scanning',
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text.rich(
            textAlign: TextAlign.center,
            TextSpan(
              children: [
                TextSpan(
                  text: 'Product not found, please add product manually first.',
                  style: context.styleParagraphMediumBold,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Future<bool?> cancelScanDialog(BuildContext context) async {
    return await getIt<ModalService>().showActionModal(
      context: context,
      title: 'Cancel Scan',
      description: 'Are you sure you want to cancel the scan?',
    );
  }

  static Future<bool?> clearItemsDialog(BuildContext context) async {
    return await getIt<ModalService>().showActionModal(
      context: context,
      title: 'Clear items',
      description: 'Would you like to clear scanned items?',
    );
  }
}
