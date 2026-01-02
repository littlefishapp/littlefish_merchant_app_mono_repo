import 'package:flutter/material.dart';
import 'package:littlefish_merchant/common/presentaion/components/chips/chip_selectable.dart';
import 'package:littlefish_merchant/ui/reports/shared/models/item.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_secondary.dart';

import '../../../../../common/presentaion/pages/scaffolds/app_scaffold.dart';

class MultiFilterSelectPage extends StatefulWidget {
  final String? placeholder;
  final List<Item> allItems;
  final List initValue;

  final String title;

  const MultiFilterSelectPage({
    Key? key,
    this.placeholder,
    required this.allItems,
    required this.initValue,
    this.title = 'Search',
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => MultiFilterSelectPageState();
}

class MultiFilterSelectPageState extends State<MultiFilterSelectPage> {
  late List<Item> filterItemList;
  List? selectedItemValueList;

  @override
  void initState() {
    super.initState();
    filterItemList = widget.allItems;
    selectedItemValueList = [];
    selectedItemValueList!.addAll(widget.initValue);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }
        Navigator.pop(context, selectedItemValueList);
      },
      child: AppScaffold(
        title: widget.title,
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          width: double.infinity,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 60.0,
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.grey.shade50,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          style: const TextStyle(
                            //fontFamily: UIStateData.primaryFontFamily,
                            fontSize: 20,
                          ),
                          onChanged: (text) {
                            filterItemList = widget.allItems
                                .where(
                                  (item) =>
                                      item.display
                                          .toString()
                                          .toUpperCase()
                                          .contains(text.toUpperCase()) ||
                                      item.content
                                          .toString()
                                          .toUpperCase()
                                          .contains(text.toUpperCase()),
                                )
                                .toList();
                            setState(() {});
                          },
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ButtonSecondary(
                  text: selectedItemValueList!.length == filterItemList.length
                      ? 'None'
                      : 'All',
                  // buttonColor:
                  //     selectedItemValueList!.length == filterItemList.length
                  //         ? Colors.white
                  //         : Theme.of(context).colorScheme.primary,
                  // textColor:
                  //     selectedItemValueList!.length == filterItemList.length
                  //         ? Theme.of(context).colorScheme.primary
                  //         : Colors.white,
                  onTap: (ctx) {
                    if (selectedItemValueList!.length ==
                        filterItemList.length) {
                      selectedItemValueList = [];
                    } else {
                      for (var element in filterItemList) {
                        if (!selectedItemValueList!.contains(element.value)) {
                          selectedItemValueList!.add(element.value);
                        }
                      }
                    }
                    if (mounted) setState(() {});
                  },
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 4.0,
                      runSpacing: 4.0,
                      children: filterItemList.map((item) {
                        bool selected = false;
                        int count = selectedItemValueList!.length;

                        if (selectedItemValueList!.isNotEmpty && count >= 0) {
                          selected = selectedItemValueList!.contains(
                            item.value,
                          );

                          if (selected) count--;
                        }

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 8,
                          ),
                          child: ChipSelectable(
                            text: item.content,
                            selected: selected,
                            onTap: (_) {
                              if (selected) {
                                selectedItemValueList!.remove(item.value);
                              } else {
                                selectedItemValueList!.add(item.value);
                              }
                              if (mounted) setState(() {});
                            },
                          ),
                        );
                        // return InkWell(
                        //   borderRadius: BorderRadius.circular(4.0),
                        //   onTap: () {
                        //     if (selected) {
                        //       selectedItemValueList!.remove(item.value);
                        //     } else {
                        //       selectedItemValueList!.add(item.value);
                        //     }
                        //     if (mounted) setState(() {});
                        //   },
                        // child: Container(
                        //   // width: 180,
                        //   padding: const EdgeInsets.symmetric(
                        //     vertical: 6,
                        //     horizontal: 8,
                        //   ),
                        //   decoration: BoxDecoration(
                        //     color: selected
                        //         ? Theme.of(context).colorScheme.primary
                        //         : null,
                        //     borderRadius: BorderRadius.circular(4.0),
                        //     border: Border.all(
                        //       color: Colors.grey.shade200,
                        //     ),
                        //   ),
                        //   child: Text(
                        //     item.content,
                        //     overflow: TextOverflow.ellipsis,
                        //     style: TextStyle(
                        //       //fontFamily: UIStateData.primaryFontFamily,
                        //       color:
                        //           selected ? Colors.white : Colors.black87,
                        //     ),
                        //   ),
                        // ),
                        // );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              SizedBox(
                child: ButtonPrimary(
                  onTap: (c) =>
                      Navigator.of(context).pop(selectedItemValueList),
                  text: 'OK',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
