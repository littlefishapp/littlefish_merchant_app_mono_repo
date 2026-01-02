// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/services/modal_service.dart';
import 'package:littlefish_merchant/injector.dart';

// Project imports:
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/auth/auth_actions.dart';
import 'package:littlefish_merchant/shared/constants/permission_name_constants.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:littlefish_merchant/ui/profile/user/forms/user_profile_details_form.dart';
import 'package:littlefish_merchant/ui/profile/user/viewmodels/user_profile_create_viewmodel.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';

import '../../../../app/custom_route.dart';
import '../../../../app/theme/applied_system/applied_text_icon.dart';
import '../../../../common/presentaion/components/buttons/footer_buttons_secondary_primary.dart';
import '../../../../common/presentaion/pages/scaffolds/app_scaffold.dart';
import '../../../security/manage_password/presentation/pages/change_password_page.dart';

class UserProfilePage extends StatefulWidget {
  static const String route = 'user/profile';

  const UserProfilePage({Key? key}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, UserProfileVM>(
      converter: (store) => UserProfileVM.fromStore(store)..key = formKey,
      builder: (ctx, vm) => AppScaffold(
        actions: <Widget>[
          if (!(vm.store!.state.userState.isGuestUser == true))
            Builder(
              builder: (cx) => IconButton(
                icon: Icon(
                  Icons.save,
                  color: Theme.of(
                    context,
                  ).extension<AppliedTextIcon>()?.inversePrimary,
                ),
                onPressed: () {
                  vm.onUpdateProfile(cx);
                },
              ),
            ),
        ],
        title: vm.item?.displayName ?? '',
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: vm.isLoading!
              ? const AppProgressIndicator()
              : Column(
                  children: <Widget>[
                    if (!(vm.store!.state.userState.isGuestUser == true))
                      Expanded(
                        child: UserProfileDetailsForm(
                          profile: vm.item,
                          formKey: vm.key,
                          enableEmail: false,
                          isCreateMode: false,
                          isFormEditable: userHasPermission(allowUser),
                        ),
                      ),
                  ],
                ),
        ),
        persistentFooterButtons: [
          FooterButtonsSecondaryPrimary(
            primaryButtonText: 'Logout',
            onPrimaryButtonPressed: (ctx) async {
              await getIt<ModalService>()
                  .showActionModal(
                    context: ctx,
                    title: 'Warning',
                    description: 'Are you sure you want to logout?',
                  )
                  .then((result) {
                    if ((result ?? false)) {
                      if (ctx.mounted) {
                        StoreProvider.of<AppState>(
                          ctx,
                        ).dispatch(signOut(reason: 'user-logoff'));
                      }
                    }
                  });
            },
            onSecondaryButtonPressed: (ctx) async {
              await Navigator.of(context).push(
                CustomRoute(
                  builder: (BuildContext context) =>
                      ChangePasswordPage(profile: vm.item!),
                ),
              );
            },
            secondaryButtonText: 'Change Password',
          ),
        ],
      ),
    );
  }
}
