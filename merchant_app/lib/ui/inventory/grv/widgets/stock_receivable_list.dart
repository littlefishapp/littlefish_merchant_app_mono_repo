// Flutter imports:
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

// Project imports:
import 'package:littlefish_merchant/models/stock/goods_received_voucher.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/inventory/inventory_actions.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/ui/inventory/view_models/view_models.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/auto_complete_text_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/common/presentaion/components/long_text.dart';
import 'package:littlefish_merchant/common/presentaion/components/text_tag.dart';
import 'package:littlefish_merchant/common/presentaion/components/new_list_tile.dart';
import 'package:quiver/strings.dart';

class GoodsRecievableList extends StatefulWidget {
  final List<GoodsRecievedVoucher>? items;

  final GoodsRecievedVoucher? selectedItem;

  final Function(GoodsRecievedVoucher data) onTap;

  const GoodsRecievableList({
    Key? key,
    required this.items,
    this.selectedItem,
    required this.onTap,
  }) : super(key: key);

  @override
  State<GoodsRecievableList> createState() => _GoodsRecievableListState();
}

class _GoodsRecievableListState extends State<GoodsRecievableList> {
  GlobalKey<AutoCompleteTextFieldState<GoodsRecievedVoucher>>? filterKey;

  late List<GoodsRecievedVoucher> _filteredList;
  late List<GoodsRecievedVoucher> _sortedList;
  late String _sortOrder;
  late String _sortSelection;
  MenuItem? _currentSelection;
  SortOrder? _selectedOrder;
  TextEditingController searchController = TextEditingController();

  late List<GoodsRecievedVoucher>? items;

  @override
  void initState() {
    items = widget.items;
    _filteredList = [];
    _sortedList = [];
    _sortOrder = 'Ascending';
    _sortSelection = '';
    filterKey = GlobalKey<AutoCompleteTextFieldState<GoodsRecievedVoucher>>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, GRVVM>(
      builder: (context, vm) {
        updateFilteredList(items!);
        sortList(items!);
        return layout(context, vm);
      },
      converter: (store) => GRVVM.fromStore(store),
    );
  }

  updateFilteredList(List<GoodsRecievedVoucher> items) {
    if (isNotBlank(searchController.text) && (items.isNotEmpty)) {
      _filteredList = items
          .where(
            (element) => element.displayName!.toLowerCase().contains(
              searchController.text.toLowerCase(),
            ),
          )
          .toList();
    }
  }

  sortList(List<GoodsRecievedVoucher> items) {
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
        case SortOrder.price:
          _sortedList.sort(
            ((a, b) => _sortOrder == 'Descending'
                ? b.invoiceAmount!.compareTo(a.invoiceAmount!)
                : a.invoiceAmount!.compareTo(b.invoiceAmount!)),
          );
          break;
        default:
      }
    }

    if (searchController.text != '') {
      _filteredList = _sortedList.toList();
    }
  }

  SizedBox topBar(BuildContext context) => SizedBox(
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
                      color: Theme.of(context).colorScheme.primary,
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
                          _sortSelection = 'Name';
                          _currentSelection = MenuItems.name;
                          break;
                        case MenuItems.createdDate:
                          _selectedOrder = SortOrder.createdDate;
                          _sortSelection = 'Created Date';
                          _currentSelection = MenuItems.createdDate;
                          break;
                        case MenuItems.price:
                          _selectedOrder = SortOrder.price;
                          _sortSelection = 'Price';
                          _currentSelection = MenuItems.price;
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
    ),
  );

  Column layout(BuildContext context, GRVVM vm) => Column(
    children: <Widget>[
      topBar(context),
      Expanded(
        child: searchController.text == ''
            ? list(context, vm)
            : filteredList(context, vm),
      ),
    ],
  );

  ListView list(BuildContext context, GRVVM vm) => ListView.separated(
    physics: const BouncingScrollPhysics(),
    shrinkWrap: true,
    itemBuilder: (BuildContext context, int index) => index == 0
        ? NewItemTile(
            title: 'New Goods Received',
            onTap: () => StoreProvider.of<AppState>(
              context,
            ).dispatch(newGoodsRecievable(context)),
          )
        : tile(context, _sortedList[index - 1], vm),
    itemCount: (_sortedList.length) + 1,
    separatorBuilder: (BuildContext context, int index) =>
        const CommonDivider(),
  );

  ListView filteredList(BuildContext context, GRVVM vm) => ListView.separated(
    physics: const BouncingScrollPhysics(),
    shrinkWrap: true,
    itemBuilder: (BuildContext context, int index) => index == 0
        ? NewItemTile(
            title: 'New Goods Received',
            onTap: () => StoreProvider.of<AppState>(
              context,
            ).dispatch(newGoodsRecievable(context)),
          )
        : tile(context, _filteredList[index - 1], vm),
    itemCount: (_filteredList.length) + 1,
    separatorBuilder: (BuildContext context, int index) =>
        const CommonDivider(),
  );

  GRVTile tile(BuildContext context, GoodsRecievedVoucher item, GRVVM vm) {
    return GRVTile(
      onRemove: (item) {
        vm.removeItem(item, context);
      },
      item: item,
      selected: item.id == widget.selectedItem?.id,
      onTap: () {
        widget.onTap(item);
      },
    );
  }
}

class GRVTile extends StatelessWidget {
  final GoodsRecievedVoucher item;

  final Function()? onTap;

  final Function(GoodsRecievedVoucher item)? onRemove;

  final bool selected;

  const GRVTile({
    Key? key,
    required this.item,
    this.onTap,
    this.selected = false,
    this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
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
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: ListTile(
        tileColor: Theme.of(context).colorScheme.background,
        onTap: onTap,
        selected: selected,
        title: Text(item.displayName ?? 'Goods Received'),
        subtitle: LongText(
          "Completed on ${TextFormatter.toShortDate(dateTime: item.dateCreated, format: "dd MMMM yyy")}, by: ${item.receivedBy}, invoice: ${item.invoiceReference}",
          maxLines: 3,
        ),
        trailing: TextTag(
          displayText: TextFormatter.toStringCurrency(
            item.receivablesValue,
            currencyCode: '',
          ),
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
  static const List<MenuItem> firstItems = [name, createdDate, price];

  static const createdDate = MenuItem(text: 'Created Date');
  static const name = MenuItem(text: 'Name');
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

enum SortOrder { name, createdDate, price }
