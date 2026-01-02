import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/models/enums.dart';

import '../../../../app/theme/applied_system/applied_text_icon.dart';
import '../../../../common/presentaion/components/form_fields/search_text_field.dart';
import '../../../../models/stock/stock_product.dart';
import '../../../../redux/product/product_actions.dart';
import '../../../../shared/sort/list_sort.dart';
import '../view_models/product_collection_vm.dart';
import 'products_menu_item.dart';
import 'products_menu_items.dart';

class ProductsListTopBar extends StatefulWidget {
  const ProductsListTopBar({
    super.key,
    required this.context,
    this.onAdd,
    required this.vm,
    required this.searchController,
    required this.filteredList,
    required this.sortSelection,
    required this.sortOrder,
    required this.onClear,
    this.selectedSortType,
    required this.canAddNew,
    required this.onChanged,
    this.onUpdateSort,
  });

  final BuildContext context;
  final Function? onAdd;
  final ProductsViewModel vm;
  final TextEditingController searchController;
  final List<StockProduct> filteredList;
  final String sortSelection;
  final SortOrder sortOrder;
  final SortBy? selectedSortType;
  final bool canAddNew;
  final void Function() onClear;
  final void Function(String) onChanged;
  final void Function(SortOrder, SortBy)? onUpdateSort;

  @override
  State<ProductsListTopBar> createState() => _ProductsListTopBarState();
}

class _ProductsListTopBarState extends State<ProductsListTopBar> {
  late SortOrder sortOrder;
  late SortBy? selectedSortType;
  late String sortSelection;

  @override
  void initState() {
    super.initState();
    sortOrder = widget.sortOrder;
    selectedSortType = widget.selectedSortType;
    sortSelection = '';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            Row(
              children: [
                Flexible(
                  flex: 10,
                  child: SearchTextField(
                    controller: widget.searchController,
                    useOutlineStyling: false,
                    onChanged: widget.onChanged,
                    onClear: widget.onClear,
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      customButton: Icon(
                        Icons.sort_outlined,
                        color: Theme.of(
                          context,
                        ).extension<AppliedTextIcon>()?.primary,
                      ),
                      items: [
                        ...ProductsMenuItems.firstItems.map(
                          (item) => DropdownMenuItem<MenuItem>(
                            value: item,
                            child: ProductsMenuItems.buildItem(
                              item,
                              sortSelection,
                              widget.sortOrder,
                              context,
                            ),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        // TODO(brandon):  Make dynamic menu items
                        SortBy? oldSelectedSortType = selectedSortType;
                        switch (value) {
                          case ProductsMenuItems.name:
                            selectedSortType = SortBy.name;
                            sortSelection = 'Product Name';
                            break;
                          case ProductsMenuItems.price:
                            selectedSortType = SortBy.price;
                            sortSelection = 'Price';
                            break;
                          case ProductsMenuItems.createdDate:
                            selectedSortType = SortBy.createdDate;
                            sortSelection = 'Created Date';
                            break;
                        }
                        sortOrder = ListSort().updateSortOrder(
                          order: widget.sortOrder,
                          type: oldSelectedSortType,
                          newType: selectedSortType!,
                        );
                        widget.onUpdateSort!(sortOrder, selectedSortType!);
                        if (mounted) setState(() {});
                      },
                      dropdownStyleData: DropdownStyleData(
                        width: MediaQuery.of(context).size.width / 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> captureProduct(
    BuildContext context,
    ProductsViewModel vm, {
    StockProduct? product,
  }) async {
    //this is an existing product that should be edited
    if (product != null) {
      vm.store!.dispatch(ProductSelectAction(product));
      if (!(vm.store!.state.isLargeDisplay ?? false)) {
        vm.store!.dispatch(editProduct(context, product));
      }
    } else {
      vm.store!.dispatch(createProduct(context));
    }
  }
}
