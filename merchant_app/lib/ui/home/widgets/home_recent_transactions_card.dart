import 'package:flutter/material.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_transaction.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/ui/sales/pages/transaction_page.dart';
import 'package:littlefish_merchant/common/presentaion/components/long_text.dart';
import 'package:littlefish_merchant/common/presentaion/components/list_leading_tile.dart';

import '../../../common/presentaion/components/cards/card_neutral.dart';

class HomeRecentTransactionsCard extends StatelessWidget {
  final List<CheckoutTransaction> recentTransactions;

  const HomeRecentTransactionsCard({Key? key, required this.recentTransactions})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return item(context);
  }

  item(context) {
    return CardNeutral(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        height: 284,
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Recent Orders'.toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      LongText(
                        TextFormatter.toShortDate(
                          dateTime: DateTime.now().toUtc(),
                          format: 'MMMM yyyy',
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(
                      Icons.shopping_cart,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              // height: 204,
              child: recentTransactions.isEmpty
                  ? const Center(child: Text('No Recent Sales'))
                  : ListView(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      children: recentTransactions
                          .map(
                            (item) => ListTile(
                              tileColor: Theme.of(
                                context,
                              ).colorScheme.background,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 0,
                              ),
                              visualDensity: const VisualDensity(
                                horizontal: 0,
                                vertical: -2,
                              ),
                              dense: true,
                              onTap: () {
                                showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (cx) =>
                                      TransactionPage(transaction: item),
                                );
                              },
                              leading: const ListLeadingIconTile(
                                icon: Icons.payment,
                              ),
                              title: LongText(
                                TextFormatter.toStringCurrency(
                                  (item.totalValue ?? 0) -
                                      (item.totalDiscount ?? 0),
                                  currencyCode: '',
                                ),
                                fontSize: null,
                                fontWeight: FontWeight.bold,
                                textColor: Colors.grey.shade700,
                              ),
                              subtitle: LongText(
                                "${item.totalQty} ${item.totalQty == 1 ? "item" : "items"}",
                              ),
                              trailing: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  LongText(
                                    TextFormatter.toShortDate(
                                      dateTime: item.dateCreated,
                                      format: 'd MMM HH:mm',
                                    ),
                                    fontWeight: FontWeight.bold,
                                  ),
                                  Visibility(
                                    visible:
                                        (item.pendingSync ?? false) == false &&
                                        item.isCancelled == false,
                                    child: LongText(
                                      '#${(item.transactionNumber ?? 0).floor()}',
                                    ),
                                  ),
                                  Visibility(
                                    visible:
                                        (item.pendingSync ?? false) == true,
                                    child: const LongText(
                                      'pending',
                                      fontSize: 10,
                                      textColor: Colors.purple,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Visibility(
                                    visible: item.isCancelled == true,
                                    child: const LongText(
                                      'cancelled',
                                      fontSize: 10,
                                      textColor: Colors.orange,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
