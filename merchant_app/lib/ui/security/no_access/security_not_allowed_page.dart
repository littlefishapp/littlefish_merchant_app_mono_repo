// Flutter imports:
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';

// Project imports:
import 'package:littlefish_merchant/ui/home/home_page.dart';
import 'package:littlefish_merchant/common/presentaion/components/circle_gradient_avatar.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';

import '../../../app/theme/applied_system/applied_text_icon.dart';

class SecurityNotAllowedPage extends StatelessWidget {
  static const String route = '/security-not-allowed';

  const SecurityNotAllowedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppSimpleAppScaffold(
      displayAppBar: false,
      body: Stack(
        children: <Widget>[centerNoAccess(context), buttonActions(context)],
      ),
      title: '',
    );
  }

  Container centerNoAccess(BuildContext context) => Container(
    alignment: Alignment.center,
    child: OutlineGradientAvatar(
      colors: [
        Theme.of(context).colorScheme.error,
        Theme.of(context).colorScheme.primary,
      ],
      radius: 136.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.do_not_disturb,
            size: 128.0,
            color: Theme.of(context).extension<AppliedTextIcon>()?.warning,
          ),
          context.labelLarge("You're not supposed to be here"),
        ],
      ),
    ),
  );

  Container buttonActions(BuildContext context) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 8.0),
    alignment: Alignment.bottomCenter,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        ButtonPrimary(
          buttonColor: Theme.of(context).colorScheme.primary,
          text: 'back to safety',
          onTap: (context) => Navigator.of(context).pushNamedAndRemoveUntil(
            HomePage.route,
            ModalRoute.withName(HomePage.route),
          ),
        ),
      ],
    ),
  );
}
