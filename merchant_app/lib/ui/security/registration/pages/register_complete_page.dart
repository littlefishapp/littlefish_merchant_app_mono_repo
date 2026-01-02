import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_button.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/ui/checkout/sell_page.dart';
import 'package:littlefish_merchant/ui/checkout/sell_page.dart';
import 'package:littlefish_merchant/ui/online_store/shared/routes/custom_route.dart';
import 'package:littlefish_merchant/ui/security/login/login_page.dart';

class RegisterCompletePage extends StatelessWidget {
  final bool isActivation;

  const RegisterCompletePage({Key? key, required this.isActivation})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: Colors.white,
      persistentFooterButtons: [
        ButtonPrimary(
          text: 'Done',
          onTap: (ctx) {
            if (isActivation) {
              Navigator.of(
                ctx,
              ).push(CustomRoute(builder: ((context) => const LoginPage())));
            } else {
              Navigator.of(context).pushReplacement(
                CustomRoute(builder: (ctx) => const SellPage()),
              );
            }
          },
        ),
      ],
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 80,
              color:
                  (Theme.of(context).extension<AppliedButton>() ??
                          const AppliedButton())
                      .primaryActive,
            ),
            SizedBox(height: 24),
            context.headingSmall('Success!'),
            const SizedBox(height: 16),
            context.paragraphMedium(
              'Your business has been successfully registered.\n\nCheck your email for next steps to log in to your business',
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
