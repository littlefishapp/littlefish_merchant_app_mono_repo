// Flutter imports:
import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/search_text_field.dart';

// Project imports:
import 'package:littlefish_merchant/models/stock/stock_run.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/auto_complete_text_field.dart';
import 'package:quiver/strings.dart';
import '../../../../app/app.dart';
import '../../../../app/theme/applied_system/applied_surface.dart';

class StockTakeList extends StatefulWidget {
  final List<StockRun>? items;

  final StockRun? selectedItem;

  final Function(StockRun employee) onTap;

  const StockTakeList({
    Key? key,
    required this.items,
    this.selectedItem,
    required this.onTap,
  }) : super(key: key);

  @override
  State<StockTakeList> createState() => _StockTakeListState();
}

class _StockTakeListState extends State<StockTakeList> {
  GlobalKey<AutoCompleteTextFieldState<StockRun>>? filterKey;
  late List<StockRun?> _filteredList;
  late List<StockRun?> _sortedList;
  late String _sortOrder;
  late String _sortSelection;
  MenuItem? _currentSelection;
  SortOrder? _selectedOrder;
  TextEditingController searchController = TextEditingController();

  late List<StockRun>? items;

  @override
  void initState() {
    _filteredList = [];
    _sortedList = [];
    _sortOrder = 'Ascending';
    _sortSelection = '';
    items = widget.items;
    filterKey = GlobalKey<AutoCompleteTextFieldState<StockRun>>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    updateFilteredList(items!);
    sortList(items!);
    return layout(context);
  }

  updateFilteredList(List<StockRun?> items) {
    if (isNotBlank(searchController.text) && (items.isNotEmpty)) {
      _filteredList = items
          .where(
            (element) => element!.displayName!.toLowerCase().contains(
              searchController.text.toLowerCase(),
            ),
          )
          .toList();
    }
  }

  sortList(List<StockRun?> items) {
    if (searchController.text == '') {
      _sortedList = items.toList();
    } else if (searchController.text != '') {
      _sortedList = _filteredList.toList();
    }

    if (_selectedOrder == null) {
      _sortedList.sort(((a, b) => b!.dateCreated!.compareTo(a!.dateCreated!)));
    } else if (_selectedOrder != null) {
      switch (_selectedOrder) {
        case SortOrder.name:
          _sortedList.sort(
            ((a, b) => _sortOrder == 'Descending'
                ? b!.displayName!.toLowerCase().compareTo(
                    a!.displayName!.toLowerCase(),
                  )
                : a!.displayName!.toLowerCase().compareTo(
                    b!.displayName!.toLowerCase(),
                  )),
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

  SizedBox topBar(BuildContext context) => SizedBox(
    height: 70.0,
    child: Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(right: 12),
            child: Row(
              children: [
                Flexible(
                  flex: 10,
                  child: SearchTextField(
                    controller: searchController,
                    onChanged: (searchController) {
                      updateFilteredList(items!);
                      if (mounted) setState(() {});
                    },
                    onClear: () {
                      updateFilteredList(items!);
                      if (mounted) setState(() {});
                    },
                    onFieldSubmitted: (searchController) {
                      updateFilteredList(items!);
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
                        color: Theme.of(context).colorScheme.onBackground,
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
          ),
        ],
      ),
    ),
  );

  Column layout(BuildContext context) => Column(
    children: <Widget>[
      topBar(context),
      Expanded(
        child: searchController.text == ''
            ? list(context)
            : filteredList(context),
      ),
    ],
  );

  // layout(BuildContext context) => Column(
  //       children: <Widget>[
  //         FilterAddBar<StockRun>(
  //           onAdd: () => StoreProvider.of<AppState>(context).dispatch(
  //             newStockTake(
  //               type: StockRunType.reCount,
  //               context: context,
  //             ),
  //           ),
  //           filterKey: filterKey,
  //           itemBuilder: (BuildContext context, StockRun suggestion) =>
  //               stockRunTile(context, suggestion),
  //           itemSorter: (a, b) {
  //             return a.displayName!.substring(0, 1).toLowerCase().compareTo(
  //                   b.displayName!.substring(0, 1).toLowerCase(),
  //                 );
  //           },
  //           itemFilter: (suggestion, query) => suggestion.displayName!
  //               .toLowerCase()
  //               .contains(query.toLowerCase()),
  //           itemSubmitted: (StockRun data) {
  //             if (widget.onTap != null) widget.onTap(data);
  //           },
  //           suggestions: items,
  //         ),
  //         Expanded(
  //           child: list(context),
  //         )
  //       ],
  //     );

  ListView list(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return stockRunTile(context, _sortedList[index]!);
      },
      itemCount: _sortedList.length,
    );
  }

  ListView filteredList(BuildContext context) => ListView.builder(
    physics: const BouncingScrollPhysics(),
    shrinkWrap: true,
    itemBuilder: (BuildContext context, int index) =>
        stockRunTile(context, _filteredList[index]!),
    itemCount: _filteredList.length,
  );

  StockRunTile stockRunTile(BuildContext context, StockRun item) {
    return StockRunTile(
      item: item,
      selected: item.id == widget.selectedItem?.id,
      onTap: () {
        widget.onTap(item);
      },
    );
  }
}

class StockRunTile extends StatelessWidget {
  final StockRun item;

  final Function()? onTap;

  final bool selected;

  const StockRunTile({
    Key? key,
    required this.item,
    this.onTap,
    this.selected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: context.labelSmall(
        item.displayName!,
        isBold: true,
        alignLeft: true,
        color: Theme.of(context).extension<AppliedTextIcon>()?.primary,
      ),
      subtitle: context.labelXSmall(
        "${TextFormatter.toShortDate(dateTime: item.dateCreated, format: 'dd/MM/yyy')} - ${item.items?.length.toString() ?? "0"} ${item.items?.length == 1 ? "product" : "products"}",
        alignLeft: true,
        color: Theme.of(context).extension<AppliedTextIcon>()?.secondary,
      ),
      leading: Container(
        width: AppVariables.appDefaultlistItemSize,
        height: AppVariables.appDefaultlistItemSize,
        decoration: BoxDecoration(
          color: Theme.of(context).extension<AppliedSurface>()?.brandSubTitle,
          border: Border.all(color: Colors.transparent, width: 1),
          borderRadius: BorderRadius.circular(AppVariables.appDefaultRadius),
        ),
        child: const Center(child: Icon(Icons.inventory_outlined)),
      ),
      trailing: Icon(
        Platform.isIOS ? Icons.arrow_forward_ios : Icons.arrow_forward,
      ),
      onTap: onTap,
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
  static const name = MenuItem(text: 'Name');

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
