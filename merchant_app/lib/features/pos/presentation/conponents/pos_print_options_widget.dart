import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';

import '../../../../common/presentaion/components/buttons/button_primary.dart';
import '../../../../common/presentaion/components/buttons/button_secondary.dart';
import '../../../../common/presentaion/components/circle_gradient_avatar.dart';
import '../../../../models/enums.dart';
import '../pages/pos_payment_page.dart';

class PosPrintOptionsWidget extends StatelessWidget {
  const PosPrintOptionsWidget(
    List<PosPrintDisplayItem> printOptions, {
    Key? key,
  }) : _printOptions = printOptions,
       super(key: key);

  final List<PosPrintDisplayItem> _printOptions;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OutlineGradientAvatar(
          radius: MediaQuery.of(context).size.height * 0.08,
          child: Icon(
            Icons.done,
            size: MediaQuery.of(context).size.height * 0.08,
            color: Theme.of(context).extension<AppliedTextIcon>()?.brand,
          ),
        ),
        const SizedBox(height: 20),
        ..._printOptions.map(
          (e) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              e.value == PosPrintOptions.none
                  ? ButtonSecondary(
                      text: e.name,
                      onTap: (_) {
                        Navigator.pop(context, e.value);
                        return true;
                      },
                    )
                  : ButtonPrimary(
                      text: e.name,
                      onTap: (_) {
                        Navigator.pop(context, e.value);
                      },
                    ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }
}
