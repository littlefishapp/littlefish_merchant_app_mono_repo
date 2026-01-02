import 'package:flutter/material.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order_transaction.dart';
import 'package:littlefish_merchant/features/transaction_history_tab/data/utility/transaction_history_tile_utility.dart';
import 'package:littlefish_merchant/features/transaction_history_tab/presentation/components/transaction_history_item.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';

class TransactionHistoryListTile extends StatelessWidget {
  final OrderTransaction transaction;
  final Function() onTap;

  const TransactionHistoryListTile({
    super.key,
    required this.transaction,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _listItemTile(context);
  }

  Widget _listItemTile(BuildContext ctx) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: TransactionHistoryItem(
        onTap: onTap,
        leadingIcon: TransactionHistoryTileUtility.getTileIcon(
          transaction.paymentType.acceptanceChannel,
        ),
        // leadingAndTrailColour: ,
        leadingText: TransactionHistoryTileUtility.getTileTitle(
          transaction.transactionType,
        ),
        leadingBottomTextOne: 'Transaction ',
        leadingBottomTextTwo: '#${transaction.transactionNumber}',
        trailBottomTextOne: TextFormatter.toShortDate(
          dateTime:
              transaction.dateUpdated ??
              transaction.dateCreated ??
              DateTime.now(),
          format: 'MM/dd',
        ),
        trailText: TextFormatter.toStringCurrencyNoDecimal(
          transaction.amount.round(),
        ),
        trailBottomTextTwo: TextFormatter.toShortDate(
          dateTime:
              transaction.dateUpdated ??
              transaction.dateCreated ??
              DateTime.now(),
          format: 'HH:mm',
        ),
        leadingBottomTextGap: 8,
        trailBottomTextGap: 4,
        leadingBottomTextAlignment: 0,
      ),
    );
  }
}
