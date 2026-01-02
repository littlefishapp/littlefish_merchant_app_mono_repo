import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:quiver/strings.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/models/products/product_discount.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/auto_complete_text_field.dart';
import 'package:littlefish_merchant/shared/list/generate_list_tile.dart';
import 'package:littlefish_merchant/ui/online_store/shared/routes/custom_route.dart';
import 'package:littlefish_merchant/ui/products/product_discounts/pages/product_discount_page.dart';
import 'package:littlefish_merchant/ui/products/product_discounts/view_models/product_discount_vm.dart';

class ProductDiscountsList extends StatefulWidget {
  final Function(ProductDiscount item)? onRemove;

  const ProductDiscountsList({Key? key, this.onRemove}) : super(key: key);

  @override
  State<ProductDiscountsList> createState() => _ProductDiscountsListState();
}

class _ProductDiscountsListState extends State<ProductDiscountsList> {
  GlobalKey<AutoCompleteTextFieldState<ProductDiscount>>? filterkey;
  late List<ProductDiscount> _filteredList;
  late List<ProductDiscount> _sortedList;
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
    filterkey = GlobalKey<AutoCompleteTextFieldState<ProductDiscount>>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ProductDiscountVM>(
      converter: (store) => ProductDiscountVM.fromStore(store),
      builder: (BuildContext ctx, vm) {
        sortList(vm);
        return vm.isLoading!
            ? const AppProgressIndicator()
            : layout(context, vm);
      },
    );
  }

  sortList(ProductDiscountVM vm) {
    if (searchController.text == '') {
      _sortedList = vm.productDiscounts!.toList();
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

  layout(context, ProductDiscountVM vm) => ListView(
    children: <Widget>[
      topBar(context, vm),
      GenerateListView(
        items: searchController.text.isEmpty ? _sortedList : _filteredList,
        context: context,
        onTap: (discount, ctx) async {
          await vm.setCurrentProductDiscount!(discount as ProductDiscount);
          Navigator.push(
            context,
            CustomRoute(
              builder: (BuildContext ctx) => const ProductDiscountPage(),
            ),
          );
        },
        trailingOnTap: (discount, ctx) async {
          discount as ProductDiscount;
          vm.removeProductDiscount!(discount);
        },
      ).getListView(vm: vm),
    ],
  );

  topBar(
    BuildContext context,
    ProductDiscountVM vm, {
    Function? onAdd,
  }) => SizedBox(
    child: Container(
      padding: const EdgeInsets.only(top: 16, left: 14, right: 0, bottom: 8),
      alignment: Alignment.center,
      child: Column(
        children: [
          Row(
            children: [
              Flexible(
                flex: 10,
                child: TextField(
                  textAlign: TextAlign.start,
                  cursorHeight: MediaQuery.of(context).size.height * (2 / 100),
                  textAlignVertical: TextAlignVertical.center,
                  controller: searchController,
                  onChanged: (searchController) {
                    if (isNotBlank(searchController) &&
                        (vm.productDiscounts!.isNotEmpty)) {
                      _filteredList = vm.productDiscounts!
                          .where(
                            (element) => element.displayName!
                                .toLowerCase()
                                .contains(searchController.toLowerCase()),
                          )
                          .toList();
                    }
                    if (mounted) setState(() {});
                  },
                  cursorColor: Colors.grey,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        width: 2,
                        color: Colors.grey.shade300,
                      ),
                    ),
                    hintText: 'Search Discounts',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 15,
                    ),
                    prefixIcon: Container(
                      padding: const EdgeInsets.all(15),
                      width: 25,
                      child: Icon(
                        Icons.search,
                        size: MediaQuery.of(context).size.height * (3 / 100),
                      ),
                    ),
                  ),
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
                      ).extension<AppliedTextIcon>()?.primary,
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
                    dropdownStyleData: DropdownStyleData(
                      maxHeight: 200,
                      width: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    menuItemStyleData: const MenuItemStyleData(height: 88),
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
                          _sortSelection = 'Discount Name';
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
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 48,
            padding: const EdgeInsets.only(right: 16),
            child: ButtonPrimary(
              text: 'Add Discount',
              isNeutral: false,
              onTap: (_) {
                vm.setCurrentProductDiscount!(ProductDiscount.create());
                Navigator.push(
                  context,
                  CustomRoute(
                    builder: (BuildContext ctx) => const ProductDiscountPage(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}

class MenuItem {
  final String text;

  const MenuItem({required this.text});
}

class MenuItems {
  static const List<MenuItem> firstItems = [name, createdDate];

  static const createdDate = MenuItem(text: 'Created Date');
  static const name = MenuItem(text: 'Discount Name');

  static Widget buildItem(
    MenuItem item,
    String sortSelection,
    String sortOrder,
    BuildContext context,
  ) {
    if (sortSelection.toLowerCase() == item.text.toLowerCase()) {
      return Row(
        // mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
            flex: 2,
            child: Text(
              item.text,
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
          ),
          Flexible(
            flex: 1,
            child: Icon(
              sortOrder == 'Descending'
                  ? Icons.arrow_upward
                  : Icons.arrow_downward,
              color: Theme.of(context).colorScheme.secondary,
              // size: 20,
            ),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
            flex: 2,
            child: Text(item.text, style: const TextStyle(color: Colors.black)),
          ),
        ],
      );
    }
  }
}

enum SortOrder { name, createdDate }
