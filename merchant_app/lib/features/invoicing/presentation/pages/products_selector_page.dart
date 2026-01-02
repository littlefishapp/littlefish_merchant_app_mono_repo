import 'package:flutter/material.dart';
import '../widgets/invoice_products_tile.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/widgets/selectable_listview.dart';
import 'package:littlefish_merchant/features/invoicing/presentation/redux/viewmodels/invoicing_view_model.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/footer_buttons_secondary_primary.dart';
import 'package:littlefish_merchant/features/invoicing/presentation/widgets/select_product_variant_for_invoice.dart';

class ProductSelectorPage extends StatefulWidget {
  final List<StockProduct> initiallySelected;

  const ProductSelectorPage({super.key, this.initiallySelected = const []});

  @override
  State<ProductSelectorPage> createState() => _ProductSelectorPageState();
}

class _ProductSelectorPageState extends State<ProductSelectorPage> {
  late List<StockProduct> products;
  late List<bool> isSelectedList;

  final Map<String, StockProduct> _selectedVariantByParentId = {};
  final Map<String, int> _selectedVariantQtyByParentId = {};

  bool _hasOptions(StockProduct p) =>
      (p.productOptionAttributes != null &&
      p.productOptionAttributes!.isNotEmpty);

  @override
  void initState() {
    super.initState();
    products = AppVariables.store?.state.productState.products ?? [];
    final selectedIds = widget.initiallySelected.map((e) => e.id).toSet();
    isSelectedList = products.map((p) => selectedIds.contains(p.id)).toList();
  }

  Future<void> _handleSelectionChanged(bool isSelected, int index) async {
    final product = products[index];

    if (isSelected && _hasOptions(product)) {
      await _openVariantPicker(product, index);
      return;
    }

    setState(() {
      final newList = List<bool>.from(isSelectedList);
      newList[index] = isSelected;
      isSelectedList = newList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, InvoicingViewModel>(
      converter: (store) =>
          InvoicingViewModel.fromStore(store, context: context),
      builder: (_, vm) {
        return AppScaffold(
          title: 'Select Products',
          body: SelectableListView(
            itemCount: products.length,
            isSelectedList: isSelectedList,
            enableSelectAll: true,
            tilePadding: const EdgeInsets.symmetric(vertical: 6),
            onSelectedChanged: (isSelected, index) async {
              await _handleSelectionChanged(isSelected, index);
            },

            itemBuilder: (context, index) {
              final product = products[index];

              return InvoiceProductsTile(
                context: context,
                item: product,
                onTap: (_) async {
                  final next = !(isSelectedList[index]);
                  await _handleSelectionChanged(next, index);
                },
                onLongPress: (_) async {
                  if (_hasOptions(product)) {
                    await _openVariantPicker(product, index);
                  }
                },
              );
            },
          ),
          persistentFooterButtons: [
            FooterButtonsSecondaryPrimary(
              secondaryButtonText: 'Cancel',
              primaryButtonText: 'Confirm',
              onSecondaryButtonPressed: (_) => Navigator.pop(context),
              onPrimaryButtonPressed: (_) {
                final selected = <StockProduct>[];
                final addedQtyById = <String, int>{};

                for (int i = 0; i < isSelectedList.length; i++) {
                  if (!isSelectedList[i]) continue;

                  final base = products[i];
                  final hasOptions = _hasOptions(base);

                  if (hasOptions) {
                    final parentId = base.id;
                    final variant = (parentId != null)
                        ? _selectedVariantByParentId[parentId]
                        : null;

                    if (variant != null) {
                      selected.add(variant);

                      final pickedQty = (parentId != null)
                          ? (_selectedVariantQtyByParentId[parentId] ?? 1)
                          : 1;

                      final variantId = variant.id;
                      if (variantId != null) {
                        addedQtyById[variantId] =
                            (addedQtyById[variantId] ?? 0) + pickedQty;
                      }
                    }
                  } else {
                    selected.add(base);
                  }
                }

                final selectedIds = selected
                    .map((p) => p.id)
                    .whereType<String>()
                    .toSet();
                final quickItems = widget.initiallySelected.where((item) {
                  final inParentList = products.any((p) => p.id == item.id);
                  final alreadySelectedNow =
                      item.id != null && selectedIds.contains(item.id);
                  return !inParentList && !alreadySelectedNow;
                }).toList();

                final merged = [...selected, ...quickItems];
                final uniqueById = <String, StockProduct>{};
                for (final p in merged) {
                  final id = p.id;
                  if (id != null) uniqueById[id] = p;
                }
                final unique = uniqueById.values.toList();

                final existingQty = Map<String, int>.from(
                  vm.selectedQuantities ?? const {},
                );
                addedQtyById.forEach((id, add) {
                  existingQty[id] = (existingQty[id] ?? 0) + add;
                });

                vm.setSelectedProducts(unique);
                vm.setSelectedQuantities(existingQty);

                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _openVariantPicker(StockProduct parent, int index) async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      useSafeArea: true,
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppVariables.appDefaultRadius),
        ),
      ),
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: Theme.of(ctx).scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppVariables.appDefaultRadius),
          ),
        ),
        child: SelectProductVariantForInvoice(parentProduct: parent),
      ),
    );

    if (!mounted) return;

    if (result == null) {
      setState(() {
        final newList = List<bool>.from(isSelectedList);
        newList[index] = false;
        isSelectedList = newList;

        _selectedVariantByParentId.remove(parent.id);
        _selectedVariantQtyByParentId.remove(parent.id);
      });
      return;
    }

    final variant = result['variant'] as StockProduct?;
    final qty = (result['quantity'] as int?) ?? 1;

    if (variant != null) {
      setState(() {
        final newList = List<bool>.from(isSelectedList);
        newList[index] = true;
        isSelectedList = newList;

        _selectedVariantByParentId[parent.id!] = variant;
        _selectedVariantQtyByParentId[parent.id!] = qty;
      });
    } else {
      setState(() {
        final newList = List<bool>.from(isSelectedList);
        newList[index] = false;
        isSelectedList = newList;

        _selectedVariantByParentId.remove(parent.id);
        _selectedVariantQtyByParentId.remove(parent.id);
      });
    }
  }
}
