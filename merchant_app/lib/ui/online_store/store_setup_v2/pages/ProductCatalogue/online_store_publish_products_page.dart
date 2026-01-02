// ignore_for_file: prefer_final_fields, implementation_imports

// flutter imports
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_secondary.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/redux/product/product_actions.dart';

// package imports
import 'package:quiver/strings.dart';
import 'package:redux/src/store.dart';

// project imports
import 'package:littlefish_merchant/ui/products/products/widgets/product_stock_tile.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/common/presentaion/components/completers.dart';
import 'package:littlefish_merchant/common/presentaion/components/keyboard_dismissal_utility.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/widgets/search_and_sort.dart';
import 'package:littlefish_merchant/redux/store/store_actions.dart';
import 'package:littlefish_merchant/shared/sort/list_sort.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/widgets/selectable_listview.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/redux/viewmodels/manage_store_vm_v2.dart';

import '../../../../../common/presentaion/components/buttons/footer_buttons_secondary_primary.dart';
import '../../../../../shared/constants/permission_name_constants.dart';

class OnlineStorePublishProductsPage extends StatefulWidget {
  const OnlineStorePublishProductsPage({Key? key}) : super(key: key);

  @override
  State<OnlineStorePublishProductsPage> createState() =>
      _OnlineStorePublishProductsPageState();
}

class _OnlineStorePublishProductsPageState
    extends State<OnlineStorePublishProductsPage> {
  late List<StockProduct> _allProductsCopy;
  late List<StockProduct> _filteredList;
  late List<StockProduct> _modifiedProducts;
  String? _searchText;

  @override
  void initState() {
    _initialiseLists();
    super.initState();
  }

  void _initialiseLists({Store<AppState>? store}) {
    List<StockProduct> stateProducts;
    if (store != null) {
      stateProducts = store.state.productState.products ?? [];
    } else {
      stateProducts = AppVariables.store?.state.productState.products ?? [];
    }
    _allProductsCopy = _copyProductsList(stateProducts);
    _filteredList = _copyProductsList(_allProductsCopy);
    _modifiedProducts = [];
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ManageStoreVMv2>(
      converter: (store) => ManageStoreVMv2.fromStore(store),
      builder: (BuildContext context, ManageStoreVMv2 vm) {
        _sortList(vm);
        return _scaffold(vm);
      },
    );
  }

  Widget _scaffold(ManageStoreVMv2 vm) {
    return KeyboardDismissalUtility(
      content: AppScaffold(
        title: 'Manage Online Products',
        centreTitle: false,
        body: vm.isLoading != true ? _layout(vm) : const AppProgressIndicator(),
        enableProfileAction: false,
        persistentFooterButtons: [
          FooterButtonsSecondaryPrimary(
            secondaryButtonText: 'Cancel',
            onSecondaryButtonPressed: (ctx) async {
              Navigator.of(context).pop();
            },
            primaryButtonText: 'Save Changes',
            onPrimaryButtonPressed: (ctx) async {
              _modifiedProducts = _getModifiedProducts(vm) ?? [];
              if (_modifiedProducts.isEmpty) return;
              Completer? completer = snackBarCompleter(
                context,
                'Online catalogue successfully updated',
                durationMilliseconds: 3000,
                completerAction: () {
                  _initialiseLists(store: vm.store);
                  setState(() {});
                },
                useOnlyCompleterAction: true,
              );
              vm.store?.dispatch(
                updateProductsIsOnline(
                  updatedProducts: _modifiedProducts,
                  completer: completer,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Column _layout(ManageStoreVMv2 vm) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _searchAndSort(vm),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: CommonDivider(),
        ),
        if (userHasPermission(allowProduct) == true) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _addNewProductButton(vm),
          ),
        ],
        Expanded(child: _productsListView(vm)),
      ],
    );
  }

  Widget _searchAndSort(ManageStoreVMv2 vm) {
    return SearchAndSort(
      onSearchChanged: (value) {
        setState(() {
          _searchText = value;
          _filteredList = _updateFilteredList(value, _allProductsCopy);
        });
      },
      sortBy: vm.sortProductsBy,
      sortOrder: vm.sortProductsOrder,
      onSortChanged: (sortBy, sortOrder) {
        vm.store?.dispatch(
          SetProductsOrCategoriesSortOptionsAction(sortBy, sortOrder),
        );
        _sortList(vm);
        setState(() {});
      },
    );
  }

  Widget _productsListView(ManageStoreVMv2 vm) {
    return SelectableListView(
      shrinkWrap: true,
      itemCount: _filteredList.length,
      tilePadding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemBuilder: ((context, index) {
        return ProductStockTile(
          item: _filteredList[index],
          category: vm.store?.state.productState.getCategory(
            categoryId: _filteredList[index].categoryId,
          ),
          selected: _filteredList[index].isOnline ?? false,
          onTap: (item) {},
          key: ValueKey(_filteredList[index].id),
        );
      }),
      onSelectedChanged: (isSelected, index) =>
          _onSelectedChanged(isSelected, index),
      isSelectedList: _filteredList
          .map((item) => item.isOnline ?? false)
          .toList(),
    );
  }

  void _onSelectedChanged(bool isSelected, int index) {
    int productIndex = _allProductsCopy.indexWhere(
      (product) => product.id == _filteredList[index].id,
    );
    if (productIndex != -1) {
      _filteredList[index].isOnline = isSelected;
      _allProductsCopy[productIndex].isOnline = isSelected;
    }
    setState(() {});
  }

  List<StockProduct> _updateFilteredList(
    String? text,
    List<StockProduct> products,
  ) {
    if (isNotBlank(text) && (products.isNotEmpty)) {
      return products
          .where(
            (element) => element.displayName!.toLowerCase().contains(
              text!.toLowerCase(),
            ),
          )
          .map((product) => product.copyWith())
          .toList();
    }

    return _copyProductsList(_allProductsCopy);
  }

  void _sortList(ManageStoreVMv2 vm) {
    _filteredList = ListSort().getSortedItems(
      items: _filteredList,
      type: vm.sortProductsBy,
      filteredItems: _copyProductsList(_filteredList),
      searchText: _searchText ?? '',
      order: vm.sortProductsOrder,
      isOnlyOfflineProducts: false,
    );

    _filteredList.sort((a, b) {
      if (a.isOnline == b.isOnline) {
        return 0;
      }
      if (a.isOnline == true) {
        return -1;
      }
      return 1;
    });
  }

  Widget _addNewProductButton(ManageStoreVMv2 vm) {
    return ButtonSecondary(
      rightIcon: Icons.add,
      text: 'Add New Product',
      onTap: (ctx) {
        vm.store?.dispatch(
          createProduct(ctx, pageContext: ProductPageContext.onlineStore),
        );
      },
    );
  }

  List<StockProduct>? _getModifiedProducts(ManageStoreVMv2 vm) {
    List<StockProduct> stateProducts =
        vm.store?.state.productState.products ?? [];
    Map<String, StockProduct> stateProductsMap = listToMap(
      stateProducts,
      (product) => product.id!,
    );
    for (StockProduct productCopy in _allProductsCopy) {
      if (productCopy.isOnline != stateProductsMap[productCopy.id]?.isOnline) {
        _modifiedProducts.add(productCopy);
      }
    }
    return _modifiedProducts;
  }

  List<StockProduct> _copyProductsList(List<StockProduct> items) {
    return List.generate(items.length, (index) => items[index].copyWith());
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}
