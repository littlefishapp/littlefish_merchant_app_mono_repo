import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/common/presentaion/components/customer_select_item.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';

import 'package:quiver/strings.dart';
import 'package:littlefish_merchant/models/customers/customer.dart';
import 'package:littlefish_merchant/ui/customers/viewmodels/customer_view_models.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/auto_complete_text_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/list_leading_tile.dart';

import '../../../app/theme/applied_system/applied_text_icon.dart';
import '../../../common/presentaion/components/form_fields/search_text_field.dart';

class CustomerList extends StatefulWidget {
  final Function(Customer customer) onTap;

  final CustomersViewModel vm;

  final bool showTotals;

  const CustomerList({
    Key? key,
    required this.onTap,
    required this.vm,
    this.showTotals = true,
  }) : super(key: key);

  @override
  State<CustomerList> createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  late List<Customer> _filteredList;
  late List<Customer> _sortedList;
  late String _sortOrder;
  late String _sortSelection;
  MenuItem? _currentSelection;
  SortOrder? _selectedOrder;

  TextEditingController searchController = TextEditingController();

  GlobalKey<AutoCompleteTextFieldState<Customer>> filterKey =
      GlobalKey<AutoCompleteTextFieldState<Customer>>();

  @override
  void initState() {
    _filteredList = [];
    _sortedList = [];
    _sortOrder = 'Ascending';
    _sortSelection = '';
    super.initState();
  }

  late CustomersViewModel vm;

  @override
  Widget build(BuildContext context) {
    vm = widget.vm;

    sortList(vm);

    return Column(
      children: <Widget>[
        topBar(context, vm: vm),
        Expanded(
          child: searchController.text == ''
              ? customerList(context)
              : filteredCustomerList(context),
        ),
      ],
    );
  }

  sortList(CustomersViewModel vm) {
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

  ListView customerList(BuildContext context) => ListView.builder(
    physics: const BouncingScrollPhysics(),
    itemBuilder: (BuildContext context, int index) {
      if (index == 0) {
        return const SizedBox();
      } else {
        Customer item = _sortedList[index - 1];
        return CustomerSelectItem(
          id: item.id ?? '',
          item: item,
          title: item.displayName ?? '',
          subtitle:
              'Last visit: '
              '${TextFormatter.toShortDate(dateTime: item.lastPurchaseDate ?? DateTime.now())}',
          onTap: () => widget.onTap(item),
          showTrailingIcon: true,
          imageUrl: item.profileImageUri ?? '',
        );
      }
    },
    itemCount: _sortedList.length + 1,
  );

  ListView filteredCustomerList(BuildContext context) => ListView.builder(
    physics: const BouncingScrollPhysics(),
    itemBuilder: (BuildContext context, int index) {
      if (index == 0) {
        return const SizedBox();
      } else {
        Customer item = _filteredList[index - 1];
        return CustomerSelectItem(
          id: item.id ?? '',
          item: item,
          title: item.displayName ?? '',
          subtitle:
              'Last visit: '
              '${TextFormatter.toShortDate(dateTime: item.lastPurchaseDate ?? DateTime.now())}',
          onTap: () => widget.onTap(item),
          showTrailingIcon: true,
          selected: vm.selectedItem == item,
        );
      }
    },
    itemCount: _filteredList.length + 1,
  );

  SizedBox topBar(BuildContext context, {required CustomersViewModel vm}) =>
      SizedBox(
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
                      onClear: () {
                        _filteredList = [];
                        if (mounted) setState(() {});
                      },
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
                              _sortSelection = 'Customer Name';
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
                          width: 185,
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
}

class CustomerTile extends StatelessWidget {
  final Customer item;
  final bool dismissAllowed;
  final Function(Customer item)? onRemove;
  final bool showTotal = true;

  final Function(Customer item)? onTap;

  final bool selected;

  const CustomerTile({
    Key? key,
    required this.item,
    this.onTap,
    this.selected = false,
    this.dismissAllowed = false,
    this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return dismissAllowed
        ? dismissibleCustomerTile(context)
        : customerTile(context);
  }

  Slidable dismissibleCustomerTile(BuildContext context) => Slidable(
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
    child: customerTile(context),
  );

  ListTile customerTile(context) => ListTile(
    tileColor: Theme.of(context).colorScheme.background,
    onTap: onTap != null ? () => onTap!(item) : null,
    selected: selected,
    leading: isNotBlank(item.profileImageUri)
        ? ListLeadingImageTile(url: item.profileImageUri)
        : Container(
            width: AppVariables.appDefaultlistItemSize,
            height: AppVariables.appDefaultlistItemSize,
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).extension<AppliedSurface>()?.brandSubTitle,
              border: Border.all(color: Colors.transparent, width: 1),
              borderRadius: BorderRadius.circular(
                AppVariables.appDefaultRadius,
              ),
            ),
            child: Center(
              child: context.labelLarge(
                (item.displayName ?? '??').substring(0, 2).toUpperCase(),
                isSemiBold: true,
              ),
            ),
          ),
    title: context.labelSmall(
      item.displayName ?? 'No Name',
      isBold: true,
      alignLeft: true,
      color: Theme.of(context).extension<AppliedTextIcon>()?.primary,
    ),
    subtitle: context.labelXSmall(
      item.lastPurchaseDate == null
          ? 'No Last Visit'
          : 'Last visit: '
                '${DateFormat.yMMMd().format(item.lastPurchaseDate!)}',
      alignLeft: true,
      color: Theme.of(context).extension<AppliedTextIcon>()?.secondary,
    ),
    trailing: Icon(
      Platform.isIOS ? Icons.arrow_forward_ios : Icons.arrow_forward,
      color: Theme.of(context).colorScheme.primary,
    ),
  );
}

class MenuItem {
  final String text;

  const MenuItem({required this.text});
}

class MenuItems {
  static const List<MenuItem> firstItems = [name, createdDate];

  static const name = MenuItem(text: 'Customer Name');
  static const createdDate = MenuItem(text: 'Created Date');

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

enum SortOrder { name, createdDate }
