// Dart imports:
// remove ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:

import 'package:fast_contacts/fast_contacts.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:permission_handler/permission_handler.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/providers/permissions_provider.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/customer/customer_actions.dart';
import 'package:littlefish_merchant/ui/customers/pages/customer_import_page.dart';
import 'package:littlefish_merchant/ui/customers/viewmodels/customer_view_models.dart';
import 'package:littlefish_merchant/common/presentaion/components/circle_gradient_avatar.dart';
import 'package:littlefish_merchant/common/presentaion/components/fliter_bar.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/auto_complete_text_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/common/presentaion/components/decorated_text.dart';
import 'package:littlefish_merchant/common/presentaion/components/long_text.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/redux/customer/customer_actions.dart'
    as customer_service;

class ContactsSelectPage extends StatefulWidget {
  const ContactsSelectPage({Key? key}) : super(key: key);

  @override
  State<ContactsSelectPage> createState() => _ContactsSelectPageState();
}

class _ContactsSelectPageState extends State<ContactsSelectPage> {
  ContactsViewModel? _vm;

  bool _hasPermission = false;

  // bool _neverAllow = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ContactsViewModel?>(
      onInit: (store) {
        store.dispatch(SetCustomerLoadingAction(true));
        checkPermission(context).then((result) {
          if (result == true) {
            _hasPermission = true;
            store.dispatch(customer_service.getContacts(refresh: false));
          } else {
            store.dispatch(SetCustomerLoadingAction(false));
            // _neverAllow = true;
            _hasPermission = false;
          }
        });
      },
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
      title: 'Import Contacts',
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
                    // this._neverAllow = (st == PermissionStatus.denied);
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

            // if (_hasPermission) {
            //   vm.onRefresh();
            // }
          },
        ),
      ],
      body: vm.isLoading! ? const AppProgressIndicator() : layout(context, vm),
    );
  }

  Column layout(context, ContactsViewModel vm) => Column(
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
        child: importButton(context, vm),
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

  SizedBox importButton(context, ContactsViewModel vm) => SizedBox(
    child: Container(
      color: Colors.transparent,
      margin: const EdgeInsets.all(8.0),
      child: ButtonPrimary(
        text: 'Import ${vm.selectedItems.length} Contacts',
        onTap: (context) {
          if (vm.selectedItems.isNotEmpty) {
            addContacts(context, vm);
          }
        },
      ),
    ),
  );

  addContacts(BuildContext context, ContactsViewModel vm) async {
    try {
      Navigator.of(context).pop(vm.getSelectedItems());
    } catch (e) {
      //debugPrint(e.toString());
      log('error occurred importing contacts', error: e);
    }
  }

  ListView contactList(context, ContactsViewModel vm) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) =>
          contactTile(context, vm.selectableItems![index]),
      itemCount: vm.selectableItems?.length ?? 0,
      separatorBuilder: (BuildContext context, int index) =>
          const CommonDivider(),
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
    trailing: OutlineGradientAvatar(
      child: DecoratedText(
        contact.item.displayName.substring(0, 1),
        fontSize: null,
        alignment: Alignment.center,
      ),
    ),
    onTap: enableTap
        ? () {
            setState(() {
              contact.selected = !contact.selected!;
            });
          }
        : null,
  );

  // needPermission(BuildContext context) => _neverAllow
  //     ? Center(
  //         child: neverAllowed(context),
  //       )
  //     : ElevatedButton(
  //         child: DecoratedText("Allow Access "),
  //         onPressed: (() {
  //           PermissionsProvider.instance
  //               .requestPermission(Permission.contacts)
  //               .then((result) async {
  //             var st = await result!.status;
  //             setState(() {
  //               this._hasPermission = (st == PermissionStatus.granted);
  //             });
  //           });
  //         }),
  //       );

  ButtonPrimary needPermission(BuildContext context) => ButtonPrimary(
    text: 'Allow Access',
    onTap: (ctx) {
      // Request contacts permission
      PermissionsProvider.instance.requestPermission(Permission.contacts).then((
        result,
      ) async {
        // Get contact permission status
        var st = await result!.status;
        if (st.isGranted) {
          if (mounted) setState(() => _hasPermission = true);
          if (_vm != null) _vm!.onRefresh();
        } else {
          // AppVariables.store!.dispatch(SetCustomerLoadingAction(false));
          if (mounted) setState(() => _hasPermission = false);
          // Ask user to open device settings to allow permission
          // since by now they would have denied permission at least twice
          showPermissionDialog(context, Permission.contacts);
        }
      });
    },
  );

  // neverAllowed(BuildContext context) => Container(
  //       margin: EdgeInsets.all(16.0),
  //       alignment: Alignment.center,
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: <Widget>[
  //           Icon(Icons.not_interested),
  //           SizedBox(
  //             height: 8.0,
  //           ),
  //           LongText(
  //             "Please go to your settings and allow us access to your contacts, as it appears you have banned us from taking a look",
  //             fontSize: null,
  //             maxLines: 4,
  //           )
  //         ],
  //       ),
  //     );

  Future<bool?> checkPermission(BuildContext context) async {
    // await PermissionsProvider.instance.getDevicePermissions();
    var ct = Permission.contacts;
    // var pp = await PermissionsProvider.instance.hasPermission(ct);
    var status = await ct.status;
    if (!status.isGranted) {
      var result = await (PermissionsProvider.instance.requestPermission(
        Permission.contacts,
      ));

      var d = await result?.status;
      return d?.isGranted;
    } else {
      return true;
    }
  }

  // Permission getPermission(BuildContext context) {
  //   return PermissionsProvider.instance.getPermission(Permission.contacts);
  // }
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
          return const AppProgressIndicator(); // Show a loading indicator while fetching
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
