// flutter imports
// remove ignore_for_file: use_build_context_synchronously

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/app.dart';

// package imports

// project imports
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/string_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/app/theme/ui_state_data.dart';
import 'package:littlefish_merchant/models/activation/activation_request.dart';
import 'package:littlefish_merchant/models/activation/create_activation_response.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/auth/auth_actions.dart';
import 'package:littlefish_merchant/ui/security/login/viewmodels/login_viewmodel.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:quiver/strings.dart';
import 'package:uuid/uuid.dart';

class ActivationPageOTP extends StatefulWidget {
  static const route = '/activation_page_otp';

  final CreateActivationResponse activationResponse;
  final bool isActivation;

  const ActivationPageOTP({
    Key? key,
    required this.activationResponse,
    required this.isActivation,
  }) : super(key: key);

  @override
  State<ActivationPageOTP> createState() => _ActivationPageOTPState();
}

class _ActivationPageOTPState extends State<ActivationPageOTP> {
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
        return AppSimpleAppScaffold(
          footerActions: [
            ButtonPrimary(
              text: 'Next',
              onTap: (context) async {
                if (_formKey.currentState!.validate()) {
                  if (_otp == null || vm.store == null) {
                    showMessageDialog(
                      context,
                      'Unable to verify your OTP. Please check the code and try again.',
                      LittleFishIcons.error,
                    );
                    return;
                  }

                  vm.verifyActivationRequest!(
                    widget.activationResponse.activationId,
                    _otp ?? '',
                    widget.isActivation,
                  );
                }
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
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                    child: context.paragraphMedium('Didn’t receive the OTP?'),
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
                        var didGenerateOTPSuccessfully = await requestOTP(
                          activationRequest: ActivationRequest(
                            activationId:
                                widget.activationResponse.activationId,
                          ),
                          store: vm.store!,
                        );
                        if (didGenerateOTPSuccessfully.success == false) {
                          showMessageDialog(
                            context,
                            'Failed to generate OTP. Please try again or request a new OTP.',
                            LittleFishIcons.error,
                          );
                        }
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
            context.labelXSmall(
              'If you do not recognise the contact details above, please contact ${AppVariables.store?.state.appName ?? ''} Support ${getSupportString()}',
              alignLeft: true,
              maxLines: 6,
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

  OtpType? mapIntToOtpType(int value) {
    return OtpType.values.firstWhereOrNull(
      (enumValue) => enumValue.index == value,
    );
  }

  String getOTPSentText() {
    String phrase = 'An OTP has been sent to your registered';

    if (isBlank(widget.activationResponse.maskedPhone)) {
      phrase += ' email address ${widget.activationResponse.maskedEmail}.';
      return phrase;
    }

    if (isBlank(widget.activationResponse.maskedEmail)) {
      phrase += ' mobile number ${widget.activationResponse.maskedPhone}.';
      return phrase;
    }

    phrase +=
        ' mobile number ${widget.activationResponse.maskedPhone} and email address ${widget.activationResponse.maskedEmail}';
    return phrase;
  }

  String getSupportString() {
    String email = '';
    String number = '';

    if (isNotBlank(AppVariables.clientSupportEmail)) {
      email = AppVariables.clientSupportEmail;
    }
    if (isNotBlank(AppVariables.clientSupportMobileNumber)) {
      number = AppVariables.clientSupportMobileNumber;
    }
    if (isBlank(email) && isBlank(number)) {
      return '.';
    } else if (isNotBlank(email) && isNotBlank(number)) {
      return ' at $email or $number.';
    } else if (isNotBlank(email)) {
      return ' at $email.';
    } else {
      return ' at $number.';
    }
  }
}

String getUniqueUserIdentifier(RegisterVM vm) {
  String uid = vm.otpIdentifier ?? const Uuid().v4();
  vm.store?.dispatch(SetOTPIdentifier(uid));
  return uid;
}
