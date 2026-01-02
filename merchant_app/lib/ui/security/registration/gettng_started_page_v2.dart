import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/toggle/term_and_condition_toggle.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/auth/auth_actions.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/ui/security/login/viewmodels/login_viewmodel.dart';

class GettingStartedPageV2 extends StatefulWidget {
  final String merchantId;
  const GettingStartedPageV2({super.key, required this.merchantId});

  @override
  State<GettingStartedPageV2> createState() => _GettingStartedPageV2State();
}

class _GettingStartedPageV2State extends State<GettingStartedPageV2> {
  bool _isTermsAndConditionsAccepted = false;

  @override
  Widget build(BuildContext context) {
    ///Todo(Brandon): Add New LD Theming
    return StoreConnector<AppState, RegisterVM?>(
      converter: (store) => RegisterVM.fromStore(store),
      builder: (context, vm) {
        return AppScaffold(
          title: 'Registration',
          body: vm!.isLoading == true
              ? const AppProgressIndicator()
              : layout(context, vm),
          persistentFooterButtons: [
            ButtonPrimary(
              disabled: !_isTermsAndConditionsAccepted,
              onTap: (ctx) async {
                try {
                  vm.store!.dispatch(
                    createActivation(merchantId: widget.merchantId),
                  );
                } catch (_) {
                  if (context.mounted) {
                    showMessageDialog(
                      context,
                      'Something went wrong, please try again.',
                      LittleFishIcons.error,
                    );
                  }
                }
              },
              text: 'Complete Registration',
            ),
          ],
        );
      },
    );
  }

  Widget layout(BuildContext context, RegisterVM? vm) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 32),
        context.headingXSmall(
          'To complete registration\nensure you are the business owner',
          alignLeft: true,
        ),
        const SizedBox(height: 16),
        context.labelXSmall(
          'You should have access to the mobile number or email address provided during the ${AppVariables.store?.state.appName ?? ''} application process to complete registration',
          maxLines: 5,
          alignLeft: true,
        ),
        const Spacer(),
        TermAndConditionToggle(
          url: AppVariables.termsAndConditions,
          isAccepted: _isTermsAndConditionsAccepted,
          onChanged: (value) {
            if (mounted) {
              setState(() {
                _isTermsAndConditionsAccepted = value;
              });
            }
          },
        ),
        const SizedBox(height: 64),
      ],
    ),
  );
}
