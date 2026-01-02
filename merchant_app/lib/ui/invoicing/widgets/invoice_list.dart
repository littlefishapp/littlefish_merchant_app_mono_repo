import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:littlefish_merchant/models/suppliers/supplier_invoice.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/invoice/invoice_actions.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/auto_complete_text_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/long_text.dart';
import 'package:littlefish_merchant/common/presentaion/components/text_tag.dart';
import 'package:littlefish_merchant/common/presentaion/components/list_leading_tile.dart';
import 'package:littlefish_merchant/common/presentaion/components/new_list_tile.dart';
import 'package:quiver/strings.dart';

import '../../../app/theme/applied_system/applied_surface.dart';

class InvoiceList extends StatefulWidget {
  final List<SupplierInvoice>? items;
  final bool allowAddNewOnList;

  final SupplierInvoice? selectedItem;

  final Function(SupplierInvoice supplier) onTap;

  const InvoiceList({
    Key? key,
    required this.items,
    this.selectedItem,
    required this.onTap,
    this.allowAddNewOnList = false,
  }) : super(key: key);

  @override
  State<InvoiceList> createState() => _InvoiceListState();
}

class _InvoiceListState extends State<InvoiceList> {
  final GlobalKey<AutoCompleteTextFieldState<SupplierInvoice>> filterKey =
      GlobalKey<AutoCompleteTextFieldState<SupplierInvoice>>();
  late List<SupplierInvoice?> _filteredList;
  late List<SupplierInvoice?> _sortedList;
  late String _sortOrder;
  late String _sortSelection;
  MenuItem? _currentSelection;
  SortOrder? _selectedOrder;
  TextEditingController searchController = TextEditingController();
  late List<SupplierInvoice>? items;

  @override
  void initState() {
    _filteredList = [];
    _sortedList = [];
    _sortOrder = 'Ascending';
    _sortSelection = '';
    items = widget.items;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    updateFilteredList(items!);
    sortList(items!);
    return layout(context);
  }

  updateFilteredList(List<SupplierInvoice?> items) {
    if (isNotBlank(searchController.text) && (items.isNotEmpty)) {
      _filteredList = items
          .where(
            (element) => element!.reference!.toLowerCase().contains(
              searchController.text.toLowerCase(),
            ),
          )
          .toList();
    }
  }

  sortList(List<SupplierInvoice?> items) {
    if (searchController.text == '') {
      _sortedList = items.toList();
    } else if (searchController.text != '') {
      _sortedList = _filteredList.toList();
    }

    if (_selectedOrder != null) {
      switch (_selectedOrder) {
        case SortOrder.name:
          _sortedList.sort(
            ((a, b) => _sortOrder == 'Descending'
                ? b!.reference!.toLowerCase().compareTo(
                    a!.reference!.toLowerCase(),
                  )
                : a!.reference!.toLowerCase().compareTo(
                    b!.reference!.toLowerCase(),
                  )),
          );
          break;
        case SortOrder.invoiceCost:
          _sortedList.sort(
            ((a, b) => _sortOrder == 'Descending'
                ? b!.amount!.compareTo(a!.amount!)
                : a!.amount!.compareTo(b!.amount!)),
          );
          break;
        case SortOrder.createdDate:
          _sortedList.sort(
            ((a, b) => _sortOrder == 'Descending'
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

  Widget topBar(BuildContext context) {
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
                    updateFilteredList(items!);
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
                      ).extension<AppliedSurface>()?.brand,
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
                          _sortSelection = 'Invoice Name';
                          _currentSelection = MenuItems.name;
                          break;
                        case MenuItems.invoiceCost:
                          _selectedOrder = SortOrder.invoiceCost;
                          _sortSelection = 'Invoice Cost';
                          _currentSelection = MenuItems.invoiceCost;
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
    );
  }

  Column layout(BuildContext context) => Column(
    children: <Widget>[
      topBar(context),
      Expanded(
        child: searchController.text == ''
            ? invoiceList(context)
            : filteredInvoiceList(context),
      ),
    ],
  );

  ListView invoiceList(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.allowAddNewOnList
          ? _sortedList.length + 1
          : _sortedList.length,
      itemBuilder: (BuildContext context, int index) {
        if (widget.allowAddNewOnList) {
          return index == 0
              ? NewItemTile(
                  title: 'New Invoice',
                  onTap: () => addInvoice(context),
                )
              : invoiceTile(context, _sortedList[index - 1]!);
        } else {
          return invoiceTile(context, _sortedList[index]!);
        }
      },
    );
  }

  ListView filteredInvoiceList(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) => index == 0
          ? NewItemTile(title: 'New Invoice', onTap: () => addInvoice(context))
          : invoiceTile(context, _filteredList[index - 1]!),
      itemCount: (_filteredList.length) + 1,
    );
  }

  InvoiceTile invoiceTile(BuildContext context, SupplierInvoice item) {
    return InvoiceTile(
      item: item,
      selected: item.id == widget.selectedItem?.id,
      onTap: () {
        widget.onTap(item);
      },
    );
  }

  addInvoice(BuildContext context) async {
    StoreProvider.of<AppState>(context).dispatch(createInvoice(context));
  }
}

class MenuItem {
  final String text;

  const MenuItem({required this.text});
}

class MenuItems {
  static const List<MenuItem> firstItems = [name, invoiceCost, createdDate];

  static const createdDate = MenuItem(text: 'Created Date');
  static const name = MenuItem(text: 'Invoice Name');
  static const invoiceCost = MenuItem(text: 'Invoice Cost');

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

enum SortOrder { name, invoiceCost, createdDate }

class InvoiceTile extends StatelessWidget {
  final SupplierInvoice item;

  final Function()? onTap;

  final bool selected;

  const InvoiceTile({
    Key? key,
    required this.item,
    this.onTap,
    this.selected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Theme.of(context).colorScheme.background,
      leading: ListLeadingIconTile(icon: MdiIcons.receipt),
      dense: !EnvironmentProvider.instance.isLargeDisplay!,
      onTap: onTap,
      selected: selected,
      title: Text(item.reference!),
      subtitle: LongText(
        '${item.supplierName}, due on ${TextFormatter.toShortDate(dateTime: item.invoiceDate)}',
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          LongText(
            TextFormatter.toShortDate(
              dateTime: item.dateCreated,
              format: 'dd MMM yyy',
            ),
            fontSize: 8,
          ),
          TextTag(
            displayText: TextFormatter.toStringCurrency(
              item.amount,
              currencyCode: '',
            ),
          ),
        ],
      ),
    );
  }
}
