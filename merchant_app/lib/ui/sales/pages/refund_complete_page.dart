import 'dart:io';

import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:littlefish_merchant/common/presentaion/components/cards/card_square_flat.dart';
import 'package:littlefish_merchant/environment/environment_config.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_refund_item.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_transaction.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:littlefish_merchant/ui/checkout/sell_page.dart';
import 'package:littlefish_merchant/ui/sales/pages/refund_email_receipt_page.dart';
import 'package:littlefish_merchant/ui/sales/pages/refund_sms_receipt_page.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/models/customers/customer.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:quiver/strings.dart';
import '../../../app/theme/applied_system/applied_surface.dart';
import '../../../app/theme/applied_system/applied_text_icon.dart';
import '../../../common/presentaion/components/customer_select_item.dart';
import '../../../common/presentaion/pages/scaffolds/app_scaffold.dart';
import '../../../features/pos/presentation/pages/pos_print_page.dart';
import '../../../features/sell/presentation/components/transaction_receipt_buttons.dart';
import '../../../injector.dart';
import '../../../models/sales/checkout/checkout_refund.dart';
import '../sales_page.dart';

class RefundCompletePage extends StatefulWidget {
  static const String route = 'refund/complete';
  final Refund? item;
  final Customer? customer;

  const RefundCompletePage({Key? key, this.item, this.customer})
    : super(key: key);

  @override
  RefundCompletePageState createState() => RefundCompletePageState();
}

class RefundCompletePageState extends State<RefundCompletePage> {
  Refund? refundTransaction;
  CheckoutTransaction? checkoutTransaction;
  Customer? refundCustomer;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    refundTransaction ??= widget.item ?? arguments?['refund'] as Refund?;
    refundCustomer ??= widget.customer ?? arguments?['customer'] as Customer?;

    return AppScaffold(
      displayAppBar: false,
      body: SafeArea(child: mobileLayout(context)),
      title: '',
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: totalAndCloseButton(context),
        ),
      ],
    );
  }

  Widget mobileLayout(BuildContext context) {
    final hasCustomer = refundCustomer != null;
    return Flex(
      direction: Axis.vertical,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                CardSquareFlat(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: centerSuccess(context),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                CardSquareFlat(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: receiptSection(context),
                ),
                const SizedBox(height: 8),

                if (hasCustomer)
                  CardSquareFlat(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: customerSections(context, refundCustomer!),
                  ),
                //itemsSection(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // TODO(lampian): create common widget with checkout complete page centersuccess widget
  Column centerSuccess(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      CircleAvatar(
        backgroundColor: Theme.of(
          context,
        ).extension<AppliedSurface>()?.successSubTitle,
        radius: 62.0,
        child: CircleAvatar(
          backgroundColor: Theme.of(
            context,
          ).extension<AppliedTextIcon>()?.positive,
          radius: 48.0,
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
    children: <Widget>[Icon(Icons.check, size: 64.0)],
  );

  Widget receiptSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          alignment: Alignment.centerLeft,
          child: context.paragraphLarge(
            'Send Refund Receipt',
            color: Theme.of(context).extension<AppliedTextIcon>()?.emphasized,
            isBold: true,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2),
          child: context.labelXSmall('Tap any option below to send receipt'),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: TransactionReceiptButtons(
            showPrintButton:
                AppVariables.hasPrinter &&
                cardPaymentRegistered == CardPaymentRegistered.pos,
            onPrintTap: () async {
              _printFunction();
            },
            onSmsTap: () {
              _smsFunction();
            },
            onEmailTap: () {
              _emailFunction();
            },
          ),
        ),
      ],
    );
  }

  // Receipt buttons functionality
  _printFunction() async {
    showPopupDialog(
      context: context,
      content: PosPrintPage(
        checkoutTransaction,
        _checkIfIsQuickRefund(refundTransaction),
        parentContext: context,
        isRefund: true,
      ),
    ).then((result) {});
    // TODO(tshief): Attempted to fix Quick Refund printing, but according to simplyblu-main branch quick_refund_complete+page.dart, printing has never worked as is currently commented out there aswell
    //   var trx = tryGetTransactionFromState(
    //       widget.item?.checkoutTransactionId ??
    //           refundTransaction?.checkoutTransactionId);
    //
    //   if (cardPaymentRegistered == CardPaymentRegistered.broadPos ||
    //       cardPaymentRegistered == CardPaymentRegistered.myPinPad) {
    //     showPopupDialog(
    //       context: context,
    //       content: PosPrintPage(
    //         trx,
    //         parentContext: context,
    //       ),
    //     ).then((result) {});
    //   } else {
    //     PrintVM printVM =
    //     PrintVM.fromStore(StoreProvider.of<AppState>(context));
    //     printVM.setReceipt(
    //       trx,
    //     );
    //     printVM.setReceipt(trx);
    //     printVM.debugPrint(context);
    //   }
  }

  _smsFunction() {
    if (AppVariables.store!.state.hasInternet!) {
      showPopupDialog(
        height: 280,
        context: context,
        content: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: RefundSMSReceiptPage(
            mobileNumber: refundTransaction!.customerMobile,
            customerName: refundCustomer != null
                ? '${refundCustomer!.firstName} ${refundCustomer!.lastName}'
                : '',
            refund: refundTransaction,
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
  }

  _emailFunction() {
    if (AppVariables.store!.state.hasInternet!) {
      showPopupDialog(
        height: 280,
        context: context,
        content: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: RefundEmailReceiptPage(
            emailAddress: refundTransaction!.customerEmail,
            customerName: refundCustomer != null
                ? '${refundCustomer!.firstName} ${refundCustomer!.lastName}'
                : '',
            refund: refundTransaction,
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
  }

  Widget customerSections(BuildContext context, Customer customer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
          child: context.paragraphLarge(
            'Customer',
            color: Theme.of(context).extension<AppliedTextIcon>()?.emphasized,
            isBold: true,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2),
          child: context.labelXSmall('Customer who was refunded'),
        ),
        CustomerSelectItem(
          item: customer,
          id: customer.id ?? '',
          showCancel: true,
          showTrailingIcon: false,
          title: customer.displayName ?? '',
          subtitle:
              'Last Visit: ${TextFormatter.toShortDate(dateTime: customer.lastPurchaseDate ?? DateTime.now(), format: AppVariables.appDateFormat)}',
          onTap: () {},
        ),
      ],
    );
  }

  quickRefundDescriptionTile() {
    if (refundTransaction == null) return const SizedBox.shrink();
    String refundDescription = getQuickRefundDescription(refundTransaction!);
    return ListTile(
      tileColor: Theme.of(context).colorScheme.background,
      leading: _buildPlaceholderImage(context, refundDescription),
      title: context.labelSmall(
        refundDescription.toUpperCase(),
        alignLeft: true,
      ),
      trailing: context.labelSmall(
        TextFormatter.toStringCurrency(
          refundTransaction?.totalRefund ?? 0,
          currencyCode: '',
        ),
        color: Theme.of(context).extension<AppliedTextIcon>()?.secondary,
        isBold: true,
      ),
    );
  }

  String getQuickRefundDescription(Refund refund) {
    if (isNotBlank(refund.description)) return refund.description!;
    if (isNotBlank(refund.displayName)) return refund.displayName!;
    return 'Quick Refund';
  }

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

  Widget totalAndCloseButton(BuildContext context) => Column(
    children: [
      // if (refundTransaction!.items!.isNotEmpty) ...[
      CardSquareFlat(
        margin: EdgeInsets.zero,
        child: Material(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(AppVariables.appDefaultRadius),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 0,
              vertical: 0,
            ),
            tileColor: Theme.of(context).colorScheme.background,
            onTap: () {
              showTransactionItemsModal(context);
            },
            title: context.labelSmall(
              'View Cart',
              alignLeft: true,
              isBold: true,
            ),
            trailing: Icon(
              Platform.isIOS
                  ? Icons.arrow_forward_ios_outlined
                  : Icons.arrow_forward,
            ),
          ),
        ),
      ),

      // ],
      Container(
        padding: EdgeInsets.only(
          bottom: refundTransaction!.paymentType!.name!.toLowerCase() == 'cash'
              ? 8
              : 16,
          top: 8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            context.labelXSmall(
              'Total Refunded',
              color: Theme.of(context).extension<AppliedTextIcon>()?.secondary,
              isBold: false,
            ),
            context.labelXSmall(
              TextFormatter.toStringCurrency(
                refundTransaction!.totalRefund,
                currencyCode: '',
              ),
              color: Theme.of(context).extension<AppliedTextIcon>()?.secondary,
              isBold: false,
            ),
          ],
        ),
      ),

      Container(
        padding: const EdgeInsets.only(bottom: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            context.labelXSmall(
              'Refunded Using',
              color: Theme.of(context).extension<AppliedTextIcon>()?.secondary,
            ),
            context.labelXSmall(
              refundTransaction!.paymentType!.name!,
              color: Theme.of(context).extension<AppliedTextIcon>()?.secondary,
            ),
          ],
        ),
      ),
      ButtonPrimary(
        text: 'Done',
        onTap: (context) {
          String pageRoute;
          if (refundTransaction?.isQuickRefund == true) {
            pageRoute = SellPage.route;
          } else {
            pageRoute = SalesPage.route;
            Navigator.of(context).pushNamedAndRemoveUntil(
              pageRoute,
              ModalRoute.withName(pageRoute),
            );
          }
        },
      ),
    ],
  );

  CheckoutTransaction? tryGetTransactionFromState(String? transactionId) {
    return AppVariables.store!.state.salesState.agglomerationTransactions
        .firstWhereOrNull((trx) => trx.id == transactionId);
  }

  Refund? _checkIfIsQuickRefund(Refund? refund) {
    if (refund == null) {
      return null;
    }
    if (!refund.isQuickRefund) {
      if (refund.transactionNumber == null) {
        var currentTransactionId = AppVariables
            .store
            ?.state
            .salesState
            .currentRefund
            ?.transactionNumber;
        refund.transactionNumber = currentTransactionId;
      }

      return refund;
    }
    if (refund.transactionNumber == null) {
      var currentTransactionId =
          AppVariables.store?.state.checkoutState.lastTransactionNumber;
      refund.transactionNumber = currentTransactionId;
    }
    refund.items = [];
    refund.items?.add(
      RefundItem(
        checkoutCartItemId: '',
        displayName: refund.description,
        quantity: 1,
        itemValue: refund.totalRefund,
      ),
    );
    return refund;
  }

  void showTransactionItemsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SafeArea(
              top: false,
              bottom: true,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(25.0),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: 12,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).extension<AppliedTextIcon>()?.emphasized,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 10),
                    context.labelLarge(
                      'Cart Items',
                      alignLeft: true,
                      isBold: false,
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height:
                          MediaQuery.of(context).size.height *
                          0.5, // Limits modal height
                      child: _getTransactionItems(context),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _getTransactionItems(BuildContext context) {
    if (refundTransaction?.isQuickRefund == true) {
      return quickRefundDescriptionTile();
    }

    if (isNullOrEmpty(refundTransaction?.items)) {
      return Center(
        child: context.paragraphMedium(
          'There are no items.',
          color: Theme.of(context).extension<AppliedTextIcon>()?.secondary,
          isBold: true,
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        RefundItem? transaction;
        transaction = refundTransaction!.items![index];
        return ListTile(
          tileColor: Theme.of(context).colorScheme.background,
          key: Key(transaction.checkoutCartItemId),
          leading: _buildPlaceholderImage(context, transaction.displayName),
          title: context.labelSmall(
            '${transaction.displayName}',
            alignLeft: true,
            isBold: false,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: context.labelXSmall(
            transaction.quantity?.round().toInt() == 1
                ? '${transaction.quantity?.round().toInt()} item'
                : '${transaction.quantity.toString()} items',
            alignLeft: true,
            isBold: false,
          ),
          trailing: context.labelSmall(
            TextFormatter.toStringCurrency(transaction.itemValue ?? 0),
            alignLeft: true,
            isBold: true,
          ),
        );
      },
      itemCount: refundTransaction!.items?.length ?? 0,
    );
  }

  Widget _buildPlaceholderImage(BuildContext context, String? name) {
    return Container(
      width: AppVariables.appDefaultlistItemSize,
      height: AppVariables.appDefaultlistItemSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).extension<AppliedSurface>()?.brandSubTitle,
        border: Border.all(color: Colors.transparent, width: 1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: context.labelMedium(
        name?.substring(0, 2).toUpperCase() ?? '',
        isBold: true,
      ),
    );
  }
}
