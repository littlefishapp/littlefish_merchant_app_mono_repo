// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/business/business_actions.dart';
import 'package:littlefish_merchant/ui/business/users/pages/user_page.dart';
import 'package:littlefish_merchant/ui/business/users/view_models.dart';
import 'package:littlefish_merchant/ui/business/users/widgets/users_list.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/decorated_text.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';

class UsersPage extends StatefulWidget {
  static const String route = 'business/system-users';

  const UsersPage({Key? key}) : super(key: key);

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, UsersListVM>(
      onInit: (store) => store.dispatch(getUsers()),
      converter: (Store store) =>
          UsersListVM.fromStore(store as Store<AppState>),
      builder: (BuildContext ctx, UsersListVM vm) =>
          EnvironmentProvider.instance.isLargeDisplay == true
          ? scaffoldLandscape(context, vm)
          : scaffold(context, vm),
    );
  }

  AppScaffold scaffoldLandscape(context, UsersListVM vm) => AppScaffold(
    enableProfileAction: false,
    title: 'Users',
    hasDrawer: vm.store!.state.enableSideNavDrawer!,
    displayNavDrawer: vm.store!.state.enableSideNavDrawer!,
    actions: <Widget>[
      IconButton(
        icon: const Icon(Icons.refresh),
        onPressed: () {
          vm.onRefresh();
        },
      ),
    ],
    body: !vm.isLoading!
        ? Row(
            children: <Widget>[
              Expanded(flex: 4, child: userList(context, vm)),
              const VerticalDivider(width: 0.5),
              Expanded(
                flex: 4,
                child: vm.selectedItem != null && !(vm.isNew ?? false)
                    ? UserPage(
                        embedded: true,
                        user: vm.selectedItem,
                        parentContext: context,
                      )
                    : const Center(
                        child: DecoratedText(
                          'Select User',
                          alignment: Alignment.center,
                          fontSize: 24,
                        ),
                      ),
              ),
            ],
          )
        : const AppProgressIndicator(),
  );

  AppScaffold scaffold(BuildContext context, UsersListVM vm) => AppScaffold(
    title: 'Users',
    hasDrawer: vm.store!.state.enableSideNavDrawer!,
    displayNavDrawer: vm.store!.state.enableSideNavDrawer!,
    actions: <Widget>[
      IconButton(
        icon: const Icon(Icons.refresh),
        onPressed: () {
          vm.onRefresh();
        },
      ),
    ],
    body: !vm.isLoading! ? userList(context, vm) : const AppProgressIndicator(),
  );

  UsersList userList(context, UsersListVM vm) => UsersList(
    items: vm.items,
    vm: vm,
    selectedItem: vm.selectedItem,
    onTap: (user) {
      if (EnvironmentProvider.instance.isLargeDisplay!) {
        vm.onSetSelected(user);
        if (mounted) setState(() {});
      } else {
        vm.onSetSelected(user);

        vm.store!.dispatch(editUser(user!));
      }
    },
  );
}
