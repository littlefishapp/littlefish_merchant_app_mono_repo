import 'package:flutter/material.dart';
import 'package:littlefish_merchant/ui/social_media/Widgets/instagram/instagram_shopping_approval_page.dart';
import 'package:littlefish_merchant/ui/social_media/Widgets/instagram/convert_instagram_page.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../../common/presentaion/pages/scaffolds/app_scaffold.dart';
import '../../../../common/presentaion/components/common_divider.dart';

class InstagramShoppingStorePage extends StatefulWidget {
  final bool showBackButton;

  const InstagramShoppingStorePage({Key? key, this.showBackButton = false})
    : super(key: key);

  @override
  State<InstagramShoppingStorePage> createState() =>
      _InstagramShoppingStorePage();
}

class _InstagramShoppingStorePage extends State<InstagramShoppingStorePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return scaffoldMobile(context);
  }

  AppScaffold scaffoldMobile(context) => AppScaffold(
    title: 'Instagram Store',
    hasDrawer: !widget.showBackButton,
    body: Column(
      children: [
        ListTile(
          tileColor: Theme.of(context).colorScheme.background,
          title: const Text(
            'Set Up Instagram Store Tutorial',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        CommonDivider(color: Colors.grey.shade300),
        quickAction(
          'Setting Instagram to a Business Account',
          Icon(
            MdiIcons.tagMultiple,
            color: Theme.of(context).colorScheme.secondary,
            // size: 54,
          ),
          () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => AppScaffold(
                title: 'Step 1',
                hasDrawer: !widget.showBackButton == true,
                body: const SingleChildScrollView(
                  child: ConvertInstagramPage(),
                ),
              ),
            ),
          ),
        ),
        CommonDivider(color: Colors.grey.shade300),
        quickAction(
          'Requesting Approval for Instagram Shopping',
          Icon(
            MdiIcons.tagMultiple,
            color: Theme.of(context).colorScheme.secondary,
            // size: 54,
          ),
          () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => AppScaffold(
                title: 'Step 2',
                hasDrawer: !widget.showBackButton == true,
                body: const SingleChildScrollView(
                  child: InstagramShoppingApprovalPage(),
                ),
              ),
            ),
          ),
        ),
        CommonDivider(color: Colors.grey.shade300),
      ],
    ),
  );

  ListTile quickAction(
    String title,
    Widget child,
    Function onTap, {
    String? subtitle,
  }) => ListTile(
    tileColor: Theme.of(context).colorScheme.background,
    trailing: const Icon(Icons.chevron_right),
    subtitle: subtitle != null ? Text(subtitle) : null,
    onTap: () {
      onTap();
    },
    title: Text(title),
  );
}
