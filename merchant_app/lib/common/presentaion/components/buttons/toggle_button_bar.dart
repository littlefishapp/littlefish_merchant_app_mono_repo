// Flutter imports:
import 'package:flutter/material.dart';

class ToggleButtonBar extends StatefulWidget {
  const ToggleButtonBar({
    Key? key,
    this.toggledItemColor,
    this.onToggled,
    this.items,
    this.initialIndex = 0,
    this.itemWidth = 0,
  }) : super(key: key);

  final Color? toggledItemColor;

  final Function(int)? onToggled;

  final List<ToggleButtonItem>? items;

  final double itemWidth;

  final int initialIndex;

  @override
  ToggleButtonBarState createState() => ToggleButtonBarState();
}

class ToggleButtonBarState extends State<ToggleButtonBar> {
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
  }

  void changeIndex(int? index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    selectedIndex = widget.initialIndex;

    if (selectedIndex != null) changeIndex(selectedIndex);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: widget.items!
          .map(
            (i) => Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () {
                  selectedIndex = i.index;
                  widget.onToggled!(i.index);
                  // if (mounted) setState(() {});
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: i.index == selectedIndex
                          ? Theme.of(context).colorScheme.primary
                          : Colors.white,
                    ),
                  ),
                  width: widget.itemWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        i.text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: i.index == selectedIndex
                              ? Theme.of(context).colorScheme.primary
                              : null,
                          fontWeight: i.index == selectedIndex
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );

    // return ListView.separated(
    //   shrinkWrap: true,
    //   physics: NeverScrollableScrollPhysics(),
    //   scrollDirection: Axis.horizontal,
    //   separatorBuilder: (BuildContext context, int index) => SizedBox(
    //     width: 1.0,
    //     child: Container(
    //       color: Colors.grey.shade100,
    //     ),
    //   ),
    //   itemBuilder: (BuildContext context, int index) {
    //     var item = widget.items[index];

    //     bool isSelected = item.index == selectedIndex;

    //     return GestureDetector(
    //       onTap: () {
    //         setState(() {
    //           this.selectedIndex = item.index;
    //           widget.onToggled(item.index);
    //         });
    //       },
    //       child: Container(
    //         width: widget.itemWidth,
    //         color: isSelected ? Theme.of(context).colorScheme.primary : Colors.white,
    //         child: Row(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: <Widget>[
    //             Icon(
    //               item.icon,
    //               color: isSelected
    //                   ? Colors.white
    //                   : Theme.of(context).colorScheme.primary,
    //               size: 28.0,
    //             ),
    //             Text(
    //               item.text,
    //             )
    //           ],
    //         ),
    //       ),
    //     );
    //   },
    //   itemCount: widget.items.length,
    // );
  }
}

class ToggleButtonItem {
  ToggleButtonItem({
    required this.text,
    required this.icon,
    required this.index,
  });

  String text;
  int index;
  IconData icon;
}
