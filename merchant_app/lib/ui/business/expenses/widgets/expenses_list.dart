// Flutter imports:
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/search_text_field.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:littlefish_merchant/models/expenses/business_expense.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/expenses/expenses_actions.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/ui/business/expenses/view_models.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/auto_complete_text_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/long_text.dart';
import 'package:littlefish_merchant/common/presentaion/components/list_leading_tile.dart';
import 'package:littlefish_merchant/common/presentaion/components/new_list_tile.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:quiver/strings.dart';

import '../../../../app/theme/applied_system/applied_text_icon.dart';

class ExpensesList extends StatefulWidget {
  final Function(BusinessExpense item)? onTap;

  final bool canAddNew;
  final BuildContext? parentContext;
  final bool showTopBar;

  const ExpensesList({
    Key? key,
    this.onTap,
    this.canAddNew = true,
    this.parentContext,
    this.showTopBar = true,
  }) : super(key: key);

  @override
  State<ExpensesList> createState() => _ExpensesListState();
}

class _ExpensesListState extends State<ExpensesList> {
  late List<BusinessExpense?> _filteredList;
  late List<BusinessExpense?> _sortedList;

  String _nameSortOrder = 'Ascending'; // Default sort order for expense name
  String _priceSortOrder = 'Descending'; // Default sort order for price
  String _createdDateSortOrder =
      'Descending'; // Default sort order for created date
  // late String _sortOrder;
  // late String _sortSelection;
  // MenuItem? _currentSelection;

  SortOrder? _selectedOrder;
  // late SortOrder? _nameSelectedOrder;
  // late SortOrder? _priceSelectedOrder;
  // late SortOrder? _createdDateSelectedOrder;
  GlobalKey<AutoCompleteTextFieldState<BusinessExpense>>? filterkey;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    _filteredList = [];
    _sortedList = [];
    // _sortOrder = "Ascending";
    _nameSortOrder = 'Descending'; // Set initial sort order for name
    _priceSortOrder = 'Ascending'; // Set initial sort order for price
    _createdDateSortOrder =
        'Descending'; // Set initial sort order for created date
    _selectedOrder = SortOrder.createdDate;

    // _sortSelection = '';
    filterkey = GlobalKey<AutoCompleteTextFieldState<BusinessExpense>>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('### ExpensesList build called');
    return StoreConnector<AppState, ExpensesVM>(
      onInit: (store) {
        store.dispatch(getExpenses());
      },
      converter: (store) => ExpensesVM.fromStore(store),
      builder: (context, vm) {
        updateFilteredList(vm);
        sortList(vm);
        return layout(context, vm);
      },
    );
  }

  updateFilteredList(ExpensesVM vm) {
    if (isNotBlank(searchController.text) && (vm.items!.isNotEmpty)) {
      _filteredList = vm.items!
          .where(
            (element) => element!.displayName!.toLowerCase().contains(
              searchController.text.toLowerCase(),
            ),
          )
          .toList();
    }
  }

  sortList(ExpensesVM vm) {
    if (searchController.text == '') {
      _sortedList = vm.items!.toList();
    } else if (searchController.text != '') {
      _sortedList = _filteredList.toList();
    }

    if (_selectedOrder != null) {
      switch (_selectedOrder) {
        case SortOrder.name:
          _sortedList.sort(
            ((a, b) => _nameSortOrder == 'Descending'
                ? b!.displayName!.toLowerCase().compareTo(
                    a!.displayName!.toLowerCase(),
                  )
                : a!.displayName!.toLowerCase().compareTo(
                    b!.displayName!.toLowerCase(),
                  )),
          );
          break;
        case SortOrder.price:
          _sortedList.sort(
            ((a, b) => _priceSortOrder == 'Descending'
                ? b!.amount!.compareTo(a!.amount!)
                : a!.amount!.compareTo(b!.amount!)),
          );
          break;
        case SortOrder.createdDate:
          _sortedList.sort(
            ((a, b) => _createdDateSortOrder == 'Descending'
                ? b!.dateCreated!.compareTo(a!.dateCreated!)
                : a!.dateCreated!.compareTo(b!.dateCreated!)),
          );
          break;
        default:
      }
    }

    if (searchController.text != '') {
      _filteredList = _sortedList.toList();
    }
  }

  Column layout(context, vm) => Column(
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
        child: vm.isLoading
            ? const AppProgressIndicator()
            : searchController.text == ''
            ? expenseList(context, vm)
            : filteredExpenseList(context, vm),
      ),
    ],
  );

  SizedBox topBar(
    BuildContext context, {
    Function? onAdd,
    required ExpensesVM vm,
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
                child: SearchTextField(
                  controller: searchController,
                  onChanged: (searchController) {
                    updateFilteredList(vm);
                    if (mounted) setState(() {});
                  },
                  onFieldSubmitted: (searchController) {
                    updateFilteredList(vm);
                    if (mounted) setState(() {});
                  },
                  onClear: () {
                    updateFilteredList(vm);
                    if (mounted) setState(() {});
                  },
                  useOutlineStyling: false,
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
                      ).extension<AppliedTextIcon>()?.secondary,
                    ),
                    items: [
                      ...MenuItems.firstItems.map(
                        (item) => DropdownMenuItem<MenuItem>(
                          value: item,
                          child: MenuItems.buildItem(
                            item,
                            _getSortSelection(item),
                            _getSortOrder(item),
                            // _sortSelection,
                            // _sortOrder,
                            context,
                          ),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      // if (_currentSelection == null ||
                      //     value != _currentSelection) {
                      //   _sortOrder = "Ascending";
                      // }
                      // if (value == _currentSelection &&
                      //     _sortOrder == "Ascending") {
                      //   _sortOrder = "Descending";
                      // } else if (value == _currentSelection &&
                      //     _sortOrder == "Descending") {
                      //   _sortOrder = "Ascending";
                      // }

                      // switch (value) {
                      //   case MenuItems.name:
                      //     _selectedOrder = SortOrder.name;
                      //     _sortSelection = "Expense Name";
                      //     _currentSelection = MenuItems.name;
                      //     break;
                      //   case MenuItems.price:
                      //     _selectedOrder = SortOrder.price;
                      //     _sortSelection = "Price";
                      //     _currentSelection = MenuItems.price;
                      //     break;
                      //   case MenuItems.createdDate:
                      //     _selectedOrder = SortOrder.createdDate;
                      //     _sortSelection = "Created Date";
                      //     _currentSelection = MenuItems.createdDate;
                      //     break;
                      // }
                      // Update the selected order based on the chosen sorting option
                      if (value != null) {
                        setState(() {
                          switch (value) {
                            case MenuItems.name:
                              _selectedOrder = SortOrder.name;
                              break;
                            case MenuItems.price:
                              _selectedOrder = SortOrder.price;
                              break;
                            case MenuItems.createdDate:
                              _selectedOrder = SortOrder.createdDate;
                              break;
                          }
                        });
                        // Update the sort order for the selected item
                        _updateSortOrder(value as MenuItem);
                        // Update the sort selection
                        _updateSortSelection(value);
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

  // Function to get the sort selection for a specific item
  String _getSortSelection(MenuItem item) {
    switch (item) {
      case MenuItems.name:
        return 'Expense Name';
      case MenuItems.price:
        return 'Price';
      case MenuItems.createdDate:
        return 'Created Date';
      default:
        return '';
    }
  }

  // Function to get the sort order for a specific item
  String _getSortOrder(MenuItem item) {
    switch (item) {
      case MenuItems.name:
        return _nameSortOrder;
      case MenuItems.price:
        return _priceSortOrder;
      case MenuItems.createdDate:
        return _createdDateSortOrder;
      default:
        return '';
    }
  }

  // Function to update the sort order and selected order based on the selected item
  void _updateSortOrder(MenuItem? value) {
    if (value == null) return;
    switch (value) {
      case MenuItems.name:
        _nameSortOrder = _nameSortOrder == 'Ascending'
            ? 'Descending'
            : 'Ascending';
        // _nameSelectedOrder = SortOrder.name;
        break;
      case MenuItems.price:
        _priceSortOrder = _priceSortOrder == 'Ascending'
            ? 'Descending'
            : 'Ascending';
        // _priceSelectedOrder = SortOrder.price;
        break;
      case MenuItems.createdDate:
        _createdDateSortOrder = _createdDateSortOrder == 'Ascending'
            ? 'Descending'
            : 'Ascending';
        // _createdDateSelectedOrder = SortOrder.createdDate;
        break;
    }
  }

  // Function to update the sort selection based on the selected item
  void _updateSortSelection(MenuItem? value) {
    if (value == null) return;
    switch (value) {
      case MenuItems.name:
        // _sortSelection = 'Expense Name';
        break;
      case MenuItems.price:
        // _sortSelection = 'Price';
        break;
      case MenuItems.createdDate:
        // _sortSelection = 'Created Date';
        break;
    }
  }

  Container expenseList(BuildContext context, ExpensesVM vm) => Container(
    child: vm.isLoading!
        ? const AppProgressIndicator()
        : ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemCount: (widget.canAddNew
                ? (_sortedList.length) + 1
                : _sortedList.length),
            itemBuilder: (BuildContext context, int index) {
              if (widget.canAddNew && index == 0) {
                return NewItemTile(
                  title: 'New Expense',
                  onTap: () => captureExpense(context, vm),
                );
              } else {
                BusinessExpense? item = widget.canAddNew
                    ? _sortedList[index - 1]
                    : _sortedList[index];

                return ExpenseTile(
                  item: item,
                  dismissAllowed: widget.canAddNew,
                  selected: vm.selectedItem == item,
                  onTap: (item) {
                    if (widget.onTap == null) {
                      captureExpense(context, vm, expense: item);
                    } else {
                      widget.onTap!(item);
                    }
                  },
                  onRemove: (item) {
                    vm.onRemove(item, widget.parentContext ?? context);
                  },
                );
              }
            },
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(height: 8),
          ),
  );

  Container filteredExpenseList(BuildContext context, ExpensesVM vm) =>
      Container(
        child: vm.isLoading!
            ? const AppProgressIndicator()
            : ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: (widget.canAddNew
                    ? (_filteredList.length) + 1
                    : _filteredList.length),
                itemBuilder: (BuildContext context, int index) {
                  if (widget.canAddNew && index == 0) {
                    return NewItemTile(
                      title: 'New Expense',
                      onTap: () => captureExpense(context, vm),
                    );
                  } else {
                    BusinessExpense? item = widget.canAddNew
                        ? _filteredList[index - 1]
                        : _filteredList[index];

                    return ExpenseTile(
                      item: item,
                      dismissAllowed: widget.canAddNew,
                      selected: vm.selectedItem == item,
                      onTap: (item) {
                        if (widget.onTap == null) {
                          captureExpense(context, vm, expense: item);
                        } else {
                          widget.onTap!(item);
                        }
                      },
                      onRemove: (item) {
                        vm.onRemove(item, widget.parentContext ?? context);
                      },
                    );
                  }
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(height: 8),
              ),
      );

  Future<void> captureExpense(
    BuildContext context,
    ExpensesVM vm, {
    BusinessExpense? expense,
  }) async {
    if (expense != null) {
      vm.store!.dispatch(editExpense(context, expense));
    } else {
      vm.store!.dispatch(createExpense(context));
    }
  }
}

class ExpenseTile extends StatelessWidget {
  const ExpenseTile({
    Key? key,
    required this.item,
    this.onTap,
    this.dismissAllowed = false,
    this.onRemove,
    this.selected = false,
  }) : super(key: key);

  final bool selected;

  final BusinessExpense? item;

  final bool dismissAllowed;

  final Function(BusinessExpense item)? onTap;

  final Function(BusinessExpense item)? onRemove;

  @override
  Widget build(BuildContext context) {
    return dismissAllowed
        ? dismissibleExpenseTile(context, item!)
        : expenseTile(context, item!);
  }

  Slidable dismissibleExpenseTile(BuildContext context, BusinessExpense item) =>
      Slidable(
        key: Key(item.id!),
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
        child: expenseTile(context, item),
      );

  ListTile expenseTile(BuildContext context, BusinessExpense item) => ListTile(
    tileColor: Theme.of(context).colorScheme.background,
    dense: !EnvironmentProvider.instance.isLargeDisplay!,
    selected: selected,
    leading: ListLeadingIconTile(
      icon: MdiIcons.accountCash,
      color: (item.deleted ?? false) ? Colors.orange : null,
    ),
    title: Text(item.displayName!),
    subtitle: item.deleted!
        ? LongText("${item.description ?? ''} (Deleted)", maxLines: 3)
        : LongText(item.description ?? '', maxLines: 3),
    trailing: context.labelXSmall(TextFormatter.toStringCurrency(item.amount)),
    onTap: onTap == null
        ? null
        : () {
            if (onTap != null) onTap!(item);
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
  static const name = MenuItem(text: 'Expense Name');
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
