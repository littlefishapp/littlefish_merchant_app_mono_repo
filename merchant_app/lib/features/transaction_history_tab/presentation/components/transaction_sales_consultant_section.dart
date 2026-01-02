import 'package:flutter/cupertino.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/features/ecommerce_shared/tools/text_formatter.dart';
import 'package:littlefish_merchant/features/transaction_history_tab/presentation/components/transaction_info_item.dart';

class TransactionSalesConsultantSection extends StatelessWidget {
  final String firstName, surname, role, userId;

  const TransactionSalesConsultantSection({
    super.key,
    required this.firstName,
    required this.surname,
    required this.role,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return _content(context);
  }

  Padding _content(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(top: 16),
          child: context.labelSmall(
            'Sales Consultant',
            alignLeft: true,
            isBold: true,
          ),
        ),
        TransactionInfoItem(title: 'First Name', value: firstName),
        TransactionInfoItem(title: 'Surname', value: surname),
        TransactionInfoItem(
          title: 'Role',
          value: TextFormatter.toCapitalize(value: role),
        ),
        TransactionInfoItem(title: 'UserID', value: userId),
        const SizedBox(height: 8),
      ],
    ),
  );
}
