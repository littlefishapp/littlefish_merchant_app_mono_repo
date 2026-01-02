import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/app.dart';

// Third-party/project imports
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_tabbar.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/footer_buttons_secondary_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/completers.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/features/payment_links/presentation/components/payment_link_preview_tab.dart';
import 'package:littlefish_merchant/features/payment_links/presentation/components/payment_link_summary_tab.dart';
import 'package:littlefish_merchant/features/payment_links/presentation/view_models/payment_links/viewmodels/payment_links_vm.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';

import '../../../../common/presentaion/components/buttons/button_primary.dart';
import '../../../../common/presentaion/components/dialogs/services/modal_service.dart';
import '../../../../common/presentaion/pages/scaffolds/app_tabbed_scaffold.dart';
import '../../../../injector.dart';
import '../../../../models/enums.dart';
import '../../../order_common/data/model/order.dart';
import '../components/share_link_buttons.dart';

class PaymentLinkDetailsPage extends StatefulWidget {
  final Order link;

  const PaymentLinkDetailsPage({super.key, required this.link});

  @override
  State<PaymentLinkDetailsPage> createState() => _PaymentLinkDetailsPageState();
}

class _PaymentLinkDetailsPageState extends State<PaymentLinkDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, PaymentLinksViewModel>(
      distinct: true,
      converter: (store) =>
          PaymentLinksViewModel.fromStore(store, context: context),
      builder: (context, vm) {
        return AppScaffold(
          title: 'Payment Link Details',
          body: vm.isLoading == true ? const AppProgressIndicator() : _tabs(),
          persistentFooterButtons: [
            AppVariables.isPOSBuild
                ? ButtonPrimary(
                    text: 'Resend Link',
                    onTap: (_) {
                      if (widget.link.customer!.mobileNumber.isNotEmpty ||
                          widget.link.customerEmail.isNotEmpty) {
                        _showSuccessDialog(widget.link, vm);
                      } else {
                        showMessageDialog(
                          context,
                          'No phone number or email available to send link.',
                          LittleFishIcons.error,
                        );
                      }
                    },
                  )
                : FooterButtonsSecondaryPrimary(
                    primaryButtonText: 'Resend Link',
                    secondaryButtonText: 'Copy Link',
                    onPrimaryButtonPressed: (_) {
                      if (widget.link.customer!.mobileNumber.isNotEmpty ||
                          widget.link.customerEmail.isNotEmpty) {
                        _showSuccessDialog(widget.link, vm);
                      } else {
                        showMessageDialog(
                          context,
                          'No phone number or email available to send link.',
                          LittleFishIcons.error,
                        );
                      }
                    },
                    onSecondaryButtonPressed: (_) => _copyToClipboard(context),
                  ),
          ],
        );
      },
    );
  }

  Widget _tabs() {
    return AppTabBar(
      intialIndex: 0,
      scrollable: false,
      resizeToAvoidBottomInset: true,
      physics: const BouncingScrollPhysics(),
      tabs: [
        TabBarItem(
          text: 'Details',
          content: PaymentLinkSummaryTab(link: widget.link),
        ),
        TabBarItem(
          text: 'Preview',
          content: PaymentLinkPreviewTab(link: widget.link),
        ),
      ],
    );
  }

  void _copyToClipboard(BuildContext context) {
    final url = widget.link.paymentLinkUrl;
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

  void _showSuccessDialog(Order link, PaymentLinksViewModel vm) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final modalService = getIt<ModalService>();

      await modalService.showActionModal(
        context: context,
        title: 'Send link',
        description: 'Please choose how you would like to send your link.',
        customWidget: Column(
          children: [
            PaymentShareLinkButtons(
              paymentLink: link,
              showCopyLinkButton: false,
              showEmailButton: link.customer!.email.isNotEmpty,
              showSmsButton: link.customer!.mobileNumber.isNotEmpty,
              onCopyLink: (link, onSuccess) async {
                await Clipboard.setData(
                  ClipboardData(text: link.paymentLinkUrl ?? ''),
                );
                onSuccess();
              },
              onSmsTap: (link, onSuccess) => _sendSms(link, vm, onSuccess),
              onEmailTap: (link, onSuccess) => _sendEmail(link, vm, onSuccess),
            ),
          ],
        ),
        showCancelButton: false,
        showAcceptButton: false,
        status: StatusType.success,
      );
    });
  }

  void _sendSms(Order link, PaymentLinksViewModel vm, VoidCallback onSuccess) {
    vm.onSendLinkViaSms(
      link.id,
      link.businessId,
      completer: snackBarCompleter(
        context,
        'Link sent via SMS successfully.',
        useOnlyCompleterAction: true,
        completerAction: onSuccess,
        usePopup: false,
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

  void _sendEmail(
    Order link,
    PaymentLinksViewModel vm,
    VoidCallback onSuccess,
  ) {
    vm.onSendLinkViaEmail(
      link.id,
      link.businessId,
      completer: snackBarCompleter(
        context,
        'Link sent via Email successfully.',
        useOnlyCompleterAction: true,
        completerAction: onSuccess,
        usePopup: false,
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
