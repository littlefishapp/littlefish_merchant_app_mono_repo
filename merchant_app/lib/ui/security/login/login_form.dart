import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_merchant/models/settings/locale/country_stub.dart';
import 'package:littlefish_merchant/models/shared/form_view_model.dart';
import 'package:littlefish_merchant/ui/online_store/tools.dart';
import 'package:littlefish_merchant/ui/security/login/viewmodels/login_viewmodel.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/auto_complete_text_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/email_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/password_form_field.dart';

import '../../online_store/shared/routes/custom_route.dart';
import '../manage_password/presentation/forgot_password_page.dart';

class LoginForm extends StatefulWidget {
  final Function(String? username, String? password) onSubmit;
  final Function(bool validate) onValidate;
  final LoginVM vm;
  final BuildContext? parentContext;
  final String loginControlText;
  final bool loginControlOnBrandedSurface;

  const LoginForm({
    Key? key,
    required this.onSubmit,
    required this.vm,
    required this.onValidate,
    this.parentContext,
    required this.loginControlText,
    required this.loginControlOnBrandedSurface,
  }) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  GlobalKey<AutoCompleteTextFieldState<CountryStub>>? countryKey;

  BasicFormModel? formModel;

  final List<FocusNode> _nodes = [FocusNode(), FocusNode()];

  @override
  void initState() {
    countryKey = GlobalKey<AutoCompleteTextFieldState<CountryStub>>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return formBody(context, widget.vm);
  }

  Widget formBody(BuildContext context, LoginVM vm) {
    formModel ??= BasicFormModel(vm.key);
    return Form(
      key: vm.key,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              loginEmailFormField(vm),
              const SizedBox(height: 16),
              loginPasswordFormField(vm, context),
            ],
          ),
          loginControls(vm),
        ],
      ),
    );
  }

  Container loginControls(LoginVM vm) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: ButtonPrimary(
        widgetOnBrandedSurface: widget.loginControlOnBrandedSurface,
        text: widget.loginControlText,
        buttonTextSize: PrimaryButtonTextSize.small,
        upperCase: false,
        onTap: (context) async {
          bool? enableWelcomeIntro = await getKeyFromPrefsBool(
            'enableWelcomePage',
          );
          if (enableWelcomeIntro == null) {
            saveKeyToPrefsBool('enableWelcomePage', true);
          }
          if (vm.key!.currentState!.validate()) {
            vm.key!.currentState!.save();
            widget.onSubmit(vm.userName, vm.password);
          } else {
            widget.onValidate(false);
          }
        },
      ),
    );
  }

  Column loginPasswordFormField(LoginVM vm, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        PasswordFormField(
          useOutlineStyling: true,
          widgetOnBrandedSurface: widget.loginControlOnBrandedSurface,
          hintText: 'Your password',
          key: const Key('password'),
          labelText: 'Password',
          initialValue: vm.password,
          prefixIcon: Icons.lock,
          suffixIcon: Icons.lock,
          focusNode: _nodes[1],
          onSaveValue: (value) {
            if (value == null) return null;
            vm.setPassword(value);
          },
          onFieldSubmitted: (value) {
            vm.setPassword(value);
          },
          isRequired: true,
          policies: PasswordPolicies()..policies = [],
        ),
        Container(
          alignment: Alignment.centerRight,
          child: IconButton(
            icon: context.labelXSmall(
              'Forgot Password',
              color: Theme.of(context).colorScheme.onBackground,
            ),
            onPressed: () async {
              vm.key!.currentState!.save();
              await Navigator.of(context).push(
                CustomRoute(
                  builder: (BuildContext context) => ForgotPasswordPage(
                    userEmail: vm.userName ?? '',
                    vm: vm,
                    parentContext: context,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  EmailFormField loginEmailFormField(LoginVM vm) {
    return EmailFormField(
      useOutlineStyling: true,
      widgetOnBrandedSurface: widget.loginControlOnBrandedSurface,
      hintText: 'Email address',
      key: const Key('email'),
      focusNode: _nodes[0],
      nextFocusNode: _nodes[1],
      prefixIcon: Icons.email,
      isRequired: true,
      initialValue: vm.userName,
      inputAction: TextInputAction.next,
      labelText: 'Username (Email Address)',
      onSaveValue: (value) {
        if (value == null) return null;
        var trimmedValue = value.trim();
        vm.setUserName(trimmedValue);
      },
      onFieldSubmitted: (value) {
        var trimmedValue = value.trim();
        vm.setUserName(trimmedValue);
      },
    );
  }

  bool validateValue(String value) {
    if (value.isEmpty) {
      return false;
    }

    var regexp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );

    var isValid = regexp.hasMatch(value);

    return isValid;
  }
}
