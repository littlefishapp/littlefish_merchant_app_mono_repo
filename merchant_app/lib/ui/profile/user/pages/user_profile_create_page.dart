import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/custom_route.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/models/security/user/user_profile.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/user/user_actions.dart';
import 'package:littlefish_merchant/ui/profile/user/forms/user_profile_details_form.dart';
import 'package:littlefish_merchant/ui/profile/user/viewmodels/user_profile_create_viewmodel.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/long_text.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/ui/security/login/landing_page.dart';

import '../../../../common/presentaion/components/buttons/button_secondary.dart';

class UserProfilePageCreatePage extends StatefulWidget {
  final Function? onSubmit;
  final bool isManual;
  final String? completionRoute;

  const UserProfilePageCreatePage({
    Key? key,
    this.onSubmit,
    this.isManual = false,
    this.completionRoute,
  }) : super(key: key);

  @override
  State<UserProfilePageCreatePage> createState() =>
      _UserProfilePageCreatePageState();
}

class _UserProfilePageCreatePageState extends State<UserProfilePageCreatePage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, UserProfileVM>(
      converter: (store) => UserProfileVM.fromStore(store)..key = formKey,
      builder: (context, vm) => scaffold(context, vm),
      onInit: (store) {
        if (store.state.userState.profile == null) {
          store.dispatch(
            UserProfileLoadedAction(
              UserProfile(email: store.state.authManager.user?.email),
            ),
          );
        }
      },
    );
  }

  AppScaffold scaffold(context, UserProfileVM model) => AppScaffold(
    displayAppBar: true,
    hasDrawer: false,
    displayBackNavigation: false,
    enableProfileAction: false,
    displayNavDrawer: false,
    title: 'Complete Your Profile',
    body: model.isLoading!
        ? const AppProgressIndicator()
        : layout(context, model),
    persistentFooterButtons: [
      Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: ButtonSecondary(
              text: 'Go Back',
              onTap: (value) async {
                await model.onLogout(context);
                Navigator.of(context).push(
                  CustomRoute(
                    builder: (BuildContext context) => const LandingPage(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 1,
            child: ButtonPrimary(
              text: 'Save',
              disabled: model.isLoading ?? false,
              onTap: (value) {
                if (widget.isManual) {
                  model.onUpsertProfile(
                    model.item,
                    context,
                    widget.completionRoute,
                  );
                } else {
                  model.onAdd(model.item, context);
                }
              },
            ),
          ),
        ],
      ),
    ],
  );

  Container layout(context, UserProfileVM model) => Container(
    // constraints: model.store.state.isLargeDisplay
    //     ? BoxConstraints.expand(
    //         width: 428,
    //       )
    //     : null,
    alignment: Alignment.center,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          child: Container(
            margin: const EdgeInsets.only(top: 12.0, left: 16.0, right: 16.0),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                LongText(
                  'We want to know more about you, so that we can best keep your business safe and experiences seamless',
                  fontSize: null,
                  alignment: TextAlign.center,
                  maxLines: 10,
                ),
                SizedBox(height: 8.0),
              ],
            ),
          ),
        ),
        Expanded(child: form(context, model)),
      ],
    ),
  );

  Container form(BuildContext context, UserProfileVM model) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: UserProfileDetailsForm(
        profile: model.item,
        formKey: model.key,
        isCreateMode: true,
        enableEmail: false,
      ),
    ),
  );
}
