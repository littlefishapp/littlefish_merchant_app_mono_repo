import 'dart:async';

import 'package:flutter/material.dart';
import 'package:littlefish_core/logging/services/logger_service.dart';
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/features/receipt_common/presentation/redux/order_receipt_actions.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_transaction.dart';
import 'package:littlefish_merchant/providers/locale_provider.dart';
import 'package:littlefish_merchant/common/presentaion/components/circle_gradient_avatar.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/mobile_number_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/string_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import '../../../app/theme/applied_system/applied_text_icon.dart';

class CheckoutSMSReceiptPage extends StatefulWidget {
  static const String route = 'checkout/receipt-sms';

  final String? mobileNumber;

  final String? customerName;

  final CheckoutTransaction? transaction;

  final bool? transactionIsVoided;

  final bool? isRefund;

  const CheckoutSMSReceiptPage({
    Key? key,
    required this.transaction,
    this.mobileNumber,
    this.customerName,
    this.transactionIsVoided,
    this.isRefund,
  }) : super(key: key);

  @override
  State<CheckoutSMSReceiptPage> createState() => _CheckoutSMSReceiptPageState();
}

class _CheckoutSMSReceiptPageState extends State<CheckoutSMSReceiptPage> {
  LoggerService get logger => LittleFishCore.instance.get<LoggerService>();

  bool isSending = false;

  bool isSent = false;

  bool smsFailed = false;

  String? mobileNumber;

  String? customerName;

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  void initState() {
    mobileNumber = widget.mobileNumber;
    customerName = widget.customerName;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      // mainAxisSize: MainAxisSize.min,
      shrinkWrap: true,
      children: [
        SizedBox(
          height: 272,
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
                            smsFailed ? LittleFishIcons.error : Icons.check,
                            size: 80,
                            color: Theme.of(
                              context,
                            ).extension<AppliedTextIcon>()?.brand,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      context.paragraphMedium(
                        smsFailed ? 'SMS Failed' : 'SMS Sent!',
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
                        context.labelLarge('SMS Receipt', isBold: true),
                        context.labelXSmall(
                          'Please ask your customer for their number and then enter it below',
                          alignLeft: true,
                        ),
                        const SizedBox(height: 16),
                        StringFormField(
                          useOutlineStyling: true,
                          initialValue: customerName,
                          hintText: 'Enter Customer Name',
                          key: const Key('firstname'),
                          labelText: 'Name',
                          onSaveValue: (value) {
                            customerName = value;
                          },
                          onFieldSubmitted: (value) {
                            customerName = value;
                          },
                          isRequired: true,
                        ),
                        const SizedBox(height: 8),
                        MobileNumberFormField(
                          useOutlineStyling: true,
                          initialValue: mobileNumber,
                          hintText: 'Enter mobile number',
                          country: LocaleProvider.instance.currentLocale,
                          key: const Key('mobile'),
                          labelText: 'Mobile Number',
                          onSaveValue: (value) {
                            mobileNumber = value;
                          },
                          onFieldSubmitted: (value) {
                            mobileNumber = value;
                          },
                          onChanged: (value) {
                            mobileNumber = value;
                          },
                          isRequired: true,
                        ),
                        ButtonPrimary(
                          text: 'Send SMS',
                          onTap: (ctx) async => onSMS(
                            context,
                            widget.transaction,
                            isRefund: widget.isRefund ?? true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Future<void> onSMS(
    BuildContext context,
    CheckoutTransaction? transaction, {
    bool isRefund = true,
  }) async {
    if (hasError(transaction)) {
      showError();
      return;
    }
    try {
      if (mounted) {
        setState(() {
          isSending = true;
        });
      }

      Completer<bool> completer = Completer();
      AppVariables.store?.dispatch(
        sendCheckoutSaleSmsReceipt(
          transaction: transaction!,
          businessId: AppVariables.businessId,
          mobileNumber: mobileNumber ?? '',
          completer: completer,
        ),
      );

      bool isSentSuccessfully = await completer.future;

      if (mounted) {
        setState(() {
          isSending = false;
          isSent = isSentSuccessfully;
          smsFailed = !isSentSuccessfully;
        });
      }
    } catch (e) {
      logger.error(
        'ui.checkout.sms_receipt',
        'Failed to send SMS receipt: $e',
        error: e,
        stackTrace: StackTrace.current,
      );
      showError();
      if (mounted) {
        setState(() {
          isSending = false;
          isSent = false;
          smsFailed = true;
        });
      }
    }
  }

  bool hasError(CheckoutTransaction? transaction) {
    if (transaction == null) return true;
    if (AppVariables.businessId.isEmpty) return true;
    if (mobileNumber == null || mobileNumber!.isEmpty) return true;
    return false;
  }

  Future<void> showError() async {
    if (mounted) {
      setState(() {
        smsFailed = true;
        isSent = true;
      });
    }
  }
}
