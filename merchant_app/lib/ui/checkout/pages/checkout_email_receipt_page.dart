import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_core/logging/services/logger_service.dart';
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_transaction.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/services/checkout_service.dart';
import 'package:littlefish_merchant/common/presentaion/components/circle_gradient_avatar.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/email_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/string_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';

import '../../../app/theme/applied_system/applied_text_icon.dart';

class CheckoutEmailReceiptPage extends StatefulWidget {
  final String? emailAddress;

  final String? customerName;

  final CheckoutTransaction? transaction;

  const CheckoutEmailReceiptPage({
    Key? key,
    this.emailAddress,
    this.customerName,
    required this.transaction,
  }) : super(key: key);

  @override
  State<CheckoutEmailReceiptPage> createState() =>
      _CheckoutEmailReceiptPageState();
}

class _CheckoutEmailReceiptPageState extends State<CheckoutEmailReceiptPage> {
  LoggerService get logger => LittleFishCore.instance.get<LoggerService>();

  bool isSending = false;

  bool isSent = false;

  String? email;

  String? customerName;

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  void initState() {
    email = widget.emailAddress ?? widget.transaction?.customerEmail;
    customerName = widget.customerName ?? widget.transaction?.customerName;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        SizedBox(
          height: 300,
          child: isSending
              ? const AppProgressIndicator()
              : isSent
              ? GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      AnimatedContainer(
                        alignment: Alignment.center,
                        duration: const Duration(milliseconds: 300),
                        child: OutlineGradientAvatar(
                          radius: 80,
                          child: Icon(
                            Icons.check,
                            color: Theme.of(
                              context,
                            ).extension<AppliedTextIcon>()?.brand,
                            size: 80,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      context.paragraphMedium(
                        'Email Sent!',
                        color: Theme.of(
                          context,
                        ).extension<AppliedTextIcon>()?.brand,
                      ),
                      const SizedBox(height: 4),
                      context.paragraphMedium(
                        'tap to close',
                        color: Theme.of(
                          context,
                        ).extension<AppliedTextIcon>()?.brand,
                      ),
                    ],
                  ),
                )
              : Form(
                  key: formKey,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        context.labelLarge('Email Receipt', isBold: true),
                        context.labelXSmall(
                          'Please ask your customer for their email and then enter it below',
                          alignLeft: true,
                        ),
                        const SizedBox(height: 16),
                        StringFormField(
                          useOutlineStyling: true,
                          initialValue: customerName,
                          hintText: 'John',
                          key: const Key('firstname'),
                          labelText: 'Customer Name',
                          onSaveValue: (value) {
                            customerName = value;
                          },
                          onFieldSubmitted: (value) {
                            customerName = value;
                          },
                          isRequired: true,
                        ),
                        const SizedBox(height: 8),
                        EmailFormField(
                          initialValue: email,
                          hintText: 'customer@gmail.com',
                          key: const Key('email'),
                          labelText: 'Email Address',
                          onSaveValue: (value) {
                            email = value;
                          },
                          onFieldSubmitted: (value) {
                            email = value;
                          },
                          isRequired: true,
                        ),
                        const SizedBox(height: 8),
                        ButtonPrimary(
                          text: 'Send Email',
                          onTap: (ctx) async =>
                              await onEmail(context, widget.transaction),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Future<void> onEmail(context, CheckoutTransaction? transaction) async {
    isSending = true;
    if (mounted) setState(() {});

    try {
      if (!formKey.currentState!.validate()) return;

      formKey.currentState!.save();

      var store = StoreProvider.of<AppState>(context);

      var service = CheckoutService.fromStore(store);

      logger.debug(
        'ui.checkout.email_receipt',
        'Sending email receipt to ${email?.trim()}',
      );

      await service.emailPaymentReceipt(
        email?.trim(),
        customerName,
        transaction,
      );

      logger.debug(
        'ui.checkout.email_receipt',
        'Email receipt sent successfully',
      );

      isSent = true;
    } catch (e) {
      logger.error(
        'ui.checkout.email_receipt',
        'Failed to send email receipt: $e',
      );

      showErrorDialog(context, e);
    } finally {
      isSending = false;
    }
    if (mounted) setState(() {});
  }
}
