import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/ui/checkout/sell_page.dart';
import 'package:littlefish_icons/littlefish_icons.dart';

import '../../../../app/custom_route.dart';

class DeleteAccountPage extends StatelessWidget {
  static const String route = 'settings/delete-account';
  const DeleteAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return scaffold(context);
  }

  Widget scaffold(BuildContext context) {
    final isTablet = EnvironmentProvider.instance.isLargeDisplay ?? false;
    final showSideNav =
        isTablet || (AppVariables.store!.state.enableSideNavDrawer ?? false);
    return AppScaffold(
      title: 'Delete Account',
      enableProfileAction: !showSideNav,
      hasDrawer: false,
      displayNavDrawer: false,
      body: layout(context),
      persistentFooterButtons: [
        Center(
          child: ButtonPrimary(
            onTap: (_) async {
              Navigator.of(context).pushReplacement(
                CustomRoute(
                  builder: (BuildContext context) => const SellPage(),
                ),
              );
            },
            text: 'Home',
          ),
        ),
      ],
    );
  }

  Widget layout(BuildContext context) => Scrollbar(
    thumbVisibility: true,
    child: SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    border: Border.all(color: Colors.red, width: 1),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            LittleFishIcons.warning,
                            color: Colors.red,
                            size: 28,
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                context.labelLarge(
                                  'Delete ${AppVariables.store?.state.appName ?? ''}',
                                  isBold: true,
                                  color: Theme.of(
                                    context,
                                  ).extension<AppliedTextIcon>()?.emphasized,
                                ),
                                const SizedBox(height: 8.0),
                                context.labelMedium(
                                  '• Deleting your ${AppVariables.store?.state.appName ?? ''} account will remove access to business tools and app data.',
                                  isBold: false,
                                  alignLeft: true,
                                  color: Theme.of(
                                    context,
                                  ).extension<AppliedTextIcon>()?.emphasized,
                                ),
                                const SizedBox(height: 8.0),
                                context.labelMedium(
                                  '• Deleting your ${AppVariables.store?.state.appName ?? ''}  account does not affect your Merchant Facility or other ${AppVariables.store?.state.organizationName ?? ''} products. Manage or cancel these through your banking channels if needed.',
                                  isBold: false,
                                  alignLeft: true,
                                  color: Theme.of(
                                    context,
                                  ).extension<AppliedTextIcon>()?.emphasized,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24.0),
                context.labelMedium(
                  'Before you proceed',
                  isBold: true,
                  color: Theme.of(
                    context,
                  ).extension<AppliedTextIcon>()?.emphasized,
                ),
                const SizedBox(height: 8.0),
                context.labelMedium(
                  '• Ensure all your transactions are banked.\n'
                  '• Some of your data may be retained for legal or regulatory purposes.',
                  isBold: false,
                  alignLeft: true,
                  color: Theme.of(
                    context,
                  ).extension<AppliedTextIcon>()?.emphasized,
                ),
                const SizedBox(height: 16.0),
                context.labelMedium(
                  'Steps to delete your account',
                  isBold: true,
                  color: Theme.of(
                    context,
                  ).extension<AppliedTextIcon>()?.emphasized,
                ),
                const SizedBox(height: 8.0),
                context.labelMedium(
                  '1. Contact Support\n'
                  'Contact support on email ${AppVariables.store?.state.clientSupportEmail ?? ''} or call ${AppVariables.store?.state.clientSupportMobileNumber ?? ''}.\n\n'
                  '2. Verify Your Identity\n'
                  'Please provide us with your merchant number and registered email address when emailing or contacting our support team.\n\n'
                  '3. Account Deletion\n'
                  'Once verified, your account will be permanently deleted in line with our privacy policy.',
                  isBold: false,
                  alignLeft: true,
                  color: Theme.of(
                    context,
                  ).extension<AppliedTextIcon>()?.emphasized,
                ),
                const SizedBox(height: 16.0),
                context.labelMedium(
                  'Need help? Contact us anytime for assistance.\n'
                  '${AppVariables.store?.state.clientSupportMobileNumber ?? ''} or email ${AppVariables.store?.state.clientSupportEmail ?? ''}',
                  isBold: false,
                  alignLeft: true,
                  color: Theme.of(
                    context,
                  ).extension<AppliedTextIcon>()?.emphasized,
                ),
                const SizedBox(height: 24.0),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
