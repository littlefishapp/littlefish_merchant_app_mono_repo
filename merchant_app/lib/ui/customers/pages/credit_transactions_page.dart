// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';
import 'package:littlefish_icons/littlefish_icons.dart';

// Project imports:
import 'package:littlefish_merchant/models/customers/customer.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/business/business_selectors.dart';
import 'package:littlefish_merchant/redux/customer/customer_actions.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/ui/customers/pages/single_credit_transaction_page.dart';
import 'package:littlefish_merchant/ui/customers/viewmodels/customer_view_models.dart';
import 'package:littlefish_merchant/common/presentaion/components/completers.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/pages/popup_forms/customer_credit_amount_popup_form.dart';

import '../../../common/presentaion/components/dialogs/common_dialogs.dart';
import '../../../common/presentaion/components/long_text.dart';
import '../../../common/presentaion/components/app_progress_indicator.dart';

class CreditTransactionsPage extends StatefulWidget {
  static const String route = 'credit/transactions';

  final Customer? customer;
  final CustomersViewModel? vm;
  final bool showAppBar;
  final bool bottonsAsFooter;

  const CreditTransactionsPage({
    Key? key,
    this.customer,
    this.vm,
    this.showAppBar = true,
    this.bottonsAsFooter = false,
  }) : super(key: key);

  @override
  State<CreditTransactionsPage> createState() => _CreditTransactionsPageState();
}

class _CreditTransactionsPageState extends State<CreditTransactionsPage> {
  ScrollController? controller;
  CustomersViewModel? vm;
  Customer? customer;

  @override
  void initState() {
    controller = ScrollController();
    customer = widget.customer;
    vm = widget.vm;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CustomersViewModel>(
      converter: (Store<AppState> store) => CustomersViewModel.fromStore(store),
      builder: (BuildContext ctx, CustomersViewModel vm) {
        return AppSimpleAppScaffold(
          displayAppBar: widget.showAppBar,
          title: "${customer!.firstName}'s Transactions",
          footerActions: widget.bottonsAsFooter == true
              ? [creditButtons(ctx)]
              : null,
          body: vm.isLoading!
              ? const AppProgressIndicator()
              : ListView(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    if (widget.bottonsAsFooter == false) sliverBalance(context),
                    // creditButtons(context),
                    Column(
                      children:
                          customer?.customerLedgerEntries
                              ?.map(
                                (e) =>
                                    creditTransactionListTile(e, context, ctx),
                              )
                              .toList() ??
                          [const Center(child: Text('No Transactions'))],
                    ),
                  ],
                ),
        );
      },
    );
  }

  ListTile creditTransactionListTile(
    CustomerLedgerEntry item,
    context,
    BuildContext ctx,
  ) {
    return ListTile(
      tileColor: Theme.of(context).colorScheme.background,
      dense: false,
      // isThreeLine: true,
      onTap: () {
        showPopupDialog(
          context: context,
          content: SingleCreditTransactionPage(
            item: item,
            customer: customer,
            vm: vm,
          ),
        );
      },
      trailing: LongText(
        TextFormatter.toStringCurrency(
          item.amount,
          displayCurrency: false,
          currencyCode: '',
        ),
        fontSize: 16,
        fontWeight: FontWeight.bold,
        textColor: item.isCancelled
            ? Colors.orange
            : item.isDebit
            ? Theme.of(context).colorScheme.secondary
            : Theme.of(context).colorScheme.primary,
      ),
      leading: Container(
        width: MediaQuery.of(context).size.width * 0.15,
        height: (MediaQuery.of(context).size.width * 0.15) * 0.65,
        decoration: BoxDecoration(
          color: item.isCancelled
              ? Colors.orange
              : item.isDebit
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              !item.isDebit ? 'Db' : 'Cr',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            TextFormatter.toShortDate(
              dateTime: item.dateAdded,
              format: 'dd MMMM HH:mm',
            ),
            style: const TextStyle(
              fontSize: 14,
              // fontWeight: FontWeight.bold,
            ),
          ),
          // LongText(
          //   item.addedBy,
          //   fontWeight: FontWeight.bold,
          // ),
          Visibility(
            visible: (item.isCancelled) == true,
            child: const LongText(
              'cancelled',
              fontSize: 10,
              textColor: Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Material creditBalance(BuildContext context) => Material(
    child: Container(
      width: MediaQuery.of(context).size.width - 8,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Credit Balance:', style: TextStyle(fontSize: 16)),
          Text(
            TextFormatter.toStringCurrency(
              ((widget.customer!.creditBalance ?? 0).abs()),
              currencyCode: '',
            ),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    ),
  );

  Material sliverBalance(BuildContext context) => Material(
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(children: [creditBalance(context), creditButtons(context)]),
    ),
  );

  Material creditButtons(BuildContext context) => Material(
    color: widget.bottonsAsFooter ? Colors.white : null,
    child: ButtonBar(
      buttonHeight: 36,
      buttonMinWidth: (MediaQuery.of(context).size.width / 2) - 20,
      alignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
          onPressed:
              (storeCreditSettings(vm!.store!.state)?.creditLimit ?? 0) ==
                  (customer!.creditBalance?.roundToDouble() ?? 0)
              ? null
              : () async {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => CustomerCreditAmountPopupForm(
                        shouldPop: false,
                        creditBalance: customer!.creditBalance ?? 0.00,
                        initialValue: 0.0,
                        title: 'Credit Amount',
                        hintText: 'Enter amount here',
                        onSubmit: (context, value) async {
                          var currentCredit = double.parse(
                            (customer?.creditBalance ?? 0).toStringAsFixed(2),
                          );

                          var credIncrease = value + (currentCredit * (-1));
                          var credLimit =
                              storeCreditSettings(
                                vm!.store!.state,
                              )?.creditLimit ??
                              0;

                          if (credIncrease > credLimit) {
                            // Navigator.of(context).pop();
                            await showMessageDialog(
                              context,
                              'Customer credit cannot exceed credit limit',
                              LittleFishIcons.info,
                            );
                          } else {
                            vm!.store!.dispatch(
                              giveCustomerStoreCreditAmount(
                                item: customer,
                                value: value,
                                completer: actionCompleter(context, () {
                                  Navigator.of(context).pop();
                                  showMessageDialog(
                                    context,
                                    'Success',
                                    LittleFishIcons.info,
                                  );
                                }),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  );
                },
          // TODO(lampian): fix color
          // color: Theme.of(context).colorScheme.secondary,
          child: const Text(
            'Give',
            style: TextStyle(
              // fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          onPressed: (customer!.creditBalance?.roundToDouble() ?? 0) == 0
              ? null
              : () async {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => CustomerCreditAmountPopupForm(
                        shouldPop: false,
                        creditBalance: customer!.creditBalance ?? 0.00,
                        initialValue: 0.0,
                        title: 'Pay Amount',
                        hintText: 'Enter amount here',
                        onSubmit: (context, value) async {
                          var currentCredit = double.parse(
                            (customer?.creditBalance ?? 0).toStringAsFixed(2),
                          );
                          if (value + currentCredit > 0) {
                            // Navigator.of(context).pop();
                            await showMessageDialog(
                              context,
                              'Customer cannot have a positive credit balance \n Please input the exact amount instead ',
                              LittleFishIcons.info,
                            );
                          } else {
                            vm!.store!.dispatch(
                              payCustomerStoreCreditAmount(
                                item: customer,
                                value: value,
                                completer: actionCompleter(context, () {
                                  Navigator.of(context).pop();
                                  showMessageDialog(
                                    context,
                                    'Success',
                                    LittleFishIcons.info,
                                  );
                                }),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  );
                },
          // TODO(lampian): fix color
          // color: Theme.of(context).colorScheme.primary,
          child: const Text(
            'Pay',
            style: TextStyle(
              color: Colors.white,
              // fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ],
    ),
  );
}
