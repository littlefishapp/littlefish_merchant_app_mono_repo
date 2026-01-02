// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/models/store/receipt_data.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';

// Project imports:
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/business/profile/forms/business_details_form.dart';
import 'package:littlefish_merchant/ui/business/profile/forms/business_receipt_form.dart';
import 'package:littlefish_merchant/ui/business/profile/viewmodels/view_models.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_secondary.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_tabbed_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_tabbar.dart';

import '../../../../common/presentaion/components/buttons/button_primary.dart';
import '../../../../common/presentaion/pages/scaffolds/app_scaffold.dart';

class BusinessProfilePage extends StatefulWidget {
  static const String route = 'business/manage';

  final bool embedded;

  const BusinessProfilePage({Key? key, this.embedded = false})
    : super(key: key);

  @override
  State<BusinessProfilePage> createState() => _BusinessProfilePageState();
}

class _BusinessProfilePageState extends State<BusinessProfilePage> {
  final GlobalKey<FormState> formKey = GlobalKey();

  final GlobalKey<FormState> receiptKey = GlobalKey();

  int tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, BusinessProfileVM>(
      converter: (store) => BusinessProfileVM.fromStore(store)
        ..key = formKey
        ..receiptKey = receiptKey,
      builder: (context, BusinessProfileVM vm) => scaffold(context, vm),
    );
  }

  Widget scaffold(context, BusinessProfileVM vm) {
    final isTablet = EnvironmentProvider.instance.isLargeDisplay ?? false;
    final showSideNav =
        isTablet || (AppVariables.store!.state.enableSideNavDrawer ?? false);
    return AppScaffold(
      title: vm.item!.name ?? 'Profile',
      enableProfileAction: !showSideNav,
      hasDrawer: false,
      displayNavDrawer: false,
      persistentFooterButtons: <Widget>[
        ButtonPrimary(
          text: 'Save',
          upperCase: false,
          onTap: (_) {
            vm.onSave(vm.item, context);
          },
        ),
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            vm.reset(context);
          },
        ),
      ],
      body: vm.isLoading! ? const AppProgressIndicator() : layout(context, vm),
    );
  }

  AppTabBar layout(context, BusinessProfileVM vm) => AppTabBar(
    reverse: true,
    physics: const NeverScrollableScrollPhysics(),
    tabAlignment: TabAlignment.fill,
    onTabChanged: (i) {
      tabIndex = i;
      if (mounted) setState(() {});
    },
    tabs: [
      TabBarItem(
        text: 'details',
        content: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: BusinessDetailsForm(formKey: formKey, profile: vm.item),
              ),
            ),
            // SizedBox(
            //   child: Container(
            //     padding: EdgeInsets.symmetric(horizontal: 8),
            //     child: CapsuleOutlineButton(
            //       onTap: (c) => showPopupDialog(
            //         content: ContactsList(contacts: vm.item.contacts),
            //         context: context,
            //       ),
            //       text: "Contacts",
            //       textColor: Theme.of(context).colorScheme.primary,
            //     ),
            //   ),
            // ),
            // CommonDivider(),
            SizedBox(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ButtonSecondary(
                  onTap: (c) async {
                    ReceiptData? data = await showPopupDialog(
                      defaultPadding: false,
                      content: BusinessReceiptForm(
                        formKey: vm.receiptKey,
                        receiptData: vm.item!.receiptData,
                      ),
                      context: context,
                    );

                    if (data != null) vm.item!.receiptData = data;
                  },
                  text: 'Receipts',
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
