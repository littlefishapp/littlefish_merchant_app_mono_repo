import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/features/invoicing/presentation/redux/viewmodels/invoicing_view_model.dart';
import 'package:littlefish_merchant/tools/extensions/extensions.dart';
import '../../../../../app/app.dart';
import '../../../../../redux/app/app_state.dart';
import '../../../../../tools/textformatter.dart';
import '../../../../../ui/checkout/helpers/discount_helper.dart';
import '../../redux/actions/invoicing_actions.dart';
import '../../widgets/invoice_label_row.dart';
import '../../widgets/invoice_products_tile.dart';

class InvoicePreviewTab extends StatefulWidget {
  final String storeName;
  final String invoiceNumber;
  final DateTime issueDate;
  final String subtotal;
  final String tax;

  const InvoicePreviewTab({
    super.key,
    required this.storeName,
    required this.invoiceNumber,
    required this.issueDate,
    required this.subtotal,
    required this.tax,
  });

  @override
  State<InvoicePreviewTab> createState() => _InvoicePreviewTabState();
}

class _InvoicePreviewTabState extends State<InvoicePreviewTab> {
  Map<String, int> _quantities = {};

  void _recalculateTotalAmount(InvoicingViewModel vm) {
    final total = vm.selectedProducts?.fold<double>(0, (sum, product) {
      final id = product.id;
      if (id == null) return sum;
      final qty = _quantities[id] ?? 1;
      return sum + ((product.regularSellingPrice ?? 0) * qty);
    });
    AppVariables.store?.dispatch(SetInvoiceTotalAmountAction(total!));
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, InvoicingViewModel>(
      onInit: (store) {
        final vm = InvoicingViewModel.fromStore(store);
        _quantities = Map<String, int>.from(vm.selectedQuantities ?? {});
        _recalculateTotalAmount(vm);
      },
      distinct: true,
      converter: (store) => InvoicingViewModel.fromStore(store),
      builder: (context, vm) {
        final selectedProducts = vm.selectedProducts;
        final dueDate = vm.dueDate;
        double discountAmount = CheckoutDiscountValidator.getDiscountAmount(
          vm.totalAmount!,
          vm.discount,
        );

        return Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  context.labelSmall(widget.storeName, isBold: true),
                  context.headingMedium(
                    TextFormatter.toStringCurrency(
                      vm.totalAmount?.truncateToDecimalPlaces(2),
                    ),
                    isBold: false,
                  ),
                  if (vm.customer != null) ...[
                    context.labelSmall(
                      vm.customer?.displayName ?? '',
                      isBold: false,
                    ),
                  ],
                  if (dueDate != null) ...[
                    Center(
                      child: Text(
                        'Due On: ${DateFormat('yyyy-MM-dd').format(dueDate)}',
                      ),
                    ),
                  ],
                ],
              ),
              if (vm.customer != null) ...[
                _section(
                  context,
                  title: 'Bill To',
                  children: [
                    if (vm.customer?.displayName != null)
                      context.labelSmall(
                        vm.customer?.displayName ?? '',
                        isBold: false,
                      ),
                    if (vm.customer?.address?.addressLine1 != null) ...[
                      context.labelSmall(
                        '${vm.customer?.address?.addressLine1} ${vm.customer?.address?.addressLine2}, ${vm.customer?.address?.city}, ${vm.customer?.address?.state}',
                        isBold: false,
                      ),
                      context.labelSmall(
                        vm.customer?.address?.country ?? '',
                        isBold: false,
                      ),
                    ],
                    if (vm.customer?.email?.trim().isNotEmpty == true) ...[
                      context.labelSmall(vm.customer!.email!, isBold: false),
                    ],
                    if (vm.customer?.internationalNumber != null)
                      context.labelSmall(
                        '${vm.customer?.internationalNumber}' ?? '',
                        isBold: false,
                      ),
                    if (AppVariables
                                .store
                                ?.state
                                .businessState
                                .profile
                                ?.taxNumber !=
                            null &&
                        AppVariables
                                .store
                                ?.state
                                .businessState
                                .profile!
                                .taxNumber!
                                .isNotEmpty ==
                            true)
                      context.labelSmall(
                        AppVariables
                                .store
                                ?.state
                                .businessState
                                .profile!
                                .taxNumber ??
                            '',
                        isBold: false,
                      ),
                    if (widget.storeName.isNotEmpty)
                      context.labelSmall(widget.storeName, isBold: false),
                  ],
                ),
              ],
              if (selectedProducts != null) ...[
                _section(
                  context,
                  title: 'Products',
                  spacing: 0,
                  children: [
                    ...selectedProducts.map((product) {
                      final quantity = vm.selectedQuantities[product.id] ?? 1;
                      return InvoiceProductsTile(
                        context: context,
                        item: product,
                        quantity: quantity,
                        onTap: (_) {},
                        onLongPress: (_) {},
                      );
                    }),
                  ],
                ),
              ],
              _section(
                context,
                title: 'Summary',
                children: [
                  InvoiceLabelRow(label: 'Subtotal', value: widget.subtotal),
                  InvoiceLabelRow(
                    label: 'Discount (${vm.discount?.value ?? 0}%)',
                    value:
                        '-${TextFormatter.toStringCurrency(discountAmount.truncateToDecimalPlaces(2))}',
                  ),
                  InvoiceLabelRow(
                    label: 'Invoice Total',
                    value: TextFormatter.toStringCurrency(
                      (vm.totalAmount! - discountAmount)
                          .truncateToDecimalPlaces(2),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _section(
    BuildContext context, {
    required String title,
    required List<Widget> children,
    double spacing = 8,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [context.labelSmall(title, isBold: true)],
        ),
        SizedBox(height: spacing),
        ...children,
        SizedBox(height: spacing),
      ],
    );
  }
}
