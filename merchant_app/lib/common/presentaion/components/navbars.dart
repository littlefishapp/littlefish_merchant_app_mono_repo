import 'package:flutter/material.dart';

class BasicNavBar extends StatefulWidget {
  final Function(int index)? indexChanged;

  final List<NavbarItem> items;

  final int initialIndex;

  final bool displayText;

  final Color? selectedItemColor;

  const BasicNavBar({
    Key? key,
    this.indexChanged,
    this.initialIndex = 0,
    required this.items,
    this.displayText = false,
    this.selectedItemColor,
  }) : super(key: key);

  @override
  State<BasicNavBar> createState() => BasicNavBarState();
}

class BasicNavBarState extends State<BasicNavBar> {
  late int selectedIndex;

  void setSelectedIndex(int value) {
    if (mounted) {
      setState(() {
        selectedIndex = value;
      });
    } else {
      selectedIndex = value;
    }
  }

  @override
  void initState() {
    selectedIndex = widget.initialIndex;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var items = widget.items.asMap().entries.toList();

    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      child: SizedBox(
        height: widget.displayText ? 54 : 48.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: items.map((i) {
            if (i.value.ignore) {
              return const SizedBox(height: 0, width: 0);
            }

            return _item(context, i.value, i.key);
          }).toList(),
        ),
      ),
    );
  }

  Widget _item(context, NavbarItem navbarItem, int index) {
    var icon = navbarItem.iconAsset == null
        ? Icon(
            navbarItem.icon,
            color: index == selectedIndex
                ? (widget.selectedItemColor ??
                      Theme.of(context).colorScheme.primary)
                : Colors.grey.shade400,
          )
        : Image.asset(
            navbarItem.iconAsset!,
            color: index == selectedIndex
                ? (widget.selectedItemColor ??
                      Theme.of(context).colorScheme.primary)
                : Colors.grey.shade400,
            width: 24,
          );
    var option = widget.items[index];

    var navItem = GestureDetector(
      onLongPress: () {
        if (widget.items[selectedIndex].onLongTap != null) {
          widget.items[selectedIndex].onLongTap!();
        }
      },
      child: IconButton(
        tooltip: navbarItem.text,
        key: navbarItem.key,
        icon: option.widget ?? icon,
        onPressed: () {
          if (widget.indexChanged != null) {
            widget.indexChanged!(index);
          } else {
            if (option.route != null && option.route!.isNotEmpty) {
              Navigator.of(context).pushReplacementNamed(option.route!);
            }
          }

          if (mounted) {
            setState(() {
              selectedIndex = index;
            });
          } else {
            selectedIndex = index;
          }
        },
      ),
    );

    if (navbarItem.stackWidget != null) {
      return GestureDetector(
        onLongPress: option.onLongTap as void Function()?,
        child: Stack(
          children: <Widget>[
            navItem,
            navbarItem.stackWidget!,
            if (selectedIndex == index && option.showUnderline)
              _heroLine(context, index),
          ],
        ),
      );
    } else {
      return GestureDetector(
        onLongPress: option.onLongTap as void Function()?,
        child: Stack(
          children: <Widget>[
            navItem,
            if (selectedIndex == index && option.showUnderline)
              _heroLine(context, index),
          ],
        ),
      );
    }
  }

  Positioned _heroLine(context, int i) => Positioned(
    bottom: 2,
    left: 4,
    right: 4,
    child: Hero(
      tag: 'selected_basicnav_item',
      child: Container(
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          color:
              widget.selectedItemColor ?? Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(8),
        ),
        constraints: const BoxConstraints(
          minWidth: 16,
          minHeight: 2,
          maxHeight: 2,
          maxWidth: 32,
        ),
        child: const SizedBox(width: 2),
      ),
    ),
  );
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
    this.key,
    this.color,
    this.iconAsset,
    this.stackWidget,
    this.widget,
    this.onLongTap,
    this.showUnderline = true,
  });

  String? text, description;

  bool showUnderline;

  IconData? icon;

  String? route;

  Function? onTap;

  Function? onLongTap;

  Widget? widget;

  Widget? stackWidget;

  String? iconAsset;

  bool isSelected;

  Color? color;

  bool allowOffline;

  List<NavbarItem>? subItems;

  bool specialDisplay;

  Key? key;

  bool ignore;
}
