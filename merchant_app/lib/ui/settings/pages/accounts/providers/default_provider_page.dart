import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';

class DefaultProviderPage extends StatelessWidget {
  const DefaultProviderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      displayBackNavigation: true,
      displayNavDrawer: false,
      enableProfileAction: false,
      persistentFooterButtons: [
        ButtonPrimary(
          text: 'Back',
          onTap: (context) async {
            Navigator.of(context).pop();
          },
        ),
      ],
      title: 'Linked Account Not Available',
      centreTitle: false,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: context.paragraphMedium(
            'This provider is not available right now.',
            maxLines: 3,
          ),
        ),
      ),
    );
  }
}
