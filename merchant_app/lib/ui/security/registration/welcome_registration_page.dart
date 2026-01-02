import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/custom_route.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/banner_panel.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/ui/security/registration/gettng_started_page_v2.dart';
import 'package:littlefish_merchant/ui/security/registration/widgets/welcome_feature_item.dart';

class WelcomeScreen extends StatelessWidget {
  final String merchantId;

  const WelcomeScreen({super.key, required this.merchantId});
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      enableProfileAction:
          !(EnvironmentProvider.instance.isLargeDisplay ?? false),
      title: 'Registration',
      backgroundColor: Colors.white,
      persistentFooterButtons: [
        ButtonPrimary(
          onTap: (_) {
            Navigator.of(context).push(
              CustomRoute(
                builder: (BuildContext context) {
                  return GettingStartedPageV2(merchantId: merchantId);
                },
              ),
            );
          },
          text: 'Start Registration',
        ),
      ],
      body: layout(context),
    );
  }

  Widget layout(BuildContext context) {
    if (EnvironmentProvider.instance.isLargeDisplay!) {
      return Row(
        children: [
          const Expanded(child: BannerPanel()),
          Expanded(
            child: Center(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: 376,
                  maxHeight: MediaQuery.of(context).size.height * 0.9,
                ),
                child: Material(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.white,
                  elevation: 1,
                  child: mobileLayout(context),
                ),
              ),
            ),
          ),
        ],
      );
    }
    return SingleChildScrollView(child: mobileLayout(context));
  }

  Widget mobileLayout(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            context.headingXSmall('Welcome to Simply', alignLeft: true),
            context.headingXSmall('BLU', isBold: true, alignLeft: true),
          ],
        ),
        const SizedBox(height: 8),
        context.labelXSmall(
          'You’re joining thousands businesses that have taken their enterprises to the next level. ',
          maxLines: 4,
          overflow: TextOverflow.visible,
          alignLeft: true,
          alignRight: false,
        ),
        const SizedBox(height: 24),
        WelcomeFeatureItem(
          context: context,
          icon: Icons.home,
          title: 'Home',
          description:
              'Get an overview of all the parts of your business and take action.',
        ),
        const SizedBox(height: 8),
        WelcomeFeatureItem(
          context: context,
          icon: Icons.inventory,
          title: 'Stock',
          description:
              'Effortlessly track products and stock levels to meet customer demands.',
        ),
        const SizedBox(height: 8),
        WelcomeFeatureItem(
          context: context,
          icon: Icons.store,
          title: 'Shop',
          description:
              'Customise and manage your shop\'s details to create a unique storefront.',
        ),
        const SizedBox(height: 8),
        WelcomeFeatureItem(
          context: context,
          icon: Icons.settings,
          title: 'Manage',
          description:
              'Manage your account in every way that counts for you and your business.',
        ),
        const SizedBox(height: 8),
      ],
    ),
  );
}
