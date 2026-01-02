import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_informational.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';

class BarcodeProductNotFoundBanner extends StatelessWidget {
  const BarcodeProductNotFoundBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).extension<AppliedInformational>()?.warningSurface,
        border: Border.all(
          style: BorderStyle.solid,
          color:
              Theme.of(
                context,
              ).extension<AppliedInformational>()?.warningBorder ??
              Colors.red,
        ),
      ),
      child: Center(
        child: context.labelSmall(
          'Product not found in store',
          color: Theme.of(
            context,
          ).extension<AppliedInformational>()?.warningText,
        ),
      ),
    );
  }
}
