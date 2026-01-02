import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/models/settings/payments/payment_type.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/redux/app_settings/app_settings_actions.dart';
import 'package:littlefish_merchant/tools/billing/billing_helpers.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:littlefish_merchant/ui/settings/view_models/view_models.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';

// import 'package:nybble_shared_ui/nybble_shared_ui.dart';

class SettingPaymentTypes extends StatefulWidget {
  static const String route = 'checkout/payment-types';

  const SettingPaymentTypes({Key? key}) : super(key: key);

  @override
  State<SettingPaymentTypes> createState() => _SettingPaymentTypesState();
}

class _SettingPaymentTypesState extends State<SettingPaymentTypes> {
  @override
  Widget build(BuildContext context) {
    final isTablet = EnvironmentProvider.instance.isLargeDisplay ?? false;
    final showSideNav =
        isTablet || (AppVariables.store!.state.enableSideNavDrawer ?? false);
    return AppScaffold(
      title: 'Payment Types',
      enableProfileAction: !showSideNav,
      hasDrawer: false,
      displayNavDrawer: false,
      body: layout(context),
    );
  }

  StoreConnector<AppState, PaymentTypesViewModel> layout(context) =>
      StoreConnector<AppState, PaymentTypesViewModel>(
        // onInit: (store) => store.dispatch(setPaymentTypes()),
        onInit: (store) => store.dispatch(setClientPaymentTypes()),
        converter: (Store<AppState> store) =>
            PaymentTypesViewModel.fromStore(store),
        builder: (BuildContext context, PaymentTypesViewModel vm) =>
            vm.isLoading! ? const AppProgressIndicator() : listing(context, vm),
      );

  ListView listing(context, PaymentTypesViewModel vm) {
    List<PaymentType>? refinedPaymentTypes;
    if (AppVariables.store!.state.enableOnlyCashCardSnapscanPayments == true) {
      refinedPaymentTypes = vm.items
          ?.where(
            (e) => e.name == 'Cash' || e.name == 'Card' || e.name == 'Snapscan',
          )
          .toList();
    } else {
      refinedPaymentTypes = vm.items!;
    }

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: refinedPaymentTypes!.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) =>
          paymentTile(context, refinedPaymentTypes![index], vm),
      separatorBuilder: (BuildContext context, int index) =>
          const CommonDivider(),
    );
  }

  // TODO(lampian): discuss version update impact on flutter switchlisttile
  Widget paymentTile(
    BuildContext context,
    PaymentType item,
    PaymentTypesViewModel vm,
  ) {
    return cleanString(item.name) == 'credit'
        ? const SizedBox.shrink()
        : SwitchListTile(
            activeColor: Theme.of(context).extension<AppliedTextIcon>()?.brand,
            title: context.paragraphMedium(
              item.name!,
              alignLeft: true,
              isBold: true,
            ),
            subtitle: context.body02x14R(
              '${item.enabled! ? "You" : "You do not"} '
              'accept ${item.name!.toLowerCase()} payments',
              color: Theme.of(context).extension<AppliedTextIcon>()?.secondary,
              alignLeft: true,
            ),
            onChanged: (value) {
              if (isNotPremium(cleanString(item.name)) && value == true) {
                showPopupDialog(
                  defaultPadding: false,
                  context: context,
                  content: billingNavigationHelper(isModal: true),
                );

                // Navigator.of(context).push(
                //   CustomRoute(builder: (BuildContext context) {
                //     return billingNavigationHelper();
                //   }),
                // );
              } else {
                var thirdParyItems = ['Snapscan', 'Zapper'];

                if (thirdParyItems.contains(item.name)) {
                  var tParty = AppVariables
                      .store!
                      .state
                      .businessState
                      .enabledLinkedAccounts
                      .map((e) => e.providerName);

                  if (tParty.contains(item.name)) {
                    setState(() {
                      item.enabled = value;
                    });
                    vm.onAdd(item, context);
                  } else {
                    showMessageDialog(
                      context,
                      'In order to enable ${item.name}, please create '
                      'a linked account under Settings.',
                      LittleFishIcons.info,
                    );
                  }
                } else {
                  setState(() {
                    item.enabled = value;
                  });
                  vm.onAdd(item, context);
                }
              }
            },
            value: item.enabled!,
          );
  }
}
