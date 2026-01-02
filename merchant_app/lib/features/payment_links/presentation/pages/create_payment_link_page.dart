// Flutter imports
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Third-party imports
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_core/auth/services/auth_service.dart';
import 'package:littlefish_icons/littlefish_icons.dart';

// Project imports
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/services/modal_service.dart';
import 'package:littlefish_merchant/common/presentaion/components/completers.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_tabbar.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order.dart';
import 'package:littlefish_merchant/features/payment_links/domain/entities/payment_link_helpers.dart';
import 'package:littlefish_merchant/features/payment_links/presentation/pages/payment_links_landing_page.dart';
import 'package:littlefish_merchant/features/payment_links/presentation/components/create_payment_link_tab.dart';
import 'package:littlefish_merchant/features/payment_links/presentation/components/preview_payment_details_tab.dart';
import 'package:littlefish_merchant/features/payment_links/presentation/components/share_link_buttons.dart';
import 'package:littlefish_merchant/features/payment_links/presentation/view_models/payment_links/viewmodels/payment_links_vm.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:uuid/uuid.dart';
import '../../../order_common/data/model/shipping_address.dart';
import 'package:littlefish_merchant/features/order_common/data/model/customer.dart';
import '../../../../app/custom_route.dart';
import '../../../../common/presentaion/pages/scaffolds/app_tabbed_scaffold.dart';
import '../../../order_common/data/model/order_line_item.dart';

class CreatePaymentLinksPage extends StatefulWidget {
  static const String route = 'create-payment-link-page';
  const CreatePaymentLinksPage({super.key});

  @override
  State<CreatePaymentLinksPage> createState() => _CreatePaymentLinksPageState();
}

class _CreatePaymentLinksPageState extends State<CreatePaymentLinksPage> {
  late TextEditingController linkNameController;
  late TextEditingController descriptionController;
  late TextEditingController amountDueController;
  late TextEditingController customerFirstNameController;
  late TextEditingController customerLastNameController;
  late TextEditingController customerPhoneNumberController;
  late TextEditingController customerEmailController;

  @override
  void initState() {
    super.initState();
    linkNameController = TextEditingController();
    descriptionController = TextEditingController();
    amountDueController = TextEditingController();
    customerFirstNameController = TextEditingController();
    customerLastNameController = TextEditingController();
    customerPhoneNumberController = TextEditingController();
    customerEmailController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, PaymentLinksViewModel>(
      distinct: true,
      converter: (store) =>
          PaymentLinksViewModel.fromStore(store, context: context),
      builder: (context, vm) {
        return AppScaffold(
          title: 'Create Payment Link',
          body: Stack(
            children: [
              _tabs(vm),
              if (vm.isLoading == true)
                Positioned.fill(
                  child: ColoredBox(
                    color: Theme.of(context).colorScheme.background,
                    child: const Center(child: AppProgressIndicator()),
                  ),
                ),
            ],
          ),
          persistentFooterButtons: [
            ButtonPrimary(text: 'Create Link', onTap: (_) => _onCreateLink(vm)),
          ],
        );
      },
    );
  }

  Widget _tabs(PaymentLinksViewModel vm) {
    return AppTabBar(
      intialIndex: 0,
      physics: const BouncingScrollPhysics(),
      scrollable: true,
      resizeToAvoidBottomInset: false,
      tabs: [
        TabBarItem(
          text: 'Create Link',
          content: CreatePaymentLinkTab(
            vm: vm,
            linkNameController: linkNameController,
            descriptionController: descriptionController,
            amountDueController: amountDueController,
            customerFirstNameController: customerFirstNameController,
            customerLastNameController: customerLastNameController,
            customerPhoneNumberController: customerPhoneNumberController,
            customerEmailController: customerEmailController,
          ),
        ),
        TabBarItem(
          text: 'Preview',
          content: PreviewPaymentDetailsTab(
            linkNameController: linkNameController,
            descriptionController: descriptionController,
            amountDueController: amountDueController,
            customerNameController: customerFirstNameController,
          ),
        ),
      ],
    );
  }

  void _onCreateLink(PaymentLinksViewModel vm) {
    final now = DateTime.now();
    final orderLineItemId = const Uuid().v4();
    final linkName = linkNameController.text.trim();
    final description = descriptionController.text.trim();
    final amountText = amountDueController.text.trim();
    final customerFirstName = customerFirstNameController.text.trim();
    final customerLastName = customerLastNameController.text.trim();
    final customerPhoneNumber = customerPhoneNumberController.text.trim();
    final customerEmail = customerEmailController.text.trim();

    final isValid = _validateRequiredFields(context, {
      'Link Name': linkName,
      'Amount Due': amountText,
    });

    if (!isValid) return;

    final amount = double.tryParse(amountText.replaceAll('R', '').trim()) ?? 0;

    final request = Order(
      businessId: AppVariables.store?.state.currentBusinessId ?? '',
      note: description,
      totalAmountOutstanding: amount,
      totalPrice: amount,
      currentTotalPrice: amount,
      subtotalPrice: amount,
      lineItemTotalPrice: amount,
      totalLineItemsSold: 1,
      totalUniqueLineItems: 1,
      orderLineItems: [
        OrderLineItem(
          id: orderLineItemId,
          displayName: linkName,
          unitPrice: amount,
          subtotalPrice: amount,
          totalPrice: amount,
          quantity: 1,
          businessId: AppVariables.store?.state.currentBusinessId ?? '',
          productId: orderLineItemId,
        ),
      ],
      financialStatus: FinancialStatus.pending,
      orderStatus: OrderStatus.open,
      fulfillmentStatus: FulfillmentStatus.processing,
      orderSource: OrderSource.online,
      fulfilmentMethod: FulfilmentMethod.undefined,
      capturedChannel: determineCapturedChannel(),
      orderVersion: 'OrderV2',
      dateCreated: now,
      dateUpdated: now,
      estimateDeliverydate: now,
      paymentLinkStatus: PaymentLinkStatus.created,
      customer: Customer(
        firstName: customerFirstName,
        lastName: customerLastName,
        email: customerEmail,
        mobileNumber: customerPhoneNumber,
        businessId: AppVariables.store?.state.businessState.businessId ?? '',
        shippingAddress: ShippingAddress(
          contactEmail: customerEmail,
          contactMobileNumber: customerPhoneNumber,
          contactName: '$customerFirstName $customerLastName',
        ),
      ),
      type: OrderType.salesOrder,
      updatedBy: AppVariables.store?.state.authState.userId ?? '',
      createdBy: AppVariables.store?.state.authState.userId ?? '',
    );

    vm.onCreatePaymentLink(request, (link) {
      _showSuccessDialog(link, vm);
    });
  }

  bool _validateRequiredFields(
    BuildContext context,
    Map<String, String> fields,
  ) {
    final missingFields = fields.entries
        .where((entry) => entry.value.trim().isEmpty)
        .map((entry) => entry.key)
        .toList();

    if (missingFields.isNotEmpty) {
      final message =
          '${missingFields.join(', ')} ${missingFields.length == 1 ? 'is' : 'are'} required.';
      showMessageDialog(context, message, LittleFishIcons.error);
      return false;
    }

    return true;
  }

  void _showSuccessDialog(Order link, PaymentLinksViewModel vm) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final modalService = getIt<ModalService>();

      await modalService.showActionModal(
        context: context,
        title: 'Payment link created successfully',
        description:
            'The payment link has been created successfully. You can share it with your customer using one of the options below.',
        customWidget: Column(
          children: [
            PaymentShareLinkButtons(
              paymentLink: link,
              showEmailButton: link.customer?.email.isNotEmpty ?? false,
              showSmsButton: link.customer?.mobileNumber.isNotEmpty ?? false,
              onCopyLink: (link, onSuccess) async {
                await Clipboard.setData(
                  ClipboardData(text: link.paymentLinkUrl ?? ''),
                );
                onSuccess();
              },
              onSmsTap: (link, onSuccess) => _sendSms(link, vm, onSuccess),
              onEmailTap: (link, onSuccess) => _sendEmail(link, vm, onSuccess),
            ),
            ButtonPrimary(
              text: 'Done',
              onTap: (_) {
                Navigator.of(context).pushReplacement(
                  CustomRoute(builder: (_) => const PaymentLinksLandingPage()),
                );
              },
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

  CapturedChannel determineCapturedChannel() {
    CapturedChannel channel = CapturedChannel.undefined;

    if (Platform.isIOS) {
      channel = CapturedChannel.ios;
    } else if (Platform.isAndroid) {
      channel = CapturedChannel.android;
    }

    if (PlatformType.pos == true || PlatformType.softPos == true) {
      channel = CapturedChannel.pos;
    }

    return channel;
  }
}
