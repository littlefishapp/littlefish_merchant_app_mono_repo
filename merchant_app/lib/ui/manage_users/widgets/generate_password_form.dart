import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/features/ecommerce_shared/models/shared/form_view_model.dart';

import '../../../common/presentaion/components/buttons/button_primary.dart';
import '../../../common/presentaion/components/form_fields/password_form_field.dart';

class GeneratePasswordForm extends StatefulWidget {
  final BasicFormModel userAuthFormModel;
  final Function(String?) onPassword1Change;
  final Function(String?) onPassword2Change;
  final VoidCallback? onSavePasswordBtnPressed;
  final bool showSavePasswordBtn;
  final VoidCallback? onPasswordFieldSubmitted;
  final String? passwordInitialValue;

  final bool? passwordsMatch;

  const GeneratePasswordForm({
    Key? key,
    required this.userAuthFormModel,
    required this.onPassword1Change,
    required this.onPassword2Change,
    this.showSavePasswordBtn = false,
    this.onSavePasswordBtnPressed,
    this.passwordsMatch,
    this.onPasswordFieldSubmitted,
    this.passwordInitialValue,
  }) : super(key: key);

  @override
  State<GeneratePasswordForm> createState() => _GeneratePasswordFormState();
}

class _GeneratePasswordFormState extends State<GeneratePasswordForm> {
  String? _password1, _password2;
  bool _passwordsMatch = true;

  static const double _formFieldSpacing = 8;

  @override
  void dispose() {
    _password1 = null;
    _password2 = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.userAuthFormModel.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PasswordFormField(
            key: const Key('password1'),
            onSaveValue: (value) {
              _setPassword1StateField(value);
            },
            onFieldSubmitted: (value) {
              _setPassword1StateField(value);
              // widget.userAuthFormModel.focusNodes?['password2']?.requestFocus();
            },
            initialValue: widget.passwordInitialValue,
            suffixIcon: Icons.lock,
            hintText: 'Enter password',
            hintColor: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
            labelText: 'Create Password',
            policies: passwordPolicies,
            useOutlineStyling: true,
            // focusNode: widget.userAuthFormModel.setFocusNode('password1'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: context.labelXSmall(
              'Password must have:\n• 8 characters\n• at least one number\n• at '
              'least one symbol\n• at least one uppercase letter\n• at least one '
              'lowercase letter\n',
              alignLeft: true,
              maxLines: 100,
            ),
          ),
          Visibility(
            visible: widget.passwordsMatch != null
                ? !widget.passwordsMatch!
                : !_passwordsMatch,
            child: passwordMismatchText(context),
          ),
          const SizedBox(height: 8),
          PasswordFormField(
            key: const Key('password2'),
            onSaveValue: (value) {
              _setPassword2StateField(value);
            },
            onFieldSubmitted: (value) {
              widget.onPasswordFieldSubmitted != null
                  ? widget.onPasswordFieldSubmitted!()
                  : _setPassword2StateField(value);
            },
            initialValue: widget.passwordInitialValue,
            suffixIcon: Icons.lock,
            hintText: 'Enter password',
            hintColor: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
            labelText: 'Confirm Password',
            policies: passwordPolicies,
            useOutlineStyling: true,
            // focusNode: widget.userAuthFormModel.setFocusNode('password2'),
          ),
          Visibility(
            visible: widget.passwordsMatch != null
                ? !widget.passwordsMatch!
                : !_passwordsMatch,
            child: passwordMismatchText(context),
          ),
          const SizedBox(height: _formFieldSpacing),
          if (widget.showSavePasswordBtn) ...[
            ButtonPrimary(
              text: 'Save Password',
              buttonColor: Theme.of(context).colorScheme.secondary,
              upperCase: false,
              onTap: (ctx) {
                widget.userAuthFormModel.formKey.currentState?.save();
                final bool authFormValid =
                    widget.userAuthFormModel.formKey.currentState?.validate() ??
                    false;
                final passwordsMatch = _passwordsMatchCheck();

                if (authFormValid && passwordsMatch) {
                  _setPasswordMatchStateValue(passwordsMatch);
                } else {
                  _setPasswordMatchStateValue(passwordsMatch);
                }
              },
            ),
            const SizedBox(height: _formFieldSpacing),
          ],
        ],
      ),
    );
  }

  final PasswordPolicies passwordPolicies = PasswordPolicies()
    ..policies = [
      PasswordPolicy(
        displayName: 'Special Characters',
        value: 1,
        policyType: PolicyType.specialCharacters,
      ),
      PasswordPolicy(
        displayName: 'Uppercase Characters',
        value: 1,
        policyType: PolicyType.upperCaseCharacters,
      ),
      PasswordPolicy(
        displayName: 'Lowercase Characters',
        value: 1,
        policyType: PolicyType.lowerCaseCharacters,
      ),
      PasswordPolicy(
        displayName: 'Digits',
        value: 1,
        policyType: PolicyType.digits,
      ),
      PasswordPolicy(
        displayName: 'Minimum Length',
        value: 8,
        policyType: PolicyType.minLength,
      ),
    ];

  _setPassword1StateField(String? value) {
    setState(() {
      _password1 = value;
    });
    widget.onPassword1Change(value);
  }

  _setPassword2StateField(String? value) {
    setState(() {
      _password2 = value;
    });
    widget.onPassword2Change(value);
  }

  bool _passwordsMatchCheck() {
    return (_password2 == _password1);
  }

  _setPasswordMatchStateValue(bool value) {
    setState(() {
      _passwordsMatch = value;
    });
  }

  Widget passwordMismatchText(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 11),
        Text(
          'Passwords must match',
          style: context.appThemeLabelLarge!.copyWith(
            color: Theme.of(context).colorScheme.error,
          ),
        ),
      ],
    );
  }
}
