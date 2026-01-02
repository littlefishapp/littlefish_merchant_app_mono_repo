import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/custom_route.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/services/modal_service.dart';
import 'package:littlefish_merchant/common/presentaion/components/viewer/resource_viewer.dart';
import 'package:littlefish_merchant/features/paywall/data/data_source/paywall_configuration.dart';
import 'package:littlefish_merchant/features/paywall/domain/entities/paywall_activiation.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_merchant/models/enums.dart';

class PaywallDialog {
  late PaywallActivation configSettings;
  final void Function(BuildContext tapContext) onAccept;
  final void Function(BuildContext tapContext) onCancel;
  final String ldFlag;

  PaywallDialog({
    required this.onAccept,
    required this.onCancel,
    required this.ldFlag,
  }) {
    configSettings = PaywallConfiguration().getActivationUIData(ldFlag: ldFlag);
  }

  Future<void> showActivationDialog(BuildContext context) async {
    final result = await getIt<ModalService>().showActionModal(
      context: context,
      title: configSettings.title,
      acceptText: 'ACCEPT',
      cancelText: 'CANCEL',
      description: configSettings.summaryText,
      status: StatusType.defaultStatus,
      customWidget: customWidget(context),
    );
    if (context.mounted) {
      if (result == true) {
        onAccept(context);
      } else if (result == false) {
        onCancel(context);
      }
    }
  }

  Widget customWidget(BuildContext context) {
    final brandColor = Theme.of(context).extension<AppliedTextIcon>()?.brand;
    final secondaryColor = Theme.of(
      context,
    ).extension<AppliedTextIcon>()?.secondary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Icon(
            //   Icons.monetization_on_outlined,
            //   color: brandColor,
            // ),
            // const SizedBox(width: 16),
            Flexible(
              child: context.paragraphLarge(
                configSettings.pricingInformation,
                color: brandColor,
                isBold: true,
                alignLeft: true,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: context.paragraphMedium(
            configSettings.tapDescriptionText,
            color: secondaryColor,
            isSemiBold: false,
            alignLeft: true,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: InkWell(
            onTap: () async {
              Navigator.of(context).push(
                CustomRoute(
                  builder: (ctx) => ResourceViewer(
                    url: configSettings.termsUrl,
                    title: 'Terms and Conditions',
                    isAsset: false,
                  ),
                ),
              );
            },
            child: context.paragraphMedium(
              configSettings.termsLinkText,
              color: brandColor,
              isSemiBold: true,
              isUnderLined: true,
              alignLeft: true,
              decorationColor: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
