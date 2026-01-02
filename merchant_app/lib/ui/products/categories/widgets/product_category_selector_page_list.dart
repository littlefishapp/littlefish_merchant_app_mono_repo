// Flutter imports:
import 'dart:io';

import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart' as intl;
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:quiver/strings.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

// Project imports:
import 'package:littlefish_merchant/models/stock/stock_category.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/auto_complete_text_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/common/presentaion/components/list_leading_tile.dart';

import '../../../../app/theme/applied_system/applied_surface.dart';
import '../../../../app/theme/applied_system/applied_text_icon.dart';
import '../../../../common/presentaion/components/form_fields/search_text_field.dart';
import '../../../../common/presentaion/components/icons/delete_icon.dart';
import '../../../../common/presentaion/components/form_fields/yes_no_form_field.dart';
import '../view_models/category_item_vm.dart';

class CategoryProductsList extends StatefulWidget {
  final Function(StockProduct item)? onTap;
  final CategoryViewModel? vm;
  final BuildContext? parentContext;
  final bool getOfflineProducts;
  final bool canAddNew;

  final Function(StockProduct item)? onLongPress;
  final Function(String)? callback;
  final Function(StockProduct item)? setCategory;
  final Function(List<StockProduct>? items)? onProductsSelected;
  final Function(StockProduct? item)? onProductSelect;
  final String? categoryId;
  final Key? newItemKey;
  final StockCategory? category;
  final ProductViewMode viewMode;
  final bool showTopBar;

  const CategoryProductsList({
    Key? key,
    this.onTap,
    this.onProductsSelected,
    this.onProductSelect,
    this.setCategory,
    this.callback,
    this.vm,
    this.parentContext,
    this.getOfflineProducts = false,
    this.canAddNew = true,
    this.categoryId,
    this.newItemKey,
    this.viewMode = ProductViewMode.productsView,
    this.onLongPress,
    this.category,
    this.showTopBar = true,
  }) : super(key: key);

  @override
  State<CategoryProductsList> createState() => _CategoryProductsList();
}

class _CategoryProductsList extends State<CategoryProductsList> {
  late List<StockProduct> _filteredList;
  late List<StockProduct> _sortedList;
  late String _sortOrder;
  late String _sortSelection;
  // late String _numProductsCount;

  MenuItem? _currentSelection;
  SortOrder? _selectedOrder;

  GlobalKey<AutoCompleteTextFieldState<StockCategory>>? filterkey;
  TextEditingController searchController = TextEditingController();
  GlobalKey? newItemKey;

  @override
  void initState() {
    _filteredList = [];
    _sortedList = [];
    _sortOrder = 'Ascending';
    _sortSelection = '';
    filterkey = GlobalKey<AutoCompleteTextFieldState<StockCategory>>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    newItemKey = widget.newItemKey as GlobalKey<State<StatefulWidget>>?;
    return StoreConnector<AppState, CategoryViewModel>(
      converter: (store) => CategoryViewModel.fromStore(store),
      builder: (BuildContext context, CategoryViewModel vm) {
        updateFilteredList(vm);
        sortList(vm);
        return Column(children: [topBar(context, vm), layout(context, vm)]);
      },
    );
  }

  updateFilteredList(CategoryViewModel vm) {
    if (isNotBlank(searchController.text) && (vm.products!.isNotEmpty)) {
      _filteredList = vm.products!
          .where(
            (element) => element.displayName!.toLowerCase().contains(
              searchController.text.toLowerCase(),
            ),
          )
          .toList();
    }
  }

  sortList(CategoryViewModel vm) {
    if (searchController.text == '') {
      _sortedList = vm.products!;
    } else if (searchController.text != '') {
      _sortedList = _filteredList.toList();
    }

    if (_selectedOrder != null) {
      switch (_selectedOrder) {
        case SortOrder.name:
          _sortedList.sort(
            ((a, b) => _sortOrder == 'Descending'
                ? b.displayName!.toLowerCase().compareTo(
                    a.displayName!.toLowerCase(),
                  )
                : a.displayName!.toLowerCase().compareTo(
                    b.displayName!.toLowerCase(),
                  )),
          );
          break;
        case SortOrder.price:
          _sortedList.sort(
            ((a, b) => _sortOrder == 'Descending'
                ? b.regularSellingPrice!.compareTo(a.regularSellingPrice!)
                : a.regularSellingPrice!.compareTo(b.regularSellingPrice!)),
          );
          break;
        case SortOrder.createdDate:
          _sortedList.sort(
            ((a, b) => _sortOrder == 'Descending'
                ? b.dateCreated!.compareTo(a.dateCreated!)
                : a.dateCreated!.compareTo(b.dateCreated!)),
          );
          break;
        default:
      }
    }

    if (widget.getOfflineProducts) {
      _sortedList = _sortedList
          .where((element) => element.isOnline == false)
          .toList();
    }

    if (searchController.text != '') {
      _filteredList = _sortedList.toList();
    }
  }

  dynamic layout(context, vm) => searchController.text == ''
      ? productList(context, vm)
      : filteredProductList(context, vm);

  SizedBox topBar(BuildContext context, CategoryViewModel vm) => SizedBox(
    child: Container(
      padding: const EdgeInsets.only(right: 12),
      alignment: Alignment.center,
      child: Column(
        children: [
          Row(
            children: [
              Flexible(
                flex: 10,
                child: SearchTextField(
                  controller: searchController,
                  useOutlineStyling: false,
                  onChanged: (searchController) {
                    updateFilteredList(vm);
                    if (mounted) setState(() {});
                  },
                  onClear: () => {
                    updateFilteredList(vm),
                    if (mounted) setState(() {}),
                  },
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                flex: 1,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    customButton: Icon(
                      Icons.sort_outlined,
                      color: Theme.of(
                        context,
                      ).extension<AppliedTextIcon>()?.primaryHeader,
                    ),
                    items: [
                      ...MenuItems.firstItems.map(
                        (item) => DropdownMenuItem<MenuItem>(
                          value: item,
                          child: MenuItems.buildItem(
                            item,
                            _sortSelection,
                            _sortOrder,
                            context,
                          ),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      if (_currentSelection == null ||
                          value != _currentSelection) {
                        _sortOrder = 'Ascending';
                      }
                      if (value == _currentSelection &&
                          _sortOrder == 'Ascending') {
                        _sortOrder = 'Descending';
                      } else if (value == _currentSelection &&
                          _sortOrder == 'Descending') {
                        _sortOrder = 'Ascending';
                      }

                      switch (value) {
                        case MenuItems.name:
                          _selectedOrder = SortOrder.name;
                          _sortSelection = 'Product Name';
                          _currentSelection = MenuItems.name;
                          break;
                        case MenuItems.price:
                          _selectedOrder = SortOrder.price;
                          _sortSelection = 'Price';
                          _currentSelection = MenuItems.price;
                          break;
                        case MenuItems.createdDate:
                          _selectedOrder = SortOrder.createdDate;
                          _sortSelection = 'Created Date';
                          _currentSelection = MenuItems.createdDate;
                          break;
                      }

                      if (mounted) setState(() {});
                    },
                    dropdownStyleData: const DropdownStyleData(
                      maxHeight: 150,
                      width: 170,
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

  ListView filteredProductList(BuildContext context, CategoryViewModel vm) =>
      ListView.separated(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: (_filteredList.length),
        itemBuilder: (BuildContext context, int index) {
          StockProduct item = _filteredList[index];
          StockCategory category = vm.item!;
          return ListTile(
            tileColor: Theme.of(context).colorScheme.background,
            key: Key(item.id!),
            leading: isNotBlank(item.imageUri)
                ? ListLeadingImageTile(
                    width: AppVariables.appDefaultlistItemSize,
                    height: AppVariables.appDefaultlistItemSize,
                    url: item.imageUri,
                  )
                : Container(
                    width: AppVariables.appDefaultlistItemSize,
                    height: AppVariables.appDefaultlistItemSize,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).extension<AppliedSurface>()?.brandSubTitle,
                      border: Border.all(color: Colors.transparent, width: 1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: context.labelMedium(
                      item.name?.substring(0, 2).toUpperCase() ?? '',
                      isBold: true,
                    ),
                  ),
            onTap: () {
              showProductEditBottomSheet(context, item, category, vm);
            },
            title: context.labelSmall(
              '${item.displayName ?? item.name}',
              alignLeft: true,
              isBold: true,
            ),
            subtitle: context.labelSmall(
              intl.NumberFormat.currency(
                locale: 'en_ZA', // Use the appropriate locale for your currency
                symbol: 'R',
                decimalDigits: 2,
              ).format(item.regularPrice!),
              alignLeft: true,
              isBold: false,
            ),
            selected: false,
            trailing: Icon(
              Platform.isIOS
                  ? Icons.arrow_forward_ios_outlined
                  : Icons.arrow_forward,
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) =>
            const CommonDivider(height: 0.5),
      );

  ListView productList(BuildContext context, CategoryViewModel vm) =>
      ListView.builder(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: (_sortedList.length),
        itemBuilder: (BuildContext context, int index) {
          StockProduct item = _sortedList[index];
          StockCategory category = vm.item!;
          return ListTile(
            tileColor: Theme.of(context).colorScheme.background,
            key: Key(item.id!),
            leading: isNotBlank(item.imageUri)
                ? ListLeadingImageTile(
                    width: AppVariables.appDefaultlistItemSize,
                    height: AppVariables.appDefaultlistItemSize,
                    url: item.imageUri,
                  )
                : Container(
                    width: AppVariables.appDefaultlistItemSize,
                    height: AppVariables.appDefaultlistItemSize,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).extension<AppliedSurface>()?.brandSubTitle,
                      border: Border.all(color: Colors.transparent, width: 1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: context.labelMedium(
                      item.name?.substring(0, 2).toUpperCase() ?? '',
                      isBold: true,
                    ),
                  ),
            onTap: () {
              showProductEditBottomSheet(context, item, category, vm);
            },
            title: context.labelSmall(
              '${item.displayName ?? item.name}',
              alignLeft: true,
              isBold: true,
            ),
            subtitle: context.labelXSmall(
              intl.NumberFormat.currency(
                locale: 'en_ZA', // Use the appropriate locale for your currency
                symbol: 'R',
                decimalDigits: 2,
              ).format(item.regularPrice!),
              alignLeft: true,
              isBold: false,
            ),
            selected: false,
            trailing: Icon(
              Platform.isIOS
                  ? Icons.arrow_forward_ios_outlined
                  : Icons.arrow_forward,
            ),
          );
        },
      );

  void showProductEditBottomSheet(
    BuildContext context,
    StockProduct item,
    StockCategory category,
    CategoryViewModel vm,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SafeArea(
              top: false,
              bottom: true,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(25.0),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 12,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),
                    ListTile(
                      tileColor: Theme.of(context).colorScheme.background,
                      key: Key(item.id!),
                      leading: isNotBlank(item.imageUri)
                          ? ListLeadingImageTile(
                              width: AppVariables.appDefaultlistItemSize,
                              height: AppVariables.appDefaultlistItemSize,
                              url: item.imageUri,
                            )
                          : _buildPlaceholderImage(context, item.name),
                      title: context.labelSmall(
                        item.displayName ?? item.name ?? '',
                        alignLeft: true,
                        isBold: true,
                      ),
                      subtitle: context.labelXSmall(
                        intl.NumberFormat.currency(
                          locale: 'en_ZA',
                          symbol: 'R',
                          decimalDigits: 2,
                        ).format(item.regularPrice ?? 0),
                        alignLeft: true,
                        isBold: false,
                      ),
                    ),
                    ListTile(
                      tileColor: Theme.of(context).colorScheme.background,
                      trailing: const DeleteIcon(),
                      title: const Text('Remove from category'),
                      onTap: () {
                        Navigator.of(context).pop(item);
                        _handleRemoveFromCategory(item, vm, category);
                      },
                    ),
                    if (AppVariables.store!.state.permissions!.manageOnline ==
                            true &&
                        item.isOnline == true &&
                        AppVariables.store!.state.storeState.storeIsLive)
                      YesNoFormField(
                        labelText: 'Is Category Online',
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        initialValue: category.isOnline ?? false,
                        onSaved: (value) {
                          setState(() {
                            category.isOnline = value;
                          });
                        },
                        description: 'Add category to your online store',
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPlaceholderImage(BuildContext context, String? name) {
    return Container(
      width: AppVariables.appDefaultlistItemSize,
      height: AppVariables.appDefaultlistItemSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).extension<AppliedSurface>()?.brandSubTitle,
        border: Border.all(color: Colors.transparent, width: 1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: context.labelMedium(
        name?.substring(0, 2).toUpperCase() ?? '',
        isBold: true,
      ),
    );
  }

  void _handleRemoveFromCategory(
    StockProduct item,
    CategoryViewModel vm,
    StockCategory category,
  ) {
    if (item.categoryId != null && vm.products!.any((p) => p.id == item.id)) {
      vm.item!.removedProducts.add(item);
    }

    vm.products!.removeWhere((p) => p.id == item.id);
    item.categoryId = null;

    widget.setCategory!(item);
    category = vm.item!;
    vm.onDeleteCategoryItem(context, category);
  }
}

enum ProductViewMode { productsView, stockView }

class MenuItem {
  final String text;

  const MenuItem({required this.text});
}

class MenuItems {
  static const List<MenuItem> firstItems = [name, price, createdDate];

  static const createdDate = MenuItem(text: 'Created Date');
  static const name = MenuItem(text: 'Product Name');
  static const price = MenuItem(text: 'Price');

  static Widget buildItem(
    MenuItem item,
    String sortSelection,
    String sortOrder,
    BuildContext context,
  ) {
    if (sortSelection.toLowerCase() == item.text.toLowerCase()) {
      return Row(
        children: [
          Flexible(
            flex: 10,
            child: Text(
              item.text,
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
          Flexible(
            flex: 1,
            child: Icon(
              sortOrder == 'Descending'
                  ? Icons.arrow_upward
                  : Icons.arrow_downward,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Text(item.text, style: const TextStyle(color: Colors.black)),
        ],
      );
    }
  }
}

enum SortOrder { name, price, createdDate }
