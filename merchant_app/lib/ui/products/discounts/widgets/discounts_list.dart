import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_discount.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/discounts/discounts_actions.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/ui/products/discounts/view_models/discount_collection_vm.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/auto_complete_text_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/new_list_tile.dart';
import 'package:quiver/strings.dart';

import '../../../../app/theme/applied_system/applied_text_icon.dart';
import '../../../../common/presentaion/components/long_text.dart';
import '../../../../common/presentaion/components/text_tag.dart';
import '../../../../common/presentaion/components/app_progress_indicator.dart';

class DiscountsList extends StatefulWidget {
  final Function(CheckoutDiscount item)? onTap;
  final Function(CheckoutDiscount item)? onRemove;
  final bool allowAddOnList;
  final bool readOnly;

  const DiscountsList({
    Key? key,
    this.onTap,
    this.readOnly = false,
    this.onRemove,
    this.allowAddOnList = false,
  }) : super(key: key);

  @override
  State<DiscountsList> createState() => _DiscountsListState();
}

class _DiscountsListState extends State<DiscountsList> {
  GlobalKey<AutoCompleteTextFieldState<CheckoutDiscount>>? filterkey;
  late List<CheckoutDiscount> _filteredList;
  late List<CheckoutDiscount> _sortedList;
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
    filterkey = GlobalKey<AutoCompleteTextFieldState<CheckoutDiscount>>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, DiscountsVM>(
      onInit: (store) => store.dispatch(getDiscounts(refresh: true)),
      converter: (store) => DiscountsVM.fromStore(store),
      builder: (BuildContext ctx, vm) {
        sortList(vm);
        return layout(context, vm);
      },
    );
  }

  sortList(DiscountsVM vm) {
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

    if (searchController.text != '') {
      _filteredList = _sortedList.toList();
    }
  }

  Container layout(context, DiscountsVM vm) => Container(
    child: vm.isLoading!
        ? const AppProgressIndicator()
        : Column(
            children: <Widget>[
              topBar(context, vm),
              Expanded(
                child: searchController.text == ''
                    ? discountList(context, vm)
                    : filteredDiscountList(context, vm),
              ),
            ],
          ),
  );

  Widget topBar(BuildContext context, DiscountsVM vm, {Function? onAdd}) {
    return Container(
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
                    if (isNotBlank(searchController) &&
                        (vm.items!.isNotEmpty)) {
                      _filteredList = vm.items!
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
    );
  }

  captureDiscount(context, CheckoutDiscount? item) async {
    if (item == null) {
      StoreProvider.of<AppState>(
        context,
      ).dispatch(createDiscount(context: context));
    } else {
      StoreProvider.of<AppState>(
        context,
      ).dispatch(editDiscount(item, context: context));
    }
  }

  ListView discountList(context, DiscountsVM vm) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: widget.allowAddOnList
          ? (_sortedList.length) + ((widget.readOnly) ? 0 : 1)
          : _sortedList.length,
      itemBuilder: (BuildContext ctx, int index) {
        if (widget.allowAddOnList) {
          if (!widget.readOnly && index == 0) {
            return NewItemTile(
              title: 'New Discount',
              onTap: () => captureDiscount(ctx, null),
            );
          } else {
            CheckoutDiscount item = widget.readOnly
                ? _sortedList[index]
                : _sortedList[index - 1];

            return DiscountTile(
              item: item,
              selected: vm.selectedItem == item,
              onRemove: (item) {
                if (widget.onRemove != null) {
                  widget.onRemove!(item);
                } else {
                  AppVariables.store!.dispatch(deleteDiscount(item: item));
                }
              },
              onTap: () {
                if (widget.onTap != null) {
                  widget.onTap!(item);
                } else {
                  captureDiscount(ctx, item);
                }
              },
            );
          }
        } else {
          CheckoutDiscount item = _sortedList[index];
          return DiscountTile(
            item: item,
            selected: vm.selectedItem == item,
            onRemove: (item) {
              if (widget.onRemove != null) {
                widget.onRemove!(item);
              } else {
                AppVariables.store!.dispatch(deleteDiscount(item: item));
              }
            },
            onTap: () {
              if (widget.onTap != null) {
                widget.onTap!(item);
              } else {
                captureDiscount(ctx, item);
              }
            },
          );
        }
      },
    );
  }

  ListView filteredDiscountList(context, DiscountsVM vm) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: widget.allowAddOnList
          ? (_sortedList.length) + ((widget.readOnly) ? 0 : 1)
          : _sortedList.length,
      itemBuilder: (BuildContext ctx, int index) {
        if (widget.allowAddOnList) {
          if (!widget.readOnly && index == 0) {
            return NewItemTile(
              title: 'New Discount',
              onTap: () => captureDiscount(ctx, null),
            );
          } else {
            CheckoutDiscount item = widget.readOnly
                ? _filteredList[index]
                : _filteredList[index - 1];

            return DiscountTile(
              item: item,
              selected: vm.selectedItem == item,
              onRemove: (item) {
                if (widget.onRemove != null) {
                  widget.onRemove!(item);
                } else {
                  AppVariables.store!.dispatch(deleteDiscount(item: item));
                }
              },
              onTap: () {
                if (widget.onTap != null) {
                  widget.onTap!(item);
                } else {
                  captureDiscount(ctx, item);
                }
              },
            );
          }
        } else {
          CheckoutDiscount item = _filteredList[index];
          return DiscountTile(
            item: item,
            selected: vm.selectedItem == item,
            onRemove: (item) {
              if (widget.onRemove != null) {
                widget.onRemove!(item);
              } else {
                AppVariables.store!.dispatch(deleteDiscount(item: item));
              }
            },
            onTap: () {
              if (widget.onTap != null) {
                widget.onTap!(item);
              } else {
                captureDiscount(ctx, item);
              }
            },
          );
        }
      },
    );
  }
}

class DiscountTile extends StatelessWidget {
  final CheckoutDiscount item;

  final bool selected;

  final Function? onTap;

  final Function? onRemove;

  const DiscountTile({
    Key? key,
    required this.item,
    this.selected = false,
    this.onTap,
    this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: onRemove == null
          ? null
          : ActionPane(
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
      child: ListTile(
        tileColor: Theme.of(context).colorScheme.background,
        selected: selected,
        leading: Container(
          alignment: Alignment.center,
          width: EnvironmentProvider.instance.isLargeDisplay!
              ? MediaQuery.of(context).size.width * 0.06
              : MediaQuery.of(context).size.width * 0.15,
          height: (MediaQuery.of(context).size.width * 0.15) * 0.65,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(4),
          ),
          child: LongText(
            item.type == DiscountType.percentage ? '%' : 'F.A',
            alignment: TextAlign.center,
            textColor: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: const Text(''),
        title: Text(item.displayName!),
        trailing: TextTag(
          displayText: item.type == DiscountType.fixedAmount
              ? TextFormatter.toStringCurrency(item.value, currencyCode: '')
              : '${item.value}%',
        ),
        onTap: () {
          if (onTap != null) onTap!();
        },
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
  static const name = MenuItem(text: 'Discount Name');

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
