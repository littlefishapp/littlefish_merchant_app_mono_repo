import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_core/business/models/business_user.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_discard.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_secondary.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/email_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/mobile_number_form_field.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/models/permissions/business_user_role.dart';

import 'package:littlefish_merchant/models/settings/locale/country_stub.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';

import '../../../app/theme/applied_system/applied_text_icon.dart';
import '../../../common/presentaion/components/completers.dart';
import '../../../common/presentaion/components/form_fields/string_form_field.dart';
import '../../../features/ecommerce_shared/models/shared/form_view_model.dart';
import '../../../models/permissions/business_role.dart';
import '../../../models/security/user/user_profile.dart';
import '../../../providers/locale_provider.dart';
import '../../../redux/app/app_state.dart';
import '../../../tools/helpers.dart';
import '../../business/users/view_models.dart';
import '../widgets/generate_password_form.dart';
import '../widgets/item_list_tile.dart';
import 'package:littlefish_icons/littlefish_icons.dart';

class CreateEditUserPage extends StatefulWidget {
  final BusinessUserRole? userRole;
  final BusinessUser? user;

  const CreateEditUserPage({Key? key, this.userRole, this.user})
    : super(key: key);

  @override
  State<CreateEditUserPage> createState() => _CreateEditUserPageState();
}

class _CreateEditUserPageState extends State<CreateEditUserPage> {
  late BasicFormModel userInfoFormModel;
  late BasicFormModel userAuthFormModel;

  GlobalKey<FormState> userInfoFormKey = GlobalKey();
  GlobalKey<FormState> userAuthFormKey = GlobalKey();

  String? _firstName, _lastName, _email, _mobileNumber, _password1, _password2;
  String? _firstNameInitialValue,
      _lastNameInitialValue,
      _emailInitialValue,
      _mobileNumberInitialValue,
      _passwordInitialValue;

  String? _selectedRoleId;
  bool _passwordLinkGenerated = false, _sendingPasswordLink = false;
  bool _passwordsMatch = true;

  @override
  void dispose() {
    _password1 = null;
    _password2 = null;
    super.dispose();
  }

  TextStyle formTextStyle(BuildContext context, String type) {
    switch (type) {
      case 'text':
        return TextStyle(
          color: Theme.of(context).extension<AppliedTextIcon>()?.secondary,
        );
      case 'hint':
        return TextStyle(
          color: Theme.of(
            context,
          ).extension<AppliedTextIcon>()?.secondary.withOpacity(0.3),
        );
      case 'label':
        return TextStyle(
          color: Theme.of(
            context,
          ).extension<AppliedTextIcon>()?.secondary.withOpacity(0.3),
        );
      default:
    }
    return TextStyle(
      color: Theme.of(context).extension<AppliedTextIcon>()?.secondary,
    );
  }

  static const double _formFieldSpacing = 8;

  @override
  Widget build(BuildContext context) {
    final outlineBorderStyle = context.inputBorderEnabled();
    return StoreConnector<AppState, UserVM>(
      converter: (store) =>
          UserVM.fromStore(store)..isNew = widget.user == null,
      builder: (BuildContext context, UserVM vm) {
        return _body(context, vm, outlineBorderStyle);
      },
    );
  }

  Widget _body(
    BuildContext context,
    UserVM vm,
    OutlineInputBorder outlineInputBorder,
  ) {
    final isTablet = EnvironmentProvider.instance.isLargeDisplay ?? false;
    final showSideNav =
        isTablet || (AppVariables.store!.state.enableSideNavDrawer ?? false);
    return AppScaffold(
      actions: [
        if (widget.user != null && !widget.user!.isOwner) _deleteUserButton(vm),
      ],
      persistentFooterButtons: vm.isLoading == true
          ? []
          : _bottomButtons(vm, context),
      title: widget.user != null ? 'Edit User' : 'Create New User',
      enableProfileAction: !showSideNav,
      hasDrawer: showSideNav,
      displayNavDrawer: showSideNav,
      body: vm.isLoading ?? false
          ? const AppProgressIndicator()
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(height: 24),
                  _userInfoForm(vm, outlineInputBorder),
                  const SizedBox(height: 20),
                  _assignRoleSection(vm),
                  const SizedBox(height: 30),
                ],
              ),
            ),
    );
  }

  //TODO (tshief): Breakout into own form widget
  Widget _userInfoForm(UserVM vm, OutlineInputBorder outlineInputBorder) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Form(
        key: userInfoFormModel.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            context.labelMediumBold('User Information'),
            const SizedBox(height: 16),
            StringFormField(
              key: const Key('firstname'),
              onChanged: (value) {
                _setFirstNameStateField(value);
              },
              onFieldSubmitted: (value) {
                _setFirstNameStateField(value);
                // userInfoFormModel.focusNodes?['lastname']?.requestFocus();
              },
              onSaveValue: (value) {
                _setFirstNameStateField(value);
              },
              hintText: 'Enter first name',
              labelText: 'First Name',
              initialValue: _firstNameInitialValue,
              useOutlineStyling: true,
              // focusNode: userInfoFormModel.setFocusNode('firstname'),
            ),
            const SizedBox(height: _formFieldSpacing),
            StringFormField(
              key: const Key('lastname'),
              onSaveValue: (value) {
                _setLastNameStateField(value);
              },
              onFieldSubmitted: (value) {
                _setLastNameStateField(value);
                // if (vm.isNew ?? false) {
                //   userInfoFormModel.focusNodes?['email']?.requestFocus();
                // } else {
                //   userInfoFormModel.focusNodes?['mobile']?.requestFocus();
                // }
              },
              onChanged: (value) {
                _setLastNameStateField(value);
              },
              hintText: 'Enter last name',
              labelText: 'Last Name',
              initialValue: _lastNameInitialValue,
              useOutlineStyling: true,
              // focusNode: userInfoFormModel.setFocusNode('lastname'),
            ),
            const SizedBox(height: _formFieldSpacing),
            EmailFormField(
              textColor: Theme.of(
                context,
              ).extension<AppliedTextIcon>()?.secondary,

              iconColor: Theme.of(
                context,
              ).extension<AppliedTextIcon>()?.secondary,

              hintColor: Theme.of(
                context,
              ).extension<AppliedTextIcon>()?.secondary.withOpacity(0.3),
              enabled: vm.isNew ?? false,
              key: const Key('email'),
              onSaveValue: (value) {
                _setEmailStateField(value);
              },
              onFieldSubmitted: (value) {
                _setEmailStateField(value);
                // userInfoFormModel.focusNodes?['mobile']?.requestFocus();
              },
              onChanged: (value) {
                _setEmailStateField(value);
              },
              hintText: 'Enter email address',
              labelText: 'Email Address',
              initialValue: _emailInitialValue,
              useOutlineStyling: true,
              // focusNode: userInfoFormModel.setFocusNode('email'),
              autoValidate: true,
            ),
            const SizedBox(height: _formFieldSpacing),
            MobileNumberFormField(
              showSuffixIcon: false,
              usePlus: true,
              country: CountryStub(diallingCode: _getMobileDialingCode()),
              key: const Key('mobile'),
              onSaveValue: (value) {
                _setMobileStateField(value);
              },
              onFieldSubmitted: (value) {
                _setMobileStateField(value);
              },
              onChanged: (value) {
                _setMobileStateField(value);
              },
              hintText: 'Enter mobile number',
              labelText: 'Mobile Number',
              initialValue: tryTrimMobileNumber(_mobileNumberInitialValue),
              useOutlineStyling: true,
              // focusNode: userInfoFormModel.setFocusNode('mobile'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _userAuthSection(UserVM vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          context.labelMediumBold('User Authentication'),
          const SizedBox(height: 20),
          if (widget.user == null)
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: GeneratePasswordForm(
                passwordInitialValue: _passwordInitialValue,
                passwordsMatch: _passwordsMatch,
                userAuthFormModel: userAuthFormModel,
                onPassword1Change: _setPassword1StateField,
                onPassword2Change: _setPassword2StateField,
                onPasswordFieldSubmitted: _onPasswordFieldSubmitted,
              ),
            ),
          if (widget.user != null) ..._authenticationButtons(vm),
        ],
      ),
    );
  }

  //
  Widget _assignRoleSection(UserVM vm) {
    final roles = vm.getBusinessRoles;
    final rolesLength = roles?.length ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: context.labelMediumBold('Assign Role'),
        ),
        const SizedBox(height: 16),
        ..._getRoleTiles(roles ?? [], rolesLength, vm),
      ],
    );
  }

  List<Widget> _bottomButtons(UserVM vm, BuildContext context) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: ButtonSecondary(
              onTap: (ctx) {
                Navigator.pop(context);
              },
              text: 'Cancel',
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: ButtonPrimary(
              text: 'Save',
              buttonColor: Theme.of(
                context,
              ).extension<AppliedTextIcon>()?.secondary,
              upperCase: false,
              onTap: (context) {
                setState(() {
                  const String noRoleAssignedErrMsg =
                      'Please select a role to be assigned to this user.';
                  final userFormValid =
                      userInfoFormModel.formKey.currentState?.validate() ??
                      false;

                  if (userFormValid) {
                    if ((vm.isNew ?? false)) {
                      if (_selectedRoleId != null) {
                        createOrUpdateUser(vm);
                      } else {
                        _showInputErrorModalPopUp(
                          message: noRoleAssignedErrMsg,
                        );
                      }
                    } else {
                      if (_selectedRoleId != null) {
                        createOrUpdateUser(vm);
                      } else {
                        _showInputErrorModalPopUp(
                          message: noRoleAssignedErrMsg,
                        );
                      }
                    }
                  } else {
                    _showInputErrorModalPopUp();
                  }
                });
              },
            ),
          ),
        ],
      ),
    ];
  }

  List<Widget> _authenticationButtons(UserVM vm) {
    return [
      if (_passwordLinkGenerated == false) ...[
        ButtonSecondary(
          text: _sendingPasswordLink
              ? 'Sending Link...'
              : 'Send Password Reset Link',
          onTap: (ctx) async {
            try {
              setState(() {
                _sendingPasswordLink = true;
              });
              await vm.resetPassword!(_email!);
              setState(() {
                _passwordLinkGenerated = !_passwordLinkGenerated;
                _sendingPasswordLink = false;
              });
            } catch (e) {
              if (mounted) {
                showErrorDialog(
                  context,
                  'Failed to send Reset Password Link, please try again later.',
                );
              }
            }
          },
        ),
        const SizedBox(height: 24),
      ],
      if (_passwordLinkGenerated) ...[
        ButtonPrimary(
          text: 'Password reset Link sent!',
          upperCase: false,
          onTap: (ctx) {
            setState(() async {
              showMessageDialog(
                context,
                "A Password Reset Link email has been sent to this user's email address.",
                Icons.check_circle,
              );
            });
          },
        ),
        const SizedBox(height: 24),
      ],
    ];
  }

  List<Widget> _getRoleTiles(
    List<BusinessRole> roles,
    int rolesLength,
    UserVM vm,
  ) {
    List<Widget> tiles = [];

    for (var index = 0; index < rolesLength; index++) {
      final role = roles[index];
      if (!((role.name ?? '').toLowerCase() == 'guest cashier' &&
          role.systemRole == true)) {
        tiles.add(
          ItemListTile(
            leading: Radio<String?>(
              groupValue: _selectedRoleId,
              toggleable: true,
              value: role.id,
              onChanged: (value) {
                setState(() {
                  _selectedRoleId = value;
                });
              },
              activeColor: Theme.of(
                context,
              ).extension<AppliedTextIcon>()?.secondary,
            ),
            title: role.name!,
            subtitle: role.name,
            displayTrailingIcon: false,
            onTap: () {
              setState(() {
                _selectedRoleId = role.id;
              });
            },
          ),
        );
      }
    }
    return tiles;
  }

  // TODO (tshief): Make a shared/common component if used in more than one place in future
  // Currently bottom sheet is not being used because functionality, as per designs is not present
  // removed ignore: unused_element
  void _generatePasswordBottomSheet(UserVM vm) async {
    await showModalBottomSheet(
      backgroundColor: Theme.of(context).extension<AppliedSurface>()?.primary,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => SafeArea(
        top: false,
        bottom: true,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            color: Theme.of(context).extension<AppliedSurface>()?.primary,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Container(
                    height: 4.0,
                    width: 74.0,
                    color: Theme.of(
                      context,
                    ).extension<AppliedTextIcon>()?.secondary.withOpacity(0.1),
                    margin: const EdgeInsets.all(8.0),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      context.labelMediumBold('Generate New Password'),
                      const SizedBox(height: 20),
                      const SizedBox(height: _formFieldSpacing),
                      GeneratePasswordForm(
                        showSavePasswordBtn: true,
                        userAuthFormModel: userAuthFormModel,
                        onPassword1Change: _setPassword1StateField,
                        onPassword2Change: _setPassword2StateField,
                        onPasswordFieldSubmitted: _onPasswordFieldSubmitted,
                        passwordInitialValue: _passwordInitialValue,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void createOrUpdateUser(UserVM vm) async {
    var role = BusinessUserRole.create();

    setState(() {
      _trimInputtedValues();
      _setInitialValues();
    });

    if (vm.isNew ?? false) {
      var profile = UserProfile.create();

      profile.firstName = _firstName;
      profile.lastName = _lastName;
      profile.email = _email;
      profile.mobileNumber = _mobileNumber;
      profile.countryCode =
          LocaleProvider.instance.currentLocale?.countryCode ?? 'ZA';
      profile.gender = Gender.notSpecified;

      if (_selectedRoleId != null) {
        role.businessId = vm.state?.businessId;
        role.roleId = _selectedRoleId;
      }

      if (vm.addNewStoreUserWithRole != null) {
        vm.addNewStoreUserWithRole!(
          username: _email!,
          profile: profile,
          businessRoleId: _selectedRoleId!,
          permission: UserPermissions(),
          ctx: context,
          role: _selectedRoleId != null ? role : null,
          completer: createOrUpdateUserCompleter('${profile.firstName} saved'),
        );
      }
    } else {
      var bu = widget.user!;
      bu.firstName = _firstName;
      bu.lastName = _lastName;
      bu.mobileNumber = _mobileNumber;

      Completer? completer = createOrUpdateUserCompleter(
        '${bu.firstName} saved',
      );

      if (widget.userRole != null) {
        role = widget.userRole!;
        role.roleId = _selectedRoleId;
      } else {
        role.businessUserId = bu.uid;
        role.businessId = bu.businessId;
        role.roleId = _selectedRoleId;
      }

      if (vm.updateStoreUserWithRole != null) {
        vm.updateStoreUserWithRole!(
          user: bu,
          ctx: context,
          role: role,
          completer: completer,
        );
      }
    }
  }

  Widget _deleteUserButton(UserVM vm) {
    return ButtonDiscard(
      isIconButton: true,
      enablePopPage: true,
      backgroundColor: Colors.transparent,
      borderColor: Colors.transparent,
      modalTitle:
          'Delete user ${widget.user!.firstName} ${widget.user!.lastName}?',
      modalDescription:
          'Are you sure you want to delete this user?\nThis cannot be undone.',
      modalAcceptText: 'Yes. Delete User',
      modalCancelText: 'No, Cancel',
      onDiscard: (ctx) async {
        Navigator.of(context).pop();
        if (mounted) {
          vm.deleteUserWithRole(widget.user!, userRole: widget.userRole);
        }
      },
    );
  }

  bool _validatePasswords() {
    userAuthFormModel.formKey.currentState?.save();
    final bool authFormValid =
        userAuthFormModel.formKey.currentState?.validate() ?? false;
    final passwordsMatch = _passwordsMatchCheck();
    _setPasswordMatchStateValue(passwordsMatch);

    return authFormValid && passwordsMatch;
  }

  Completer? createOrUpdateUserCompleter(String completerText) {
    return snackBarCompleter(
      context,
      '$completerText successfully!',
      shouldPop: true,
    );
  }

  _setFirstNameStateField(String? value) {
    setState(() {
      _firstName = value;
    });
  }

  _setLastNameStateField(String? value) {
    setState(() {
      _lastName = value;
    });
  }

  _setEmailStateField(String? value) {
    setState(() {
      _email = value;
    });
  }

  _setMobileStateField(String? value) {
    setState(() {
      _mobileNumber = value;
    });
  }

  _setPassword1StateField(String? value) {
    setState(() {
      _password1 = value;
    });
  }

  _setPassword2StateField(String? value) {
    setState(() {
      _password2 = value;
    });
  }

  _onPasswordFieldSubmitted() {
    _validatePasswords();
  }

  bool _passwordsMatchCheck() {
    return (_password2 == _password1 &&
        _password2 != null &&
        _password1 != null);
  }

  _setPasswordMatchStateValue(bool value) {
    setState(() {
      _passwordsMatch = value;
    });
  }

  String _getMobileDialingCode() {
    return LocaleProvider.instance.currentLocale?.diallingCode ?? '27';
  }

  void _showInputErrorModalPopUp({String? message}) {
    showMessageDialog(
      context,
      message ??
          'Please ensure all required fields are filled in with valid data.',
      LittleFishIcons.info,
    );
  }

  void _setInitialValues() {
    _firstNameInitialValue = _firstName;
    _lastNameInitialValue = _lastName;
    _mobileNumberInitialValue = _mobileNumber;
    _passwordInitialValue = _password1;
    _emailInitialValue = _email;
  }

  void _trimInputtedValues() {
    _firstName = _firstName?.trim();
    _lastName = _lastName?.trim();
    _mobileNumber = _mobileNumber?.trim();
    _email = _email?.trim();
  }

  @override
  void initState() {
    super.initState();
    userInfoFormModel = BasicFormModel(userInfoFormKey);
    userAuthFormModel = BasicFormModel(userAuthFormKey);
    _selectedRoleId = widget.userRole?.roleId;

    if (widget.user != null) {
      final user = widget.user!;
      _firstNameInitialValue = user.firstName;
      _lastNameInitialValue = user.lastName;
      _mobileNumberInitialValue = user.mobileNumber;
      _emailInitialValue = user.email;
      _firstName = user.firstName;
      _lastName = user.lastName;
      _mobileNumber = user.mobileNumber;
      _email = user.email;
    }
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}
