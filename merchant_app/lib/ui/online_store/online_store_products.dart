// remove ignore_for_file: use_build_context_synchronously

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/services/modal_service.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/store/store_actions.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/ui/online_store/viewmodels/manage_store_vm.dart';
import 'package:littlefish_merchant/ui/products/products/widgets/products_list.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/auto_complete_text_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/common/presentaion/components/long_text.dart';
import 'package:littlefish_merchant/common/presentaion/components/text_tag.dart';
import 'package:littlefish_merchant/common/presentaion/components/list_leading_tile.dart';
import 'package:littlefish_merchant/common/presentaion/components/new_list_tile.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:quiver/strings.dart';

import '../../features/ecommerce_shared/models/store/store_product.dart';
import '../../models/stock/stock_category.dart';

class OnlineStoreProducts extends StatefulWidget {
  const OnlineStoreProducts({
    Key? key,
    this.storeId,
    this.showTopBar = false,
    this.canAddNew = false,
    this.onTap,
    this.parentContext,
    this.showBackButton = false,
    this.parentVM,
    this.filterKey,
    this.refreshKey,
    this.newItemKey,
    this.scaffoldKey,
  }) : super(key: key);

  final String? storeId;
  final bool showTopBar;
  final bool showBackButton;
  final bool canAddNew;
  final Function? onTap;
  final BuildContext? parentContext;
  final ManageStoreVM? parentVM;
  final GlobalKey<AutoCompleteTextFieldState<StoreProduct>>? filterKey;
  final GlobalKey? newItemKey;
  final GlobalKey? refreshKey;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  @override
  State<OnlineStoreProducts> createState() => _OnlineStoreProductsState();
}

class _OnlineStoreProductsState extends State<OnlineStoreProducts> {
  List<StoreProduct>? onlineProducts;
  late List<StoreProduct> _filteredList;
  late List<StoreProduct> _sortedList;
  late String _sortOrder;
  late String _sortSelection;
  MenuItem? _currentSelection;
  SortOrder? _selectedOrder;

  // final GlobalKey<AutoCompleteTextFieldState<StoreProduct>> _filterkey =
  //     GlobalKey();
  //GlobalKey<ScaffoldState>? _scaffoldKey;
  final GlobalKey _newItemKey = GlobalKey();
  final GlobalKey _refreshKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController searchController = TextEditingController();
  GlobalKey? newItemKey;
  @override
  void initState() {
    _filteredList = [];
    _sortedList = [];
    _sortOrder = 'Ascending';
    _sortSelection = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ManageStoreVM>(
      converter: (store) => ManageStoreVM.fromStore(store),
      builder: (context, vm) {
        updateFilteredList(vm);
        sortList(vm);
        return AppScaffold(
          scaffoldKey: _scaffoldKey,
          title: 'Online Products',
          centreTitle: false,
          hasDrawer: !widget.showBackButton,
          actions: <Widget>[
            IconButton(
              key: _refreshKey,
              icon: const Icon(Icons.refresh),
              onPressed: () {
                vm.store!.dispatch(getStoreProducts(refresh: true));
              },
            ),
          ],
          body: layout(context, vm),
        );
      },
    );
  }

  updateFilteredList(ManageStoreVM vm) {
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

  sortList(ManageStoreVM vm) {
    if (searchController.text == '') {
      _sortedList = (vm.products ?? []).toList();
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
                ? b.sellingPrice!.compareTo(a.sellingPrice!)
                : a.sellingPrice!.compareTo(b.sellingPrice!)),
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
      if (widget.showTopBar)
        topBar(
          context,
          // onAdd:
          //     widget.canAddNew ? () => captureProduct(context, vm) : null,
          vm: vm,
        ),
      Expanded(
        flex: 20,
        child: vm.isLoading!
            ? const AppProgressIndicator()
            : searchController.text == ''
            ? productList(context, vm)
            : filteredProductList(context, vm),
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

  Future<void> captureProduct(BuildContext context, ManageStoreVM vm) async {
    showPopupDialog(
      context: context,
      content: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                icon: const Icon(Icons.close),
              ),
              // SizedBox(
              //   width: 40,
              //   height: 100,
              // ),
              Text(
                'Products',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(width: 50),
            ],
          ),
        ),
        body: productsModal(context, vm: vm),
      ),
    );
  }

  Future<void> editStoreProduct(BuildContext context, ManageStoreVM vm) async {
    showPopupDialog(
      context: context,
      content: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close),
              ),
              Text(
                'Products',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(width: 50),
            ],
          ),
        ),
        body: productsModal(context, vm: vm),
      ),
    );
  }

  ProductsList productsModal(
    BuildContext context, {
    ProductViewMode mode = ProductViewMode.productsView,
    ManageStoreVM? vm,
  }) => ProductsList(
    viewMode: mode,
    parentContext: context,
    getOfflineProducts: true,
    showTopBar: widget.showTopBar,
    canAddNew: true,
    onTap: (item) async {
      var result = await getIt<ModalService>().showActionModal(
        context: context,
        title: 'Publish Category?',
        description:
            'Are you sure you want to publish the ${item.displayName} category to your Online Store?',
        acceptText: 'Yes, Publish',
        cancelText: 'No, Cancel',
      );

      if (result == true) {
        item.isOnline = true;

        StockCategory? category;

        List<StockProduct> products = [];

        if (vm!.store!.state.productState.categories != null) {
          try {
            category = vm.store!.state.productState.categories!
                .where((element) => element.id == item.categoryId)
                .first;
          } catch (e) {
            category = null;
          }
        }

        // if (vm.store!.state.productState.products != null) {
        //   try {
        //     products = vm.store!.state.productState.products!
        //         .where((element) =>
        //             element.categoryId == item.categoryId &&
        //             element.id == item.id)
        //         .toList();
        //   } catch (e) {
        //     products = null;
        //   }
        // }
        products.add(item);
        Navigator.pop(context);
        vm.publishStoreProduct(item, context, category, products);
      }
    },
  );

  ListView filteredProductList(BuildContext context, ManageStoreVM vm) {
    // var onlineProducts = vm.products != null
    //     ? vm.products!.where((element) => element.deleted == false).toList()
    //     : null;

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: (widget.canAddNew
          ? (_filteredList.length) + 1
          : _filteredList.length),
      itemBuilder: (BuildContext context, int index) {
        if (widget.canAddNew && index == 0) {
          return NewItemTile(
            newItemKey: _newItemKey,
            title: 'Publish Product',
            onTap: () => captureProduct(_scaffoldKey.currentContext!, vm),
          );
        } else {
          StoreProduct item = widget.canAddNew
              ? _filteredList[index - 1]
              : _filteredList[index];

          return StoreProductListTile(
            item: item,
            dismissAllowed: true,
            category: _filteredList[index - 1].baseCategoryId != null
                ? vm.categories
                          .where(
                            (element) =>
                                element.categoryId ==
                                _filteredList[index - 1].baseCategoryId!,
                          )
                          .isNotEmpty
                      ? vm.categories
                            .where(
                              (element) =>
                                  element.categoryId ==
                                  _filteredList[index - 1].baseCategoryId!,
                            )
                            .first
                      : null
                : null,
            onTap: (item) {
              if (widget.onTap == null) {
                //captureProduct(context, vm);
              } else {
                widget.onTap!(item);
              }
            },
            onRemove: (item) async {
              item.deleted = true;
              item.dateUpdated = DateTime.now().toUtc();
              item.updatedBy = vm.store!.state.currentUser!.email;

              bool? proceed = true;
              // bool prompt = false;

              StockProduct? product;
              // List<StoreProduct> storeProducts = [];

              if (vm.store!.state.productState.products != null) {
                try {
                  product = vm.store!.state.productState.products!
                      .where((element) => element.id == item.productId)
                      .first;
                } catch (e) {
                  product = null;
                }
              }

              // if (vm.store!.state.storeState.hasProducts) {
              //   try {
              //     storeProducts = vm.store!.state.storeState.products!;
              //   } catch (e) {
              //     storeProducts = [];
              //   }
              // }

              // if (storeProducts.length == 1 &&
              //     storeProducts
              //             .where((element) => element.id == item.id)
              //             .toList()
              //             .length ==
              //         1) {
              //   proceed = await showAcceptDialog(
              //     context: context,
              //     content: const Text(
              //       'If you delete this item, your Online Catalog will be set to Offline, would you still like to continue with the deletion?',
              //     ),
              //   );
              // }

              if (proceed) {
                if (product != null) {
                  product.isOnline = false;
                  vm.updateStockProduct(product);
                }

                vm.deleteOnlineProduct(
                  item,
                  _scaffoldKey.currentContext!,
                  true,
                );
              }
            },
          );
        }
      },
      separatorBuilder: (BuildContext context, int index) =>
          const CommonDivider(),
    );
  }

  ListView productList(BuildContext context, ManageStoreVM vm) {
    // var onlineProducts = vm.products != null
    //     ? vm.products!.where((element) => element.deleted == false).toList()
    //     : null;

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: (widget.canAddNew
          ? (_sortedList.length) + 1
          : _sortedList.length),
      itemBuilder: (BuildContext context, int index) {
        if (widget.canAddNew && index == 0) {
          return NewItemTile(
            newItemKey: _newItemKey,
            title: 'Publish Product',
            onTap: () => captureProduct(_scaffoldKey.currentContext!, vm),
          );
        } else {
          StoreProduct item = widget.canAddNew
              ? _sortedList[index - 1]
              : _sortedList[index];

          return StoreProductListTile(
            item: item,
            dismissAllowed: true,
            category: _sortedList[index - 1].baseCategoryId != null
                ? vm.categories
                          .where(
                            (element) =>
                                element.categoryId ==
                                _sortedList[index - 1].baseCategoryId!,
                          )
                          .isNotEmpty
                      ? vm.categories
                            .where(
                              (element) =>
                                  element.categoryId ==
                                  _sortedList[index - 1].baseCategoryId!,
                            )
                            .first
                      : null
                : null,
            onTap: (item) {
              if (widget.onTap == null) {
                //captureProduct(context, vm);
              } else {
                widget.onTap!(item);
              }
            },
            onRemove: (item) async {
              item.deleted = true;
              item.dateUpdated = DateTime.now().toUtc();
              item.updatedBy = vm.store!.state.currentUser!.email;

              bool? proceed = true;
              // bool prompt = false;

              StockProduct? product;
              // List<StoreProduct> storeProducts = [];

              if (vm.store!.state.productState.products != null) {
                try {
                  product = vm.store!.state.productState.products!
                      .where((element) => element.id == item.productId)
                      .first;
                } catch (e) {
                  product = null;
                }
              }

              // if (vm.store!.state.storeState.hasProducts) {
              //   try {
              //     storeProducts = vm.store!.state.storeState.products!;
              //   } catch (e) {
              //     storeProducts = [];
              //   }
              // }

              // if (storeProducts.length == 1 &&
              //     storeProducts
              //             .where((element) => element.id == item.id)
              //             .toList()
              //             .length ==
              //         1) {
              //   proceed = await showAcceptDialog(
              //     context: context,
              //     content: const Text(
              //       'If you delete this item, your Online Catalog will be set to Offline, would you still like to continue with the deletion?',
              //     ),
              //   );
              // }

              if (proceed) {
                if (product != null) {
                  product.isOnline = false;
                  vm.updateStockProduct(product);
                }

                vm.deleteOnlineProduct(
                  item,
                  _scaffoldKey.currentContext!,
                  true,
                );
              }
            },
          );
        }
      },
      separatorBuilder: (BuildContext context, int index) =>
          const CommonDivider(),
    );
  }
}

class StoreProductListTile extends StatelessWidget {
  const StoreProductListTile({
    Key? key,
    required this.item,
    this.onTap,
    this.dismissAllowed = false,
    this.onRemove,
    this.category,
    this.selected = false,
    this.onLongPress,
  }) : super(key: key);

  final bool selected;

  final StoreProduct? item;

  final bool dismissAllowed;

  final Function(StoreProduct item)? onTap;

  final Function(StoreProduct item)? onLongPress;

  final Function(StoreProduct item)? onRemove;

  final StoreProductCategory? category;

  @override
  Widget build(BuildContext context) {
    return dismissAllowed
        ? dismissibleProductTile(context, item!)
        : productTile(context, item!);
  }

  Slidable dismissibleProductTile(BuildContext context, StoreProduct item) =>
      Slidable(
        endActionPane: ActionPane(
          extentRatio: .25,
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (ctx) async {
                var result = await confirmDismissal(context, item);

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
        key: Key(item.id!),
        child: productTile(context, item),
      );

  ListTile productTile(BuildContext context, StoreProduct item) => ListTile(
    tileColor: Theme.of(context).colorScheme.background,
    isThreeLine: false,
    dense: true,
    // selected: selected,
    title: Text('${item.displayName}'),
    leading: isNotBlank(item.featureImageUrl)
        ? ListLeadingImageTile(url: item.featureImageUrl)
        : ListLeadingIconTile(icon: MdiIcons.tag),
    subtitle: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [if (category != null) LongText('${category!.displayName}')],
    ),
    trailing: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextTag(
          displayText: item.sellingPrice! > 0
              ? TextFormatter.toStringCurrency(
                  item.sellingPrice,
                  currencyCode: '',
                )
              : 'Variable',
        ),
      ],
    ),
    onTap: onTap == null
        ? null
        : () {
            if (onTap != null) onTap!(item);
          },
    onLongPress: () {
      if (onLongPress != null) onLongPress!(item);
    },
  );
}

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
