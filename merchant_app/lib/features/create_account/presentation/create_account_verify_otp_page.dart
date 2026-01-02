// flutter imports
// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/bootstrap.dart';

// package imports

// project imports
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/string_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/app/theme/ui_state_data.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/business/profile/pages/business_profile_create_page.dart';
import 'package:littlefish_merchant/ui/online_store/shared/routes/custom_route.dart';
import 'package:littlefish_merchant/ui/profile/user/pages/user_profile_create_page.dart';
import 'package:littlefish_merchant/ui/security/login/viewmodels/login_viewmodel.dart';

class CreateAccountPageVerifyOTP extends StatefulWidget {
  static const route = '/create_account_page_verify_otp';
  final bool createUser;
  final bool createBusiness;

  const CreateAccountPageVerifyOTP({
    Key? key,
    required this.createUser,
    required this.createBusiness,
  }) : super(key: key);

  @override
  State<CreateAccountPageVerifyOTP> createState() =>
      _CreateAccountPageVerifyOTPState();
}

class _CreateAccountPageVerifyOTPState
    extends State<CreateAccountPageVerifyOTP> {
  final _formKey = GlobalKey<FormState>();
  late String? _otp;

  @override
  void initState() {
    _otp = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, RegisterVM>(
      converter: (store) => RegisterVM.fromStore(store)..key = _formKey,
      builder: (c, vm) {
        return AppScaffold(
          displayBackNavigation: false,
          displayNavDrawer: false,
          enableProfileAction: false,
          persistentFooterButtons: [
            ButtonPrimary(
              text: 'Next',
              onTap: (context) async {
                await verifyOtp(
                  vm,
                  context,
                  widget.createUser,
                  widget.createBusiness,
                );
              },
            ),
          ],
          title: 'OTP Verification',
          centreTitle: false,
          body: vm.isLoading == true
              ? const AppProgressIndicator()
              : SafeArea(child: form(vm)),
        );
      },
    );
  }

  Widget form(RegisterVM vm) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          children: [
            const SizedBox(height: 56),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: context.paragraphMedium(getOTPSentText()),
            ),
            const SizedBox(height: 16),
            StringFormField(
              key: const Key('otp'),
              textInputType: TextInputType.number,
              onSaveValue: (value) {
                if (mounted) {
                  setState(() {
                    _otp = value;
                  });
                }
              },
              hintText: 'Enter your OTP',
              labelText: 'One Time Pin',
              onChanged: (value) {
                if (mounted) {
                  _otp = value;
                }
              },
              useOutlineStyling: true,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: context.labelXSmall(
                'Your OTP will be valid for 10 minutes.',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: context.paragraphMedium('Didn not receive the OTP?'),
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (vm.store == null) {
                        showMessageDialog(
                          context,
                          'Something went wrong. Please try again.',
                          LittleFishIcons.error,
                        );
                        return;
                      }

                      try {
                        await sendOtp(vm, context);
                      } catch (e) {
                        showMessageDialog(
                          context,
                          'Failed to generate OTP. Please try again.',
                          LittleFishIcons.error,
                        );
                      }
                    },
                    child: context.labelSmall(
                      'Resend OTP',
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: context.labelXSmall(
                'An OTP has been sent to your registered email address. If you do not receive the email, please contact ${AppVariables.store?.state.appName ?? ''} Support at ${AppVariables.store!.state.clientSupportEmail} or ${AppVariables.store!.state.clientSupportMobileNumber}',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container logo() => Container(
    margin: const EdgeInsets.only(bottom: 20),
    alignment: Alignment.center,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(top: 40, bottom: 40),
          alignment: Alignment.center,
          height: 80,
          width: 68,
          child: Image.asset(UIStateData().appLogo, fit: BoxFit.fitHeight),
        ),
      ],
    ),
  );

  String getOTPSentText() {
    return 'An OTP has been sent to your registered email address. Please check your email and enter the code below to validate your account.';
  }

  Future<void> verifyOtp(
    RegisterVM vm,
    BuildContext ctx,
    bool createUser,
    bool createBusiness,
  ) async {
    if (_formKey.currentState!.validate()) {
      if (_otp == null || vm.store == null) {
        showMessageDialog(
          ctx,
          'Unable to verify your OTP. Please check the code and try again.',
          LittleFishIcons.error,
        );
        return;
      }
      bool result = await vm.verifyOtp(_otp ?? '');
      if (result) {
        BuildContext ctxInner = ctx;
        if (!ctxInner.mounted) {
          ctxInner = globalNavigatorKey.currentContext!;
        }

        if (ctxInner.mounted) {
          if (createUser) {
            await Navigator.of(ctxInner).push(
              CustomRoute(
                builder: (context) => UserProfilePageCreatePage(
                  isManual: true,
                  completionRoute: createBusiness
                      ? BusinessProfileCreatePage.route
                      : null,
                ),
              ),
            );
          } else if (createBusiness) {
            await Navigator.of(ctxInner).push(
              CustomRoute(
                builder: (context) => const BusinessProfileCreatePage(),
              ),
            );
          }
        }
      }
      return;
    }
  }

  Future<void> sendOtp(RegisterVM vm, BuildContext ctx) async {
    bool result = await vm.sendOtp();
    BuildContext ctxInner = ctx;
    if (!ctxInner.mounted) {
      ctxInner = globalNavigatorKey.currentContext!;
    }
    String message = 'Failed to send OTP. Please try again.';
    if (result) {
      message = 'A new OTP has been sent to your registered email address.';
    }

    if (ctxInner.mounted) {
      await showMessageDialog(ctxInner, message, LittleFishIcons.info);
    }
    return;
  }
}
