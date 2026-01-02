// Flutter imports:
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:quiver/strings.dart';

// Project imports:
import 'package:littlefish_merchant/models/stock/stock_category.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/product/product_actions.dart';
import 'package:littlefish_merchant/ui/products/categories/view_models/category_collection_vm.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/auto_complete_text_field.dart';
import 'package:littlefish_merchant/common/presentaion/pages/popup_forms/string_popup_form.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/common/presentaion/components/new_list_tile.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/app/custom_route.dart';
import 'package:littlefish_icons/littlefish_icons.dart';

import '../../../../common/presentaion/components/icons/warning_icon.dart';
import '../../../../injector.dart';
import '../../../../tools/network_image/flutter_network_image.dart';

class ProductCategories extends StatefulWidget {
  final Function(StockCategory item)? onTap;
  final CategoriesViewModel? vm;
  final BuildContext? parentContext;
  final bool getOfflineProducts;
  final bool canAddNew;
  const ProductCategories({
    Key? key,
    this.onTap,
    this.vm,
    this.parentContext,
    this.getOfflineProducts = false,
    this.canAddNew = true,
  }) : super(key: key);

  @override
  State<ProductCategories> createState() => _ProductCategoriesState();
}

class _ProductCategoriesState extends State<ProductCategories> {
  late List<StockCategory> _filteredList;
  late List<StockCategory> _sortedList;
  late String _sortOrder;
  late String _sortSelection;
  MenuItem? _currentSelection;
  SortOrder? _selectedOrder;

  GlobalKey<AutoCompleteTextFieldState<StockCategory>>? filterKey;
  TextEditingController searchController = TextEditingController();
  CategoriesViewModel? parentVM;
  @override
  void initState() {
    _filteredList = [];
    _sortedList = [];
    _sortOrder = 'Ascending';
    _sortSelection = '';
    filterKey = GlobalKey<AutoCompleteTextFieldState<StockCategory>>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var result = StoreConnector<AppState, CategoriesViewModel>(
      converter: (store) => CategoriesViewModel.fromStore(store),
      builder: (BuildContext ctx, CategoriesViewModel vm) {
        updateFilteredList(vm);
        sortList(vm);
        return layout(context, vm);
      },
    );
    return result;
  }

  updateFilteredList(CategoriesViewModel vm) {
    if (isNotBlank(searchController.text) && (vm.items!.isNotEmpty)) {
      _filteredList = vm.items!
          .where(
            (element) => element.displayName!.toLowerCase().contains(
              searchController.text.toLowerCase(),
            ),
          )
          .toList();
    }
  }

  sortList(CategoriesViewModel vm) {
    if (searchController.text == '') {
      _sortedList = vm.items!.toList();
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

  Column layout(context, CategoriesViewModel vm) => Column(
    children: <Widget>[
      SizedBox(child: topBar(context, vm)),
      Expanded(
        flex: 20,
        child: vm.isLoading!
            ? const AppProgressIndicator()
            : searchController.text == ''
            ? categoryList(context, vm)
            : filteredCategoryList(context, vm),
      ),
    ],
  );

  SizedBox topBar(BuildContext context, CategoriesViewModel vm) => SizedBox(
    height: 70.0,
    child: Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          Row(
            children: [
              Flexible(
                flex: 10,
                child: TextField(
                  controller: searchController,
                  onChanged: (searchController) {
                    updateFilteredList(vm);
                    if (mounted) setState(() {});
                  },
                  cursorColor: Colors.grey,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Search',
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                    ),
                    prefixIcon: Container(
                      padding: const EdgeInsets.all(15),
                      width: 18,
                      child: const Icon(Icons.search),
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    customButton: const Icon(Icons.sort_outlined),
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
                          _sortSelection = 'Category Name';
                          _currentSelection = MenuItems.name;
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
                      width: 180,
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

  ListView filteredCategoryList(BuildContext context, CategoriesViewModel vm) =>
      ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemCount: (_filteredList.length) + 1,
        itemBuilder: (BuildContext ctx, int index) {
          if (index == 0) {
            return NewItemTile(
              title: 'New Category',
              onTap: () => vm.store!.dispatch(createCategory(ctx)),
            );
          } else {
            StockCategory item = _filteredList[index - 1];

            return CategoryListTile(
              item: item,
              isDismissable: false,
              selected: vm.selectedItem == item,
              onRemove: (item) {
                vm.onRemove(item, widget.parentContext ?? ctx);
              },
              onTap: (item) {
                if (widget.onTap == null) {
                  vm.store!.dispatch(editCategory(ctx, item, vm));
                } else {
                  widget.onTap!(item);
                }
              },
            );
          }
        },
        separatorBuilder: (BuildContext context, int index) =>
            const CommonDivider(height: 0.5),
      );

  ListView categoryList(BuildContext context, CategoriesViewModel vm) =>
      ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemCount: (_sortedList.length) + 1,
        itemBuilder: (BuildContext ctx, int index) {
          if (index == 0) {
            return NewItemTile(
              title: 'New Category',
              onTap: () => vm.store!.dispatch(createCategory(ctx)),
            );
          } else {
            StockCategory item = _sortedList[index - 1];

            return CategoryListTile(
              item: item,
              isDismissable: false,
              selected: vm.selectedItem == item,
              onRemove: (item) {
                vm.onRemove(item, widget.parentContext ?? ctx);
              },
              onTap: (item) {
                if (widget.onTap == null) {
                  vm.store!.dispatch(editCategory(ctx, item, vm));
                } else {
                  widget.onTap!(item);
                }
              },
            );
          }
        },
        separatorBuilder: (BuildContext context, int index) =>
            const CommonDivider(height: 0.5),
      );

  Future<void> captureCategory(
    BuildContext context,
    CategoriesViewModel vm,
  ) async {
    Navigator.of(context)
        .push<String>(
          CustomRoute(
            maintainState: true,
            builder: (BuildContext context) => StringPopupForm(
              maxLength: 20,
              initialValue: '',
              subTitle: 'Enter the name of your new category',
              title: 'Category Name',
              onSubmit: (context, dynamic value) {},
            ),
          ),
        )
        .then((value) {
          if (value != null && value.isNotEmpty) {
            vm.onAdd(StockCategory()..name = value, context);
          }
        });
  }
}

class CategoryListTile extends StatelessWidget {
  final bool isDismissable;

  final StockCategory item;

  final bool selected;

  final Function(StockCategory item)? onTap;

  final Function(StockCategory item)? onRemove;

  final int productCount;

  const CategoryListTile({
    Key? key,
    this.isDismissable = false,
    required this.item,
    this.onTap,
    this.selected = false,
    this.onRemove,
    this.productCount = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isDismissable
        ? _dismissableCategory(context)
        : _categoryTile(context);
  }

  Slidable _dismissableCategory(BuildContext context) => Slidable(
    // actionPane: SlidableDrawerActionPane(),
    // actionExtentRatio: 0.25,
    key: Key(item.id!),
    endActionPane: ActionPane(
      extentRatio: .25,
      motion: const ScrollMotion(),
      children: [
        SlidableAction(
          onPressed: (ctx) async {
            var result = await confirmDismissal(context, null);

            if (result == true) {
              onRemove!(item);
            }
          },
          backgroundColor: const Color(0xFFFE4A49),
          foregroundColor: Colors.white,
          icon: Icons.delete,
          label: 'Delete',
        ),
      ],
    ),
    // actionPane: SlidableDrawerActionPane(),
    // actionExtentRatio: 0.25,
    child: _categoryTile(context),
    // secondaryActions: [
    //   IconSlideAction(
    //     color: Colors.red,
    //     icon: Icons.delete,
    //     onTap: () async {
    //       var result = await confirmDismissal(context);

    //       if (result == true) {
    //         this.onRemove(item);
    //       }
    //     },
    //   ),
    // ],
  );

  InkWell _categoryTile(BuildContext context) {
    return InkWell(
      onTap: onTap == null
          ? null
          : () {
              if (onTap != null) onTap!(item);
            },
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 88,
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(4),
                  image: isNotBlank(item.imageUri)
                      ? DecorationImage(
                          image: getIt<FlutterNetworkImage>()
                              .asImageProviderById(
                                id: item.id!,
                                category: 'categories',
                                legacyUrl: item.imageUri!,
                                height: AppVariables.listImageHeight,
                                width: AppVariables.listImageWidth,
                              ),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.displayName!,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      //fontFamily: UIStateData.primaryFontFamily,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${item.productCount} items',
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(158, 156, 159, 1),
                      //fontFamily: UIStateData.primaryFontFamily,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column customDeleteBody(BuildContext context) => Column(
    children: [
      Material(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            height: (MediaQuery.of(context).size.height * (7.5 / 100)),
            width: (MediaQuery.of(context).size.height * (7.5 / 100)),
            child: WarningIcon(
              size: (MediaQuery.of(context).size.height * (3 / 100)),
            ),
          ),
        ),
      ),
      SizedBox(height: MediaQuery.of(context).size.height * (3 / 100)),
      const Text(
        'Delete category?',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 20,
        ),
        textAlign: TextAlign.center,
      ),
      SizedBox(height: MediaQuery.of(context).size.height * (2 / 100)),
      Text(
        'Are you sure you want to delete this category? This cannot be undone.',
        style: TextStyle(
          color: Colors.grey.shade700,
          fontSize: 16,
          height: 1.3,
        ),
        textAlign: TextAlign.center,
      ),
      SizedBox(height: MediaQuery.of(context).size.height * (3 / 100)),
      Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            height: (MediaQuery.of(context).size.height * (4 / 100)),
            width: (MediaQuery.of(context).size.height * (4 / 100)),
            child: Icon(
              LittleFishIcons.info,
              size: (MediaQuery.of(context).size.height * (3 / 100)),
              color: Colors.grey,
            ),
          ),
        ),
      ),
      Text(
        'Products in this category will not be deleted - they will have no category.',
        style: TextStyle(
          color: Colors.grey.shade700,
          fontSize: 16,
          height: 1.3,
        ),
        textAlign: TextAlign.center,
      ),
      SizedBox(height: MediaQuery.of(context).size.height * (3 / 100)),
    ],
  );
}

class MenuItem {
  final String text;

  const MenuItem({required this.text});
}

class MenuItems {
  static const List<MenuItem> firstItems = [name, createdDate];

  static const createdDate = MenuItem(text: 'Created Date');
  static const name = MenuItem(text: 'Category Name');

  static Widget buildItem(
    MenuItem item,
    String sortSelection,
    String sortOrder,
    BuildContext context,
  ) {
    if (sortSelection.toLowerCase() == item.text.toLowerCase()) {
      return Row(
        children: [
          Text(
            item.text,
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          Icon(
            sortOrder == 'Descending'
                ? Icons.arrow_upward
                : Icons.arrow_downward,
            size: 20,
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

enum SortOrder { name, createdDate }
