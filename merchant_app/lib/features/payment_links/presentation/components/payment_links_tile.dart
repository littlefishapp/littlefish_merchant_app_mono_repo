import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/features/payment_links/presentation/components/send_payment_link_options_dialog.dart';
import '../../../../app/custom_route.dart';
import '../../../../common/presentaion/components/completers.dart';
import '../../../../common/presentaion/components/dialogs/common_dialogs.dart';
import '../../../../common/presentaion/components/dialogs/services/modal_service.dart';
import '../../../../injector.dart';
import '../../../../models/enums.dart';
import '../../../order_common/data/model/order.dart';
import '../../domain/entities/payment_link_helpers.dart';
import '../pages/payment_link_details_page.dart';
import '../view_models/payment_links/viewmodels/payment_links_vm.dart';

class PaymentLinksTile extends StatelessWidget {
  final Order link;
  final PaymentLinksViewModel vm;
  final BuildContext ctx;

  PaymentLinksTile({
    super.key,
    required this.link,
    required this.vm,
    required this.ctx,
  });

  final modalService = getIt<ModalService>();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 16),
      tileColor: Theme.of(context).colorScheme.background,
      onTap: () {
        Navigator.of(
          context,
        ).push(CustomRoute(builder: (_) => PaymentLinkDetailsPage(link: link)));
      },
      leading: Container(
        width: 48,
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).extension<AppliedSurface>()?.brandSubTitle,
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Icon(Icons.link),
      ),
      title: context.labelXSmall(
        link.orderLineItems[0].displayName,
        isBold: false,
        alignLeft: true,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: context.labelXSmall(
        '${link.customer?.firstName} ${link.customer?.lastName}',
        alignLeft: true,
        isBold: true,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        color: Theme.of(context).colorScheme.onBackground,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              context.labelSmall(
                'R${link.totalPrice.toStringAsFixed(2)}',
                isBold: true,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  link.dateCreated != null
                      ? context.labelXSmall(
                          DateFormat('dd MMM yyyy').format(link.dateCreated!),
                        )
                      : context.labelXSmall('No date'),
                  context.labelXSmall(
                    link.financialStatus == FinancialStatus.paid
                        ? ' - Paid'
                        : ' - ${paymentLinkStatusLabel(link.paymentLinkStatus)}',
                    alignLeft: true,
                    isBold: false,
                    color: link.financialStatus == FinancialStatus.paid
                        ? Theme.of(context).colorScheme.tertiary
                        : paymentLinkStatusColor(
                            context,
                            link.paymentLinkStatus,
                          ),
                  ),
                ],
              ),
            ],
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            color: Theme.of(context).colorScheme.background,
            surfaceTintColor: Theme.of(context).colorScheme.background,
            onSelected: (value) {
              switch (value) {
                case 'sent':
                  _showStatusDialog(context, link, PaymentLinkStatus.sent, () {
                    if (link.paymentLinkStatus == PaymentLinkStatus.disabled) {
                      showMessageDialog(
                        context,
                        'You cannot mark a disabled payment link as sent.',
                        LittleFishIcons.error,
                      );
                      return;
                    }

                    if (link.paymentLinkStatus == PaymentLinkStatus.sent) {
                      showMessageDialog(
                        context,
                        'This payment link has already been marked as sent.',
                        LittleFishIcons.info,
                      );
                      return;
                    }
                    vm.onMarkAsSent(
                      link.id,
                      link.businessId,
                      completer: snackBarCompleter(
                        ctx,
                        'Payment Link Marked as Sent',
                        shouldPop: false,
                        useOnlyCompleterAction: true,
                        completerAction: () => vm.onRefresh(),
                      )!,
                      onError: (e) {
                        showMessageDialog(
                          ctx,
                          'Failed to mark payment link as sent: ${e.toString()}',
                          LittleFishIcons.error,
                        );
                      },
                    );
                  });
                  break;
                case 'resend':
                  SendPaymentLinkOptionsDialog.show(ctx, link, vm);
                  break;
                case 'disable':
                  if (link.paymentLinkStatus == PaymentLinkStatus.disabled) {
                    showMessageDialog(
                      context,
                      'Payment link already disabled',
                      LittleFishIcons.error,
                    );
                    return;
                  }
                  vm.onMarkAsDisabled(
                    link.id,
                    link.businessId,
                    completer: snackBarCompleter(
                      context,
                      'Payment Link Disabled',
                      shouldPop: false,
                      useOnlyCompleterAction: true,
                      completerAction: () => vm.onRefresh(),
                    )!,
                    onError: (e) {
                      showMessageDialog(
                        context,
                        'Failed to disable payment link: ${e.toString()}',
                        LittleFishIcons.error,
                      );
                    },
                  );
                  break;
              }
            },
            itemBuilder: (context) {
              final items = <PopupMenuEntry<String>>[];

              if (link.paymentLinkStatus != PaymentLinkStatus.sent &&
                  link.financialStatus != FinancialStatus.paid) {
                items.add(
                  PopupMenuItem(
                    value: 'sent',
                    child: _optionLabel(context, 'Mark as Sent'),
                  ),
                );
              }
              if (link.customer!.email.isNotEmpty ||
                  link.customer!.mobileNumber.isNotEmpty) {
                items.add(
                  PopupMenuItem(
                    value: 'resend',
                    child: _optionLabel(context, 'Resend Link'),
                  ),
                );
              }
              items.add(
                PopupMenuItem(
                  value: 'disable',
                  child: _optionLabel(context, 'Disable Link'),
                ),
              );

              return items;
            },
          ),
        ],
      ),
    );
  }

  Widget _optionLabel(BuildContext context, String text) {
    return context.paragraphXSmall(
      text,
      isBold: false,
      alignLeft: true,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Future<void> _showStatusDialog(
    BuildContext context,
    Order link,
    PaymentLinkStatus status,
    VoidCallback onConfirmed,
  ) async {
    final title = PaymentLinkStatusHelper.getTitle(status);
    final message = PaymentLinkStatusHelper.getMessage(link, status);
    final confirmLabel = PaymentLinkStatusHelper.getConfirmLabel(status);

    await modalService.showActionModal(
      context: context,
      title: title,
      description: message,
      acceptText: confirmLabel,
      cancelText: 'Cancel',
      status: StatusType.defaultStatus,
      onTap: (_) async {
        Navigator.pop(context);
        onConfirmed();
      },
    );
  }
}
