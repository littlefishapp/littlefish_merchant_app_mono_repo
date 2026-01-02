import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/icons/right_indicator.dart';
import 'package:littlefish_merchant/models/staff/employee.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/business/business_actions.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/ui/business/employees/view_models.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/auto_complete_text_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/new_list_tile.dart';
import 'package:quiver/strings.dart';

class EmployeeList extends StatefulWidget {
  final Function(Employee employee) onTap;
  final EmployeeListVM vm;
  final BuildContext? parentContext;
  final List<Employee>? items;
  final Employee? selectedItem;
  final bool enableAddCntlOnList;

  const EmployeeList({
    Key? key,
    required this.onTap,
    required this.items,
    required this.vm,
    this.parentContext,
    this.selectedItem,
    this.enableAddCntlOnList = false,
  }) : super(key: key);

  @override
  State<EmployeeList> createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList> {
  late List<Employee?> _filteredList;
  late List<Employee?> _sortedList;
  late String _sortOrder;
  late String _sortSelection;
  MenuItem? _currentSelection;
  SortOrder? _selectedOrder;
  GlobalKey<AutoCompleteTextFieldState<Employee>>? filterKey;

  late List<Employee?>? items;

  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    _filteredList = [];
    _sortedList = [];
    _sortOrder = 'Ascending';
    _sortSelection = '';
    items = widget.items;
    filterKey = GlobalKey<AutoCompleteTextFieldState<Employee>>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    updateFilteredList(items!);
    sortList(items!);
    return layout(context);
  }

  updateFilteredList(List<Employee?> items) {
    if (isNotBlank(searchController.text) && (items.isNotEmpty)) {
      _filteredList = items
          .where(
            (element) => element!.displayName.toLowerCase().contains(
              searchController.text.toLowerCase(),
            ),
          )
          .toList();
    }
  }

  sortList(List<Employee?> items) {
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
                ? b!.displayName.toLowerCase().compareTo(
                    a!.displayName.toLowerCase(),
                  )
                : a!.displayName.toLowerCase().compareTo(
                    b!.displayName.toLowerCase(),
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
                          _sortSelection = 'Employee Name';
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

  Column layout(BuildContext context) => Column(
    children: <Widget>[
      topBar(context),
      Expanded(
        child: searchController.text == ''
            ? employeeList(context)
            : filteredEmployeeList(context),
      ),
    ],
  );

  ListView employeeList(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.enableAddCntlOnList
          ? _sortedList.length + 1
          : _sortedList.length,
      itemBuilder: (BuildContext context, int index) {
        if (widget.enableAddCntlOnList) {
          if (index == 0) {
            return NewItemTile(
              title: 'New Employee',
              onTap: () => addEmployee(context),
            );
          } else {
            return employeeTile(context, _sortedList[index - 1]!);
          }
        } else {
          return employeeTile(context, _sortedList[index]!);
        }
      },
    );
  }

  ListView filteredEmployeeList(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.enableAddCntlOnList
          ? (_filteredList.length) + 1
          : _filteredList.length,
      itemBuilder: (BuildContext context, int index) {
        if (widget.enableAddCntlOnList) {
          if (index == 0) {
            return NewItemTile(
              title: 'New Employee',
              onTap: () => addEmployee(context),
            );
          } else {
            return employeeTile(context, _filteredList[index - 1]!);
          }
        } else {
          return employeeTile(context, _filteredList[index]!);
        }
      },
    );
  }

  EmployeeTile employeeTile(BuildContext context, Employee item) {
    return EmployeeTile(
      employee: item,
      onRemove: (item) {
        widget.vm.onRemove(item, widget.parentContext ?? context);
      },
      selected: item.id == widget.selectedItem?.id,
      onTap: () {
        widget.onTap(item);
      },
    );
  }

  addEmployee(BuildContext context) async {
    StoreProvider.of<AppState>(context).dispatch(createEmployee(context));
  }
}

class MenuItem {
  final String text;

  const MenuItem({required this.text});
}

class MenuItems {
  static const List<MenuItem> firstItems = [name, createdDate];

  static const createdDate = MenuItem(text: 'Created Date');
  static const name = MenuItem(text: 'Employee Name');

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

class EmployeeTile extends StatelessWidget {
  final Employee employee;

  final Function()? onTap;

  final Function(Employee item)? onRemove;

  final bool selected;

  const EmployeeTile({
    Key? key,
    required this.employee,
    this.onTap,
    this.onRemove,
    this.selected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _dismissableEmployee(context);
  }

  Slidable _dismissableEmployee(BuildContext context) {
    final tileColor = Theme.of(context).extension<AppliedSurface>()?.primary;
    final titleColor = Theme.of(context).extension<AppliedTextIcon>()?.primary;
    final subTitleColor =
        Theme.of(context).extension<AppliedTextIcon>()?.secondary ??
        Colors.grey;
    return Slidable(
      endActionPane: ActionPane(
        extentRatio: .25,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (ctx) async {
              var result = await confirmDismissal(context, null);

              if (result == true) {
                onRemove!(employee);
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
        tileColor: tileColor,
        dense: !EnvironmentProvider.instance.isLargeDisplay!,
        selected: selected,
        leading: Container(
          width: AppVariables.appDefaultlistItemSize,
          height: AppVariables.appDefaultlistItemSize,
          decoration: BoxDecoration(
            color: Theme.of(context).extension<AppliedSurface>()?.brandSubTitle,
            border: Border.all(color: Colors.transparent, width: 1),
            borderRadius: BorderRadius.circular(AppVariables.appDefaultRadius),
          ),
          child: Center(
            child: context.labelLarge(
              (employee.displayName).substring(0, 2).toUpperCase(),
              isSemiBold: true,
            ),
          ),
        ),
        trailing: const ArrowForward(),
        title: context.labelSmall(
          _getTitle(employee),
          color: titleColor,
          alignLeft: true,
          isBold: true,
        ),
        subtitle: getSubtitle(
          context: context,
          employee: employee,
          subTitleColor: subTitleColor,
        ),
        onTap: onTap,
      ),
    );
  }

  String _getTitle(Employee employee) {
    if ((employee.firstName?.isNotEmpty ?? false) &&
        (employee.lastName?.isNotEmpty ?? false)) {
      return '${employee.firstName} ${employee.lastName}';
    }

    return employee.name ?? '';
  }

  Widget getSubtitle({
    required BuildContext context,
    required Employee employee,
    required Color subTitleColor,
  }) {
    String value = employee.jobTitle ?? 'No Job';
    String format1 = 'dd MMMM yyy';
    String dateValue = TextFormatter.toShortDate(
      dateTime: employee.dateOfEmployment,
      format: format1,
    );
    String valueUsed = '$value, $dateValue';
    final subTitle = context.labelXSmall(
      valueUsed,
      color: subTitleColor,
      alignLeft: true,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
    return subTitle;
  }
}
