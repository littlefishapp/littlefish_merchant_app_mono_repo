// Flutter imports:
// remove ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/simple_app_scaffold.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/settings/payments/payment_type.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/online_store/viewmodels/manage_order_vm.dart';
import 'package:littlefish_merchant/common/presentaion/pages/popup_forms/amount_popup_form.dart';
import 'package:littlefish_icons/littlefish_icons.dart';

import '../../../../common/presentaion/components/cards/card_neutral.dart';
import '../../../../common/presentaion/components/custom_app_bar.dart';
import '../../../../features/ecommerce_shared/models/checkout/checkout_order.dart';
import '../../../../tools/textformatter.dart';
import '../../../../common/presentaion/components/dialogs/common_dialogs.dart';
import '../../../../common/presentaion/components/decorated_text.dart';
import '../../../../common/presentaion/components/long_text.dart';
import '../../../../common/presentaion/components/text_tag.dart';

class OrderChargeScreen extends StatefulWidget {
  static const String route = '/order/charge';

  final bool isEmbedded;

  final BuildContext? parentContext;

  final CheckoutOrder? item;
  const OrderChargeScreen({
    Key? key,
    this.isEmbedded = false,
    required this.item,
    this.parentContext,
  }) : super(key: key);

  @override
  State<OrderChargeScreen> createState() => _OrderChargeScreenState();
}

class _OrderChargeScreenState extends State<OrderChargeScreen> {
  CheckoutOrder? item;
  late CheckoutHelper helper;
  late ManageOrderVM vm;
  int? paymentTypeIndex;
  // AsyncMemoizer<List<SystemPaymentType>?> _memoizer = AsyncMemoizer();

  @override
  void initState() {
    item = widget.item;
    helper = CheckoutHelper(
      totalValue: item!.totalDueByCustomer,
      amountTendered: 0,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ManageOrderVM>(
      converter: (Store store) {
        return ManageOrderVM.fromStore(store as Store<AppState>)
        // ..store.dispatch(
        //   initializeDrivers(refresh: true),
        ;
      },
      builder: (BuildContext context, ManageOrderVM vm) {
        this.vm = vm;

        return SimpleAppScaffold(
          bottomButtonText: 'Complete Order',
          bottomButtonFunction: vm.isLoading == false
              ? () async {
                  if (!helper.isShort) {
                    if (helper.type == null) {
                      showMessageDialog(
                        context,
                        'Choose Payment',
                        LittleFishIcons.info,
                      );
                    } else if (helper.type!.name == 'zapper' ||
                        helper.type!.name == 'snapscan') {
                      var result = await setPaymentPopup(helper.type!, context);
                      if (result['proceed'] && !result['paid']) {
                        vm.completeOrder(
                          context,
                          item!,
                          paymentType: helper.type!,
                          reference: result['providerPaymentReference'],
                        );
                      } else if (result['proceed'] && result['paid']) {
                        vm.completeOrder(
                          context,
                          item!,
                          paymentType: helper.type!,
                          reference: result['providerPaymentReference'],
                        );
                        if (mounted) {
                          setState(() {
                            vm.isLoading = true;
                          });
                        }
                      } else {
                        showMessageDialog(
                          context,
                          'Payment Cancelled',
                          LittleFishIcons.info,
                        );
                      }
                    } else {
                      if (helper.type!.name == 'ozow') {
                        // var result = await setPaymentPopup(helper.type!, context);

                        // if (isNotBlank(result)) {
                        //   vm.isLoading = true;
                        //   await ozowSetup(result);
                        //   vm.isLoading = false;
                        // } else {
                        //   showMessageDialog(
                        //       context, 'SMS could not be sent', LittleFishIcons.error);
                        // }
                      } else {
                        if (mounted) {
                          setState(() {
                            vm.isLoading = true;
                          });
                        }
                        vm.completeOrder(
                          context,
                          item!,
                          paymentType: helper.type!,
                        );
                      }
                    }
                  } else {
                    showMessageDialog(
                      context,
                      'Not Enough money Received',
                      LittleFishIcons.info,
                    );
                  }
                }
              : null,
          appBar:
              CustomAppBar(
                    centerTitle: true,
                    elevation: 0,
                    title: Text(
                      'Complete Sale',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  )
                  as AppBar,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (vm.isLoading!) const LinearProgressIndicator(),
              cartAmountOptions(context, vm),
              Expanded(child: amountDue(context)),
              customerInformationTile(),
              typeGrid(context, vm),
            ],
          ),
        );
      },
    );
  }

  setPaymentPopup(PaymentType type, BuildContext ctx) {
    // switch (type.type) {
    //   case 'zapper':
    //     return showPopupDialog(
    //       context: ctx,
    //       content: ZapperPayPage(item, type, parentContext: ctx),
    //     );
    //   case 'snapscan':
    //     return showPopupDialog(
    //       context: ctx,
    //       content: SnapscanPayPage(item, type, parentContext: ctx),
    //     );
    //   case 'ozow':
    //     return showPopupDialog(
    //       defaultPadding: false,
    //       context: ctx,
    //       content: InputModal(
    //         mobileNumber: true,
    //         title: "Customer Number",
    //         description: "Mobile Number",
    //         inputTitle: "Mobile Number",
    //       ),
    //     );
    //   default:
    //     return null;
    // }
  }

  ListTile customerInformationTile() => ListTile(
    tileColor: Theme.of(context).colorScheme.background,
    title: Text(item!.customerName ?? 'N/A'),
    leading: Icon(Icons.person, color: Theme.of(context).colorScheme.primary),
  );

  GridView typeGrid(BuildContext context, ManageOrderVM vm) => GridView.builder(
    // key: _paymentTypeKey,
    physics: const BouncingScrollPhysics(),
    itemCount: vm.paymentTypes.length,
    shrinkWrap: true,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      childAspectRatio: 1.75,
    ),
    itemBuilder: (BuildContext context, int index) => paymentCard(
      index: vm.paymentTypes[index].displayIndex!,
      selectedIcon: vm.paymentTypes[index].icon!,
      unselectedIcon: vm.paymentTypes[index].icon!,
      type: vm.paymentTypes[index],
      vm: vm,
      // vm: vm,
    ),
  );

  // typeGrid(BuildContext context, ManageOrderVM vm) => GridView.builder(
  //       physics: BouncingScrollPhysics(),
  //       itemCount: vm.paymentTypes?.length,
  //       shrinkWrap: true,
  //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //         crossAxisCount: 3,
  //         childAspectRatio: 1.75,
  //       ),
  //       itemBuilder: (BuildContext context, int index) => paymentCard(
  //         index: vm.paymentTypes![index].displayIndex,
  //         selectedIcon: vm.paymentTypes![index].icon,
  //         unselectedIcon: vm.paymentTypes![index].icon,
  //         type: vm.paymentTypes![index],
  //       ),
  //     );

  // ozowSetup(String? number) async {
  //   var service = OzowService.fromPaymentConfig(helper.type!, vm!.store!);
  //   var res = await service.sendOzowPaymentRequest(item!);

  //   if (isNotBlank(res.errorMessage)) {
  //     reportCheckedError(res.errorMessage);
  //     showMessageDialog(context, res.errorMessage!, LittleFishIcons.error);
  //   } else if (isNotBlank(res.url)) {
  //     var notificationCF = NotificationServiceCF(store: vm!.store!);

  //     await notificationCF.sendSMS(
  //       'OZOW Payment: ' + res.url!,
  //       [number],
  //     );

  //     await showMessageDialog(context, 'SMS Sent Successfully', LittleFishIcons.info);
  //   } else {
  //     reportCheckedError('Ozow url is null');
  //     showErrorDialog(context, 'Ozow Error');
  //   }
  // }

  InkWell paymentCard({
    required IconData unselectedIcon,
    required IconData selectedIcon,
    required int index,
    required PaymentType type,
    required ManageOrderVM vm,
  }) => InkWell(
    onTap: () {
      paymentTypeIndex = index;
      helper.type = type;
      helper.selectedIndex = index;

      if (type.name!.toLowerCase() != 'cash') {
        helper.amountTendered = item!.totalDueByCustomer;
      }
      // if (isNotPremium(type.name)) {
      //   showPopupDialog(
      //     defaultPadding: false,
      //     context: context,
      //     content: billingNavigationHelper(isModal: true),
      //   );
      //   // Navigator.of(context).push(
      //   //   CustomRoute(builder: (BuildContext context) {
      //   //     return billingNavigationHelper();
      //   //   }),
      //   // );
      // } else {
      // }
      // vm.setPaymentType(type);

      if (mounted) setState(() {});
    },
    child: Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade50)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          (type.imageURI != null && type.imageURI!.isNotEmpty)
              ? Container(
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage(type.imageURI!)),
                  ),
                )
              : Icon(
                  paymentTypeIndex == index ? selectedIcon : unselectedIcon,
                  size: 30.0,
                  color: paymentTypeIndex == index
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey.shade700,
                ),
          const SizedBox(height: 8.0),
          DecoratedText(
            type.name!,
            textColor: paymentTypeIndex == index
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.shade700,
            alignment: Alignment.bottomCenter,
          ),
        ],
      ),
    ),
  );

  Widget cartAmountOptions(
    BuildContext context,
    ManageOrderVM vm,
  ) => CardNeutral(
    elevation: 0,
    child: ListTile(
      tileColor: Theme.of(context).colorScheme.background,
      trailing: TextTag(
        displayText: TextFormatter.toStringCurrency(
          item!.totalDueByCustomer,
          currencyCode: '',
        ),
        fontSize: 14,
        color: helper.isShort
            ? Colors.red
            : Theme.of(context).colorScheme.primary,
      ),
      onTap: () {
        if (mounted) {
          setState(() {
            helper.amountTendered = item!.totalDueByCustomer;
          });
        }
      },
      title: const Text('Amount Due'),
      subtitle: LongText(
        "Amount Due: ${TextFormatter.toStringCurrency(item!.totalDueByCustomer, currencyCode: '')}",
      ),
    ),
  );

  Material amountDue(context) => Material(
    child: InkWell(
      onTap: () {
        showPopupDialog(
          defaultPadding: false,
          context: context,
          content: AmountPopupForm(
            initialValue: helper.amountTendered,
            title: 'Amount Payable',
            subTitle: 'Please enter the amount the customer is paying you now',
            hintText: 'Enter amount here',
            onSubmit: (context, value) {
              helper.amountTendered = value;
            },
          ),
        );
      },
      child: SizedBox(
        // margin: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text('Amount Received'),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  TextFormatter.toStringCurrency(
                    helper.amountTendered,
                    displayCurrency: true,
                    currencyCode: '',
                  ),
                  style: TextStyle(
                    fontSize: 36,
                    color: helper.isShort
                        ? Colors.red
                        : Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              helper.isShort
                  ? "Amount Outstanding: ${TextFormatter.toStringCurrency(helper.amountShort, displayCurrency: false, currencyCode: '')}"
                  : "Change: ${TextFormatter.toStringCurrency(helper.amountShort, displayCurrency: false, currencyCode: '')}",
            ),
          ],
        ),
      ),
    ),
  );
}

class CheckoutHelper {
  double? amountTendered, totalValue;
  bool get isShort => (totalValue ?? -1) > (amountTendered ?? 0);

  double get amountShort => (amountTendered ?? 0) - totalValue!;

  PaymentType? type;

  int? selectedIndex;

  CheckoutHelper({this.amountTendered, this.totalValue});
  // double get amountShort => amountTendered - totalValue;
}
