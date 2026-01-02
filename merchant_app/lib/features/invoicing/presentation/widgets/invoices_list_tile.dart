import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/features/invoicing/presentation/pages/invoice_edit_draft.dart';
import 'package:littlefish_merchant/features/invoicing/presentation/pages/invoice_view_page.dart';
import 'package:littlefish_merchant/features/invoicing/presentation/redux/viewmodels/invoicing_view_model.dart';
import 'package:littlefish_merchant/features/invoicing/presentation/widgets/send_invoice_link_options_dialog.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import '../../../../app/custom_route.dart';
import '../../../../common/presentaion/components/completers.dart';
import '../../../../common/presentaion/components/dialogs/common_dialogs.dart';
import '../../../../common/presentaion/components/dialogs/services/modal_service.dart';
import '../../../../injector.dart';
import '../../../../models/enums.dart';
import '../../../../tools/textformatter.dart';
import '../../../order_common/data/model/order.dart';
import '../../data/invoice_helpers.dart';

class InvoicesListTile extends StatelessWidget {
  final Order invoice;
  final InvoicingViewModel vm;
  final BuildContext ctx;

  InvoicesListTile({
    super.key,
    required this.invoice,
    required this.vm,
    required this.ctx,
  });

  final modalService = getIt<ModalService>();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Theme.of(context).colorScheme.background,
      onTap: () {
        final targetPage = invoice.orderStatus == OrderStatus.draft
            ? InvoiceEditDraftPage(order: invoice)
            : InvoiceViewPage(order: invoice);
        Navigator.of(context).push(CustomRoute(builder: (_) => targetPage));
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
      title: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: context.labelSmall(
          'INV-${invoice.orderNumber.toString()}',
          isBold: false,
          alignLeft: true,
        ),
      ),
      subtitle: context.labelXSmall(
        '${invoice.customer?.firstName} ${invoice.customer?.lastName}',
        alignLeft: true,
        isBold: true,
        color: Theme.of(context).colorScheme.onBackground,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              context.labelSmall(
                TextFormatter.toStringCurrency(invoice.totalPrice),
                isBold: true,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  invoice.dateCreated != null
                      ? context.labelXSmall(
                          DateFormat(
                            'dd MMM yyyy',
                          ).format(invoice.dateCreated!),
                        )
                      : context.labelXSmall('No date'),
                  context.labelXSmall(
                    invoice.financialStatus == FinancialStatus.paid
                        ? ' - Paid'
                        : ' - ${invoicesStatusLabel(invoice.orderStatus)}',
                    alignLeft: true,
                    isBold: false,
                    color: invoice.financialStatus == FinancialStatus.paid
                        ? Theme.of(context).colorScheme.tertiary
                        : invoiceStatusColor(context, invoice.orderStatus),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(width: 8),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            color: Theme.of(context).colorScheme.background,
            surfaceTintColor: Theme.of(context).colorScheme.background,
            onSelected: (value) {
              switch (value) {
                // case 'sent':
                //   _showStatusDialog(context, invoice, OrderStatus.draft, () {
                //     if (invoice.orderStatus == OrderStatus.discarded) {
                //       showMessageDialog(
                //         context,
                //         'You cannot mark a disabled invoice as sent.',
                //         LittleFishIcons.error,
                //       );
                //       return;
                //     }
                //
                //     if (invoice.orderStatus == OrderStatus.draft) {
                //       showMessageDialog(
                //         context,
                //         'This invoice has already been marked as sent.',
                //         LittleFishIcons.info,
                //       );
                //       return;
                //     }
                //     vm.onMarkAsSent(
                //       invoice.id,
                //       invoice.businessId,
                //       completer: snackBarCompleter(
                //         ctx,
                //         'Invoice Marked as Sent',
                //         shouldPop: false,
                //         useOnlyCompleterAction: true,
                //         completerAction: () => vm.onRefresh(),
                //       )!,
                //       onError: (e) {
                //         showMessageDialog(
                //           ctx,
                //           'Failed to mark invoice as sent: ${e.toString()}',
                //           LittleFishIcons.error,
                //         );
                //       },
                //     );
                //   });
                //   break;
                case 'copyLink':
                  if (invoice.paymentLinkUrl.isEmpty) {
                    showMessageDialog(
                      context,
                      'Invoice either in draft mode or has not been fully created.',
                      LittleFishIcons.error,
                    );
                    return;
                  }
                  _copyToClipboard(context, invoice);
                  break;
                case 'resend':
                  SendInvoiceLinkOptionsDialog.show(ctx, invoice, vm);
                  break;
                case 'discard':
                  if (invoice.orderStatus == OrderStatus.discarded) {
                    showMessageDialog(
                      context,
                      'Invoice already discarded',
                      LittleFishIcons.error,
                    );
                    return;
                  }
                  _showStatusDialog(
                    context,
                    invoice,
                    OrderStatus.discarded,
                    () {
                      vm.onMarkAsDiscarded(
                        invoice,
                        completer: snackBarCompleter(
                          context,
                          'Invoice Discarded',
                          shouldPop: false,
                          useOnlyCompleterAction: true,
                          completerAction: () => vm.onRefresh(),
                        )!,
                        onError: (e) {
                          showMessageDialog(
                            context,
                            'Failed to discard invoice: ${e.toString()}',
                            LittleFishIcons.error,
                          );
                        },
                      );
                    },
                  );
                  break;
              }
            },
            itemBuilder: (context) {
              final items = <PopupMenuEntry<String>>[];
              if (!AppVariables.isPOSBuild) {
                items.add(
                  PopupMenuItem(
                    value: 'copyLink',
                    child: context.labelSmall('Copy Link', isBold: false),
                  ),
                );
              }
              if (invoice.orderStatus == OrderStatus.open) {
                items.add(
                  PopupMenuItem(
                    value: 'resend',
                    child: context.labelSmall('Resend Invoice', isBold: false),
                  ),
                );
              }
              items.addAll([
                PopupMenuItem(
                  value: 'discard',
                  child: context.labelSmall('Discard Invoice', isBold: false),
                ),
              ]);
              return items;
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showStatusDialog(
    BuildContext context,
    Order link,
    OrderStatus status,
    VoidCallback onConfirmed,
  ) async {
    final title = InvoiceStatusHelper.getTitle(status);
    final message = InvoiceStatusHelper.getMessage(link, status);
    final confirmLabel = InvoiceStatusHelper.getConfirmLabel(status);

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

  void _copyToClipboard(BuildContext context, Order invoice) {
    final url = invoice.paymentLinkUrl;
    if (url.isNotEmpty == true) {
      Clipboard.setData(ClipboardData(text: url));
      showMessageDialog(context, 'Link copied to clipboard!', Icons.done);
    } else {
      showMessageDialog(
        context,
        'No link available to copy.',
        LittleFishIcons.error,
      );
    }
  }
}
