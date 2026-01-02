import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/ui/security/login/viewmodels/login_viewmodel.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/ui/security/manage_password/viewmodels/password_vm.dart';

import '../../../../common/presentaion/components/buttons/footer_buttons_secondary_primary.dart';
import '../../../../common/presentaion/components/dialogs/common_dialogs.dart';
import '../../../../common/presentaion/components/form_fields/email_form_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  static const route = '/login/forgot-password';
  final dynamic vm;
  final String userEmail;
  final BuildContext parentContext;

  const ForgotPasswordPage({
    Key? key,
    this.vm,
    required this.userEmail,
    required this.parentContext,
  }) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  late String _email;

  @override
  void initState() {
    super.initState();
    _email = widget.userEmail;
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = widget.vm?.isLoading == true;

    return AppScaffold(
      title: 'Forgot Password',
      enableProfileAction: false,
      persistentFooterButtons: [
        FooterButtonsSecondaryPrimary(
          primaryButtonText: 'Send Link',
          onPrimaryButtonPressed: (ctx) async {
            _sendResetLink(context);
          },
          onSecondaryButtonPressed: (ctx) {
            Navigator.of(context).pop();
          },
          secondaryButtonText: 'Cancel',
        ),
      ],
      body: isLoading
          ? const AppProgressIndicator()
          : _forgotPasswordBody(context),
    );
  }

  Widget _forgotPasswordBody(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            context.paragraphMedium(
              'Please enter your email address that is '
              'linked to your account and we will send you a link.',
            ),
            const SizedBox(height: 24),
            _buildEmailField(context),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailField(BuildContext context) {
    return EmailFormField(
      textColor: Theme.of(context).colorScheme.onBackground,
      iconColor: Theme.of(context).colorScheme.onBackground,
      hintColor: Theme.of(context).colorScheme.onBackground,
      initialValue: _email,
      hintText: widget.userEmail,
      key: const Key('email'),
      useOutlineStyling: true,
      isRequired: false,
      prefixIcon: Icons.email,
      labelText: widget.userEmail,
      inputAction: TextInputAction.next,
      onChanged: (value) {
        _email = value;
      },
      onSaveValue: (value) => _updateEmail(value),
      onFieldSubmitted: (value) => _updateEmail(value),
    );
  }

  void _updateEmail(String? value) {
    if (value == null) return;
    final trimmedValue = value.trim();

    if (widget.vm is LoginVM) {
      (widget.vm as LoginVM).setUserName(trimmedValue);
    }
  }

  Future<void> _sendResetLink(BuildContext context) async {
    if (widget.vm is LoginVM) {
      final loginVM = widget.vm as LoginVM;
      setState(() => loginVM.isLoading = true);
      loginVM.onResetPassword(widget.parentContext, _email);
    }

    if (widget.vm is ChangePasswordVM) {
      final changePasswordVM = widget.vm as ChangePasswordVM;

      setState(() => changePasswordVM.isLoading = true);

      changePasswordVM.resetPassword(
        email: _email,
        onComplete: (message, icon) {
          showMessageDialog(context, message, icon);
          setState(() => changePasswordVM.isLoading = false);
        },
      );
    }
  }
}
