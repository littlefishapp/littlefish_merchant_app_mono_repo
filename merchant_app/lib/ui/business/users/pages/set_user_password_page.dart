// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/password_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/string_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';

class SetUserPasswordPage extends StatefulWidget {
  final String? password;

  final String? username;

  const SetUserPasswordPage({Key? key, this.password, this.username})
    : super(key: key);

  @override
  State<SetUserPasswordPage> createState() => _SetUserPasswordPageState();
}

class _SetUserPasswordPageState extends State<SetUserPasswordPage> {
  bool isSending = false;

  bool isSent = false;

  String? password;

  String? username;

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  void initState() {
    password = widget.password;
    username = widget.username;
    super.initState();
  }

  @override
  void dispose() {
    password = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppSimpleAppScaffold(
      resizeToAvoidBottomPadding: false,
      isEmbedded: true,
      title: 'Login Details',
      displayAppBar: false,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Do not forget to save the username, and password - they cannot be changed once you save them',
                  ),
                  const SizedBox(height: 4),
                  const CommonDivider(),
                  StringFormField(
                    enabled: false,
                    initialValue: username,
                    hintText: 'Username',
                    key: const Key('firstname'),
                    labelText: 'Username',
                    onSaveValue: (value) {
                      username = value;
                    },
                    onFieldSubmitted: (value) {
                      username = value;
                    },
                    isRequired: true,
                  ),
                  PasswordFormField(
                    textColor: Colors.black,
                    hintText: 'Your password',
                    key: const Key('password'),
                    labelText: 'Password',
                    initialValue: password ?? '',
                    suffixIcon: Icons.lock,
                    onSaveValue: (value) {
                      password = value;
                    },
                    onFieldSubmitted: (value) {
                      password = value;
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
                  ButtonPrimary(
                    text: 'Complete',
                    onTap: (ctx) {
                      formKey.currentState!.save();
                      if (formKey.currentState?.validate() ?? false) {
                        Navigator.of(context).pop(password);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
