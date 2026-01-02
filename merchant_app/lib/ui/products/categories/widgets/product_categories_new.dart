import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/services/modal_service.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:quiver/strings.dart';
import 'package:littlefish_merchant/models/stock/stock_category.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/product/product_actions.dart';
import 'package:littlefish_merchant/ui/products/categories/view_models/category_collection_vm.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/auto_complete_text_field.dart';
import 'package:littlefish_merchant/common/presentaion/pages/popup_forms/string_popup_form.dart';
import 'package:littlefish_merchant/common/presentaion/components/list_leading_tile.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/app/custom_route.dart';
import 'package:littlefish_icons/littlefish_icons.dart';

import '../../../../app/theme/applied_system/applied_text_icon.dart';
import '../../../../common/presentaion/components/form_fields/search_text_field.dart';
import '../../../../common/presentaion/components/icons/warning_icon.dart';

class ProductCategoriesNew extends StatefulWidget {
  final Function(StockCategory item)? onTap;
  final CategoriesViewModel? vm;
  final BuildContext? parentContext;
  final bool getOfflineProducts;
  final bool canAddNew;
  const ProductCategoriesNew({
    Key? key,
    this.onTap,
    this.vm,
    this.parentContext,
    this.getOfflineProducts = false,
    this.canAddNew = true,
  }) : super(key: key);

  @override
  State<ProductCategoriesNew> createState() => _ProductCategoriesNewState();
}

class _ProductCategoriesNewState extends State<ProductCategoriesNew> {
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
          _sortedList.sort(
            ((a, b) => _sortOrder == 'Ascending'
                ? b.dateCreated!.compareTo(a.dateCreated!)
                : a.dateCreated!.compareTo(b.dateCreated!)),
          );
          break;
      }
    } else {
      _sortedList.sort(
        ((a, b) => _sortOrder == 'Ascending'
            ? b.dateCreated!.compareTo(a.dateCreated!)
            : a.dateCreated!.compareTo(b.dateCreated!)),
      );
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
      topBar(context, vm),
      vm.isLoading!
          ? const AppProgressIndicator()
          : searchController.text == ''
          ? categoryList(context, vm)
          : filteredCategoryList(context, vm),
    ],
  );

  SizedBox topBar(BuildContext context, CategoriesViewModel vm) => SizedBox(
    child: Container(
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
                  onClear: () {
                    updateFilteredList(vm);
                    if (mounted) setState(() {});
                  },
                ),
              ),
              const SizedBox(width: 8),
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
        itemCount: (_filteredList.length),
        shrinkWrap: true,
        itemBuilder: (BuildContext ctx, int index) {
          StockCategory item = _filteredList[index];
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
        },
        separatorBuilder: (BuildContext context, int index) => Container(),
      );

  ListView categoryList(BuildContext context, CategoriesViewModel vm) =>
      ListView.separated(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: (_sortedList.length),
        itemBuilder: (BuildContext ctx, int index) {
          StockCategory item = _sortedList[index];
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
        },
        separatorBuilder: (BuildContext context, int index) => Container(),
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
            bool? result = await getIt<ModalService>().showActionModal(
              context: context,
              title: 'Delete Category',
              description:
                  'Are you sure you want to delete this category?'
                  '\nThis cannot be undone.'
                  '\n\nProducts in this category will not be deleted - they will have no category.',
              acceptText: 'Yes, Delete Category',
              cancelText: 'No, Cancel',
            );

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

    child: _categoryTile(context),
  );

  Widget _categoryTile(BuildContext context) {
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
                (item.name != null && item.name!.isNotEmpty)
                    ? (item.name!.length >= 2
                          ? item.name!.substring(0, 2).toUpperCase()
                          : item.name!.toUpperCase())
                    : '',
                isBold: true,
              ),
            ),
      onTap: onTap != null
          ? () {
              onTap!(item);
            }
          : null,
      title: context.labelSmall(
        '${item.displayName ?? item.name}',
        alignLeft: true,
        isBold: true,
      ),
      subtitle: context.labelXSmall(
        '${(item.description ?? 'No Description').trim().isEmpty ? 'No Description' : (item.description ?? 'No Description').trim()}, ${item.productCount} items',
        alignLeft: true,
      ),
      selected: selected,
      trailing: Icon(
        Platform.isIOS ? Icons.arrow_forward_ios_outlined : Icons.arrow_forward,
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
