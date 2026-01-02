import 'package:flutter/material.dart';
import 'package:littlefish_merchant/ui/social_media/Widgets/facebook/integrate_products_page.dart';
import 'package:littlefish_merchant/ui/social_media/Widgets/facebook/setup_fb_shop_page.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../../common/presentaion/pages/scaffolds/app_scaffold.dart';
import '../../../../common/presentaion/components/common_divider.dart';
import 'create_fb_business_page.dart';
import 'verify_domain_page.dart';

class FacebookShoppingStorePage extends StatefulWidget {
  final bool showBackButton;

  const FacebookShoppingStorePage({Key? key, this.showBackButton = false})
    : super(key: key);

  @override
  State<FacebookShoppingStorePage> createState() =>
      _FacebookShoppingStorePage();
}

class _FacebookShoppingStorePage extends State<FacebookShoppingStorePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return scaffoldMobile(context);
  }

  AppScaffold scaffoldMobile(BuildContext context) => AppScaffold(
    title: 'Facebook Store',
    hasDrawer: !widget.showBackButton,
    body: Column(
      children: [
        ListTile(
          tileColor: Theme.of(context).colorScheme.background,
          title: const Text(
            'Set Up Facebook Store Tutorial',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        CommonDivider(color: Colors.grey.shade300),
        quickAction(
          'Creating a Facebook Businness Page',
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
                body: SingleChildScrollView(child: CreateFBBusinessPage()),
              ),
            ),
          ),
        ),
        CommonDivider(color: Colors.grey.shade300),
        quickAction(
          'Setting a Shop on Your Facebook Business Page',
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
                body: const SingleChildScrollView(child: SetupFBShop()),
              ),
            ),
          ),
        ),
        CommonDivider(color: Colors.grey.shade300),
        quickAction(
          'Integrating your LittleFish Products with Facebook Business',
          Icon(
            MdiIcons.tagMultiple,
            color: Theme.of(context).colorScheme.secondary,
            // size: 54,
          ),
          () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => AppScaffold(
                title: 'Step 3',
                hasDrawer: !widget.showBackButton == true,
                body: SingleChildScrollView(child: IntegrateProductsPage()),
              ),
            ),
          ),
        ),
        CommonDivider(color: Colors.grey.shade300),
        quickAction(
          'Veryfying Your Domain to Prevent Issues on Instagram',
          Icon(
            MdiIcons.tagMultiple,
            color: Theme.of(context).colorScheme.secondary,
            // size: 54,
          ),
          () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => AppScaffold(
                title: 'Step 4',
                hasDrawer: !widget.showBackButton == true,
                body: SingleChildScrollView(child: VerifyDomainPage()),
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
