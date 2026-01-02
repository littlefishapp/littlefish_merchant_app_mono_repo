// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';

// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/shared/data/contact.dart';
import 'package:littlefish_merchant/models/suppliers/supplier.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/common/presentaion/pages/address_screen_dynamic.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_secondary.dart';
import 'package:littlefish_merchant/common/presentaion/pages/contacts/contacts_list.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_tabbed_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_tabbar.dart';
import 'package:littlefish_merchant/ui/suppliers/forms/supplier_details_form.dart';
import 'package:littlefish_merchant/ui/suppliers/view_models/view_models.dart';
import 'package:littlefish_merchant/ui/suppliers/widgets/supplier_products.dart';

import '../../common/presentaion/components/buttons/button_primary.dart';
import '../../common/presentaion/components/icons/delete_icon.dart';
import '../../common/presentaion/pages/scaffolds/app_scaffold.dart';

class SupplierPage extends StatefulWidget {
  static const String route = '/supplier-details';

  final bool? embedded;

  final Supplier? supplier;
  final BuildContext? parentContext;

  const SupplierPage({
    Key? key,
    this.embedded,
    this.supplier,
    this.parentContext,
  }) : super(key: key);

  @override
  State<SupplierPage> createState() => _SupplierPageState();
}

class _SupplierPageState extends State<SupplierPage> {
  final GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SupplierVM>(
      converter: (Store store) {
        return SupplierVM.fromStore(store as Store<AppState>)..key = key;
      },
      builder: (BuildContext ctx, SupplierVM vm) =>
          scaffold(widget.parentContext ?? context, vm),
    );
  }

  Widget scaffold(context, SupplierVM vm) {
    final isTablet = EnvironmentProvider.instance.isLargeDisplay ?? false;
    return AppScaffold(
      // isEmbedded: EnvironmentProvider.instance.isLargeDisplay,
      title: vm.item?.displayName == null || vm.item!.displayName!.isEmpty
          ? 'New Supplier'
          : vm.item!.displayName ?? 'New Supplier',
      enableProfileAction: !isTablet,
      displayBackNavigation: !isTablet,
      actions: vm.item!.displayName != null && vm.item!.displayName!.isNotEmpty
          ? <Widget>[
              IconButton(
                icon: const DeleteIcon(),
                onPressed: () {
                  vm.onRemove(vm.item, context);
                },
              ),
            ]
          : null,
      persistentFooterButtons: [
        footerButtonsIconPrimary(
          vm: vm,
          primaryButtonText: 'Save',
          onPrimaryButtonPressed: (context) {
            vm.onAdd(vm.item, context);
          },
          allSecondaryControls: isTablet,
        ),
      ],
      body: vm.isLoading!
          ? const AppProgressIndicator()
          : AppTabBar(
              reverse: true,
              tabs: [
                TabBarItem(
                  text: 'Details',
                  content: detailsLayout(context, vm),
                ),
              ],
            ),
    );
  }

  ListView detailsLayout(context, SupplierVM vm) => ListView(
    physics: const BouncingScrollPhysics(),
    shrinkWrap: false,
    children: <Widget>[
      form(context, vm),
      SizedBox(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ButtonSecondary(
            onTap: (c) => showPopupDialog(
              content: ContactsList(contacts: vm.item!.contacts ?? <Contact>[]),
              context: context,
            ),
            text: 'Contacts',
          ),
        ),
      ),
      const SizedBox(height: 8),
      SizedBox(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ButtonSecondary(
            onTap: (c) => showPopupDialog(
              content: SupplierProducts(supplier: vm.item),
              context: context,
            ),
            text: 'Products',
          ),
        ),
      ),
      const SizedBox(height: 8),
      SizedBox(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child:
              vm.item!.address != null && vm.item!.address!.friendlyName != null
              ? ButtonBar(
                  buttonMinWidth: MediaQuery.of(context).size.width,
                  alignment: MainAxisAlignment.center,
                  buttonPadding: EdgeInsets.zero,
                  children: [
                    // TODO(lampian): fix colors
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      // padding: EdgeInsets.zero,
                      // color: Theme.of(context).colorScheme.secondary,
                      child: Text(
                        vm.item!.address!.friendlyName!,
                        style: const TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        //Navigator.of(context).push(
                        //MaterialPageRoute(
                        SupplierVM? localVM = await showPopupDialog(
                          context: context,
                          content: AddressScreenDynamic(
                            vm: vm,
                            addressId: 'supp',
                            storeAddress: vm.item!.address,
                            modalTitle: 'Supplier Address',
                          ),
                        );

                        vm.item!.address;

                        if (localVM != null) {
                          setState(() {
                            vm = localVM;
                          });

                          Navigator.of(context).pop();
                        }
                        // ),
                        //);
                      },
                    ),
                  ],
                )
              : ButtonSecondary(
                  onTap: (c) async {
                    //Navigator.of(context).push(
                    //MaterialPageRoute(
                    SupplierVM? localVM = await showPopupDialog(
                      context: c,
                      content: AddressScreenDynamic(
                        vm: vm,
                        addressId: 'supp',
                        storeAddress: vm.item!.address,
                        modalTitle: 'Supplier Address',
                      ),
                    );

                    vm.item!.address;

                    if (localVM != null) {
                      setState(() {
                        vm = localVM;
                      });

                      Navigator.of(context).pop();
                    }
                    // ),
                    //);
                  },
                  text: 'Supplier Address',
                ),
        ),
      ),

      // ExpandableStoreAddress(
      //   details: vm.item!.address ?? new st.StoreAddress(),
      //   fieldsEnabled: true,
      // ),
      // Expanded(child: SizedBox()),
      // SizedBox(
      //   height: 16,
      // ),
      // Row(
      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //   children: <Widget>[
      // Expanded(
      //   child: Container(
      //     color: Colors.grey.shade50,
      //     height: 60,
      //     child: ElevatedButton(
      //       color: Theme.of(context).colorScheme.primary,
      //       child: Row(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           crossAxisAlignment: CrossAxisAlignment.center,
      //           children: <Widget>[
      //             Text(
      //               "Save1111111",
      //               style: TextStyle(
      //                 fontSize: 16,
      //                 color: Colors.white,
      //               ),
      //             )
      //           ]),
      //       onPressed: () {
      //         vm.onAdd(vm.item, context);
      //       },
      //     ),
      //   ),
      // )
      // // ],
      // ),
    ],
  );

  Container form(BuildContext context, SupplierVM vm) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: SupplierDetailsForm(formKey: vm.key, supplier: vm.item),
  );

  Widget footerButtonsIconPrimary({
    required SupplierVM vm,
    required String primaryButtonText,
    required Function(BuildContext) onPrimaryButtonPressed,
    final bool allSecondaryControls = false,
  }) {
    return allSecondaryControls
        ? ButtonSecondary(
            text: primaryButtonText,
            upperCase: false,
            onTap: (context) {
              onPrimaryButtonPressed.call(context);
            },
          )
        : ButtonPrimary(
            text: 'Save',
            upperCase: false,
            onTap: (context) {
              onPrimaryButtonPressed.call(context);
            },
          );
  }
}
