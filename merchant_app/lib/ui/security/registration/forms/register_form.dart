// removed ignore: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/models/security/user/business_user_profile.dart';
import 'package:littlefish_merchant/ui/security/login/login_page.dart';
import 'package:redux/redux.dart';
import 'package:littlefish_merchant/models/settings/locale/country_stub.dart';
import 'package:littlefish_merchant/models/shared/form_view_model.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/ui/security/login/viewmodels/login_viewmodel.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/auto_complete_text_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/email_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/password_form_field.dart';

import '../../../../app/app.dart';
import '../../../../app/theme/applied_system/applied_text_icon.dart';
import '../../../../common/presentaion/components/dialogs/common_dialogs.dart';
import '../../../../injector.dart';

class RegisterForm extends StatefulWidget {
  // final Function onSubmit;

  final RegisterVM vm;

  final BusinessUserProfile? profile;
  final bool decorationEnabled;

  const RegisterForm({
    Key? key,
    // required this.onSubmit,
    required this.vm,
    this.profile,
    this.decorationEnabled = false,
  }) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  GlobalKey<AutoCompleteTextFieldState<CountryStub>>? countryKey;

  BasicFormModel? form;

  late RegisterVM vm;
  String? _username, _password, _confirmPassword;

  final List<FocusNode> _nodes = [FocusNode(), FocusNode(), FocusNode()];

  @override
  void initState() {
    vm = widget.vm;
    vm.setUserName(widget.profile?.user?.email ?? '');
    countryKey = GlobalKey<AutoCompleteTextFieldState<CountryStub>>();
    super.initState();
  }

  @override
  void dispose() {
    _password = null;
    _username = null;
    _confirmPassword = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('#### RegisterForm');
    form ??= BasicFormModel(vm.key);

    var store = StoreProvider.of<AppState>(context);

    return body(context, vm, store);
  }

  Widget body(BuildContext context, RegisterVM vm, Store<AppState> store) {
    var result = Container(
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
              const SizedBox(height: 56),
              context.headingXSmall(
                'Create Your Account',
                isSemiBold: true,
                color: Theme.of(
                  context,
                ).extension<AppliedTextIcon>()?.emphasized,
              ),
              const SizedBox(height: 24),
              EmailFormField(
                useOutlineStyling: true,
                widgetOnBrandedSurface: false,
                hintText: 'Email address',
                key: const Key('email'),
                focusNode: _nodes[0],
                nextFocusNode: _nodes[1],
                isRequired: true,
                enabled: true,
                suffixIcon: Icons.email,
                initialValue: vm.userName,
                inputAction: TextInputAction.next,
                labelText: 'Username (Email Address)',
                onSaveValue: (value) {
                  if (value == null) return null;
                  var trimmedValue = value.trim();
                  vm.setUserName(trimmedValue);
                  _username = trimmedValue;
                },
                onFieldSubmitted: (value) {
                  var trimmedValue = value.trim();
                  vm.setUserName(trimmedValue);
                  _username = trimmedValue;
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: PasswordFormField(
                  textColor: Theme.of(context).colorScheme.onBackground,
                  iconColor: Theme.of(context).colorScheme.onBackground,
                  hintColor: Theme.of(context).colorScheme.onBackground,
                  useOutlineStyling: true,
                  hintText: 'Your password',
                  key: const Key('password'),
                  labelText: 'Password',
                  initialValue: vm.password,
                  suffixIcon: Icons.lock,
                  focusNode: _nodes[1],
                  nextFocusNode: _nodes[2],
                  onSaveValue: (value) {
                    if (value == null) return null;
                    vm.setPassword(value);
                    _password = value;
                  },
                  onFieldSubmitted: (value) {
                    vm.setPassword(value);
                    _password = value;
                  },
                  isRequired: true,
                  policies: PasswordPolicies()
                    ..policies = [
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
                child: context.body02x14R(vm.errorMessage ?? 'Error'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: context.labelXSmall(
                  'Password must have:\n• 8 characters\n• at least one '
                  'number\n• at least one symbol\n• at least one uppercase '
                  'letter\n• at least one lowercase letter\n',
                  alignLeft: true,
                  maxLines: 25,
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
              registerButton(context, vm),
              gotoLoginButton(context),
            ],
          ),
        ),
      ),
    );

    return result;
  }

  Widget registerButton(BuildContext ctx, RegisterVM vm) {
    return ButtonPrimary(
      text: 'REGISTER',
      widgetOnBrandedSurface: widget.decorationEnabled,
      onTap: (context) {
        if (vm.key?.currentState?.validate() ?? false) {
          vm.key!.currentState!.save();
          if (AppVariables.store!.state.environmentSettings!.commonPasswords!
              .contains(_password)) {
            showMessageDialog(
              context,
              'Password can not be used as it can be easily guessed',
              LittleFishIcons.info,
            );
          } else {
            if (widget.profile != null) {
              if (_password != _confirmPassword) {
                showMessageDialog(
                  context,
                  'Passwords Do Not Match',
                  LittleFishIcons.info,
                );
                return;
              }
              widget.profile!.user!.email = _username;
              widget.profile!.password = _password;
              if (widget.profile!.business!.businessEmail == null) {
                widget.profile!.business!.businessEmail = _username;
              }
              vm.onOnboardingRegister(
                ctx,
                businessUserProfile: widget.profile!,
              );
            } else {
              vm.onRegister(
                context,
                username: _username!,
                password: _password!,
              );
            }
          }
        }
      },
    );
  }

  Widget gotoLoginButton(BuildContext context) {
    return ButtonPrimary(
      onTap: (BuildContext context) {
        Navigator.pushReplacementNamed(context, LoginPage.route);
      },
      text: 'Already have a store? Log in'.toUpperCase(),
      widgetOnBrandedSurface: widget.decorationEnabled,
    );
  }
}
