// removed ignore: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/environment/environment_config.dart';
import 'package:littlefish_merchant/ui/sales/sales_page.dart';
import 'package:redux/redux.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:littlefish_merchant/models/customers/customer.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_cart_item.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_transaction.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/checkout/checkout_actions.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/ui/checkout/pages/checkout_email_receipt_page.dart';
import 'package:littlefish_merchant/ui/checkout/pages/checkout_sms_receipt_page.dart';
import 'package:littlefish_merchant/ui/checkout/viewmodels/print_vm.dart';
import 'package:littlefish_merchant/ui/checkout/widgets/checkout_receipt.dart';
import 'package:littlefish_merchant/ui/customers/widgets/customer_list.dart';
import 'package:littlefish_merchant/ui/home/home_page.dart';

import '../../../app/app.dart';
import '../../../app/theme/applied_system/applied_text_icon.dart';
import '../../../common/presentaion/components/common_divider.dart';
import '../../../common/presentaion/components/decorated_text.dart';
import '../../../common/presentaion/components/dialogs/common_dialogs.dart';
import '../../../common/presentaion/pages/scaffolds/app_scaffold.dart';
import '../../../common/presentaion/pages/scaffolds/app_simple_scaffold.dart';
import '../../../features/pos/presentation/pages/pos_print_page.dart';
import '../../../injector.dart';

class VoidCompletePage extends StatefulWidget {
  static const String route = 'sales/void/complete';

  final bool isEmbedded;

  final bool isReprint;

  final PrintVM? printVM;

  final Function(String)? onEvent;

  final CheckoutTransaction? item;

  // receive customer in constructor when using large displays
  final Customer? customer;

  const VoidCompletePage({
    Key? key,
    this.item,
    this.isEmbedded = false,
    this.onEvent,
    this.printVM,
    this.isReprint = false,
    this.customer,
  }) : super(key: key);

  @override
  State<VoidCompletePage> createState() => _VoidCompletePageState();
}

class _VoidCompletePageState extends State<VoidCompletePage> {
  // Items (transaction) are passed throught the constructor
  // only for large displays and for small displays we pass arguments using ModalRoute
  // i.e. ModalRoute.of(context)!.settings.arguments as CheckoutTransaction?)
  CheckoutTransaction? transactionFromModalRouteArguments;

  Customer? customerFromModalRouteArguments;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    transactionFromModalRouteArguments =
        arguments?['transaction'] as CheckoutTransaction?;

    customerFromModalRouteArguments = arguments?['customer'] as Customer?;

    return StoreConnector<AppState, ReceiptViewModel>(
      converter: (Store<AppState> store) => ReceiptViewModel.fromStore(
        store,
        widget.item ?? transactionFromModalRouteArguments,
      ),
      builder: (BuildContext context, ReceiptViewModel vm) {
        if (vm.transaction == null) return noTransactionErrorLayout();

        return AppScaffold(
          displayAppBar: false,
          body: SafeArea(child: mobileLayout(context, vm)),
          title: '',
          persistentFooterButtons: [
            Column(children: [totalSummary(context, vm), closeButton(context)]),
          ],
        );
      },
    );
  }

  Widget noTransactionErrorLayout() {
    return AppSimpleAppScaffold(
      title: null,
      displayAppBar: false,
      footerActions: [
        ButtonPrimary(
          text: 'Close',
          onTap: (context) => Navigator.of(context).pop(),
        ),
      ],
      body: const SafeArea(
        child: Center(child: Text('Something went wrong, please try again.')),
      ),
    );
  }

  Widget customerSection(BuildContext context) {
    final customer = widget.customer ?? customerFromModalRouteArguments;

    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(
            top: 16.0,
            left: 16.0,
            right: 16.0,
            bottom: 8.0,
          ),
          alignment: Alignment.centerLeft,
          child: context.paragraphMedium(
            'Customer',
            color: Theme.of(context).colorScheme.primary,
            isSemiBold: true,
          ),
        ),
        if (customer != null) CustomerTile(item: customer),
      ],
    );
  }

  getTransactionItems(context) {
    CheckoutTransaction? transaction = widget.item;
    List<CheckoutCartItem>? allCartItems =
        transaction?.items ?? transactionFromModalRouteArguments?.items;
    if (allCartItems == null || allCartItems.isEmpty) {
      return const Center(child: Text('There are no items.'));
    }

    // Return list of items
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 0.0),
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        CheckoutCartItem cartItem = allCartItems[index];

        return ListTile(
          dense: true,
          title: context.paragraphMedium(
            '${cartItem.quantity.round()} x ${cartItem.description}',
            color: Theme.of(context).colorScheme.secondary,
            alignLeft: true,
            isBold: true,
          ),
          trailing: context.paragraphMedium(
            TextFormatter.toStringCurrency(cartItem.value, currencyCode: ''),
            color: Theme.of(context).colorScheme.secondary,
            isSemiBold: true,
          ),
        );
      },
      itemCount: allCartItems.length,
      separatorBuilder: (BuildContext context, int index) =>
          const CommonDivider(),
    );
  }

  Widget itemsSection(BuildContext context) => Column(
    children: [
      Container(
        padding: const EdgeInsets.only(
          top: 16.0,
          left: 16.0,
          right: 16.0,
          bottom: 8.0,
        ),
        alignment: Alignment.centerLeft,
        child: context.paragraphMedium('Items', isBold: true),
      ),
      getTransactionItems(context),
    ],
  );

  Widget totalSummary(BuildContext context, ReceiptViewModel vm) => Column(
    children: [
      _buildSummaryRow(
        'Total',
        vm.transaction!.checkoutTotal,
        const EdgeInsets.symmetric(vertical: 4),
      ),
    ],
  );

  Widget closeButton(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ButtonPrimary(
        text: 'Close',
        onTap: (context) {
          AppVariables.store!.dispatch(CheckoutClearAction(null));
          Navigator.of(context).pushNamedAndRemoveUntil(
            SalesPage.route,
            ModalRoute.withName(HomePage.route),
          );
        },
      ),
    );
  }

  Widget _buildSummaryRow(
    String title,
    double amount,
    EdgeInsetsGeometry padding, {
    String amountPrefix = '',
  }) {
    Color titleColour = Theme.of(context).colorScheme.primary;
    Color amountColour = Theme.of(context).colorScheme.primary;
    return Container(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DecoratedText(
            title,
            alignment: Alignment.topRight,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            textColor: titleColour,
          ),
          DecoratedText(
            '$amountPrefix${TextFormatter.toStringCurrency(amount, currencyCode: '')}',
            alignment: Alignment.topRight,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            textColor: amountColour,
          ),
        ],
      ),
    );
  }

  bool isDiscountApplied(ReceiptViewModel vm) {
    return vm.transaction!.totalDiscount != null &&
        vm.transaction!.totalDiscount != 0;
  }

  centerSuccess(BuildContext context, ReceiptViewModel vm) => Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.6),
        radius: 62.0, // 138.0
        child: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          radius: 48.0, // 136.0
          child: successIndicator(context),
        ),
      ),
      const SizedBox(height: 16.0),
      context.headingSmall(
        'Void Successful',
        color: Theme.of(context).colorScheme.primary,
        isSemiBold: true,
      ),
    ],
  );

  Widget mobileLayout(BuildContext context, ReceiptViewModel vm) {
    final hasCustomer =
        widget.customer != null || customerFromModalRouteArguments != null;

    return Flex(
      direction: Axis.vertical,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: centerSuccess(context, vm),
                ),
                receiptSection(context, vm),
                const CommonDivider(),
                Container(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    bottom: 8.0,
                    right: 16.0,
                    top: 16.0,
                  ),
                  alignment: Alignment.centerLeft,
                  child: context.headingXSmall(
                    'Summary',
                    color: Theme.of(
                      context,
                    ).extension<AppliedTextIcon>()?.emphasized,
                    isBold: true,
                  ),
                ),
                if (hasCustomer) customerSection(context),
                itemsSection(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget receiptButtons(BuildContext context, ReceiptViewModel vm) {
    final showPrinterControl =
        AppVariables.hasPrinter &&
        (cardPaymentRegistered == CardPaymentRegistered.pos);
    return Container(
      height: 70,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          if (showPrinterControl)
            ButtonPrimary(
              expand: false,
              layoutVertically: true,
              icon: Icons.print_outlined,
              text: 'Print',
              onTap: (context) async {
                if (vm.isPosDevice && context.mounted) {
                  showPopupDialog(
                    context: context,
                    content: PosPrintPage(
                      widget.item ?? transactionFromModalRouteArguments,
                      null,
                      isRefund: false,
                      parentContext: context,
                    ),
                  ).then((result) {});
                } else {
                  if (context.mounted) {
                    PrintVM printVM = PrintVM.fromStore(
                      StoreProvider.of<AppState>(context),
                    );
                    printVM.setReceipt(
                      widget.item ?? transactionFromModalRouteArguments,
                    );

                    printVM.debugPrint(context);
                  }
                }
              },
            ),
          ButtonPrimary(
            expand: false,
            layoutVertically: true,
            icon: Icons.sms_outlined,
            text: 'SMS',
            onTap: (context) {
              if (vm.store!.state.hasInternet!) {
                showPopupDialog(
                  height: 280,
                  context: context,
                  content: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: CheckoutSMSReceiptPage(
                      mobileNumber: vm.transaction!.customerMobile,
                      customerName: vm.transaction!.customerName,
                      transaction: vm.transaction,
                      transactionIsVoided: true,
                    ),
                  ),
                );
              } else {
                showMessageDialog(
                  context,
                  'Please go online to use this feature',
                  MdiIcons.wifi,
                );
              }
            },
          ),
          ButtonPrimary(
            expand: false,
            layoutVertically: true,
            icon: Icons.email_outlined,
            text: 'Email',
            onTap: (context) {
              if (vm.store!.state.hasInternet!) {
                showPopupDialog(
                  height: 280,
                  context: context,
                  content: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: CheckoutEmailReceiptPage(
                      emailAddress: vm.transaction!.customerEmail,
                      customerName: vm.transaction!.customerName,
                      transaction: vm.transaction,
                    ),
                  ),
                );
              } else {
                showMessageDialog(
                  context,
                  'Please go online to use this feature',
                  MdiIcons.wifi,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget receiptSection(BuildContext context, ReceiptViewModel vm) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 16.0, bottom: 8.0, right: 16.0),
          alignment: Alignment.centerLeft,
          child: context.headingXSmall(
            'Send Receipt',
            color: Theme.of(context).extension<AppliedTextIcon>()?.emphasized,
            isBold: true,
          ),
        ),
        receiptButtons(context, vm),
      ],
    );
  }

  successIndicator(context) => const Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Icon(
        Icons.check,
        size: 64.0, // 128.0
        color: Colors.white, //Theme.of(context).colorScheme.primary,
      ),
    ],
  );
}
