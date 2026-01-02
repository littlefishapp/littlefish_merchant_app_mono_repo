// flutter imports
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/bootstrap.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/footer_buttons_secondary_primary.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/features/create_account/presentation/create_account_verify_otp_page.dart';
import 'package:littlefish_merchant/ui/business/profile/pages/business_profile_create_page.dart';
import 'package:littlefish_merchant/ui/online_store/shared/routes/custom_route.dart';
import 'package:littlefish_merchant/ui/profile/user/pages/user_profile_create_page.dart';
import 'package:littlefish_merchant/ui/security/login/landing_page.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/security/login/viewmodels/login_viewmodel.dart';

class CreateAccountPage extends StatelessWidget {
  static const route = '/create_account_page';
  final bool createUser;
  final bool createBusiness;

  const CreateAccountPage({
    Key? key,
    required this.createUser,
    required this.createBusiness,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, RegisterVM>(
      converter: (store) => RegisterVM.fromStore(store),
      builder: (c, vm) {
        return AppScaffold(
          title: 'Create Account',
          centreTitle: false,
          displayBackNavigation: false,
          displayNavDrawer: false,
          enableProfileAction: false,
          persistentFooterButtons: [
            FooterButtonsSecondaryPrimary(
              primaryButtonText: 'Continue',
              secondaryButtonText: 'Go Back',
              onPrimaryButtonPressed: (ctx) async {
                bool result = await vm.sendOtp();
                if (result) {
                  BuildContext ctx = context;
                  if (!ctx.mounted) {
                    ctx = globalNavigatorKey.currentContext!;
                  }

                  if (ctx.mounted) {
                    await Navigator.of(ctx).push(
                      CustomRoute(
                        builder: (context) => CreateAccountPageVerifyOTP(
                          createBusiness: createBusiness,
                          createUser: createUser,
                        ),
                      ),
                    );
                  }
                }
                return;
              },
              onSecondaryButtonPressed: (ctx) async {
                await Navigator.of(
                  context,
                ).push(CustomRoute(builder: (context) => const LandingPage()));
              },
            ),
          ],
          body: vm.isLoading == true
              ? const AppProgressIndicator()
              : SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 56),
                        context.paragraphMedium(
                          'Some required information is missing from your account. To continue, please update your details. This helps us serve you better and ensures the security of your account. You will not be able to proceed until all required information is provided.',
                        ),
                        const SizedBox(height: 24),
                        context.labelXSmall(
                          'We will send an OTP to your registered email address to verify your changes. If you need any further support, please contact ${AppVariables.store?.state.appName ?? ''} Support at ${AppVariables.store?.state.clientSupportEmail ?? ''} or ${AppVariables.store?.state.clientSupportMobileNumber ?? ''}.',
                          maxLines: 8,
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}
