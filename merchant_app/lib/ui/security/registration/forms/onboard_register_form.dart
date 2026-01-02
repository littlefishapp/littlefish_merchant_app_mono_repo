// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/settings/locale/country_stub.dart';
import 'package:littlefish_merchant/models/shared/form_view_model.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/auto_complete_text_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/email_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/password_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/long_text.dart';

import '../../../../app/theme/applied_system/applied_text_icon.dart';
import '../../../../models/security/user/business_user_profile.dart';
import '../../../../common/presentaion/components/dialogs/common_dialogs.dart';
import '../../login/viewmodels/login_viewmodel.dart';

class OnboardRegisterForm extends StatefulWidget {
  final bool isEditMode;

  final RegisterVM vm;
  final BusinessUserProfile businessUserProfile;

  const OnboardRegisterForm({
    Key? key,
    // required this.onSubmit,
    required this.vm,
    required this.businessUserProfile,
    required this.isEditMode,
  }) : super(key: key);

  @override
  State<OnboardRegisterForm> createState() => _OnboardRegisterFormState();
}

class _OnboardRegisterFormState extends State<OnboardRegisterForm> {
  GlobalKey<AutoCompleteTextFieldState<CountryStub>>? countryKey;

  BasicFormModel? form;

  late RegisterVM vm;
  late BusinessUserProfile profile;
  String? _password, _confirmPassword, _email;

  final List<FocusNode> _nodes = [FocusNode(), FocusNode(), FocusNode()];

  @override
  void initState() {
    vm = widget.vm;
    profile = widget.businessUserProfile;
    _email = profile.user!.email;
    countryKey = GlobalKey<AutoCompleteTextFieldState<CountryStub>>();
    super.initState();
  }

  @override
  void dispose() {
    _password = null;
    _confirmPassword = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    form ??= BasicFormModel(vm.key);

    var store = StoreProvider.of<AppState>(context);

    return body(context, vm, store);
  }

  Widget body(BuildContext context, RegisterVM vm, Store<AppState> store) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Form(
        key: vm.key,
        child: MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 56, bottom: 16),
                child: context.headingXSmall(
                  'Create Your Account',
                  color: Theme.of(
                    context,
                  ).extension<AppliedTextIcon>()?.emphasized,
                  isBold: true,
                ),
              ),
              EmailFormField(
                enabled: widget.isEditMode,
                textColor: Theme.of(context).colorScheme.onBackground,
                iconColor: Theme.of(context).colorScheme.onBackground,
                hintColor: Theme.of(context).colorScheme.onBackground,
                useOutlineStyling: true,
                hintText: 'Please enter your email',
                key: const Key('email'),
                focusNode: _nodes[0],
                isRequired: true,
                suffixIcon: Icons.email,
                initialValue: _email,
                inputAction: TextInputAction.next,
                labelText: 'Username (Email Address)',
                onSaveValue: (value) {
                  if (value == null) return null;
                  var trimmedValue = value.trim();
                  vm.setUserName(trimmedValue);
                  _email = trimmedValue;
                  //_username = trimmedValue;
                },
                onChanged: (value) {
                  var trimmedValue = value.trim();
                  _email = trimmedValue;
                  profile.user!.email = trimmedValue;
                },
                onFieldSubmitted: (value) {
                  var trimmedValue = value.trim();
                  vm.setUserName(trimmedValue);
                  setState(() {
                    _email = trimmedValue;
                    profile.user!.email = trimmedValue;
                  });
                },
                // readOnly: true,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: PasswordFormField(
                  useOutlineStyling: true,
                  hintText: 'Please enter your password',
                  key: const Key('password'),
                  labelText: 'Password',
                  initialValue: null,
                  suffixIcon: Icons.lock,
                  focusNode: _nodes[1],
                  errorColor: Theme.of(context).colorScheme.error,
                  onSaveValue: (value) {
                    if (value == null) return null;
                    profile.password = value;
                    vm.setPassword(value);
                    _password = value;
                  },
                  onFieldSubmitted: (value) {
                    profile.password = value;
                    vm.setPassword(value);
                    _password = value;
                    // FocusScope.of(context).requestFocus();
                  },
                  isRequired: true,
                  policies: PasswordPolicies()
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
                    ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: context.labelXSmall(
                  'Password must have:\n• 8 characters\n• at least one '
                  'number\n• at least one symbol\n• at least one uppercase '
                  'letter\n• at least one lowercase letter\n',
                  alignLeft: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: PasswordFormField(
                  useOutlineStyling: true,
                  hintText: 'Please confirm your password',
                  key: const Key('passwordConfirm'),
                  labelText: 'Confirm Password',
                  initialValue: null,
                  suffixIcon: Icons.lock,
                  focusNode: _nodes[2],
                  errorColor: Theme.of(context).colorScheme.error,
                  onSaveValue: (value) {
                    if (value == null) return null;
                    _confirmPassword = value;
                  },
                  onFieldSubmitted: (value) {
                    vm.setPassword(value);
                    _confirmPassword = value;
                    // FocusScope.of(context).requestFocus();
                  },
                  isRequired: true,
                  policies: PasswordPolicies()
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
                    ],
                ),
              ),
              Visibility(
                visible: vm.errorMessage != null,
                child: LongText(
                  vm.errorMessage,
                  fontSize: 12,
                  textColor: Colors.red,
                  alignment: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 0),
                child: ButtonPrimary(
                  buttonColor: Theme.of(context).colorScheme.primary,
                  text: 'Create Account',
                  onTap: (context) {
                    if (vm.key?.currentState?.validate() ?? false) {
                      vm.key!.currentState!.save();

                      if (_password != _confirmPassword) {
                        showMessageDialog(
                          context,
                          'Passwords Do Not Match',
                          LittleFishIcons.info,
                        );
                      } else if (AppVariables
                          .store!
                          .state
                          .environmentSettings!
                          .commonPasswords!
                          .contains(_password)) {
                        showMessageDialog(
                          context,
                          'Password can not be used as it can be easily guessed',
                          LittleFishIcons.info,
                        );
                      } else {
                        profile.user!.email = _email;
                        if (profile.business!.businessEmail == null) {
                          profile.business!.businessEmail = _email;
                        }
                        vm.onOnboardingRegister(
                          context,
                          businessUserProfile: profile,
                        );
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
