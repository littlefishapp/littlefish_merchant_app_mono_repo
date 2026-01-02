// flutter imports
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_quick_action.dart';

class TransactionReceiptButtons extends StatelessWidget {
  final bool showPrintButton;
  final bool showSmsButton;
  final bool showEmailButton;
  final Function onPrintTap;
  final Function onSmsTap;
  final Function onEmailTap;

  const TransactionReceiptButtons({
    Key? key,
    this.showPrintButton = true,
    this.showSmsButton = true,
    this.showEmailButton = true,
    required this.onPrintTap,
    required this.onSmsTap,
    required this.onEmailTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          if (showPrintButton)
            ButtonQuickAction(
              icon: Icons.print_outlined,
              title: 'Print',
              onTap: () => onPrintTap(),
            ),
          if (showSmsButton)
            ButtonQuickAction(
              icon: Icons.sms_outlined,
              title: 'SMS',
              onTap: () => onSmsTap(),
            ),
          if (showEmailButton)
            ButtonQuickAction(
              icon: Icons.email_outlined,
              title: 'Email',
              onTap: () => onEmailTap(),
            ),
        ],
      ),
    );
  }
}
