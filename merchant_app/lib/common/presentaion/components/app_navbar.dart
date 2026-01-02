// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:littlefish_merchant/app/theme/ui_state_data.dart';

class AppNavBar extends StatefulWidget {
  final List<NavbarItem> items;

  final int selectedIndex;

  const AppNavBar({Key? key, required this.items, required this.selectedIndex})
    : super(key: key);

  @override
  State<AppNavBar> createState() => _AppNavBarState();
}

class _AppNavBarState extends State<AppNavBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      elevation: UIStateData.appBarElevation,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      type: BottomNavigationBarType.fixed,
      currentIndex: widget.selectedIndex,
      onTap: (index) {
        var option = widget.items[index];

        if (option.route != null && option.route!.isNotEmpty) {
          Navigator.of(context).pushReplacementNamed(option.route!);
        }
      },
      items: widget.items
          .map(
            (i) => BottomNavigationBarItem(icon: Icon(i.icon), label: i.text!),
          )
          .toList(),
    );
  }
}

class NavbarItem {
  NavbarItem({
    required this.text,
    this.description,
    this.route,
    this.onTap,
    this.isSelected = false,
    this.icon,
    this.allowOffline = false,
    this.subItems,
    this.specialDisplay = false,
    this.ignore = false,
    this.hasAppBar = true,
    this.key,
  });

  String? text, description;

  bool? hasAppBar;

  IconData? icon;

  String? route;

  Function? onTap;

  bool isSelected;

  Color? color;

  bool allowOffline;

  List<NavbarItem>? subItems;

  bool specialDisplay;

  Key? key;

  bool ignore;
}
