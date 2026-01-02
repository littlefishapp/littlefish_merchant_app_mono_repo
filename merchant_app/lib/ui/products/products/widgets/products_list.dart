// removed ignore: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/shared/sort/list_sort.dart';
import 'package:littlefish_merchant/ui/products/products/widgets/filtered_product_list_view.dart';
import 'package:littlefish_merchant/ui/products/products/widgets/product_list_view.dart';
import 'package:littlefish_merchant/ui/products/products/widgets/products_list_empty_list.dart';
import 'package:littlefish_merchant/ui/products/products/widgets/products_list_top_bar.dart';
import 'package:quiver/strings.dart';
import 'package:redux/redux.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/product/product_actions.dart';
import 'package:littlefish_merchant/ui/products/products/view_models/product_collection_vm.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/auto_complete_text_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/ui/checkout/viewmodels/checkout_viewmodels.dart';

class ProductsList extends StatefulWidget {
  final Function(StockProduct item) onTap;
  final Function(StockProduct item)? onRemove;
  final Function(StockProduct item)? onLongPress;
  final Function(SortOrder, SortBy)? onUpdateSort;
  final bool canAddNew;
  final CheckoutVM? checkoutVM;
  final String? categoryId;
  final Key? newItemKey;
  final ProductViewMode viewMode;
  final bool showTopBar;
  final BuildContext? parentContext;
  final bool getOfflineProducts;
  final bool showCurrentQuantity;
  final bool isStockListing;
  final bool isOnlyTrackableStock;
  final bool? showQuickPaymentButton;
  final bool isMultiSelect;
  final List<StockProduct>? selectedProducts;
  final SortOrder? sortOrder;
  final SortBy? sortBy;

  /// optional searchController can be passed in when using a search bar
  /// outside of this class but you wish to search through products.
  /// Passing in a search controller will edit the text of the the local
  /// search controller, effectively using the parent search controller to
  /// hijack the local searchcontroller.
  final TextEditingController? searchController;

  const ProductsList({
    Key? key,
    required this.onTap,
    this.onRemove,
    this.canAddNew = true,
    this.isStockListing = false,
    this.categoryId,
    this.newItemKey,
    this.checkoutVM,
    this.viewMode = ProductViewMode.productsView,
    this.onLongPress,
    this.showTopBar = true,
    this.showCurrentQuantity = true,
    this.parentContext,
    this.getOfflineProducts = false,
    this.searchController,
    this.showQuickPaymentButton = false,
    this.isMultiSelect = false,
    this.isOnlyTrackableStock = false,
    this.selectedProducts,
    this.sortOrder,
    this.sortBy,
    this.onUpdateSort,
  }) : super(key: key);

  @override
  State<ProductsList> createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  late List<StockProduct> _filteredList;
  late List<StockProduct> _sortedList;
  late SortOrder _sortOrder;
  late String _sortSelection;
  SortBy? _selectedSortType;

  GlobalKey<AutoCompleteTextFieldState<StockProduct>>? filterkey;
  late TextEditingController searchController;
  GlobalKey? newItemKey;
  @override
  void initState() {
    _filteredList = [];
    _sortedList = [];
    _sortOrder = SortOrder.ascending;
    _sortSelection = '';
    filterkey = GlobalKey<AutoCompleteTextFieldState<StockProduct>>();
    searchController = widget.searchController ?? TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    newItemKey = widget.newItemKey as GlobalKey<State<StatefulWidget>>?;
    return StoreConnector<AppState, ProductsViewModel>(
      converter: (Store store) => ProductsViewModel.fromStore(
        store as Store<AppState>,
        categoryId: widget.categoryId,
      ),
      builder: (BuildContext context, vm) {
        updateFilteredList(vm);
        sortList(vm);
        if (widget.viewMode == ProductViewMode.checkoutView) {
          return vm.checkoutProducts!.isNotEmpty
              ? hasProductsLayout(context, vm)
              : ProductsListEmptyList(
                  context: context,
                  vm: vm,
                  addProductsOnTap: (_) => captureProduct(context, vm),
                );
        }
        return hasProductsLayout(context, vm);
      },
    );
  }

  Widget hasProductsLayout(context, vm) {
    return Column(
      children: <Widget>[
        if (widget.showTopBar)
          ProductsListTopBar(
            context: context,
            vm: vm,
            searchController: searchController,
            filteredList: _filteredList,
            sortSelection: _sortSelection,
            sortOrder: widget.sortOrder ?? _sortOrder,
            canAddNew: widget.canAddNew,
            onChanged: (searchController) {
              updateFilteredList(vm);
              if (mounted) setState(() {});
            },
            onClear: () {
              updateFilteredList(vm);
              if (mounted) setState(() {});
            },
            onUpdateSort: (order, type) {
              widget.onUpdateSort!(order, type);
            },
          ),
        Expanded(
          flex: 20,
          child: vm.isLoading
              ? const AppProgressIndicator()
              : searchController.text == ''
              ? ProductListView(
                  context: context,
                  vm: vm,
                  canAddNew: widget.canAddNew,
                  filteredList: _filteredList,
                  isMultiSelect: widget.isMultiSelect,
                  isStockListing: widget.isStockListing,
                  sortedList: _sortedList,
                  viewMode: widget.viewMode,
                  onLongPress: widget.onLongPress,
                  onRemove: widget.onRemove,
                  onTap: (item) => widget.onTap(item),
                  parentContext: widget.parentContext,
                  selectedProducts: widget.selectedProducts,
                )
              : FilteredProductListView(
                  context: context,
                  vm: vm,
                  canAddNew: widget.canAddNew,
                  filteredList: _filteredList,
                  isMultiSelect: widget.isMultiSelect,
                  viewMode: widget.viewMode,
                  onLongPress: widget.onLongPress,
                  onRemove: widget.onRemove,
                  onTap: widget.onTap,
                  parentContext: widget.parentContext,
                  selectedProducts: widget.selectedProducts,
                ),
        ),
      ],
    );
  }

  void sortList(ProductsViewModel vm) {
    _sortedList = ListSort().getSortedItems(
      items:
          ((widget.viewMode == ProductViewMode.checkoutView
                      ? vm.checkoutProducts
                      : vm.items) ??
                  [])
              .toList(),
      type: widget.sortBy ?? _selectedSortType,
      filteredItems: _filteredList.toList(),
      searchText: searchController.text,
      order: widget.sortOrder ?? _sortOrder,
      isOnlyTrackableStock: widget.isOnlyTrackableStock,
      isOnlyOfflineProducts: widget.getOfflineProducts,
    );
    if (isNotEmpty(searchController.text)) {
      _filteredList = _sortedList.toList();
    }
  }

  void updateFilteredList(ProductsViewModel vm) {
    if (isNotBlank(searchController.text) && (vm.items!.isNotEmpty)) {
      if (widget.viewMode == ProductViewMode.checkoutView) {
        _filteredList = vm.checkoutProducts!
            .where(
              (element) => element.displayName!.toLowerCase().contains(
                searchController.text.toLowerCase(),
              ),
            )
            .toList();
      } else {
        _filteredList = vm.items!
            .where(
              (element) => element.displayName!.toLowerCase().contains(
                searchController.text.toLowerCase(),
              ),
            )
            .toList();
      }
    } else {
      _sortedList =
          (widget.viewMode == ProductViewMode.checkoutView
              ? vm.checkoutProducts
              : vm.items) ??
          [];
      _filteredList = [];
    }
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

enum ProductViewMode { productsView, stockView, checkoutView, cartView }
