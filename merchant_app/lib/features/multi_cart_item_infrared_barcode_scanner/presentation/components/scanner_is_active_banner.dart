import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';

import '../../../../app/theme/applied_system/applied_informational.dart';

class ScannerIsActiveBanner extends StatelessWidget {
  const ScannerIsActiveBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).extension<AppliedInformational>()?.successSurface,
        border: Border.all(
          style: BorderStyle.solid,
          color:
              Theme.of(
                context,
              ).extension<AppliedInformational>()?.successBorder ??
              Colors.red,
        ),
      ),
      child: Center(
        child: context.labelSmall(
          'Barcode scanning is currently active.',
          color: Theme.of(
            context,
          ).extension<AppliedInformational>()?.successText,
        ),
      ),
    );
  }
}
