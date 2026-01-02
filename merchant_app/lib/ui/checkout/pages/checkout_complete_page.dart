import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/customer_select_item.dart';
import 'package:littlefish_merchant/common/presentaion/components/list_leading_tile.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_cart_item.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/ui/checkout/sell_page.dart';
import 'package:quiver/strings.dart';
import 'package:intl/intl.dart' as intl;
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_transaction.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/checkout/checkout_actions.dart';
import 'package:littlefish_merchant/ui/home/home_page.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/ui/checkout/viewmodels/print_vm.dart';
import 'package:littlefish_merchant/ui/checkout/widgets/checkout_receipt.dart';
import 'package:littlefish_merchant/tools/billing/billing_helpers.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/ui/checkout/pages/checkout_email_receipt_page.dart';
import 'package:littlefish_merchant/ui/checkout/pages/checkout_sms_receipt_page.dart';
import 'package:littlefish_merchant/models/customers/customer.dart';

import '../../../app/app.dart';
import '../../../common/presentaion/components/cards/card_square_flat.dart';
import '../../../common/presentaion/pages/scaffolds/app_scaffold.dart';
import '../../../features/pos/presentation/pages/pos_print_page.dart';
import '../../../features/sell/presentation/components/transaction_receipt_buttons.dart';
import '../../../features/sell/presentation/components/transaction_summary_row.dart';
import '../../../injector.dart';

class CheckoutCompletePage extends StatefulWidget {
  static const String route = 'checkout/complete';

  final bool isEmbedded;

  final bool isWithdrawal;

  final bool isReprint;

  final PrintVM? printVM;

  final Function(String)? onEvent;

  final CheckoutTransaction? item;

  // receive customer in constructor when using large displays
  final Customer? customer;

  const CheckoutCompletePage({
    Key? key,
    this.item,
    this.isEmbedded = false,
    this.onEvent,
    this.printVM,
    this.isReprint = false,
    this.customer,
    this.isWithdrawal = false,
  }) : super(key: key);

  @override
  State<CheckoutCompletePage> createState() => _CheckoutCompletePageState();
}

class _CheckoutCompletePageState extends State<CheckoutCompletePage> {
  CheckoutTransaction? transactionFromModalRouteArguments;

  Customer? customerFromModalRouteArguments;

  bool? isWithdrawal;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    transactionFromModalRouteArguments =
        arguments?['transaction'] as CheckoutTransaction?;

    customerFromModalRouteArguments = arguments?['customer'] as Customer?;

    isWithdrawal = arguments?['isWithdrawal'] as bool? ?? false;

    return StoreConnector<AppState, ReceiptViewModel>(
      converter: (Store<AppState> store) => ReceiptViewModel.fromStore(
        store,
        widget.item ?? transactionFromModalRouteArguments,
      ),
      builder: (BuildContext context, ReceiptViewModel vm) =>
          appScaffold(context, vm),
    );
  }

  AppScaffold appScaffold(BuildContext context, ReceiptViewModel vm) {
    return AppScaffold(
      backgroundColor: Colors.white.withOpacity(0.99),
      displayAppBar: false,
      body: SafeArea(child: mobileLayout(context, vm)),
      title: 'Transaction result',
      persistentFooterButtons: [
        Column(children: [totalSummary(context, vm), closeButton(context, vm)]),
      ],
    );
  }

  Widget mobileLayout(BuildContext context, ReceiptViewModel vm) {
    final thisCustomer = widget.customer != null
        ? widget.customer!
        : customerFromModalRouteArguments;
    final hasCustomer = thisCustomer != null;
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
                  child: receiptSection(context, vm),
                ),
                const SizedBox(height: 8),
                if (hasCustomer)
                  CardSquareFlat(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: customerSection(context, thisCustomer),
                  ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget receiptSection(BuildContext context, ReceiptViewModel vm) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: context.paragraphLarge(
            'Send Receipt',
            alignLeft: true,
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
              _printFunction(vm);
            },
            onSmsTap: () {
              _smsFunction(vm);
            },
            onEmailTap: () {
              _emailFunction(vm);
            },
          ),
        ),
      ],
    );
  }

  // Receipt buttons functionality
  _printFunction(ReceiptViewModel vm) async {
    if (cardPaymentRegistered == CardPaymentRegistered.pos) {
      if (vm.transaction != null && vm.transaction?.transactionNumber == null) {
        vm.transaction?.transactionNumber = vm.lastTransactionNumber;
      }
      await showPopupDialog(
        context: context,
        content: PosPrintPage(
          vm.transaction,
          null,
          isRefund: false,
          parentContext: context,
        ),
      );
    } else {
      PrintVM printVM = PrintVM.fromStore(StoreProvider.of<AppState>(context));
      printVM.setReceipt(widget.item ?? transactionFromModalRouteArguments);
      printVM.debugPrint(context);
    }
  }

  _smsFunction(ReceiptViewModel vm) {
    if (vm.store!.state.hasInternet!) {
      if (isNotPremium(cleanString('sms_receipt'))) {
        showPopupDialog(
          defaultPadding: false,
          context: context,
          content: billingNavigationHelper(isModal: true),
        );
      } else {
        showPopupDialog(
          height: 280,
          context: context,
          content: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: CheckoutSMSReceiptPage(
              mobileNumber: vm.transaction!.customerMobile,
              customerName: vm.transaction!.customerName,
              transaction: vm.transaction,
            ),
          ),
        );
      }
    } else {
      showMessageDialog(
        context,
        'Please go online to use this feature',
        MdiIcons.wifi,
      );
    }
  }

  _emailFunction(ReceiptViewModel vm) {
    if (vm.store!.state.hasInternet!) {
      if (isNotPremium(cleanString('email_receipt'))) {
        showPopupDialog(
          defaultPadding: false,
          context: context,
          content: billingNavigationHelper(isModal: true),
        );
      } else {
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
      }
    } else {
      showMessageDialog(
        context,
        'Please go online to use this feature',
        MdiIcons.wifi,
      );
    }
  }

  Widget customerSection(BuildContext context, Customer customer) {
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
          child: context.labelXSmall('Customer who made the purchase'),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: CustomerSelectItem(
            item: customer,
            id: customer.id ?? '',
            title: customer.displayName ?? '',
            subtitle:
                'Last visit: '
                '${TextFormatter.toShortDate(dateTime: customer.lastPurchaseDate ?? DateTime.now())}',
            showTrailingIcon: false,
            onTap: () {},
          ),
        ),
      ],
    );
  }

  Widget totalSummary(BuildContext context, ReceiptViewModel vm) => Column(
    children: [
      if ((transactionFromModalRouteArguments?.items! ?? []).isNotEmpty) ...[
        CardSquareFlat(
          margin: EdgeInsets.zero,
          child: Material(
            color: Theme.of(context).colorScheme.background,
            borderRadius: BorderRadius.circular(AppVariables.appDefaultRadius),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
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
      ],
      const SizedBox(height: 8),
      Visibility(
        visible: shouldShowSubtotal(vm),
        child: TransactionSummaryRow(
          title:
              'Sub-Total${AppVariables.store!.state.appSettingsState.salesTax?.enabled ?? false ? ' (incl tax)' : ''}',
          amount: vm.transaction!.totalValue!,
        ),
      ),
      Visibility(
        visible: isNotZeroOrNull(vm.transaction!.withdrawalAmount),
        child: TransactionSummaryRow(
          title: 'Cash Withdrawal',
          amount: vm.transaction!.withdrawalAmount ?? 0,
        ),
      ),
      Visibility(
        visible: isDiscountApplied(vm),
        child: TransactionSummaryRow(
          title: 'Discount',
          amount: vm.transaction!.totalDiscount ?? 0,
          amountPrefix: '-',
        ),
      ),
      Visibility(
        visible: isNotZeroOrNull(vm.transaction!.cashbackAmount),
        child: TransactionSummaryRow(
          title: 'Cashback',
          amount: vm.transaction!.cashbackAmount ?? 0,
        ),
      ),
      Visibility(
        visible: isNotZeroOrNull(vm.transaction!.tipAmount),
        child: TransactionSummaryRow(
          title: 'Tip',
          amount: vm.transaction!.tipAmount ?? 0,
        ),
      ),
      TransactionSummaryRow(
        title: 'Total Tax',
        amount: vm.transaction!.totalTax ?? 0,
      ),
      TransactionSummaryRow(
        title:
            'Total Bill${AppVariables.store!.state.appSettingsState.salesTax?.enabled ?? false ? ' (incl tax)' : ''}',
        amount: vm.transaction!.checkoutTotal,
      ),
      Visibility(
        visible: vm.transaction!.paymentType?.name!.toLowerCase() == 'cash',
        child: TransactionSummaryRow(
          title: 'Amount Tendered',
          amount: vm.transaction!.amountTendered ?? 0,
        ),
      ),
      Visibility(
        visible: vm.transaction!.paymentType?.name!.toLowerCase() == 'cash',
        child: TransactionSummaryRow(
          title: 'Amount Change',
          amount: vm.transaction!.amountChange ?? 0,
        ),
      ),
      const SizedBox(height: 8),
    ],
  );

  Widget closeButton(BuildContext context, ReceiptViewModel vm) {
    return ButtonPrimary(
      text: 'Done',
      upperCase: false,
      onTap: (context) async {
        Store<AppState> store = StoreProvider.of(context);

        store.dispatch(CheckoutClearAction(null));
        store.dispatch(CheckoutSetLoadingAction(false));

        if (context.mounted) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            SellPage.route,
            ModalRoute.withName(HomePage.route),
          );
        }
      },
    );
  }

  bool shouldShowSubtotal(ReceiptViewModel vm) {
    if (isDiscountApplied(vm)) return true;
    if (isNotZeroOrNull(vm.transaction?.withdrawalAmount)) return true;
    if (isNotZeroOrNull(vm.transaction?.cashbackAmount)) return true;
    if (isNotZeroOrNull(vm.transaction?.tipAmount)) return true;

    return false;
  }

  bool isDiscountApplied(ReceiptViewModel vm) {
    return isNotZeroOrNull(vm.transaction!.totalDiscount);
  }

  EdgeInsetsGeometry getTotalAmountPadding(ReceiptViewModel vm) {
    bool isCashPayment =
        vm.transaction!.paymentType!.name!.toLowerCase() == 'cash';

    if (isDiscountApplied(vm) == false) {
      return EdgeInsets.only(bottom: isCashPayment ? 4 : 0);
    }

    return EdgeInsets.only(bottom: isCashPayment ? 4 : 8, top: 4);
  }

  Column centerSuccess(BuildContext context) {
    final innerCircleColour = Theme.of(
      context,
    ).extension<AppliedTextIcon>()?.positive;
    final outerCircleColour = Theme.of(
      context,
    ).extension<AppliedSurface>()?.successSubTitle.withAlpha(0x70);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        CircleAvatar(
          backgroundColor: outerCircleColour,
          radius: 62.0,
          child: CircleAvatar(
            backgroundColor: innerCircleColour,
            radius: 48.0,
            child: successIndicator(context),
          ),
        ),
        const SizedBox(height: 16.0),
        context.headingXSmall(
          widget.isWithdrawal || isWithdrawal!
              ? 'Cash Withdrawal Successful'
              : 'Sale Successful',
          color: Theme.of(context).extension<AppliedTextIcon>()?.positive,
          isBold: true,
        ),
      ],
    );
  }

  Column successIndicator(context) => const Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[Icon(Icons.check, size: 64.0)],
  );

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
    CheckoutTransaction? transaction = widget.item;
    List<CheckoutCartItem>? allCartItems =
        transaction?.items ?? transactionFromModalRouteArguments?.items;

    if (allCartItems == null || allCartItems.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: context.labelSmall(
            'There are no items.',
            alignLeft: true,
            isBold: true,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        CheckoutCartItem cartItem = allCartItems[index];
        StockProduct? product = AppVariables.store?.state.productState
            .getProductById(cartItem.productId);
        return ListTile(
          tileColor: Theme.of(context).colorScheme.background,
          key: Key(cartItem.id ?? ''),
          leading: isNotBlank(product?.imageUri)
              ? ListLeadingImageTile(
                  width: AppVariables.appDefaultlistItemSize,
                  height: AppVariables.appDefaultlistItemSize,
                  url: product?.imageUri,
                )
              : _buildPlaceholderImage(
                  context,
                  product?.name ?? cartItem.description,
                ),
          title: context.labelSmall(
            '${cartItem.description}',
            alignLeft: true,
            isBold: true,
          ),
          subtitle: context.labelXSmall(
            cartItem.quantity == 1
                ? '${cartItem.quantity.round().toString()} item'
                : '${cartItem.quantity.round().toString()} items',
            alignLeft: true,
            isBold: false,
          ),
          trailing: context.labelSmall(
            intl.NumberFormat.currency(
              locale: 'en_ZA',
              symbol: 'R',
              decimalDigits: 2,
            ).format((cartItem.itemValue ?? 0) * (cartItem.quantity)),
            alignLeft: true,
            isBold: false,
          ),
        );
      },
      itemCount: allCartItems.length,
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
