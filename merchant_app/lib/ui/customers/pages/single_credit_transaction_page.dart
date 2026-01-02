// Flutter imports:
// remove ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/services/modal_service.dart';
import 'package:littlefish_merchant/injector.dart';

// Package imports:
import 'package:quiver/strings.dart';

// Project imports:
import 'package:littlefish_merchant/models/customers/customer.dart';
import 'package:littlefish_merchant/redux/checkout/checkout_actions.dart';
import 'package:littlefish_merchant/redux/customer/customer_actions.dart';
import 'package:littlefish_merchant/services/checkout_service.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/ui/customers/viewmodels/customer_view_models.dart';
import 'package:littlefish_merchant/common/presentaion/components/completers.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/common/presentaion/components/decorated_text.dart';
import 'package:littlefish_icons/littlefish_icons.dart';

class SingleCreditTransactionPage extends StatefulWidget {
  final bool isEmbedded;
  final CustomerLedgerEntry item;
  final Customer? customer;
  final CustomersViewModel? vm;

  const SingleCreditTransactionPage({
    Key? key,
    this.isEmbedded = true,
    required this.item,
    required this.vm,
    required this.customer,
  }) : super(key: key);

  @override
  State<SingleCreditTransactionPage> createState() =>
      _SingleCreditTransactionPageState();
}

class _SingleCreditTransactionPageState
    extends State<SingleCreditTransactionPage> {
  CustomerLedgerEntry? item;
  CustomersViewModel? vm;
  Customer? customer;

  @override
  void initState() {
    item = widget.item;
    vm = widget.vm;
    customer = widget.customer;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppSimpleAppScaffold(
      title: item!.entryType?.toLowerCase() == 'debit'
          ? 'Debit Entry'
          : 'Credit Entry',
      isEmbedded: widget.isEmbedded,
      footerActions: [creditButtons(context)],
      body: SafeArea(
        child: ListView(
          children: [
            itemTile(context, 'Username:', customer!.displayName),
            const CommonDivider(),
            itemTile(
              context,
              'Date Added:',
              TextFormatter.toShortDate(
                dateTime: item!.dateAdded,
                format: 'dd MMMM HH:mm',
              ),
            ),
            const CommonDivider(),
            itemTile(context, 'Captured By:', item!.addedBy),
            const CommonDivider(),
            transactionAmout(context),
          ],
        ),
      ),
    );
  }

  ListTile itemTile(context, String title, String? trailing) => ListTile(
    tileColor: Theme.of(context).colorScheme.background,
    dense: true,
    title: DecoratedText(
      title,
      fontSize: null,
      textColor: Theme.of(context).colorScheme.secondary,
    ),
    trailing: Text(
      trailing ?? '',
      style: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        // fontWeight: FontWeight.bold,
      ),
    ),
  );

  ButtonBar creditButtons(BuildContext ctx) => ButtonBar(
    buttonHeight: 40,
    buttonMinWidth: (MediaQuery.of(context).size.width / 1.1),
    alignment: MainAxisAlignment.center,
    children: [
      ElevatedButton(
        // TODO(lampian): fix color
        //color: Theme.of(context).colorScheme.secondary,
        onPressed: item!.status?.toLowerCase() == 'cancelled'
            ? null
            : () async {
                final ModalService modalService = getIt<ModalService>();

                if (item!.isCancelled == true) {
                  showPopupDialog(
                    context: context,
                    content: const Text(
                      'Transaction has already been cancelled',
                    ),
                  );
                } else {
                  var res = await modalService.showActionModal(
                    context: context,
                    title: 'Cancel Transaction',
                    description:
                        'Are you sure you want to cancel this transaction?',
                  );

                  if (res == true) {
                    if (isNotBlank(item!.transactionId)) {
                      // vm.isLoading = true;

                      var sale = await CheckoutService.fromStore(
                        vm!.store!,
                      ).getTransactionById(item!.transactionId);

                      vm!.store!.dispatch(
                        cancelSale(
                          context,
                          sale,
                          completer: actionCompleter(ctx, () async {
                            Navigator.of(context).pop();
                            await showMessageDialog(
                              context,
                              'Success',
                              LittleFishIcons.info,
                            );

                            if (mounted) setState(() {});
                          }),
                        ),
                      );
                    } else {
                      vm!.store!.dispatch(
                        cancelPayCustomerStoreCreditAmount(
                          entry: item,
                          item: customer,
                          completer: actionCompleter(ctx, () async {
                            await showMessageDialog(
                              context,
                              'Success',
                              LittleFishIcons.info,
                            );

                            if (mounted) setState(() {});
                          }),
                        ),
                      );
                    }
                  }
                }
              },
        // TODO(lampian): fix color
        //color: Theme.of(context).colorScheme.secondary,
        child: const Text(
          'Cancel ',
          style: TextStyle(
            color: Colors.white,
            // fontWeight: FontWeight.bold,
            // fontSize: 14,
          ),
        ),
      ),
    ],
  );

  Material transactionAmout(BuildContext context) => Material(
    child: Container(
      width: MediaQuery.of(context).size.width - 8,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Amount', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 4),
          Text(
            TextFormatter.toStringCurrency(
              ((item!.amount ?? 0).abs()),
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
}
