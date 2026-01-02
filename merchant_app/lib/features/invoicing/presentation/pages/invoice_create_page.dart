import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/footer_buttons_secondary_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/services/modal_service.dart';
import 'package:littlefish_merchant/common/presentaion/components/completers.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_tabbar.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/features/invoicing/presentation/pages/invoice_landing_page.dart';
import 'package:littlefish_merchant/features/invoicing/presentation/pages/tabs/invoice_create_tab.dart';
import 'package:littlefish_merchant/features/invoicing/presentation/pages/tabs/invoice_preview_tab.dart';
import 'package:littlefish_merchant/features/invoicing/presentation/redux/viewmodels/invoicing_view_model.dart';
import 'package:littlefish_merchant/features/order_common/data/model/customer.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order.dart';
import 'package:littlefish_merchant/features/payment_links/presentation/components/share_link_buttons.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_discount.dart'
    as checkout;
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:uuid/uuid.dart';
import '../../../../app/custom_route.dart';
import '../../../../common/presentaion/pages/scaffolds/app_tabbed_scaffold.dart';
import '../../../../models/sales/checkout/checkout_discount.dart';
import '../../../../models/stock/stock_product.dart';
import '../../../../ui/checkout/helpers/discount_helper.dart';
import '../../../order_common/data/model/order_discount.dart';
import '../../../order_common/data/model/order_line_item.dart';
import '../../../order_common/data/model/shipping_address.dart';
import '../../../order_common/data/model/tax_info.dart';

class InvoiceCreatePage extends StatefulWidget {
  static const String route = 'invoice-create-page';
  final List<StockProduct> initialSelectedProducts;

  const InvoiceCreatePage({super.key, this.initialSelectedProducts = const []});

  @override
  State<InvoiceCreatePage> createState() => _InvoiceCreatePageState();
}

class _InvoiceCreatePageState extends State<InvoiceCreatePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late TextEditingController amountDueController;
  late TextEditingController dueDateController;
  late TextEditingController notesController;
  late TextEditingController discountController;

  @override
  void initState() {
    super.initState();
    amountDueController = TextEditingController();
    dueDateController = TextEditingController();
    notesController = TextEditingController();
    discountController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, InvoicingViewModel>(
      distinct: true,
      converter: (store) =>
          InvoicingViewModel.fromStore(store, context: context),
      builder: (context, vm) {
        return AppScaffold(
          title: 'Create Invoice',
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
            FooterButtonsSecondaryPrimary(
              secondaryButtonText: 'Save as Draft',
              primaryButtonText: 'Create',
              onSecondaryButtonPressed: (_) => _onCreateDraftInvoice(vm),
              onPrimaryButtonPressed: (_) => _onCreateInvoice(vm),
            ),
          ],
        );
      },
    );
  }

  Widget _tabs(InvoicingViewModel vm) {
    return AppTabBar(
      intialIndex: 0,
      physics: const BouncingScrollPhysics(),
      scrollable: true,
      resizeToAvoidBottomInset: false,
      tabs: [
        TabBarItem(
          text: 'Create Invoice',
          content: InvoiceCreateTab(
            amountDueController: amountDueController,
            notesController: notesController,
            dueDateController: dueDateController,
            discountController: discountController,
            onProductsSelected: vm.setSelectedProducts,
          ),
        ),
        TabBarItem(
          text: 'Preview',
          content: InvoicePreviewTab(
            storeName:
                AppVariables.store?.state.businessState.profile?.name ?? '',
            invoiceNumber: '#',
            issueDate: DateTime.now(),
            subtotal: amountDueController.text,
            tax:
                'R0.00', //TODO: ADD tax calculations per product variant after variants work is done.
          ),
        ),
      ],
    );
  }

  void _showSuccessDialog(
    Order link,
    InvoicingViewModel vm,
    bool showShareButtons,
  ) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final modalService = getIt<ModalService>();

      final title = showShareButtons
          ? 'Invoice Created Successfully'
          : 'Draft Saved Successfully';

      final description = showShareButtons
          ? 'Your invoice has been created '
                'and you can use one of the options '
                'below to share it with your customer '
                'or copy the payment link to your clipboard.'
          : 'Your invoice has been saved as a draft. '
                'You can return to it later to make changes.';

      await modalService.showActionModal(
        context: context,
        title: title,
        description: description,
        customWidget: Column(
          children: [
            if (showShareButtons)
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
                onEmailTap: (link, onSuccess) =>
                    _sendEmail(link, vm, onSuccess),
              ),
            ButtonPrimary(
              text: 'Done',
              onTap: (_) {
                Navigator.of(context).pushReplacement(
                  CustomRoute(builder: (_) => const InvoiceLandingPage()),
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

  void _sendSms(Order order, InvoicingViewModel vm, VoidCallback onSuccess) {
    vm.onSendLinkViaSms(
      order.id,
      order.businessId,
      completer: snackBarCompleter(
        context,
        'Invoice sent via SMS successfully.',
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

  void _sendEmail(Order order, InvoicingViewModel vm, VoidCallback onSuccess) {
    vm.onSendLinkViaEmail(
      order.id,
      order.businessId,
      completer: snackBarCompleter(
        context,
        'Invoice sent via Email successfully.',
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

  void _onCreateDraftInvoice(InvoicingViewModel vm) {
    if (!_validateSelections(vm)) return;
    final request = _buildInvoiceOrder(vm, isDraft: true);
    vm.onCreateDraftInvoice(request, (order) {
      _showSuccessDialog(order, vm, false);
    });
  }

  void _onCreateInvoice(InvoicingViewModel vm) {
    if (!_validateSelections(vm)) return;
    final request = _buildInvoiceOrder(vm, isDraft: false);
    vm.onCreateInvoice(request, (order) {
      _showSuccessDialog(order, vm, true);
    });
  }

  Order _buildInvoiceOrder(InvoicingViewModel vm, {required bool isDraft}) {
    final now = DateTime.now();
    final businessId = AppVariables.store?.state.businessState.businessId ?? '';
    final user = AppVariables.store?.state.authState.currentUser;
    final selectedProducts = vm.selectedProducts ?? [];

    final orderLineItems = selectedProducts.map((product) {
      final quantity = vm.selectedQuantities[product.id] ?? 1;
      return mapStockProductToOrderLineItem(product, quantity);
    }).toList();

    final total = vm.totalAmount ?? 0;
    final discountAmount = CheckoutDiscountValidator.getDiscountAmount(
      total,
      vm.discount,
    );

    return Order(
      id: '',
      businessId: businessId,
      sellerId: user?.uid ?? '',
      sellerName: user?.displayName ?? '',
      currencyCode: 'ZAR',
      customer: Customer(
        id: vm.customer?.id ?? '',
        firstName: vm.customer?.firstName ?? '',
        lastName: vm.customer?.lastName ?? '',
        email: vm.customer?.email ?? '',
        mobileNumber: vm.customer?.mobileNumber ?? '',
        businessId: AppVariables.store?.state.businessState.businessId ?? '',
        shippingAddress: ShippingAddress(
          line1: vm.customer?.address?.addressLine1 ?? '',
          line2: vm.customer?.address?.addressLine2 ?? '',
          city: vm.customer?.address?.city ?? '',
          province: vm.customer?.address?.state ?? '',
          country: vm.customer?.address?.country ?? '',
          zipCode: vm.customer?.address?.postalCode ?? '',
        ),
      ),
      customerId: vm.customer?.id ?? '',
      customerName: vm.customer?.displayName ?? '',
      customerEmail: vm.customer?.email ?? '',
      customerMobile: vm.customer?.mobileNumber ?? '',
      orderLineItems: orderLineItems,
      discounts: mapCheckoutDiscountToOrderDiscount(vm.discount),
      totalPrice: total,
      subtotalPrice: total,
      orderSubtotal: total,
      orderTotal: total,
      totalAmountOutstanding: total,
      totalAmountPaid: 0,
      totalDiscount: discountAmount,
      note: notesController.text,
      invoiceDueDate: vm.dueDate,
      dateCreated: now,
      dateUpdated: now,
      createdBy: user?.uid ?? '',
      updatedBy: user?.uid ?? '',
      type: OrderType.invoice,
      orderStatus: isDraft ? OrderStatus.draft : OrderStatus.open,
      orderSource: OrderSource.instore,
      capturedChannel: CapturedChannel.android,
      fulfillmentStatus: FulfillmentStatus.received,
      fulfilmentMethod: FulfilmentMethod.undefined,
      financialStatus: FinancialStatus.pending,
      orderVersion: 'OrderV2',
      estimateDeliverydate: now,
    );
  }

  OrderLineItem mapStockProductToOrderLineItem(
    StockProduct product,
    int quantity,
  ) {
    final subtotal = (product.regularSellingPrice ?? 0) * quantity;

    return OrderLineItem(
      id: const Uuid().v4(),
      displayName: product.displayName ?? '',
      unitPrice: product.regularSellingPrice ?? 0,
      unitCost: product.regularCostPrice ?? 0,
      subtotalPrice: subtotal,
      totalPrice: subtotal,
      quantity: quantity.toDouble(),
      taxable: product.taxId?.isNotEmpty ?? false,
      taxInfo: const TaxInfo(),
      sku: product.sku ?? '',
      variantId: product.regularVariance?.id ?? '',
      imageUrl: product.imageUri ?? '',
      businessId: product.businessId ?? '',
      productId: product.id ?? '',
      isCombo: false,
      isStockTrackable: product.isStockTrackable ?? false,
      discounts: const [],
      comboItems: const [],
    );
  }

  List<OrderDiscount> mapCheckoutDiscountToOrderDiscount(
    CheckoutDiscount? discount,
  ) {
    if (discount == null || discount.value == null || discount.value == 0.0) {
      return [];
    }

    return [
      OrderDiscount.cart(
        discount.value!,
        discount.type == checkout.DiscountType.percentage
            ? DiscountValueType.percentage
            : DiscountValueType.fixedAmount,
      ),
    ];
  }

  bool _validateSelections(InvoicingViewModel vm) {
    final hasCustomer = vm.customer != null;
    final hasProducts = (vm.selectedProducts?.isNotEmpty ?? false);

    if (!hasCustomer || !hasProducts) {
      showMessageDialog(
        context,
        'Please select a customer and at least one product before continuing.',
        LittleFishIcons.info,
      );
      return false;
    }
    return true;
  }
}
