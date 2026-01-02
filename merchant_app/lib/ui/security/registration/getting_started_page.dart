// flutter imports
import 'package:flutter/material.dart';

// package imports
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/custom_route.dart';

// project imports
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/security/login/viewmodels/login_viewmodel.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/ui/security/registration/merchant_identifier_page.dart';

import '../../../app/theme/applied_system/applied_text_icon.dart';
import '../../../common/presentaion/pages/scaffolds/app_scaffold.dart';

class GettingStartedPage extends StatelessWidget {
  final String merchantId;

  const GettingStartedPage({required this.merchantId, Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, RegisterVM?>(
      converter: (store) => RegisterVM.fromStore(store),
      builder: (context, vm) {
        return AppScaffold(
          title: 'Getting Started',
          centreTitle: false,
          persistentFooterButtons: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ButtonPrimary(
                text: 'Get Started',
                onTap: (context) async {
                  Navigator.of(context).push(
                    CustomRoute(
                      builder: (ctx) =>
                          MerchantIdentifierPage(merchantId: merchantId),
                    ),
                  );
                },
              ),
            ),
          ],
          body: vm?.isLoading == true
              ? const AppProgressIndicator()
              : layout(context, vm!),
        );
      },
    );
  }

  Widget layout(BuildContext context, RegisterVM vm) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 80),
          child: Center(
            child: context.headingXSmall(
              'To register and begin,\nplease ensure you have the\nfollowing ready',
              isSemiBold: true,
              color: Theme.of(context).extension<AppliedTextIcon>()?.emphasized,
            ),
          ),
        ),
        const SizedBox(height: 56),
        Padding(
          padding: const EdgeInsets.only(left: 24, bottom: 4),
          child: context.labelSmall(
            '1. Merchant Number',
            alignLeft: true,
            isBold: true,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 20, bottom: 24),
          child: context.paragraphMedium(
            "Gather your Merchant Number. You'll need this information to proceed with the registration.",
            alignLeft: true,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 24, bottom: 4),
          child: context.labelSmall(
            '2. Ownership Confirmation',
            alignLeft: true,
            isBold: true,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 16),
          child: context.paragraphMedium(
            'Ensure that you are the owner who completed the application form. You should also have access to the mobile number or email address provided during the application process',
            alignLeft: true,
          ),
        ),
      ],
    );
  }
}
