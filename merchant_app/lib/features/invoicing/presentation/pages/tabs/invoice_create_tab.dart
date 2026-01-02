import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_secondary.dart';
import 'package:littlefish_merchant/common/presentaion/components/custom_keypad.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/string_form_field.dart';
import 'package:littlefish_merchant/features/invoicing/presentation/redux/viewmodels/invoicing_view_model.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/models/stock/stock_variance.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/customers/widgets/customer_select_tile.dart';
import 'package:uuid/uuid.dart';
import '../../../../../app/app.dart';
import '../../../../../app/custom_route.dart';
import '../../../../../app/theme/applied_system/applied_surface.dart';
import '../../../../../common/presentaion/components/list_leading_tile.dart';
import '../../../../../models/enums.dart';
import '../../../../../tools/helpers.dart';
import '../../../../../tools/textformatter.dart';
import '../../../../../ui/business/expenses/widgets/selectable_quantity_tile_new.dart';
import '../../../../../ui/checkout/helpers/discount_helper.dart';
import '../../redux/actions/invoicing_actions.dart';
import '../invoice_discount_page.dart';
import '../products_selector_page.dart';

class InvoiceCreateTab extends StatefulWidget {
  final TextEditingController amountDueController;
  final TextEditingController dueDateController;
  final TextEditingController notesController;
  final TextEditingController discountController;
  final void Function(List<StockProduct>) onProductsSelected;

  const InvoiceCreateTab({
    super.key,
    required this.amountDueController,
    required this.dueDateController,
    required this.notesController,
    required this.discountController,
    required this.onProductsSelected,
  });

  @override
  State<InvoiceCreateTab> createState() => _InvoiceCreateTabState();
}

class _InvoiceCreateTabState extends State<InvoiceCreateTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Map<String, int> _quantities = {};
  late double discountAmount;
  DateTime get _today => DateUtils.dateOnly(DateTime.now());

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, InvoicingViewModel>(
      distinct: true,
      converter: (store) => InvoicingViewModel.fromStore(store),
      onInit: (store) {
        final vm = InvoicingViewModel.fromStore(store);
        _quantities = Map<String, int>.from(vm.selectedQuantities ?? {});
        _recalculateTotalAmount(vm);
      },
      builder: (context, vm) {
        final selectedProducts = vm.selectedProducts;
        final dueDate = vm.dueDate;
        final discount = vm.discount;
        final notes = vm.notes;
        if (dueDate != null) {
          widget.dueDateController.text = DateFormat(
            'yyyy-MM-dd',
          ).format(dueDate);
        }
        if (discount != null && discount.value != null) {
          widget.discountController.text = discount.value!.toStringAsFixed(2);
        }

        discountAmount = CheckoutDiscountValidator.getDiscountAmount(
          vm.totalAmount!,
          vm.discount,
        );
        widget.notesController.text = notes ?? '';

        return Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SelectCustomerTile(
                      customer: vm.customer,
                      onSetCustomer: (ctx, customer) =>
                          vm.setCustomer(customer),
                      onClearCustomer: () => vm.setCustomer(null),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => _pickDateTime(context, vm),
                      child: StringFormField(
                        enabled: false,
                        onSaveValue: (e) {},
                        controller: widget.dueDateController,
                        labelText: 'Due Date',
                        isRequired: false,
                        hintText: 'Please select the due date',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        useOutlineStyling: true,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ButtonPrimary(
                      text: 'Add Products',
                      onTap: (_) async {
                        final selected =
                            await Navigator.push<List<StockProduct>>(
                              context,
                              MaterialPageRoute(
                                builder: (ctx) => ProductSelectorPage(
                                  initiallySelected: selectedProducts ?? [],
                                ),
                              ),
                            );

                        if (selected != null) {
                          vm.setSelectedProducts(selected);
                          widget.onProductsSelected(selected);
                          _recalculateTotalAmount(vm);
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    ButtonSecondary(
                      text: 'Add Quick Item',
                      onTap: (_) {
                        addQuickItem(vm: vm).then((product) {
                          if (product != null) {
                            final updated = [...?selectedProducts, product];
                            vm.setSelectedProducts(updated);
                            widget.onProductsSelected(updated);

                            if (product.id != null) {
                              _quantities[product.id!] = 1;
                              vm.setSelectedQuantities(_quantities);
                            }

                            _recalculateTotalAmount(vm);
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: context.labelSmall(
                            'Selected Products',
                            isBold: true,
                          ),
                        ),
                        context.labelSmall(
                          TextFormatter.toStringCurrency(
                            _getTotalAmount(vm),
                            currencyCode: '',
                          ),
                          isBold: true,
                        ),
                      ],
                    ),
                    if (selectedProducts!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Column(
                        children: selectedProducts.map((product) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: SelectableQuantityTile(
                              initialQuantity: (_quantities[product.id] ?? 1)
                                  .toDouble(),
                              onTap: (newQuantity) {
                                final id = product.id;
                                if (id == null) return;
                                setState(() {
                                  if (newQuantity == 0) {
                                    _quantities.remove(id);
                                    final updated = [...?vm.selectedProducts]
                                      ..removeWhere((p) => p.id == id);
                                    vm.setSelectedProducts(updated);
                                    widget.onProductsSelected(updated);
                                  } else {
                                    _quantities[id] = newQuantity.toInt();
                                  }

                                  vm.setSelectedQuantities(_quantities);
                                });
                                _recalculateTotalAmount(vm);
                              },
                              onFieldSubmitted: (newQuantity) {
                                final id = product.id;
                                if (id == null) return;
                                setState(() {
                                  if (newQuantity == 0) {
                                    _quantities.remove(id);
                                    final updated = [...?vm.selectedProducts]
                                      ..removeWhere((p) => p.id == id);
                                    vm.setSelectedProducts(updated);
                                    widget.onProductsSelected(updated);
                                  } else {
                                    _quantities[id] = newQuantity.toInt();
                                  }

                                  vm.setSelectedQuantities(_quantities);
                                });
                                _recalculateTotalAmount(vm);
                              },
                              leading:
                                  product.imageUri != null &&
                                      product.imageUri!.isNotEmpty
                                  ? ListLeadingImageTile(url: product.imageUri!)
                                  : Container(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .extension<AppliedSurface>()
                                            ?.brandSubTitle,
                                        border: Border.all(
                                          color: Colors.transparent,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          AppVariables.appDefaultButtonRadius,
                                        ),
                                      ),
                                      child: Center(
                                        child: context.labelLarge(
                                          product.displayName
                                                  ?.substring(0, 2)
                                                  .toUpperCase() ??
                                              '',
                                          isSemiBold: true,
                                        ),
                                      ),
                                    ),
                              trailing: context.labelSmall(
                                TextFormatter.toStringCurrency(
                                  product.regularSellingPrice ?? 0,
                                  currencyCode: '',
                                ),
                                alignRight: true,
                                alignLeft: false,
                                overflow: TextOverflow.ellipsis,
                              ),
                              title: context.labelSmall(
                                product.displayName ?? '',
                                alignLeft: true,
                                isBold: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                              minValue: 0,
                              enableHighlighting: false,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                    const SizedBox(height: 8),
                    ButtonSecondary(
                      text: isNotZeroOrNull(vm.discount?.value)
                          ? 'Edit Discount'
                          : 'Add Discount',
                      onTap: (_) async {
                        _recalculateTotalAmount(vm);
                        await Navigator.of(context).push(
                          CustomRoute(
                            builder: (context) => const InvoiceDiscountPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: context.labelSmall('Discount', isBold: true),
                        ),
                        context.labelSmall(
                          TextFormatter.toStringCurrency(_getDiscount(vm)),
                          isBold: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    StringFormField(
                      key: const Key('notes'),
                      controller: widget.notesController,
                      hintText: 'Enter Note',
                      labelText: 'Notes',
                      isRequired: false,
                      minLines: 4,
                      maxLines: 6,
                      maxLength: 500,
                      minLength: 1,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      useOutlineStyling: true,
                      onSaveValue: (String? value) {
                        widget.notesController.text = value ?? '';
                        vm.setNotes(value ?? '');
                      },
                      onFieldSubmitted: (String? value) {
                        widget.notesController.text = value ?? '';
                        vm.setNotes(value ?? '');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickDateTime(
    BuildContext context,
    InvoicingViewModel vm,
  ) async {
    final theme = Theme.of(context);

    final today = _today;
    final existing = vm.dueDate != null
        ? DateUtils.dateOnly(vm.dueDate!)
        : null;
    final initial = (existing != null && !existing.isBefore(today))
        ? existing
        : today;

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: today,
      lastDate: DateTime(2100),
      selectableDayPredicate: (d) => !d.isBefore(today),
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(
            dialogBackgroundColor: theme.colorScheme.background,
            colorScheme: theme.colorScheme.copyWith(
              surfaceTint: theme.colorScheme.background,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      final dateOnly = DateUtils.dateOnly(pickedDate);
      widget.dueDateController.text = DateFormat('yyyy-MM-dd').format(dateOnly);
      vm.setDueDate(dateOnly);
    }
  }

  Future<StockProduct?> addQuickItem({required InvoicingViewModel vm}) async {
    return showModalBottomSheet<StockProduct>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (ctx) => SafeArea(
        child: SizedBox(
          height: 480,
          child: CustomKeyPad(
            isLoading: vm.isLoading,
            enableAppBar: false,
            title: 'Quick Item',
            enableDescription: true,
            confirmErrorMessage: 'Please enter the amount for the quick item.',
            confirmButtonText: 'Add',
            onValueChanged: (_) {},
            onDescriptionChanged: (_) {},
            onSubmit: (amount, description) {
              final now = DateTime.now().toUtc();
              final currencyCode = AppVariables
                  .store
                  ?.state
                  .localeState
                  .currentLocale
                  ?.currencyCode;

              final product = StockProduct(
                id: const Uuid().v4(),
                name: cleanString(description ?? 'Quick Item'),
                displayName: description?.trim().isNotEmpty == true
                    ? description!.trim()
                    : 'Quick Item',
                currencyCode: currencyCode,
                productType: ProductType.service,
                isOnline: false,
                isInStore: true,
                isStockTrackable: false,
                createdBy: AppVariables.store?.state.currentUser?.email,
                dateCreated: now,
                variances: [
                  StockVariance(
                    name: 'QuickItem',
                    type: StockVarianceType.regular,
                    id: const Uuid().v4(),
                    costPrice: 0,
                    sellingPrice: amount,
                    quantity: 1,
                  ),
                ],
              );

              Navigator.of(ctx).pop(product);
            },
            initialValue: 0,
            parentContext: ctx,
          ),
        ),
      ),
    );
  }

  void _recalculateTotalAmount(InvoicingViewModel vm) {
    final total = vm.selectedProducts?.fold<double>(0, (sum, product) {
      final id = product.id;
      if (id == null) return sum;
      final qty = _quantities[id] ?? 1;
      return sum + ((product.regularSellingPrice ?? 0) * qty);
    });
    AppVariables.store?.dispatch(SetInvoiceTotalAmountAction(total!));
  }

  double _getTotalAmount(InvoicingViewModel vm) {
    double total = 0;
    final products = vm.selectedProducts ?? [];

    for (final p in products) {
      final id = p.id;
      if (id == null) continue;
      final qty = _quantities[id] ?? 1;
      total += (p.regularSellingPrice ?? 0) * qty;
    }

    widget.amountDueController.text = total.toStringAsFixed(2);
    return total;
  }

  double _getDiscount(InvoicingViewModel vm) {
    discountAmount = CheckoutDiscountValidator.getDiscountAmount(
      _getTotalAmount(vm),
      vm.discount,
    );
    return discountAmount;
  }

  Widget discountTextAndAmount(BuildContext context, InvoicingViewModel vm) {
    return _buildSummaryRow(
      title: vm.discount?.type == DiscountType.percentage
          ? 'Discount (${vm.discount?.value} %)'
          : 'Discount',
      value: vm.discount?.type == DiscountType.percentage
          ? '${widget.discountController.text} %'
          : 'R${widget.discountController.text}',
      padding: const EdgeInsets.symmetric(vertical: 4),
      margin: const EdgeInsets.only(bottom: 12),
      context: context,
      usePrimaryColor: true,
    );
  }

  Widget _buildSummaryRow({
    required String title,
    required String value,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    required BuildContext context,
    bool usePrimaryColor = false,
  }) {
    final textTheme = Theme.of(context).extension<AppliedTextIcon>();
    return Container(
      margin: margin,
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          context.labelSmall(title, isBold: true),
          if (usePrimaryColor)
            context.labelSmall(value, color: textTheme?.brand, isBold: true)
          else
            context.labelSmall(
              value,
              color: textTheme?.secondary,
              isBold: true,
            ),
        ],
      ),
    );
  }
}
