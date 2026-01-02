// Flutter imports:
// remove ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages
import 'package:decimal/decimal.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_text.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/shared/constants/permission_name_constants.dart';
import 'package:littlefish_merchant/shared/sort/list_sort.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:littlefish_merchant/ui/checkout/sell_page.dart';
import 'package:littlefish_merchant/ui/checkout/widgets/checkout_combo_tile.dart';
import 'package:quiver/strings.dart';
import 'package:redux/redux.dart';
import 'package:littlefish_merchant/models/products/product_combo.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/product/product_actions.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/ui/products/combos/view_models/combo_collection_vm.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/auto_complete_text_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/common/presentaion/components/long_text.dart';
import 'package:littlefish_merchant/common/presentaion/components/text_tag.dart';
import 'package:littlefish_merchant/common/presentaion/components/list_leading_tile.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import '../../../../common/presentaion/components/buttons/button_discard.dart';
import '../../../../common/presentaion/components/buttons/button_primary.dart';
import '../../../checkout/pages/checkout_quick_sale_page.dart';
import '../../../checkout/viewmodels/checkout_viewmodels.dart';
import '../../../../common/presentaion/components/custom_keypad.dart';

class ProductComboList extends StatefulWidget {
  final Function(ProductCombo item)? onTap;
  final bool canAddNew;
  final bool canRemove;
  final CheckoutVM? checkoutVM;
  final Function(ProductCombo item)? onLongPress;
  final bool showTopBar;
  final bool? showQuickPaymentButton;
  final ComboViewMode? viewMode;
  final SortOrder? sortOrder;
  final SortBy? sortBy;

  /// optional searchController can be passed in when using a search bar
  /// outside of this class but you wish to search through products.
  /// Passing in a search controller will edit the text of the the local
  /// search controller, effectively using the parent search controller to
  /// hijack the local searchcontroller.
  final TextEditingController? searchController;

  const ProductComboList({
    Key? key,
    this.onTap,
    this.canAddNew = true,
    this.canRemove = true,
    this.showTopBar = true,
    this.onLongPress,
    this.checkoutVM,
    this.searchController, // parameters when using external search bar
    this.showQuickPaymentButton = false,
    this.viewMode,
    this.sortOrder,
    this.sortBy,
  }) : super(key: key);

  @override
  State<ProductComboList> createState() => _ProductComboListState();
}

class _ProductComboListState extends State<ProductComboList> {
  late List<ProductCombo> _filteredList;
  late List<ProductCombo> _sortedList;
  late SortOrder _sortOrder;
  late String _sortSelection;
  SortBy? _selectedSortType;

  late TextEditingController searchController;

  GlobalKey<AutoCompleteTextFieldState<ProductCombo>>? filterkey;

  @override
  void initState() {
    _filteredList = [];
    _sortedList = [];
    _sortOrder = SortOrder.ascending;
    _sortSelection = '';
    filterkey = GlobalKey<AutoCompleteTextFieldState<ProductCombo>>();
    searchController = widget.searchController ?? TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CombosViewModel>(
      builder: (BuildContext context, vm) {
        updateFilteredList(vm);
        sortList(vm);
        return layout(context, vm);
      },
      converter: (Store store) =>
          CombosViewModel.fromStore(store as Store<AppState>),
    );
  }

  sortList(CombosViewModel vm) {
    _sortedList = ListSort().getSortedItems(
      items: vm.items!.toList(),
      type: widget.sortBy ?? _selectedSortType,
      filteredItems: _filteredList.toList(),
      searchText: searchController.text,
      order: widget.sortOrder ?? _sortOrder,
    );

    if (searchController.text != '') {
      _filteredList = _sortedList.toList();
    }
  }

  Container layout(context, CombosViewModel vm) => Container(
    child: vm.isLoading!
        ? const AppProgressIndicator()
        : Column(
            children: <Widget>[
              if (widget.showTopBar)
                topBar(
                  context,
                  vm,
                  // onAdd: () => captureCombo(context, null),
                ),
              if (widget.showQuickPaymentButton == true &&
                  userHasPermission(allowQuickItem))
                Container(
                  // width: 343,
                  height: 48,
                  margin: const EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 56,
                        width: MediaQuery.of(context).size.width - 152,
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(6),
                              ),
                              color: Color.fromRGBO(246, 246, 246, 1),
                            ),
                            padding: const EdgeInsets.only(left: 8),
                            height: 56,
                            child: ButtonText(
                              icon: Icons.add,
                              text: 'Add Quick Item',
                              layoutVertically: true,
                              onTap: (_) async {
                                await customPayment(widget.checkoutVM!);
                              },
                            ),
                          ),
                        ),
                      ),
                      Ink(
                        width: 56,
                        height: 56,
                        decoration: ShapeDecoration(
                          color: const Color.fromRGBO(246, 246, 246, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: IconButton(
                          iconSize: 24,
                          icon: const Icon(Icons.bolt_outlined),
                          onPressed: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              CheckoutQuickSale.route,
                              ModalRoute.withName(SellPage.route),
                              arguments: 1,
                            );
                          },
                        ),
                      ),
                      ButtonDiscard(
                        isIconButton: true,
                        backgroundColor: const Color.fromRGBO(246, 246, 246, 1),
                        onDiscard: (ctx) => widget.checkoutVM?.onClear(),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: searchController.text == ''
                    ? productList(context, vm)
                    : filteredProductList(context, vm),
              ),
            ],
          ),
  );

  Future<Future<double?>> customPayment(CheckoutVM vm) async =>
      showModalBottomSheet<double>(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        builder: (ctx) => SizedBox(
          height: 480,
          child: CustomKeyPad(
            isLoading: vm.isLoading,
            enableAppBar: false,
            title: 'Quick Item',
            onValueChanged: (double amount) {},
            onDescriptionChanged: (String description) {},
            onSubmit: (amount, description) {
              vm.addCustomSaleToCart(
                Decimal.parse(amount.toString()),
                description ?? '',
              );
              Navigator.of(context).pop();
            },
            parentContext: ctx,
            minChargeAmount: (vm.checkoutTotal ?? Decimal.zero).toDouble(),
            enableDescription: true,
            confirmErrorMessage: 'Please enter the amount for the quick item.',
            confirmButtonText: 'Add',
            initialValue: (vm.amountTendered ?? Decimal.zero).toDouble(),
          ),
        ),
      );

  updateFilteredList(CombosViewModel vm) {
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

  SizedBox topBar(
    BuildContext context,
    CombosViewModel vm, {
    Function? onAdd,
  }) => SizedBox(
    height: 67.0,
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
                    // customItemsIndexes: const [3],
                    // customItemsHeight: 8,
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
                      SortBy? oldSelectedSortType = _selectedSortType;
                      switch (value) {
                        case MenuItems.name:
                          _selectedSortType = SortBy.name;
                          _sortSelection = 'Combo Name';
                          break;
                        case MenuItems.price:
                          _selectedSortType = SortBy.price;
                          _sortSelection = 'Price';
                          break;
                        case MenuItems.createdDate:
                          _selectedSortType = SortBy.createdDate;
                          _sortSelection = 'Created Date';
                          break;
                      }
                      _sortOrder = ListSort().updateSortOrder(
                        order: _sortOrder,
                        type: oldSelectedSortType,
                        newType: _selectedSortType!,
                      );

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

  ListView productList(BuildContext context, CombosViewModel vm) =>
      ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemCount: widget.canAddNew
            ? (_sortedList.length) + 1
            : _sortedList.length,
        itemBuilder: (BuildContext context, int index) {
          if (widget.canAddNew) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: ButtonPrimary(
                  text: 'New Combo',
                  icon: Icons.add,
                  onTap: (context) => captureCombo(context, null),
                ),
              );
            } else {
              ProductCombo item = _sortedList[index - 1];

              return getComboTile(context, vm, item);
            }
          } else {
            ProductCombo item = _sortedList[index];

            return getComboTile(context, vm, item);
          }
        },
        separatorBuilder: (BuildContext context, int index) => CommonDivider(
          height: 0.5,
          color: Theme.of(context).colorScheme.secondary,
        ),
      );

  ListView filteredProductList(BuildContext context, CombosViewModel vm) =>
      ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemCount: widget.canAddNew
            ? (_filteredList.length) + 1
            : _filteredList.length,
        itemBuilder: (BuildContext context, int index) {
          if (widget.canAddNew) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: ButtonPrimary(
                  text: 'New Combo',
                  icon: Icons.add,
                  onTap: (_) => captureCombo(context, null),
                  isNeutral: true,
                ),
              );
            } else {
              ProductCombo item = _filteredList[index - 1];

              return getComboTile(context, vm, item);
            }
          } else {
            ProductCombo item = _filteredList[index];

            return getComboTile(context, vm, item);
          }
        },
        separatorBuilder: (BuildContext context, int index) =>
            const CommonDivider(height: 0.5),
      );

  captureCombo(context, ProductCombo? item) async {
    if (item == null) {
      StoreProvider.of<AppState>(context).dispatch(createCombo(context));
    } else {
      StoreProvider.of<AppState>(context).dispatch(editCombo(context, item));
    }
  }

  StatelessWidget getComboTile(
    BuildContext context,
    CombosViewModel combosVM,
    ProductCombo item,
  ) {
    if (widget.viewMode != null &&
        widget.viewMode == ComboViewMode.checkoutView) {
      return StoreConnector<AppState, CheckoutVM>(
        onInit: (store) {},
        converter: (Store<AppState> store) {
          return CheckoutVM.fromStore(store);
        },
        builder: (BuildContext context, CheckoutVM checkoutVM) {
          return CheckoutComboTile(combo: item, key: ValueKey(item.id));
        },
      );
    } else {
      return ProductComboTile(
        canRemove: widget.canRemove,
        onLongPress: widget.onLongPress,
        onRemove: (item) {
          combosVM.onRemove(item, context);
        },
        item: item,
        selected: combosVM.selectedItem == item,
        onTap: (item) {
          if (widget.onTap == null) {
            {
              combosVM.store!.dispatch(editCombo(context, item));
            }
          } else {
            widget.onTap!(item);
          }
        },
      );
    }
  }
}

class ProductComboTile extends StatelessWidget {
  final ProductCombo item;

  final bool selected;

  final Function? onTap;

  final Function(ProductCombo item)? onRemove;

  final Function(ProductCombo item)? onLongPress;

  final bool canRemove;

  const ProductComboTile({
    Key? key,
    this.selected = false,
    required this.item,
    this.onTap,
    this.onRemove,
    this.canRemove = true,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return canRemove ? _dismissableCombo(context) : comboTile(context);
  }

  Widget comboTile(context) {
    return ListTile(
      tileColor: Theme.of(context).extension<AppliedSurface>()?.primary,
      dense: !EnvironmentProvider.instance.isLargeDisplay!,
      selected: selected,
      leading: ListLeadingTextTile(text: '${item.totalItems.round()}'),
      title: Text(item.displayName!),
      subtitle: LongText(
        "${TextFormatter.toStringCurrency(item.comboSaving, displayCurrency: false, currencyCode: '')} Saving",
      ),
      trailing: Column(
        children: <Widget>[
          LongText('Markup: ${item.markup} %', fontSize: 8),
          TextTag(
            displayText: TextFormatter.toStringCurrency(
              item.comboSellingPrice,
              currencyCode: '',
            ),
          ),
        ],
      ),
      onLongPress: () {
        if (onLongPress != null) onLongPress!(item);
      },
      onTap: onTap == null
          ? null
          : () {
              if (onTap != null) onTap!(item);
            },
    );
  }

  Slidable _dismissableCombo(BuildContext context) => Slidable(
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
    key: Key(item.id!),
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
    child: comboTile(context),
    // actionPane: SlidableDrawerActionPane(),
    // actionExtentRatio: 0.25,
  );
}

class MenuItem {
  final String text;

  const MenuItem({required this.text});
}

class MenuItems {
  static const List<MenuItem> firstItems = [name, price, createdDate];

  static const createdDate = MenuItem(text: 'Created Date');
  static const price = MenuItem(text: 'Price');
  static const name = MenuItem(text: 'Combo Name');

  static Widget buildItem(
    MenuItem item,
    String sortSelection,
    SortOrder sortOrder,
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
              sortOrder == SortOrder.descending
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

enum ComboViewMode { checkoutView, combosView }
