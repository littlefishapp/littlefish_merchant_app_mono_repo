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
import '../../../../order_common/data/model/order.dart';
import '../../widgets/invoice_label_row.dart';
import '../../widgets/invoice_products_tile.dart';

class InvoicePreviewDraftTab extends StatelessWidget {
  final Order invoice;
  final String storeName;
  final String invoiceNumber;
  final DateTime issueDate;
  final String tax;

  const InvoicePreviewDraftTab({
    super.key,
    required this.storeName,
    required this.invoiceNumber,
    required this.issueDate,
    required this.tax,
    required this.invoice,
  });

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, InvoicingViewModel>(
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
                  context.labelSmall(storeName, isBold: true),
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
              _section(
                context,
                title: 'Bill From',
                children: [
                  context.labelSmall(
                    AppVariables.store?.state.businessState.profile?.name ?? '',
                    isBold: false,
                  ),
                  context.labelSmall(
                    '${AppVariables.store?.state.businessState.profile?.address?.address1} '
                    '${AppVariables.store?.state.businessState.profile?.address?.address2} '
                    '${AppVariables.store?.state.businessState.profile?.address?.city} '
                    '${AppVariables.store?.state.businessState.profile?.address?.state}',
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
                      'VAT No. ${AppVariables.store?.state.businessState.profile!.taxNumber}',
                      isBold: false,
                    ),
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
                    if (vm.customer?.address?.addressLine1?.trim().isNotEmpty ==
                        true) ...[
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
                  InvoiceLabelRow(
                    label: 'Subtotal',
                    value: TextFormatter.toStringCurrency(
                      vm.totalAmount?.truncateToDecimalPlaces(2),
                    ),
                  ),
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
