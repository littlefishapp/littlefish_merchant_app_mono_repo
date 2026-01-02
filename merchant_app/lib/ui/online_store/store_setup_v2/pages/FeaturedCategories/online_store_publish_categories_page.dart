// ignore_for_file: prefer_final_fields, implementation_imports

// flutter imports
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_secondary.dart';
import 'package:littlefish_merchant/models/stock/stock_category.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/pages/FeaturedCategories/online_store_add_category_page.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/widgets/featured_category_tile.dart';

// package imports
import 'package:quiver/strings.dart';
import 'package:redux/src/store.dart';

// project imports
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/ui/online_store/shared/routes/custom_route.dart';
import 'package:littlefish_merchant/common/presentaion/components/keyboard_dismissal_utility.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/widgets/search_and_sort.dart';
import 'package:littlefish_merchant/redux/store/store_actions.dart';
import 'package:littlefish_merchant/shared/sort/list_sort.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/widgets/selectable_listview.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/redux/viewmodels/manage_store_vm_v2.dart';

import '../../../../../app/theme/applied_system/applied_text_icon.dart';
import '../../../../../common/presentaion/components/buttons/footer_buttons_secondary_primary.dart';
import '../../../../../common/presentaion/components/dialogs/common_dialogs.dart';
import '../../../../../shared/constants/permission_name_constants.dart';
import 'package:littlefish_icons/littlefish_icons.dart';

class OnlineStorePublishCategoriesPage extends StatefulWidget {
  const OnlineStorePublishCategoriesPage({Key? key}) : super(key: key);

  @override
  State<OnlineStorePublishCategoriesPage> createState() =>
      _OnlineStorePublishCategoriesPageState();
}

class _OnlineStorePublishCategoriesPageState
    extends State<OnlineStorePublishCategoriesPage> {
  late List<StockCategory> _allCategoriesCopy;
  late List<StockCategory> _filteredList;
  late List<StockCategory> _modifiedCategories;
  String? _searchText;
  bool _isDialogShowing = false;

  @override
  void initState() {
    _initialiseLists();
    super.initState();
  }

  void _initialiseLists({Store<AppState>? store}) {
    List<StockCategory> stateCategories;
    if (store != null) {
      stateCategories = store.state.productState.categories ?? [];
    } else {
      stateCategories = AppVariables.store?.state.productState.categories ?? [];
    }
    _allCategoriesCopy = _copyCategoriesList(stateCategories);
    _filteredList = _copyCategoriesList(_allCategoriesCopy);
    _modifiedCategories = [];
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
        title: 'Manage Featured Categories',
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
              _modifiedCategories = _getModifiedCategories(vm) ?? [];
              if (_modifiedCategories.isEmpty) return;
              vm.updateCategory(context, _modifiedCategories);
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: context.paragraphSmall(
            'Note: You can feature only 4 categories on your online store.',
            color: Theme.of(context).extension<AppliedTextIcon>()?.secondary,
            isBold: true,
          ),
        ),
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
            child: _addNewCategoryButton(vm),
          ),
        ],
        Expanded(child: _categoriesListView(vm)),
      ],
    );
  }

  Widget _searchAndSort(ManageStoreVMv2 vm) {
    return SearchAndSort(
      onSearchChanged: (value) {
        setState(() {
          _searchText = value;
          _filteredList = _updateFilteredList(value, _allCategoriesCopy);
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

  Widget _categoriesListView(ManageStoreVMv2 vm) {
    return SelectableListView(
      shrinkWrap: true,
      itemCount: _filteredList.length,
      tilePadding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemBuilder: ((context, index) {
        return FeaturedCategoriesTile(
          item: _filteredList[index],
          selected: _filteredList[index].isFeatured ?? false,
          onTap: (item) {},
          key: ValueKey(_filteredList[index].id),
        );
      }),
      onSelectedChanged: (isSelected, index) =>
          _onSelectedChanged(isSelected, index),
      isSelectedList: _filteredList
          .map((item) => item.isFeatured ?? false)
          .toList(),
    );
  }

  void _onSelectedChanged(bool isSelected, int index) async {
    int selectedCount = _filteredList
        .where((item) => item.isFeatured ?? false)
        .length;

    if (isSelected && selectedCount >= 4) {
      if (!_isDialogShowing) {
        _isDialogShowing = true;
        await showMessageDialog(
          context,
          'You are only allowed to select 4 categories to feature on your online store.',
          LittleFishIcons.info,
        );
        _isDialogShowing = false;
        setState(() {});
      }
      return;
    }

    int categoryIndex = _allCategoriesCopy.indexWhere(
      (category) => category.id == _filteredList[index].id,
    );
    if (categoryIndex != -1) {
      _filteredList[index].isFeatured = isSelected;
      _allCategoriesCopy[categoryIndex].isFeatured = isSelected;
    }
    setState(() {});
  }

  List<StockCategory> _updateFilteredList(
    String? text,
    List<StockCategory> categories,
  ) {
    if (isNotBlank(text) && (categories.isNotEmpty)) {
      return categories
          .where(
            (element) => element.displayName!.toLowerCase().contains(
              text!.toLowerCase(),
            ),
          )
          .map((category) => category.copyWith(category))
          .toList();
    }

    return _copyCategoriesList(_allCategoriesCopy);
  }

  void _sortList(ManageStoreVMv2 vm) {
    _filteredList = ListSort().getSortedItems(
      items: _filteredList,
      type: vm.sortProductsBy,
      filteredItems: _copyCategoriesList(_filteredList),
      searchText: _searchText ?? '',
      order: vm.sortProductsOrder,
      isOnlyOfflineProducts: false,
    );

    _filteredList.sort((a, b) {
      if (a.isFeatured == b.isFeatured) {
        return 0;
      }
      if (a.isFeatured == true) {
        return -1;
      }
      return 1;
    });
  }

  Widget _addNewCategoryButton(ManageStoreVMv2 vm) {
    return ButtonSecondary(
      rightIcon: Icons.add,
      text: 'Add New Category',
      onTap: (_) async {
        await vm.onResetCategory(context);
        Navigator.of(context).push(
          CustomRoute(builder: (context) => const OnlineStoreAddCategoryPage()),
        );
      },
    );
  }

  List<StockCategory>? _getModifiedCategories(ManageStoreVMv2 vm) {
    List<StockCategory> stateCategories =
        vm.store?.state.productState.categories ?? [];
    Map<String, StockCategory> stateCategoriesMap = listToMap(
      stateCategories,
      (category) => category.id!,
    );
    for (StockCategory categoryCopy in _allCategoriesCopy) {
      if (categoryCopy.isFeatured !=
          stateCategoriesMap[categoryCopy.id]?.isFeatured) {
        _modifiedCategories.add(categoryCopy);
      }
    }
    return _modifiedCategories;
  }

  List<StockCategory> _copyCategoriesList(List<StockCategory> items) {
    return List.generate(
      items.length,
      (index) => items[index].copyWith(items[index]),
    );
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}
