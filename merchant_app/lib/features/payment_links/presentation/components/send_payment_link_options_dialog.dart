import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/services/modal_service.dart';
import 'package:littlefish_merchant/features/payment_links/presentation/components/share_link_buttons.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/models/enums.dart';
import '../../../../common/presentaion/components/completers.dart';
import '../../../../common/presentaion/components/dialogs/common_dialogs.dart';
import '../../../order_common/data/model/order.dart';
import '../view_models/payment_links/viewmodels/payment_links_vm.dart';

class SendPaymentLinkOptionsDialog {
  static Future<void> show(
    BuildContext context,
    Order link,
    PaymentLinksViewModel vm,
  ) async {
    final modalService = getIt<ModalService>();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await modalService.showActionModal(
        context: context,
        title: 'Send link',
        description: 'Please choose how you would like to send your link.',
        customWidget: Column(
          children: [
            PaymentShareLinkButtons(
              paymentLink: link,
              showCopyLinkButton: false,
              showEmailButton: link.customer?.email.isNotEmpty == true,
              showSmsButton: link.customer?.mobileNumber.isNotEmpty == true,
              onCopyLink: (link, onSuccess) async {
                await Clipboard.setData(
                  ClipboardData(text: link.paymentLinkUrl ?? ''),
                );
                onSuccess();
              },
              onSmsTap: (link, onSuccess) =>
                  _sendSms(context, link, vm, onSuccess),
              onEmailTap: (link, onSuccess) =>
                  _sendEmail(context, link, vm, onSuccess),
            ),
          ],
        ),
        showCancelButton: false,
        showAcceptButton: false,
        status: StatusType.success,
      );
    });
  }

  static void _sendSms(
    BuildContext context,
    Order link,
    PaymentLinksViewModel vm,
    VoidCallback onSuccess,
  ) {
    vm.onSendLinkViaSms(
      link.id,
      link.businessId,
      completer: snackBarCompleter(
        context,
        'Link resent via SMS successfully.',
        useOnlyCompleterAction: true,
        completerAction: onSuccess,
        usePopup: true,
      )!,
      onError: (e) {
        showMessageDialog(
          context,
          'Failed to resend SMS: ${e.toString()}',
          LittleFishIcons.error,
        );
      },
    );
  }

  static void _sendEmail(
    BuildContext context,
    Order link,
    PaymentLinksViewModel vm,
    VoidCallback onSuccess,
  ) {
    vm.onSendLinkViaEmail(
      link.id,
      link.businessId,
      completer: snackBarCompleter(
        context,
        'Link resent via Email successfully.',
        useOnlyCompleterAction: true,
        completerAction: onSuccess,
        usePopup: true,
      )!,
      onError: (e) {
        showMessageDialog(
          context,
          'Failed to resend Email: ${e.toString()}',
          LittleFishIcons.error,
        );
      },
    );
  }
}
