// Dart imports:
// remove ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';

// Flutter imports:
import 'package:fast_contacts/fast_contacts.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/services/modal_service.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:permission_handler/permission_handler.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/providers/permissions_provider.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/customer/customer_actions.dart';
import 'package:littlefish_merchant/ui/customers/viewmodels/customer_view_models.dart';
import 'package:littlefish_merchant/common/presentaion/components/fliter_bar.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/auto_complete_text_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/common/presentaion/components/decorated_text.dart';
import 'package:littlefish_merchant/common/presentaion/components/long_text.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';

import 'package:littlefish_merchant/redux/customer/customer_actions.dart'
    as customer_service;

class CustomerImportPage extends StatefulWidget {
  static const String route = '/customer_import';

  const CustomerImportPage({Key? key}) : super(key: key);

  @override
  State<CustomerImportPage> createState() => _CustomerImportPageState();
}

class _CustomerImportPageState extends State<CustomerImportPage> {
  ContactsViewModel? _vm;

  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();

    Timer.run(() {
      // If we already have contacts permission then get contacts,
      // otherwise create popup dialog asking if they want to import contacts.
      AppVariables.store!.dispatch(SetCustomerLoadingAction(true));
      hasPermission(context, Permission.contacts).then((permissionAllowed) {
        if (permissionAllowed == true) {
          // We have permission
          _hasPermission = true;
          AppVariables.store!.dispatch(
            customer_service.getContacts(refresh: false),
          );
        } else {
          // We don't have permission
          AppVariables.store!.dispatch(SetCustomerLoadingAction(false));
          final ModalService modalService = getIt<ModalService>();
          modalService
              .showActionModal(
                context: context,
                title: 'Import Contacts',
                description:
                    'Would you like to import your contacts? This would require access to your contact list.',
                acceptText: 'Yes',
                cancelText: 'No',
                status: StatusType.defaultStatus,
              )
              .then((userWantsContacts) {
                if (userWantsContacts == true) {
                  AppVariables.store!.dispatch(SetCustomerLoadingAction(true));
                  // Gets permission status, if not granted then request permission.
                  checkPermission(context).then((requestAccepted) {
                    if (requestAccepted == true) {
                      // Granted permission
                      _hasPermission = true;
                      AppVariables.store!.dispatch(
                        customer_service.getContacts(refresh: false),
                      );
                    } else {
                      // Denied permission
                      AppVariables.store!.dispatch(
                        SetCustomerLoadingAction(false),
                      );
                      _hasPermission = false;
                    }
                  });
                } else {
                  // User doesn't want to import contacts
                  AppVariables.store!.dispatch(SetCustomerLoadingAction(false));
                  _hasPermission = false;
                }
              });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ContactsViewModel?>(
      onInit: (store) {},
      converter: (Store<AppState> store) {
        _vm = ContactsViewModel.fromStore(
          store,
          selectableItems: _vm?.selectableItems,
        );

        return _vm;
      },
      builder: (BuildContext context, ContactsViewModel? vm) =>
          scaffold(context, vm!),
    );
  }

  AppSimpleAppScaffold scaffold(context, ContactsViewModel vm) {
    return AppSimpleAppScaffold(
      isEmbedded: EnvironmentProvider.instance.isLargeDisplay,
      title: 'Import Contact List',
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            // Request contacts permission
            PermissionsProvider.instance
                .requestPermission(Permission.contacts)
                .then((result) async {
                  // Get permission status
                  var st = await result!.status;
                  // Update state
                  setState(() {
                    _hasPermission = (st == PermissionStatus.granted);
                  });

                  if (!st.isGranted) {
                    // User must allow permission in device settings
                    showPermissionDialog(context, Permission.contacts);
                  } else {
                    // call onRefresh only when we have permission, likely because
                    // onRefresh gets contacts by invoking a plugin, so possibly
                    // trying to get contacts without permission causes an error.
                    vm.onRefresh();
                  }
                });
          },
        ),
      ],
      body: vm.isLoading! ? const AppProgressIndicator() : layout(context, vm),
    );
  }

  bool _isContactsEmpty(ContactsViewModel vm) {
    var contacts = vm.state?.contacts;
    return contacts == null || contacts.isEmpty;
  }

  Widget _noContactsView(BuildContext context) {
    return Center(child: context.labelMediumBold('No contacts found'));
  }

  Widget layout(context, ContactsViewModel vm) => _isContactsEmpty(vm)
      ? _noContactsView(context)
      : Column(
          children: <Widget>[
            searchBar(context, vm),
            Visibility(
              visible: _hasPermission == false,
              child: needPermission(context),
            ),
            Visibility(
              visible: vm.selectedItems.isNotEmpty,
              child: selectedContactsHeader(context, vm),
            ),
            Visibility(
              visible: vm.selectedItems.isNotEmpty,
              child: const CommonDivider(),
            ),
            Visibility(
              visible: _hasPermission == true,
              child: Expanded(child: contactList(context, vm)),
            ),
            Visibility(
              visible: vm.selectedItems.isNotEmpty,
              child: inviteButton(context, vm),
            ),
          ],
        );

  FilterBar<SelectableItem<Contact>> searchBar(context, ContactsViewModel vm) =>
      FilterBar<SelectableItem<Contact>>(
        filterKey:
            GlobalKey<AutoCompleteTextFieldState<SelectableItem<Contact>>>(),
        itemSorter: (a, b) {
          return a.item.displayName
              .substring(0, 1)
              .toLowerCase()
              .compareTo(b.item.displayName.substring(0, 1).toLowerCase());
        },
        suggestions: vm.selectableItems,
        itemBuilder: (BuildContext context, SelectableItem suggestion) =>
            contactTile(
              context,
              suggestion as SelectableItem<Contact>,
              enableTap: false,
            ),
        itemFilter: (suggestion, query) => suggestion.item.displayName
            .toLowerCase()
            .startsWith(query.toLowerCase()),
        itemSubmitted: (SelectableItem data) {
          setState(() {
            data.selected = !data.selected!;
          });
        },
      );

  SizedBox inviteButton(context, ContactsViewModel vm) => SizedBox(
    child: Container(
      color: Colors.transparent,
      margin: const EdgeInsets.all(8.0),
      child: ButtonPrimary(
        text: 'Add ${vm.selectedItems.length} Customers',
        onTap: (context) {
          if (vm.selectedItems.isNotEmpty) {
            addCustomers(context, vm);
          }
        },
      ),
    ),
  );

  addCustomers(BuildContext context, ContactsViewModel vm) async {
    try {
      vm.saveContactList();
      Navigator.of(context).pop();
    } catch (e) {
      //debugPrint(e.toString());
      log('error occurred importing contacts', error: e);
    }
  }

  Scrollbar contactList(context, ContactsViewModel vm) {
    return Scrollbar(
      // isAlwaysShown: true, // TODO(lampian): fix
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) =>
            contactTile(context, vm.selectableItems![index]),
        itemCount: vm.selectableItems?.length ?? 0,
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(height: 8),
      ),
    );
  }

  SizedBox selectedContactsHeader(context, ContactsViewModel vm) => SizedBox(
    height: 100,
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          var contact = vm.selectedItems[index].item;

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  setState(() {
                    vm.selectedItems[index].selected =
                        !vm.selectedItems[index].selected!;
                  });
                },
                child: _ContactImage(contact: contact),
              ),
              const SizedBox(height: 8.0),
              LongText(contact.displayName, fontSize: 8),
            ],
          );
        },
        itemCount: vm.selectedItems.length,
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(width: 12.0),
      ),
    ),
  );

  ListTile contactTile(
    context,
    SelectableItem<Contact> contact, {
    bool enableTap = true,
  }) => ListTile(
    tileColor: Theme.of(context).colorScheme.background,
    dense: true,
    selected: contact.selected!,
    title: DecoratedText(contact.item.displayName, fontSize: null),
    subtitle: LongText(contact.item.phones.first.number ?? 'no mobile number'),
    leading: _ContactImage(contact: contact.item),
    trailing: Text(contact.item.displayName.substring(0, 1)),
    onTap: enableTap
        ? () {
            setState(() {
              contact.selected = !contact.selected!;
            });
          }
        : null,
  );

  ButtonPrimary needPermission(BuildContext context) => ButtonPrimary(
    text: 'Allow Access',
    onTap: (ctx) {
      // Request contacts permission
      AppVariables.store!.dispatch(SetCustomerLoadingAction(true));
      PermissionsProvider.instance.requestPermission(Permission.contacts).then((
        result,
      ) async {
        // Get contact permission status
        var st = await result!.status;
        if (st.isGranted) {
          if (mounted) setState(() => _hasPermission = true);
          AppVariables.store!.dispatch(
            customer_service.getContacts(refresh: false),
          );
        } else {
          AppVariables.store!.dispatch(SetCustomerLoadingAction(false));
          if (mounted) setState(() => _hasPermission = false);
          // Ask user to open device settings to allow permission
          // since by now they would have denied permission at least twice
          showPermissionDialog(context, Permission.contacts);
        }
      });
    },
  );

  Future<bool?> checkPermission(BuildContext context) async {
    /* 
    Gets status of contacts permission, if not granted then request permission.
    Returns true if contact permission is granted, otherwise false.
    */
    var ct = Permission.contacts;
    var status = await ct.status;
    if (!status.isGranted) {
      var result = await (PermissionsProvider.instance.requestPermission(ct));

      var d = await result?.status;
      return d?.isGranted;
    } else {
      return true;
    }
  }

  // A function which checks if we have contacts permission, returns true or false
  Future<bool?> hasPermission(
    BuildContext context,
    Permission permission,
  ) async {
    var status = await permission.status;
    if (status.isGranted) {
      return true;
    } else {
      return false;
    }
  }
}

class SelectableItem<T> with ChangeNotifier {
  SelectableItem({bool initialValue = false, required this.item}) {
    this.selected = initialValue;
  }

  bool? _selected;

  bool? get selected {
    return _selected;
  }

  set selected(bool? value) {
    if (_selected != value) {
      _selected = value;
      notifyListeners();
    }
  }

  T item;
}

class _ContactImage extends StatefulWidget {
  const _ContactImage({Key? key, required this.contact}) : super(key: key);

  final Contact contact;

  @override
  __ContactImageState createState() => __ContactImageState();
}

class __ContactImageState extends State<_ContactImage> {
  late Future<Uint8List?> _imageFuture;

  @override
  void initState() {
    super.initState();
    _imageFuture = FastContacts.getContactImage(widget.contact.id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: _imageFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const AppProgressIndicator();
        }
        if (snapshot.hasData && snapshot.data != null) {
          return Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: MemoryImage(snapshot.data!),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(30.0),
            ),
          );
        } else {
          return const Icon(Icons.account_circle, size: 56); // Fallback icon
        }
      },
    );
  }
}
