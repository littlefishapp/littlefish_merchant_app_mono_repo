import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:littlefish_merchant/models/suppliers/supplier.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/suppliers/supplier_actions.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/auto_complete_text_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/decorated_text.dart';
import 'package:littlefish_merchant/common/presentaion/components/long_text.dart';
import 'package:littlefish_merchant/common/presentaion/components/list_leading_tile.dart';
import 'package:littlefish_merchant/common/presentaion/components/new_list_tile.dart';
import 'package:littlefish_merchant/ui/suppliers/view_models/view_models.dart';
import 'package:quiver/strings.dart';

class SupplierList extends StatefulWidget {
  final Function(Supplier? supplier) onTap;

  // final Supplier selectedItem;

  final SuppliersVM? vm;

  final bool canAddNew;

  final BuildContext? parentContext;

  const SupplierList({
    Key? key,
    required this.onTap,
    this.canAddNew = true,
    this.vm,
    this.parentContext,
  }) : super(key: key);

  @override
  State<SupplierList> createState() => _SupplierListState();
}

class _SupplierListState extends State<SupplierList> {
  late List<Supplier?> _filteredList;
  late List<Supplier?> _sortedList;
  late String _sortOrder;
  late String _sortSelection;
  MenuItem? _currentSelection;
  SortOrder? _selectedOrder;
  final GlobalKey<AutoCompleteTextFieldState<Supplier>> filterKey =
      GlobalKey<AutoCompleteTextFieldState<Supplier>>();

  late SuppliersVM vm;
  bool isTablet = false;

  TextEditingController searchController = TextEditingController();
  GlobalKey? newItemKey;
  @override
  void initState() {
    _filteredList = [];
    _sortedList = [];
    _sortOrder = 'Ascending';
    _sortSelection = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isTablet = EnvironmentProvider.instance.isLargeDisplay ?? false;
    return StoreConnector<AppState, SuppliersVM>(
      // onInit: (store) {
      //   store.dispatch(getSuppliers());
      // },
      converter: (store) => SuppliersVM.fromStore(store),
      builder: (context, SuppliersVM vm) {
        this.vm = vm;
        updateFilteredList(vm);
        sortList(vm);
        return layout(context, vm);
      },
    );
  }

  updateFilteredList(SuppliersVM vm) {
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

  sortList(SuppliersVM vm) {
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

  Column layout(BuildContext context, vm) => Column(
    children: <Widget>[
      topBar(context),
      Expanded(
        flex: 20,
        child: vm.isLoading
            ? const AppProgressIndicator()
            : searchController.text == ''
            ? supplierList(context, vm)
            : filteredSupplierList(context, vm),
      ),
    ],
  );

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
                          _sortSelection = 'Product Name';
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
    ),
  );

  ListView supplierList(BuildContext context, SuppliersVM vm) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: widget.canAddNew
          ? (_sortedList.length) + 1
          : _sortedList.length,
      itemBuilder: (BuildContext ctx, int index) {
        Supplier? item;
        if (widget.canAddNew) {
          if (index == 0) {
            return NewItemTile(
              title: 'New Supplier',
              onTap: () => addSupplier(context),
            );
          } else {
            item = _sortedList[index - 1];
          }
        } else {
          item = _sortedList[index];
        }
        return SupplierTile(
          item: item,
          onTap: widget.onTap,
          dismissAllowed: widget.canAddNew,
          selected: vm.selectedItem == item,
          onRemove: (item) {
            vm.onRemove(item, widget.parentContext ?? ctx);
          },
        );
      },
    );
  }

  ListView filteredSupplierList(BuildContext context, SuppliersVM vm) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: (widget.canAddNew
          ? (_filteredList.length) + 1
          : _filteredList.length),
      itemBuilder: (BuildContext ctx, int index) {
        Supplier? item;
        if (widget.canAddNew) {
          if (index == 0) {
            return NewItemTile(
              title: 'New Supplier',
              onTap: () => addSupplier(context),
            );
          } else {
            item = _filteredList[index - 1];
          }
        } else {
          item = _filteredList[index];
        }
        return SupplierTile(
          item: item,
          onTap: widget.onTap,
          dismissAllowed: widget.canAddNew,
          selected: vm.selectedItem == item,
          onRemove: (item) {
            vm.onRemove(item, widget.parentContext ?? ctx);
          },
        );
      },
    );
  }

  addSupplier(BuildContext context) async {
    StoreProvider.of<AppState>(context).dispatch(createSupplier(context));

    // Navigator.of(context).pushNamed(
    //   SupplierPage.route,
    //   arguments: null,
    // );
  }
}

class MenuItem {
  final String text;

  const MenuItem({required this.text});
}

class MenuItems {
  static const List<MenuItem> firstItems = [name, createdDate];

  static const createdDate = MenuItem(text: 'Created Date');
  // static const name = MenuItem(text: 'Product Name');
  static const name = MenuItem(text: 'Supplier Name');

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

class SupplierTile extends StatelessWidget {
  final Supplier? item;
  final bool dismissAllowed;
  final Function(Supplier? item)? onRemove;

  final Function(Supplier? item)? onTap;

  final bool selected;

  const SupplierTile({
    Key? key,
    required this.item,
    this.onTap,
    this.onRemove,
    this.dismissAllowed = false,
    this.selected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return dismissAllowed
        ? dismissibleSupplierTile(context)
        : supplierTile(context);
  }

  Slidable dismissibleSupplierTile(BuildContext context) => Slidable(
    key: Key(item!.id!),
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
    child: supplierTile(context),
    // actionPane: SlidableDrawerActionPane(),
    // actionExtentRatio: 0.25,
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
  );

  ListTile supplierTile(BuildContext context) => ListTile(
    tileColor: Theme.of(context).extension<AppliedSurface>()?.primary,
    dense: !EnvironmentProvider.instance.isLargeDisplay!,
    onTap: onTap != null ? () => onTap!(item) : null,
    selected: selected,
    title: Text(item!.displayName!),
    leading: ListLeadingIconTile(icon: MdiIcons.truckDelivery),
    trailing: CircleAvatar(
      backgroundColor: Theme.of(context).extension<AppliedSurface>()?.brand,
      child: DecoratedText(
        item!.displayName!.substring(0, 1).toUpperCase(),
        fontSize: null,
        textColor: Colors.white,
        alignment: Alignment.center,
        fontWeight: FontWeight.bold,
      ),
    ),
    subtitle: LongText(
      '${item!.contacts!.length} Contacts, ${item!.products!.length} Products',
    ),
  );
}
