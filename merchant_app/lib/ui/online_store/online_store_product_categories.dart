// remove ignore_for_file: use_build_context_synchronously

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/services/modal_service.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/store/store_actions.dart';
import 'package:littlefish_merchant/ui/online_store/categories/store_category_page.dart';
import 'package:littlefish_merchant/ui/online_store/viewmodels/manage_store_vm.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/ui/products/categories/widgets/product_categories.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/auto_complete_text_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/common/presentaion/components/list_leading_tile.dart';
import 'package:littlefish_merchant/common/presentaion/components/new_list_tile.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:quiver/strings.dart';

import '../../features/ecommerce_shared/models/store/store_product.dart';
import '../../models/stock/stock_category.dart';

class OnlineStoreProductCategories extends StatefulWidget {
  final Function(StoreProductCategory item)? onTap;
  final ManageStoreVM? vm;
  final BuildContext? parentContext;
  final bool getOnlineProducts;
  const OnlineStoreProductCategories({
    Key? key,
    this.onTap,
    this.vm,
    this.parentContext,
    this.getOnlineProducts = false,
  }) : super(key: key);

  @override
  State<OnlineStoreProductCategories> createState() =>
      _OnlineStoreProductCategoriesState();
}

class _OnlineStoreProductCategoriesState
    extends State<OnlineStoreProductCategories> {
  GlobalKey<AutoCompleteTextFieldState<StoreProductCategory>>? filterKey;
  ManageStoreVM? parentVM;
  final GlobalKey _refreshKey = GlobalKey();
  late List<StoreProductCategory> _filteredList;
  late List<StoreProductCategory> _sortedList;
  late String _sortOrder;
  late String _sortSelection;
  MenuItem? _currentSelection;
  SortOrder? _selectedOrder;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    _filteredList = [];
    _sortedList = [];
    _sortOrder = 'Ascending';
    _sortSelection = '';
    filterKey = GlobalKey<AutoCompleteTextFieldState<StoreProductCategory>>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var result = StoreConnector<AppState, ManageStoreVM>(
      converter: (store) => ManageStoreVM.fromStore(store),
      builder: (BuildContext ctx, ManageStoreVM vm) {
        updateFilteredList(vm);
        sortList(vm);
        return AppScaffold(
          title: 'Online Categories',
          hasDrawer: false,
          actions: <Widget>[
            IconButton(
              key: _refreshKey,
              icon: const Icon(Icons.refresh),
              onPressed: () {
                vm.store!.dispatch(getStoreCategories(refresh: true));
              },
            ),
          ],
          body: layout(context, vm),
        );
      },
    );
    return result;
  }

  updateFilteredList(ManageStoreVM vm) {
    if (isNotBlank(searchController.text) && (vm.categories.isNotEmpty)) {
      _filteredList = vm.categories
          .where(
            (element) => element.displayName!.toLowerCase().contains(
              searchController.text.toLowerCase(),
            ),
          )
          .toList();
    }
  }

  Future<void> openOnlineCategory(
    BuildContext context,
    ManageStoreVM vm, {
    StoreProductCategory? cat,
  }) async {
    if (cat != null) {
      // vm.setSelectedItem(product);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) {
            cat.isNew = false;

            return StoreCategoryPage(vm: vm, item: cat);
          },
        ),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) {
            return StoreCategoryPage(vm: vm);
          },
        ),
      );
    }
  }

  sortList(ManageStoreVM vm) {
    if (searchController.text == '') {
      _sortedList = vm.categories.toList();
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

    if (searchController.text != '') {
      _filteredList = _sortedList.toList();
    }
  }

  Column layout(context, ManageStoreVM vm) => Column(
    children: <Widget>[
      SizedBox(child: topBar(context, vm: vm)),
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

  SizedBox topBar(
    BuildContext context, {
    Function? onAdd,
    required ManageStoreVM vm,
  }) => SizedBox(
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
                          _sortSelection = 'Product Name';
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
  ListView filteredCategoryList(BuildContext context, ManageStoreVM vm) {
    // var categories =
    //     vm.categories.where((element) => element.deleted == false).toList();

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: (_filteredList.length) + 1,
      itemBuilder: (BuildContext ctx, int index) {
        if (index == 0) {
          return NewItemTile(
            title: 'Publish Category',
            onTap: () => captureCategory(context, vm),
          );
        } else {
          StoreProductCategory item = _filteredList[index - 1];

          return CategoryListTile(
            item: item,
            isDismissable: true,
            onRemove: (item) async {
              item.deleted = true;
              item.dateUpdated = DateTime.now().toUtc();
              item.updatedBy = vm.store!.state.currentUser!.email;

              StockCategory? category;
              try {
                category = vm.store!.state.productState.categories!
                    .where((element) => element.id == item.categoryId)
                    .first;
                category.isOnline = false;
              } catch (e) {
                category = null;
              }

              bool? result = await getIt<ModalService>().showActionModal(
                context: context,
                title: 'Unpublish Category?',
                description:
                    'Would you also like to unpublish the products linked to the ${item.displayName} category from your Online Store?\nPlease note, your Online Store will be set to offline if no products are published/online.',
                acceptText: 'Yes, Unpublish',
                cancelText: 'No, Cancel',
              );

              if (!(result ?? false)) {
                vm.deleteOnlineCategory(category, item, context);
              } else {
                var products = vm.store!.state.productState.products
                    ?.where((element) => element.categoryId == item.id)
                    .toList();

                vm.setCategoryProductsToOffline(
                  products,
                  context,
                  false,
                  item.categoryId!,
                );

                vm.deleteOnlineCategory(category, item, context);
              }
            },
          );
        }
      },
      separatorBuilder: (BuildContext context, int index) =>
          const CommonDivider(height: 0.5),
    );
  }

  ListView categoryList(BuildContext context, ManageStoreVM vm) {
    // var categories =
    //     vm.categories.where((element) => element.deleted == false).toList();

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: (_sortedList.length) + 1,
      itemBuilder: (BuildContext ctx, int index) {
        if (index == 0) {
          return NewItemTile(
            title: 'Publish Category',
            onTap: () => captureCategory(context, vm),
          );
        } else {
          StoreProductCategory item = _sortedList[index - 1];

          return CategoryListTile(
            item: item,
            isDismissable: true,
            onRemove: (item) async {
              item.deleted = true;
              item.dateUpdated = DateTime.now().toUtc();
              item.updatedBy = vm.store!.state.currentUser!.email;

              StockCategory? category;
              try {
                category = vm.store!.state.productState.categories!
                    .where((element) => element.id == item.categoryId)
                    .first;
                category.isOnline = false;
              } catch (e) {
                category = null;
              }

              bool? result = await getIt<ModalService>().showActionModal(
                context: context,
                title: 'Unpublish Category?',
                description:
                    'Would you also like to unpublish the products linked to the ${item.displayName} category from your Online Store?\nPlease note, your Online Store will be set to offline if no products are published/online.',
                acceptText: 'Yes, Unpublish',
                cancelText: 'No, Cancel',
              );

              if (!(result ?? false)) {
                vm.deleteOnlineCategory(category, item, context);
              } else {
                var products = vm.store!.state.productState.products
                    ?.where((element) => element.categoryId == item.id)
                    .toList();

                vm.setCategoryProductsToOffline(
                  products,
                  context,
                  false,
                  item.categoryId!,
                );

                vm.deleteOnlineCategory(category, item, context);
              }
            },
            onTap: (item) {
              openOnlineCategory(context, vm, cat: item);
            },
          );
        }
      },
      separatorBuilder: (BuildContext context, int index) =>
          const CommonDivider(height: 0.5),
    );
  }

  Future<void> captureCategory(BuildContext context, ManageStoreVM vm) async {
    showPopupDialog(
      context: context,
      content: AppSimpleAppScaffold(
        title: 'Categries',
        // appBar: PreferredSize(
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       IconButton(
        //         onPressed: () {
        //           Navigator.pop(context);
        //         },
        //         icon: Icon(
        //           Icons.close,
        //           color: Theme.of(context).colorScheme.secondary,
        //         ),
        //       ),
        //       Text(
        //         "Categories",
        //         style: TextStyle(
        //           color: Theme.of(context).colorScheme.secondary,
        //           fontWeight: FontWeight.bold,
        //           fontSize: 20,
        //         ),
        //       ),
        //       SizedBox(
        //         width: 50,
        //       )
        //     ],
        //   ),
        //   preferredSize: Size.fromHeight(100),
        // ),
        body: categoriesModal(context, vm: vm),
      ),
    );
  }

  ProductCategories categoriesModal(
    BuildContext context, {
    ManageStoreVM? vm,
  }) => ProductCategories(
    parentContext: context,
    getOfflineProducts: true,
    canAddNew: true,
    onTap: (item) async {
      if (item.isOnline!) {
        showMessageDialog(
          context,
          '${item.displayName} category is already online.',
          LittleFishIcons.info,
        );
      } else {
        var result = await getIt<ModalService>().showActionModal(
          context: context,
          title: 'Publish Category?',
          description:
              'Are you sure you want to publish the ${item.displayName} category to your Online Store?',
          acceptText: 'Yes, Publish',
          cancelText: 'No, Cancel',
        );

        if (result == true) {
          vm!.updateCategoryAndProductsToOnline(item, context);
        }
      }
    },
  );
}

class CategoryListTile extends StatelessWidget {
  final bool isDismissable;

  final StoreProductCategory item;

  final bool selected;

  final Function(StoreProductCategory item)? onTap;

  final Function(StoreProductCategory item)? onRemove;

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
    child: _categoryTile(context),
  );

  Container _categoryTile(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        tileColor: Theme.of(context).colorScheme.background,
        key: Key(item.id!),
        leading: isNotBlank(item.featureImageUrl)
            ? ListLeadingImageTile(url: item.featureImageUrl)
            : ListLeadingIconTile(icon: MdiIcons.tagMultiple),
        onTap: onTap != null
            ? () {
                onTap!(item);
              }
            : null,
        title: Text('${item.displayName ?? item.name}'),
        selected: selected,
        trailing: ListLeadingTextTile(
          text: (item.productCount ?? 0).toString(),
        ),
      ),
    );
  }
}

class MenuItem {
  final String text;

  const MenuItem({required this.text});
}

class MenuItems {
  static const List<MenuItem> firstItems = [name, createdDate];

  static const createdDate = MenuItem(text: 'Created Date');
  static const name = MenuItem(text: 'Product Name');

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

enum SortOrder { name, createdDate }
