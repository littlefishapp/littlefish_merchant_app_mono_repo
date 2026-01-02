import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/common/presentaion/components/avatars/avatar_xsmall.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/business/users/view_models.dart';
import 'package:littlefish_merchant/common/presentaion/pages/popup_forms/profile_popup.dart';
import 'package:littlefish_merchant/app/theme/ui_state_data.dart';

import '../../components/dialogs/common_dialogs.dart';

class ProfileNavbarActions extends StatefulWidget {
  const ProfileNavbarActions({Key? key}) : super(key: key);

  @override
  State<ProfileNavbarActions> createState() => _ProfileNavbarActionsState();
}

class _ProfileNavbarActionsState extends State<ProfileNavbarActions> {
  UserVM? vm;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, UserVM>(
      converter: (store) => UserVM.fromStore(store),
      builder: (ctx, vm) {
        this.vm = vm;
        var userProfile = vm.store?.state.userProfile;
        var firstName = userProfile?.firstName ?? '';
        return AvatarXSmall(
          text: firstName,
          imageUrl: userProfile?.profileImageUri ?? '',
          placeholder: UIStateData().appLogo,
          onTap: () => {
            showPopupDialog(
              defaultPadding: false,
              context: context,
              content: const ProfilePopup(),
            ),
          },
        );
      },
    );
  }
}
