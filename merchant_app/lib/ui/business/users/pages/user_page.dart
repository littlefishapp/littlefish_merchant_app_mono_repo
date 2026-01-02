// Flutter imports:
// remove ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_core/business/models/business_user.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_merchant/shared/constants/permission_name_constants.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/security/user/user_profile.dart';
import 'package:littlefish_merchant/providers/locale_provider.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/ui/business/users/forms/user_details_form.dart';
import 'package:littlefish_merchant/ui/business/users/pages/set_user_password_page.dart';
import 'package:littlefish_merchant/ui/business/users/view_models.dart';
import 'package:littlefish_merchant/ui/profile/user/forms/user_profile_details_form.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_secondary.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_tabbed_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/yes_no_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_tabbar.dart';

class UserPage extends StatefulWidget {
  static const String route = '/users/user';

  final bool embedded;
  final BuildContext? parentContext;
  final BusinessUser? user;

  const UserPage({
    Key? key,
    this.parentContext,
    this.embedded = false,
    this.user,
  }) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  GlobalKey<FormState>? formKey;
  UserPermissions? _permissions;
  UserProfile? _profile;
  String? _password;

  @override
  void initState() {
    formKey = GlobalKey<FormState>();
    _profile = UserProfile.create();
    super.initState();
  }

  @override
  void dispose() {
    _password = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, UserVM>(
      converter: (Store<AppState> store) =>
          UserVM.fromStore(store)..key = formKey,
      builder: (BuildContext ctx, UserVM vm) {
        _permissions ??= vm.item!.permissions;

        return scaffold(widget.parentContext ?? context, vm);
      },
    );
  }

  AppSimpleAppScaffold scaffold(context, UserVM vm) => AppSimpleAppScaffold(
    isEmbedded: widget.embedded,
    title: vm.item == null || vm.item!.displayName == null
        ? 'New User'
        : vm.item!.displayName,
    actions: <Widget>[
      Builder(
        builder: (ctx) => IconButton(
          icon: const Icon(Icons.save),
          onPressed: () async {
            if (vm.key?.currentState?.validate() ?? false) {
              vm.key!.currentState!.save();
              if (vm.isNew == true) {
                var prefix =
                    (_profile?.firstName ?? '') + (_profile?.lastName ?? '');

                var domainName =
                    '@${readableCleanString(vm.store!.state.businessState.profile!.name)}.com';

                var usrName = prefix + domainName;

                _profile!.email = usrName;
                try {
                  _password = await showPopupDialog(
                    defaultPadding: false,
                    height: 300,
                    context: context,
                    content: SetUserPasswordPage(
                      username: usrName,
                      password: _password,
                    ),
                  );

                  if (_password != null) {
                    _profile!.countryCode =
                        LocaleProvider.instance.currentLocale?.countryCode ??
                        'ZA';
                    vm.addNewStoreUser(
                      usrName,
                      _password,
                      _profile,
                      _permissions,
                      ctx,
                    );
                  } else {
                    showMessageDialog(
                      context,
                      'Password not set',
                      LittleFishIcons.info,
                    );
                  }
                  // if (mounted) setState(() {});
                } catch (e) {
                  showErrorDialog(context, e);
                }
              } else {
                debugPrint('${vm.item!.permissions!.manageOnline}');
                debugPrint('${_permissions!.manageOnline}');

                vm.item!.permissions = _permissions;
                vm.onAdd(vm.item, context);
              }
            }
          },
        ),
      ),
    ],
    body: vm.isLoading! ? const AppProgressIndicator() : layout(context, vm),
  );

  AppTabBar layout(context, UserVM vm) => AppTabBar(
    reverse: true,
    tabs: [
      TabBarItem(content: form(context, vm), text: 'Details'),
      // TabBarItem(
      //   content: permissions(context, vm),
      //   text: "Permissions",
      // )
    ],
  );

  Container form(BuildContext context, UserVM vm) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: Builder(
      builder: (ctx) {
        return Column(
          children: <Widget>[
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [],
            ),
            Expanded(
              child: vm.item != null && vm.isNew == false
                  ? UserDetailsForm(
                      user: vm.item,
                      formKey: vm.key,
                      onSubmit: (employee) {
                        vm.onAdd(vm.item, ctx);
                      },
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          UserProfileDetailsForm(
                            profile: _profile,
                            isCreateMode: true,
                            formKey: vm.key,
                            showEmail: false,
                            showCountryPicker: false,
                            isFormEditable: userHasPermission(allowUser),
                          ),
                        ],
                      ),
                    ),
            ),
            const CommonDivider(height: 0.5),
            SizedBox(
              child: ButtonSecondary(
                onTap: (c) => showPopupDialog(
                  content: UserPermissionsList(
                    user: vm,
                    permissions: _permissions,
                  ),
                  context: context,
                ),
                text: 'Permissions',
              ),
            ),
            const SizedBox(height: 32),
          ],
        );
      },
    ),
  );
}

class UserPermissionsList extends StatefulWidget {
  final UserVM user;
  final UserPermissions? permissions;

  const UserPermissionsList({
    Key? key,
    required this.user,
    required this.permissions,
  }) : super(key: key);

  @override
  State<UserPermissionsList> createState() => _UserPermissionsListState();
}

class _UserPermissionsListState extends State<UserPermissionsList> {
  late UserVM userVm;
  late UserPermissions? _selectedPermissions;

  @override
  void initState() {
    userVm = widget.user;
    if (widget.permissions != null) {
      _selectedPermissions = widget.permissions;
    } else {
      _selectedPermissions = UserPermissions(
        analytics: true,
        isAdmin: false,
        giveDiscounts: false,
        isOwner: false,
        makeSale: true,
        manageBusiness: false,
        manageCustomers: false,
        manageEmployees: false,
        manageExpenses: false,
        manageInventory: false,
        manageProducts: false,
        managePromotions: false,
        manageSuppliers: false,
        manageUsers: false,
        manageOnline: false,
      );
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // removed ignore: deprecated_member_use
    return PopScope(
      onPopInvoked: (didPop) {
        Navigator.of(context).pop(_selectedPermissions);
        return;
      },
      // onWillPop: () {
      //   return Future.value(false);
      // Navigator.of(context).pop(_selectedPermissions);

      // },
      child: permissions(context, userVm),
    );
  }

  _rebuild() {
    if (mounted) setState(() {});
  }

  Container permissions(context, UserVM vm) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 8),
    child: ListView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      children: <Widget>[
        YesNoFormField(
          labelText: 'Administrator',
          initialValue: _selectedPermissions!.isAdmin,
          onSaved: (value) {
            if (mounted) {
              setState(() {
                _selectedPermissions!.isAdmin = value;
              });
            } else {
              _selectedPermissions!.isAdmin = value;
            }
          },
          description: 'overall system administrator',
        ),
        const CommonDivider(width: 0.5),
        if (AppVariables.store!.state.enableStaffSales == true)
          Visibility(
            visible: !_selectedPermissions!.isAdmin!,
            child: YesNoFormField(
              labelText: 'Make Sales',
              initialValue: _selectedPermissions!.makeSale,
              onSaved: (value) {
                if (value == null) return null;
                _selectedPermissions!.makeSale = value;
                _rebuild();
              },
              description: 'Make New Sales',
            ),
          ),
        Visibility(
          visible: !_selectedPermissions!.isAdmin!,
          child: YesNoFormField(
            labelText: 'Manage Online Store',
            initialValue: _selectedPermissions!.manageOnline,
            onSaved: (value) {
              _selectedPermissions!.manageOnline = value;
              _rebuild();
            },
            description: 'view and manage online store',
          ),
        ),
        Visibility(
          visible: !_selectedPermissions!.isAdmin!,
          child: YesNoFormField(
            labelText: 'Manage Products',
            initialValue: _selectedPermissions!.manageProducts,
            onSaved: (value) {
              _selectedPermissions!.manageProducts = value;
              _rebuild();
            },
            description: 'view and manage all products',
          ),
        ),
        Visibility(
          visible: !_selectedPermissions!.isAdmin!,
          child: YesNoFormField(
            labelText: 'Manage Inventory',
            initialValue: _selectedPermissions!.manageInventory,
            onSaved: (value) {
              _selectedPermissions!.manageInventory = value;
              _rebuild();
            },
            description: 'view and manage inventory',
          ),
        ),
        Visibility(
          visible: !_selectedPermissions!.isAdmin!,
          child: YesNoFormField(
            labelText: 'Manage Business',
            initialValue: _selectedPermissions!.manageBusiness,
            onSaved: (value) {
              _selectedPermissions!.manageBusiness = value;
              _rebuild();
            },
            description: 'manage the business profile',
          ),
        ),
        Visibility(
          visible:
              !_selectedPermissions!.isAdmin! &&
              _selectedPermissions!.manageBusiness!,
          child: YesNoFormField(
            labelText: 'Manage Expenses',
            initialValue: _selectedPermissions!.manageExpenses,
            onSaved: (value) {
              _selectedPermissions!.manageExpenses = value;
              _rebuild();
            },
            description: 'view and manage expenses',
          ),
        ),
        Visibility(
          visible:
              !_selectedPermissions!.isAdmin! &&
              _selectedPermissions!.manageBusiness!,
          child: YesNoFormField(
            labelText: 'Manage Transactions',
            initialValue: _selectedPermissions!.manageTransactions,
            onSaved: (value) {
              _selectedPermissions!.manageTransactions = value;
              _rebuild();
            },
            description: 'view and manage transactions',
          ),
        ),
        Visibility(
          visible:
              !_selectedPermissions!.isAdmin! &&
              _selectedPermissions!.manageBusiness!,
          child: YesNoFormField(
            labelText: 'Manage Users',
            initialValue: _selectedPermissions!.manageUsers,
            onSaved: (value) {
              _selectedPermissions!.manageUsers = value;
              _rebuild();
            },
            description: 'view and manage users',
          ),
        ),
        Visibility(
          visible:
              !_selectedPermissions!.isAdmin! &&
              _selectedPermissions!.manageBusiness!,
          child: YesNoFormField(
            labelText: 'Manage Customers',
            initialValue: _selectedPermissions!.manageCustomers,
            onSaved: (value) {
              _selectedPermissions!.manageCustomers = value;
              _rebuild();
            },
            description: 'view and manage all customers',
          ),
        ),
        if (AppVariables.store!.state.enableEmployee == true)
          Visibility(
            visible:
                !_selectedPermissions!.isAdmin! &&
                _selectedPermissions!.manageBusiness!,
            child: YesNoFormField(
              labelText: 'Manage Employees',
              initialValue: _selectedPermissions!.manageEmployees,
              onSaved: (value) {
                _selectedPermissions!.manageEmployees = value;
                _rebuild();
              },
              description: 'view and manage all employees',
            ),
          ),
        Visibility(
          visible:
              !_selectedPermissions!.isAdmin! &&
              _selectedPermissions!.manageBusiness!,
          child: YesNoFormField(
            labelText: 'Manage Suppliers',
            initialValue: _selectedPermissions!.manageSuppliers,
            onSaved: (value) {
              _selectedPermissions!.manageSuppliers = value;
              _rebuild();
            },
            description: 'view and manage suppliers',
          ),
        ),
        // Visibility(
        //   visible: !_selectedPermissions.isAdmin,
        //   child: YesNoFormField(
        //     labelText: "Manage Promotions",
        //     initialValue: _selectedPermissions.managePromotions,
        //     onSaved: (value) {
        //       _selectedPermissions.managePromotions = value;
        //       _rebuild();
        //     },
        //     description: "view and manage promotions",
        //   ),
        // ),
        if (AppVariables.store!.state.enableDiscounts == true)
          Visibility(
            visible:
                !_selectedPermissions!.isAdmin! &&
                _selectedPermissions!.manageBusiness!,
            child: YesNoFormField(
              labelText: 'Manage Discounts',
              initialValue: _selectedPermissions!.giveDiscounts,
              onSaved: (value) {
                _selectedPermissions!.giveDiscounts = value;
                _rebuild();
              },
              description: 'Manage and view discounts',
            ),
          ),
        Visibility(
          visible: !_selectedPermissions!.isAdmin!,
          child: YesNoFormField(
            labelText: 'View Analytics',
            initialValue: _selectedPermissions!.analytics,
            onSaved: (value) {
              _selectedPermissions!.analytics = value;
              _rebuild();
            },
            description: 'View and run analytics',
          ),
        ),
      ],
    ),
  );
}
