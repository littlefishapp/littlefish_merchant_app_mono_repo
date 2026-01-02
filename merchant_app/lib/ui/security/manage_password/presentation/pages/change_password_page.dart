import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/models/security/user/user_profile.dart';
import 'package:littlefish_merchant/ui/security/manage_password/viewmodels/password_vm.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import '../../../../../app/custom_route.dart';
import '../../../../../common/presentaion/components/buttons/footer_buttons_secondary_primary.dart';
import '../../../../../common/presentaion/components/dialogs/common_dialogs.dart';
import '../../../../../common/presentaion/components/form_fields/password_form_field.dart';
import '../../../../../common/presentaion/pages/scaffolds/app_scaffold.dart';
import '../../../../../redux/app/app_state.dart';
import '../forgot_password_page.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';

class ChangePasswordPage extends StatefulWidget {
  final UserProfile profile;

  const ChangePasswordPage({super.key, required this.profile});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  late String _oldPassword;
  late String _newPassword;
  late String _confirmPassword;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ChangePasswordVM>(
      converter: ChangePasswordVM.fromStore,
      builder: (context, vm) {
        return AppScaffold(
          title: 'Change Your Password',
          persistentFooterButtons: [
            FooterButtonsSecondaryPrimary(
              primaryButtonText: 'Change Password',
              onPrimaryButtonPressed: (ctx) => _handleChangePassword(vm),
              onSecondaryButtonPressed: (ctx) {
                Navigator.of(context).push(
                  CustomRoute(
                    builder: (_) => ForgotPasswordPage(
                      vm: vm,
                      userEmail: widget.profile.email ?? '',
                      parentContext: context,
                    ),
                  ),
                );
              },
              secondaryButtonText: 'Forgot Password',
            ),
          ],
          body: vm.isLoading == true
              ? const AppProgressIndicator()
              : Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      PasswordFormField(
                        useOutlineStyling: true,
                        hintText: 'Please enter your current password',
                        key: const Key('current_password'),
                        labelText: 'Current Password',
                        prefixIcon: Icons.lock,
                        suffixIcon: Icons.lock,
                        onChanged: (value) => _oldPassword = value,
                        onSaveValue: (_) {},
                        onFieldSubmitted: (_) {},
                        isRequired: true,
                        policies: PasswordPolicies()..policies = [],
                      ),
                      PasswordFormField(
                        useOutlineStyling: true,
                        hintText: 'Please enter your new password',
                        key: const Key('new_password'),
                        labelText: 'New Password',
                        prefixIcon: Icons.lock,
                        suffixIcon: Icons.lock,
                        onChanged: (value) => _newPassword = value,
                        onSaveValue: (_) {},
                        onFieldSubmitted: (_) {},
                        isRequired: true,
                        policies: PasswordPolicies()..policies = [],
                      ),
                      PasswordFormField(
                        useOutlineStyling: true,
                        hintText: 'Please confirm your new password',
                        key: const Key('confirm_password'),
                        labelText: 'Confirm Password',
                        prefixIcon: Icons.lock,
                        suffixIcon: Icons.lock,
                        onChanged: (value) => _confirmPassword = value,
                        onSaveValue: (_) {},
                        onFieldSubmitted: (_) {},
                        isRequired: true,
                        policies: PasswordPolicies()..policies = [],
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }

  void _handleChangePassword(ChangePasswordVM vm) {
    if (!mounted) return;

    final errorMessage = vm.validate(
      oldPassword: _oldPassword,
      newPassword: _newPassword,
      confirmPassword: _confirmPassword,
    );

    if (errorMessage != null) {
      if (mounted) {
        showMessageDialog(context, errorMessage, LittleFishIcons.warning);
      }
      return;
    }

    vm.changeUserPassword(
      email: widget.profile.email!,
      oldPassword: _oldPassword,
      newPassword: _newPassword,
      onComplete: (message, icon) {
        if (!mounted) return;
        showMessageDialog(context, message, icon);
      },
    );
  }
}
