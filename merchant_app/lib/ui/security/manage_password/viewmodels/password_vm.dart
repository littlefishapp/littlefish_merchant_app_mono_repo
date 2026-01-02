import 'package:flutter/cupertino.dart';
import 'package:littlefish_merchant/redux/auth/auth_actions.dart';
import 'package:redux/redux.dart';
import '../../../../redux/app/app_state.dart';

class ChangePasswordVM {
  bool isLoading;
  bool hasError;
  String? errorMessage;

  final void Function({
    required String email,
    required String oldPassword,
    required String newPassword,
    required void Function(String message, IconData icon) onComplete,
  })
  changeUserPassword;

  final void Function({
    required String email,
    required void Function(String message, IconData icon) onComplete,
  })
  resetPassword;

  final String? Function({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  })
  validate;

  ChangePasswordVM({
    required this.isLoading,
    required this.hasError,
    required this.errorMessage,
    required this.changeUserPassword,
    required this.resetPassword,
    required this.validate,
  });

  static ChangePasswordVM fromStore(Store<AppState> store) {
    return ChangePasswordVM(
      isLoading: store.state.authState.isLoading ?? false,
      hasError: store.state.authState.hasError ?? false,
      errorMessage: store.state.authState.errorMessage,

      validate:
          ({
            required String oldPassword,
            required String newPassword,
            required String confirmPassword,
          }) {
            if ([
              oldPassword,
              newPassword,
              confirmPassword,
            ].any((e) => e.isEmpty)) {
              return 'Please fill in all fields.';
            } else if (oldPassword == newPassword) {
              return 'New password must be different from the current password.';
            } else if (newPassword != confirmPassword) {
              return 'New password and confirm password do not match.';
            }
            return null;
          },

      changeUserPassword:
          ({
            required String email,
            required String oldPassword,
            required String newPassword,
            required void Function(String message, IconData icon) onComplete,
          }) {
            store.dispatch(
              changePassword(
                email: email,
                oldPassword: oldPassword,
                newPassword: newPassword,
                onComplete: onComplete,
              ),
            );
          },

      resetPassword:
          ({
            required String email,
            required void Function(String message, IconData icon) onComplete,
          }) {
            store.dispatch(
              resetPasswordSendGrid(email: email, onComplete: onComplete),
            );
          },
    );
  }
}
