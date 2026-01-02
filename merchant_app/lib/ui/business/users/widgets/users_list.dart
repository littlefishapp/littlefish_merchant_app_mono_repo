// Flutter imports:
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:littlefish_core/business/models/business_user.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

// Project imports:
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/business/business_actions.dart';
import 'package:littlefish_merchant/common/presentaion/components/circle_gradient_avatar.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/auto_complete_text_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/common/presentaion/components/decorated_text.dart';
import 'package:littlefish_merchant/common/presentaion/components/long_text.dart';
import 'package:littlefish_merchant/common/presentaion/components/list_leading_tile.dart';
import 'package:littlefish_merchant/common/presentaion/components/new_list_tile.dart';
import 'package:quiver/strings.dart';
import '../../../../common/presentaion/components/dialogs/common_dialogs.dart';
import '../view_models.dart';

class UsersList extends StatefulWidget {
  final Function(BusinessUser? employee) onTap;

  final UsersListVM vm;

  final List<BusinessUser?>? items;

  final BusinessUser? selectedItem;

  const UsersList({
    Key? key,
    required this.vm,
    required this.onTap,
    required this.items,
    this.selectedItem,
  }) : super(key: key);

  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  GlobalKey<AutoCompleteTextFieldState<BusinessUser>>? filterKey;
  late List<BusinessUser?> _filteredList;
  late List<BusinessUser?> _sortedList;
  late String _sortOrder;
  late String _sortSelection;
  MenuItem? _currentSelection;
  SortOrder? _selectedOrder;
  late List<BusinessUser?>? items;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    _filteredList = [];
    _sortedList = [];
    _sortOrder = 'Ascending';
    _sortSelection = '';
    items = widget.items;
    filterKey = GlobalKey<AutoCompleteTextFieldState<BusinessUser>>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    updateFilteredList(items!);
    sortList(items!);
    return layout(context, widget.vm);
  }

  updateFilteredList(List<BusinessUser?> items) {
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

  sortList(List<BusinessUser?> items) {
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
                          _sortSelection = 'User Name';
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
        ],
      ),
    ),
  );

  Column layout(BuildContext context, UsersListVM vm) => Column(
    children: <Widget>[
      topBar(context),
      Expanded(
        child: searchController.text == ''
            ? userList(context, vm)
            : filteredUserList(context, vm),
      ),
    ],
  );

  // Column(
  //       children: <Widget>[
  //         FilterAddBar<BusinessUser?>(
  //           // onAdd: () => newUser(context),
  //           filterKey: filterKey,
  //           itemBuilder: (BuildContext context, BusinessUser? suggestion) =>
  //               userTile(context, suggestion!),
  //           itemSorter: (a, b) {
  //             return a!.displayName!.substring(0, 1).toLowerCase().compareTo(
  //                   b!.displayName!.substring(0, 1).toLowerCase(),
  //                 );
  //           },
  //           itemFilter: (suggestion, query) => suggestion!.displayName!
  //               .toLowerCase()
  //               .contains(query.toLowerCase()),
  //           itemSubmitted: (BusinessUser? data) {
  //             if (widget.onTap != null) widget.onTap(data);
  //           },
  //           suggestions: items,
  //         ),
  //         Expanded(
  //           child: userList(context),
  //         )
  //       ],
  //     );

  ListView userList(BuildContext context, UsersListVM vm) => ListView.separated(
    physics: const BouncingScrollPhysics(),
    shrinkWrap: true,
    itemBuilder: (BuildContext context, int index) {
      if (index == 0) {
        return NewItemTile(title: 'New User', onTap: () => newUser(context));
      } else {
        return userTile(context, _sortedList[index - 1]!, vm);
      }
    },
    itemCount: (_sortedList.length) + 1,
    separatorBuilder: (BuildContext context, int index) =>
        const CommonDivider(),
  );

  ListView filteredUserList(BuildContext context, UsersListVM vm) =>
      ListView.separated(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return NewItemTile(
              title: 'New User',
              onTap: () => newUser(context),
            );
          } else {
            return userTile(context, _filteredList[index - 1]!, vm);
          }
        },
        itemCount: (_filteredList.length) + 1,
        separatorBuilder: (BuildContext context, int index) =>
            const CommonDivider(),
      );

  UserTile userTile(BuildContext context, BusinessUser item, UsersListVM vm) {
    return UserTile(
      onRemove: (item) {
        vm.onRemove(item, context);
      },
      item: item,
      selected: item.id == widget.selectedItem?.id,
      onTap: () {
        widget.onTap(item);
      },
    );
  }

  newUser(BuildContext context) async {
    StoreProvider.of<AppState>(context).dispatch(createUser(context));
  }
}

class MenuItem {
  final String text;

  const MenuItem({required this.text});
}

class MenuItems {
  static const List<MenuItem> firstItems = [name, createdDate];

  static const createdDate = MenuItem(text: 'Created Date');
  static const name = MenuItem(text: 'User Name');

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

class UserTile extends StatelessWidget {
  final BusinessUser item;

  final Function()? onTap;
  final Function(BusinessUser item)? onRemove;

  final bool selected;

  const UserTile({
    Key? key,
    required this.item,
    this.onTap,
    this.onRemove,
    this.selected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (item.isOwner) {
      return userTile(context);
    } else {
      return dismissableUserTile(context);
    }
  }

  ListTile userTile(context) => ListTile(
    tileColor: Theme.of(context).colorScheme.background,
    dense: !EnvironmentProvider.instance.isLargeDisplay!,
    onTap: onTap,
    selected: selected,
    leading: ListLeadingIconTile(
      icon: MdiIcons.badgeAccountHorizontal,
      color: item.isOwner
          ? Theme.of(context).colorScheme.secondary
          : item.isPending
          ? Colors.purple
          : !item.isActive
          ? Colors.orange
          : Colors.blue,
    ),
    subtitle: item.isOwner
        ? const LongText('Owner')
        : item.isAdmin
        ? const LongText('Administrator')
        : const LongText('General User'),
    title: Text(item.displayName!),
    trailing: OutlineGradientAvatar(
      child: DecoratedText(
        item.displayName!.substring(0, 1),
        fontSize: null,
        alignment: Alignment.center,
      ),
    ),
  );
  Slidable dismissableUserTile(context) => Slidable(
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
    child: userTile(context),
    // actionPane: SlidableDrawerActionPane(),
    // actionExtentRatio: 0.25,
  );
}
