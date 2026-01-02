import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/features/invoicing/presentation/pages/invoice_landing_page.dart';
import 'package:littlefish_merchant/features/invoicing/presentation/pages/tabs/invoice_preview_draft_tab.dart';
import 'package:littlefish_merchant/features/invoicing/presentation/redux/viewmodels/invoicing_view_model.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import '../../../../app/custom_route.dart';
import '../../../../models/sales/checkout/checkout_discount.dart';
import '../../../../models/stock/stock_product.dart';
import '../../../../redux/checkout/checkout_actions.dart';
import '../../../order_common/data/model/order_discount.dart';
import '../redux/actions/invoicing_actions.dart';
import 'package:littlefish_merchant/models/customers/customer.dart'
    as app_models;

import '../widgets/invoice_pdf_viewer_page.dart';

class InvoiceViewPage extends StatefulWidget {
  static const String route = 'invoice-view-page';
  final List<StockProduct> initialSelectedProducts;
  final Order order;

  const InvoiceViewPage({
    super.key,
    this.initialSelectedProducts = const [],
    required this.order,
  });

  @override
  State<InvoiceViewPage> createState() => _InvoiceViewPageState();
}

class _InvoiceViewPageState extends State<InvoiceViewPage>
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final store = StoreProvider.of<AppState>(context, listen: false);
      final order = widget.order;

      store.dispatch(SetInvoiceNotesAction(order.note ?? ''));
      store.dispatch(SetInvoiceDueDateAction(order.invoiceDueDate));
      store.dispatch(SetInvoiceTotalAmountAction(order.subtotalPrice));

      store.dispatch(
        CheckoutSetCustomerAction(
          app_models.Customer.fromOrderCustomer(order.customer),
        ),
      );

      final selectedProducts = order.orderLineItems
          .map((item) => StockProduct.fromOrderCartItem(item))
          .toList();

      final selectedQuantities = {
        for (var item in order.orderLineItems)
          item.productId: item.quantity.toInt() ?? 1,
      };

      store.dispatch(SetInvoiceSelectedProductsAction(selectedProducts));
      store.dispatch(SetSelectedQuantitiesAction(selectedQuantities));

      final discount = mapOrderDiscountToCheckoutDiscount(order.discounts);
      if (discount != null) {
        store.dispatch(SetInvoiceDiscountAction(discount));
      }
    });
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
          title: 'Preview Invoice',
          body: Stack(
            children: [
              InvoicePreviewDraftTab(
                invoice: widget.order,
                storeName:
                    AppVariables.store?.state.businessState.profile?.name ?? '',
                invoiceNumber: '#',
                issueDate: DateTime.now(),
                tax: 'R0.00',
              ),
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
            ButtonPrimary(
              text: 'Download Pdf',
              onTap: (_) {
                vm.downloadPdf(
                  orderId: widget.order.id,
                  businessId: widget.order.businessId,
                  onSuccess: (file) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PdfViewerPage(file: file),
                      ),
                    );
                  },
                  onError: (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: ${e.toString()}')),
                    );
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }

  CheckoutDiscount? mapOrderDiscountToCheckoutDiscount(
    List<OrderDiscount> discounts,
  ) {
    if (discounts.isEmpty) return null;

    final first = discounts.first;
    return CheckoutDiscount(
      value: first.value,
      type: first.type == DiscountValueType.percentage
          ? DiscountType.percentage
          : DiscountType.fixedAmount,
    );
  }
}
