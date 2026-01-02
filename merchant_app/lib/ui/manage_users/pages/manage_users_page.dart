import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_core/business/models/business_user.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/custom_route.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/footer_buttons_icon_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/search_text_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/icons/right_indicator.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/ui/manage_users/pages/create_edit_user_page.dart';
import 'package:littlefish_merchant/ui/manage_users/widgets/item_list_tile.dart';

import '../../../models/permissions/business_role.dart';
import '../../../models/permissions/business_user_role.dart';

import '../../../redux/app/app_state.dart';
import '../../../redux/business/business_actions.dart';
import '../../business/users/view_models.dart';

class ManageUsersPage extends StatefulWidget {
  const ManageUsersPage({Key? key}) : super(key: key);

  static String route = 'manage-users';

  @override
  State<ManageUsersPage> createState() => _ManageUsersPageState();
}

class _ManageUsersPageState extends State<ManageUsersPage> {
  late TextEditingController _searchTextController;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, UsersListVM>(
      onInit: (store) => store.dispatch(getUsers(refresh: true)),
      converter: (store) => UsersListVM.fromStore(store),
      builder: (BuildContext ctx, UsersListVM vm) {
        return _body(vm);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _searchTextController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _searchTextController.dispose();
  }

  Widget _body(UsersListVM vm) {
    final filteredUserList = _getFilteredBusinessUserList(
      vm: vm,
      searchText: _searchTextController.text,
    );

    final tileColor = Theme.of(context).extension<AppliedSurface>()?.primary;
    final titleColor = Theme.of(context).extension<AppliedTextIcon>()?.primary;
    final subTitleColor = Theme.of(
      context,
    ).extension<AppliedTextIcon>()?.secondary;
    final isTablet = EnvironmentProvider.instance.isLargeDisplay ?? false;
    final showSideNav =
        isTablet || (vm.store?.state.enableSideNavDrawer ?? false);
    return AppScaffold(
      title: 'Manage Users',
      enableProfileAction: !showSideNav,
      hasDrawer: showSideNav,
      displayNavDrawer: showSideNav,
      persistentFooterButtons: [_footerButtons(vm)],
      body: vm.isLoading ?? false
          ? const AppProgressIndicator()
          : Column(
              children: [
                SearchTextField(
                  key: const Key('manage_users_search_text_field'),
                  focusNode: FocusNode(),
                  initialValue: _searchTextController.text,
                  onChanged: (text) {
                    if (mounted) {
                      setState(() {
                        _searchTextController.text = text;
                      });
                    }
                  },
                  onClear: () {
                    if (mounted) {
                      setState(() {
                        _searchTextController.clear();
                      });
                    }
                  },
                ),
                Expanded(
                  child: _listOfUsersIsEmpty(filteredUserList)
                      ? const ItemListTile(title: 'No Users Available') //
                      : ListView.builder(
                          itemCount: (filteredUserList?.length ?? 0),
                          itemBuilder: (ctx, index) {
                            final user = filteredUserList![index];
                            final BusinessRole? role = vm.getRole!(user);
                            final BusinessUserRole? userRole = vm.getUserRole!(
                              user,
                            );

                            if (user?.role == UserRoleType.guest) {
                              return const SizedBox.shrink();
                            }

                            return ListTile(
                              tileColor: tileColor,
                              leading: Container(
                                width: AppVariables.appDefaultlistItemSize,
                                height: AppVariables.appDefaultlistItemSize,
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).extension<AppliedSurface>()?.brandSubTitle,
                                  border: Border.all(
                                    color: Colors.transparent,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    AppVariables.appDefaultRadius,
                                  ),
                                ),
                                child: Center(
                                  child: context.labelLarge(
                                    (user?.username ?? '??')
                                        .substring(0, 2)
                                        .toUpperCase(),
                                    isSemiBold: true,
                                  ),
                                ),
                              ),
                              trailing: const ArrowForward(),
                              title: context.labelSmall(
                                _getUserTitle(user),
                                color: titleColor,
                                alignLeft: true,
                                isBold: true,
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  context.labelXSmall(
                                    'Username: ${user?.username}'.trim(),
                                    color: subTitleColor,
                                    alignLeft: true,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  context.labelXSmall(
                                    'Role: ${role?.name ?? 'Unassigned'}'
                                        .trim(),
                                    color: subTitleColor,
                                    alignLeft: true,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  CustomRoute(
                                    builder: (ctx) {
                                      return CreateEditUserPage(
                                        user: user,
                                        userRole: userRole,
                                      );
                                    },
                                  ),
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }

  String _getUserTitle(BusinessUser? user) {
    if (user == null) return '';

    if ((user.firstName?.isNotEmpty ?? false) &&
        (user.lastName?.isNotEmpty ?? false)) {
      return '${user.firstName} ${user.lastName}';
    }

    return user.name ?? '';
  }

  Widget _searchBar({
    required TextEditingController searchController,
    required void Function(String) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppVariables.appDefaultRadius),
        border: Border.all(style: BorderStyle.none),
      ),
      child: TextField(
        controller: searchController,
        onChanged: onChanged,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppVariables.appDefaultRadius),
            borderSide: BorderSide.none,
          ),
          hintText: 'Search',
          prefixIcon: const Icon(Icons.search),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _footerButtons(UsersListVM vm) {
    return FooterButtonsIconPrimary(
      primaryButtonText: 'Add New User',
      onPrimaryButtonPressed: (ctx) {
        return Navigator.push(
          context,
          CustomRoute(
            builder: (BuildContext ctx) {
              return const CreateEditUserPage();
            },
          ),
        );
      },
      secondaryButtonIcon: Icons.refresh,
      onSecondaryButtonPressed: (context) {
        vm.store?.dispatch(getUsers(refresh: true));
      },
    );
  }

  List<BusinessUser?>? _getFilteredBusinessUserList({
    required String searchText,
    required UsersListVM vm,
  }) {
    if (searchText.isEmpty) {
      return vm.items;
    }
    return (vm.items?.isEmpty ?? true)
        ? <BusinessUser>[]
        : vm.items!.where((element) {
            if (element == null) return false;

            final fullName =
                '${element.firstName ?? ''} ${element.lastName ?? ''}'
                    .trim()
                    .toLowerCase();
            final firstName =
                element.firstName?.toLowerCase().contains(
                  searchText.toLowerCase(),
                ) ??
                false;
            final lastName =
                element.lastName?.toLowerCase().contains(
                  searchText.toLowerCase(),
                ) ??
                false;
            final name =
                element.name?.toLowerCase().contains(
                  searchText.toLowerCase(),
                ) ??
                false;

            return fullName.contains(searchText.toLowerCase()) ||
                firstName ||
                lastName ||
                name;
          }).toList();
  }

  bool _listOfUsersIsEmpty(List<BusinessUser?>? usersList) =>
      (usersList?.isEmpty ?? true);

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}
