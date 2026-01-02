import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/icon_text_tile.dart';

import '../../../../redux/product/product_actions.dart';

class MoreActionsRefreshProducts extends StatelessWidget {
  const MoreActionsRefreshProducts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconTextTile(
      icon: Icon(
        Icons.sync,
        color: Theme.of(context).extension<AppliedTextIcon>()?.secondary,
      ),
      text: context.paragraphMedium('Refresh Products'),
      onTap: () async {
        AppVariables.store!.dispatch(initializeProductState(refresh: true));
        Navigator.of(context).pop();
      },
    );
  }
}
