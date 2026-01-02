// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/user/user_actions.dart';
import 'package:littlefish_merchant/common/presentaion/components/circle_gradient_avatar.dart';
import 'package:littlefish_merchant/common/presentaion/components/long_text.dart';

class BusinessProfileCard extends StatefulWidget {
  final double? radius;

  final bool showAvatar;

  const BusinessProfileCard({Key? key, this.radius, this.showAvatar = true})
    : super(key: key);

  @override
  State<BusinessProfileCard> createState() => _BusinessProfileCardState();
}

class _BusinessProfileCardState extends State<BusinessProfileCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreBuilder(
      builder: (BuildContext context, Store<AppState> vm) {
        // var profile = vm.state.businessState.profile;
        var userProfile = vm.state.userState.profile;

        return PreferredSize(
          preferredSize: Size.fromHeight(
            MediaQuery.of(context).size.height / 3,
          ),
          child: SafeArea(
            child: InkWell(
              onTap: () => StoreProvider.of<AppState>(
                context,
              ).dispatch(editUserProfile(context)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: OutlineGradientAvatar(
                      radius: 48,
                      child: Icon(MdiIcons.account, size: 48),
                    ),
                  ),
                  Text(
                    "${userProfile?.firstName ?? "Firstname"} ${userProfile?.lastName ?? "Lastname"}",
                  ),
                  LongText(userProfile?.email ?? 'username@s.com'),
                  const SizedBox(height: 8),
                  const Divider(height: 0.5),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
