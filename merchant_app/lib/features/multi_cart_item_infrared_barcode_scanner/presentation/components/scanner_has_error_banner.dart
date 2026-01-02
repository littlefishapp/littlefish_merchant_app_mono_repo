import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';

import '../../../../app/theme/applied_system/applied_informational.dart';
import '../../../../common/presentaion/components/buttons/button_text.dart';

class ScannerHasErrorBanner extends StatelessWidget {
  final VoidCallback? retryCallback;

  const ScannerHasErrorBanner({this.retryCallback, super.key});

  @override
  Widget build(BuildContext context) {
    final textWidth = MediaQuery.of(context).size.width * 0.6;
    final controlWidth = MediaQuery.of(context).size.width * 0.2;
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).extension<AppliedInformational>()?.errorSurface,
        border: Border.all(
          style: BorderStyle.solid,
          color:
              Theme.of(
                context,
              ).extension<AppliedInformational>()?.errorBorder ??
              Colors.red,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: textWidth,
            child: context.labelMedium(
              'Barcode scanning failed',
              color: Theme.of(
                context,
              ).extension<AppliedInformational>()?.errorIcon,
              alignLeft: true,
            ),
          ),
          SizedBox(
            height: 50,
            width: controlWidth,
            child: ButtonText(
              isNegative: true,
              text: 'Retry',
              widgetOnBrandedSurface: true,
              onTap: (BuildContext context) {
                if (retryCallback != null) retryCallback!();
              },
            ),
          ),
        ],
      ),
    );
  }
}
