// Flutter imports:
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/cards/card_square_flat.dart';

// Package imports:
import 'package:littlefish_merchant/ui/checkout/layouts/library/select_products_page.dart';

// Project imports:
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/receipt_button.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';
import 'package:littlefish_merchant/models/customers/customer.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/ui/customers/widgets/customer_list.dart';
import 'package:littlefish_merchant/common/presentaion/components/decorated_text.dart';
import 'package:littlefish_merchant/models/expenses/business_expense.dart';

import '../../../../features/order_complete_pages/presentation/components/transaction_success_display_section.dart';
import '../../../../injector.dart';

class QuickRefundCompletePage extends StatefulWidget {
  static const String route = 'refund/complete';
  final BusinessExpense refund;
  final Customer customer;

  const QuickRefundCompletePage({
    Key? key,
    required this.refund,
    required this.customer,
  }) : super(key: key);

  @override
  QuickRefundCompletePageState createState() => QuickRefundCompletePageState();
}

class QuickRefundCompletePageState extends State<QuickRefundCompletePage> {
  @override
  Widget build(BuildContext context) {
    return AppSimpleAppScaffold(
      displayAppBar: false,
      body: SafeArea(child: mobileLayout(context)),
      title: '',
      footerActions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: totalAndCloseButton(context),
        ),
      ],
    );
  }

  Widget mobileLayout(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const CardSquareFlat(
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  child: TransactionSuccessDisplaySection(
                    message: 'Refund Successful',
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    bottom: 8.0,
                    right: 16.0,
                    top: 16.0,
                  ),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Summary',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                customerSection(context),
                itemsSection(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget receiptSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16.0, bottom: 8.0, right: 16.0),
      alignment: Alignment.centerLeft,
      child: Text(
        'Send Refund Receipt',
        style: TextStyle(
          color: Theme.of(context).colorScheme.primaryContainer,
          fontSize: 20.0,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget customerSection(BuildContext context) {
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
          child: Text(
            'Customer',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primaryContainer,
              fontSize: 16.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        CustomerTile(item: widget.customer),
      ],
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
        child: Text(
          'Items',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primaryContainer,
            fontSize: 16.0,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      getTransactionItems(context),
    ],
  );

  Widget totalAndCloseButton(BuildContext context) => Column(
    children: [
      Container(
        padding: EdgeInsets.symmetric(
          vertical: widget.refund.sourceOfFunds?.name.toLowerCase() == 'cash'
              ? 8
              : 16,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DecoratedText(
              'Total Refunded',
              alignment: Alignment.topRight,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              textColor: Theme.of(context).colorScheme.primaryContainer,
            ),
            DecoratedText(
              TextFormatter.toStringCurrency(
                widget.refund.amount,
                currencyCode: '',
              ),
              alignment: Alignment.topRight,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              textColor: Theme.of(context).colorScheme.primaryContainer,
            ),
          ],
        ),
      ),
      Container(
        padding: const EdgeInsets.only(bottom: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DecoratedText(
              'Refund via',
              alignment: Alignment.topRight,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              textColor: Theme.of(context).colorScheme.primaryContainer,
            ),
            DecoratedText(
              capitalizeFirstLetter(widget.refund.sourceOfFunds?.name),
              alignment: Alignment.topRight,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              textColor: Theme.of(context).colorScheme.primaryContainer,
            ),
          ],
        ),
      ),
      SizedBox(
        height: 48,
        child: ButtonPrimary(
          text: 'Close',
          onTap: (context) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              SelectProductsPage.route,
              ModalRoute.withName(SelectProductsPage.route),
            );
          },
        ),
      ),
    ],
  );

  Column largeLayout(context) => Column(
    children: <Widget>[
      Expanded(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[Expanded(child: centerSuccess(context))],
              ),
            ),
          ],
        ),
      ),
    ],
  );

  // TODO(lampian): create common widget with checkout complete page centersuccess widget
  Column centerSuccess(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      CircleAvatar(
        backgroundColor: Theme.of(
          context,
        ).extension<AppliedSurface>()?.successSubTitle,
        radius: 62.0, // 138.0
        child: CircleAvatar(
          backgroundColor: Theme.of(
            context,
          ).extension<AppliedTextIcon>()?.positive,
          radius: 48.0, // 136.0
          child: successIndicator(context),
        ),
      ),
      const SizedBox(height: 16.0),
      context.headingXSmall(
        'Refund Successful',
        color: Theme.of(context).extension<AppliedTextIcon>()?.positive,
        isBold: true,
      ),
    ],
  );

  Column successIndicator(context) => const Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Icon(
        Icons.check,
        size: 64.0, // 128.0
        // color: Colors.white, //Theme.of(context).colorScheme.secondary,
      ),
    ],
  );

  Container receiptButtons(BuildContext context) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        if (AppVariables.hasPrinter &&
            (cardPaymentRegistered == CardPaymentRegistered.pos))
          ReceiptButton(
            icon: Icons.print_outlined,
            label: 'Print',
            onPressed: () async {
              // PrintVM printVM =
              //     PrintVM.fromStore(StoreProvider.of<AppState>(context));
              // printVM.setReceipt(
              //   refundTransaction,
              // );
              // printVM.debugPrint(context);
            },
          ),
        ReceiptButton(
          icon: Icons.sms_outlined,
          label: 'SMS',
          onPressed: () {
            // if (AppVariables.store!.state.hasInternet!) {
            //   if (isNotPremium(cleanString('sms_receipt'))) {
            //     showPopupDialog(
            //       defaultPadding: false,
            //       context: context,
            //       content: billingNavigationHelper(isModal: true),
            //     );
            //   } else {
            //     showPopupDialog(
            //       height: 280,
            //       context: context,
            //       content: Container(
            //         margin: EdgeInsets.symmetric(horizontal: 8),
            //         child: CheckoutSMSReceiptPage(
            //           mobileNumber: refundTransaction!.customerMobile,
            //           customerName: refundTransaction!.customerName,
            //           transaction: refundTransaction,
            //         ),
            //       ),
            //     );
            //   }
            // } else {
            //   showMessageDialog(
            //     context,
            //     "Please go online to use this feature",
            //     MdiIcons.wifi,
            //   );
            // }
          },
        ),
        ReceiptButton(
          icon: Icons.email_outlined,
          label: 'Email',
          onPressed: () {
            // if (AppVariables.store!.state.hasInternet!) {
            //   if (isNotPremium(cleanString('email_receipt'))) {
            //     showPopupDialog(
            //       defaultPadding: false,
            //       context: context,
            //       content: billingNavigationHelper(isModal: true),
            //     );
            //   } else
            //     showPopupDialog(
            //       height: 280,
            //       context: context,
            //       content: Container(
            //         margin: EdgeInsets.symmetric(horizontal: 8),
            //         child: CheckoutEmailReceiptPage(
            //           emailAddress: refundTransaction!.customerEmail,
            //           customerName: refundTransaction!.customerName,
            //           transaction: refundTransaction,
            //         ),
            //       ),
            //     );
            // } else
            //   showMessageDialog(
            //     context,
            //     "Please go online to use this feature",
            //     MdiIcons.wifi,
            //   );
          },
        ),
      ],
    ),
  );

  ListTile getTransactionItems(context) {
    return ListTile(
      tileColor: Theme.of(context).colorScheme.background,
      dense: true,
      title: Text(
        widget.refund.description != null &&
                widget.refund.description!.isNotEmpty
            ? '${widget.refund.description}'
            : 'No description',
        style: TextStyle(
          color: Theme.of(context).colorScheme.secondaryContainer,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
      trailing: Text(
        TextFormatter.toStringCurrency(widget.refund.amount, currencyCode: ''),
        style: TextStyle(
          color: Theme.of(context).colorScheme.secondaryContainer,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
    );
  }

  String capitalizeFirstLetter(String? inputString) {
    if (inputString == null || inputString.isEmpty) {
      return inputString ?? ''; // Return unchanged
    }

    return inputString[0].toUpperCase() + inputString.substring(1);
  }
}
