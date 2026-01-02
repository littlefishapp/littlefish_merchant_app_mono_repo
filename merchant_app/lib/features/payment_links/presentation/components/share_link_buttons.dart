import 'package:flutter/material.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_quick_action.dart';

import '../../../order_common/data/model/order.dart';

class PaymentShareLinkButtons extends StatefulWidget {
  final bool showCopyLinkButton;
  final bool showSmsButton;
  final bool showEmailButton;
  final Function(Order link, VoidCallback onSuccess) onCopyLink;
  final Function(Order link, VoidCallback onSuccess) onSmsTap;
  final Function(Order link, VoidCallback onSuccess) onEmailTap;
  final Order paymentLink;

  const PaymentShareLinkButtons({
    Key? key,
    this.showCopyLinkButton = true,
    this.showSmsButton = true,
    this.showEmailButton = true,
    required this.onCopyLink,
    required this.onSmsTap,
    required this.onEmailTap,
    required this.paymentLink,
  }) : super(key: key);

  @override
  State<PaymentShareLinkButtons> createState() =>
      _PaymentShareLinkButtonsState();
}

class _PaymentShareLinkButtonsState extends State<PaymentShareLinkButtons> {
  bool emailSent = false;
  bool smsSent = false;
  bool linkCopied = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          if (widget.showEmailButton)
            ButtonQuickAction(
              icon: emailSent ? Icons.check : Icons.email_outlined,
              title: emailSent ? 'Emailed' : 'Email',
              onTap: () => widget.onEmailTap(widget.paymentLink, () {
                setState(() => emailSent = true);
              }),
            ),
          if (widget.showSmsButton)
            ButtonQuickAction(
              icon: smsSent ? Icons.check : Icons.sms_outlined,
              title: smsSent ? 'Sent SMS' : 'SMS',
              onTap: () => widget.onSmsTap(widget.paymentLink, () {
                setState(() => smsSent = true);
              }),
            ),
          if (widget.showCopyLinkButton)
            ButtonQuickAction(
              icon: linkCopied ? Icons.check : Icons.link,
              title: linkCopied ? 'Copied' : 'Copy Link',
              onTap: () => widget.onCopyLink(widget.paymentLink, () {
                setState(() => linkCopied = true);
              }),
            ),
        ],
      ),
    );
  }
}
