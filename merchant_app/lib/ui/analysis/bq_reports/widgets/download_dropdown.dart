// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

// Project imports:
import 'package:littlefish_merchant/common/presentaion/components/list_leading_tile.dart';

class DownloadDropDown extends StatefulWidget {
  const DownloadDropDown({
    Key? key,
    this.values,
    required this.serviceFunction,
    this.requestData,
    this.requestData2,
  }) : super(key: key);

  final List<String>? values;
  final Function? serviceFunction;
  final List<dynamic>? requestData;
  final Map<String, List<dynamic>>? requestData2;

  @override
  State<DownloadDropDown> createState() => _DownloadDropDownState();
}

class _DownloadDropDownState extends State<DownloadDropDown> {
  // late String _selectedValue;
  // late bool _isLoading;
  List<DropdownMenuItem> menuItems = [];
  StateSetter? bottomsheetState;

  @override
  void initState() {
    // _isLoading = false;
    // _selectedValue = '';
    menuItems = widget.values != null
        ? convertToMenuItems(widget.values!)
        : convertToMenuItems(getDefaultDownloadItems());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
    // return Container(
    //   width: 32,
    //   margin: const EdgeInsets.only(right: 12),
    //   // height: 16,
    //   child: IconButton(
    //     icon: Icon(Icons.download),
    //     color: Theme.of(context).colorScheme.secondary,
    //     //Icon(Icons.download),
    //     onPressed: () {
    //       if (widget.requestData == null && widget.requestData2 == null) {
    //         showMessageDialog(
    //           context,
    //           'Please have valid data before attempting to download',
    //           LittleFishIcons.info,
    //         );
    //       } else {
    //         pressedDownloadButton();
    //       }
    //       //dropDownSelectedItem("PDF");
    //     },
    //   ),
    // );
  }

  List<DropdownMenuItem> convertToMenuItems(List<String> items) {
    for (var element in items) {
      DropdownMenuItem item = DropdownMenuItem<String>(
        value: element,
        child: Text(element),
      );

      menuItems.add(item);
    }

    return menuItems;
  }

  List<String> getListItems() {
    return widget.values != null ? widget.values! : getDefaultDownloadItems();
  }

  List<ListTile> getListTileItems() {
    List<ListTile> tiles = [];

    tiles.add(
      ListTile(
        tileColor: Theme.of(context).colorScheme.background,
        leading: ListLeadingIconTile(
          icon: MdiIcons.filePdfBox,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: const Text('PDF'),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {
          dropDownSelectedItem('PDF');
        },
      ),
    );

    tiles.add(
      ListTile(
        tileColor: Theme.of(context).colorScheme.background,
        leading: ListLeadingIconTile(
          icon: MdiIcons.fileWordBox,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: const Text('Word'),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {
          dropDownSelectedItem('Word');
        },
      ),
    );

    tiles.add(
      ListTile(
        tileColor: Theme.of(context).colorScheme.background,
        leading: ListLeadingIconTile(
          icon: MdiIcons.fileExcelBox,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: const Text('Excel'),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {
          dropDownSelectedItem('Excel');
        },
      ),
    );

    return tiles;
  }

  Future<void> dropDownSelectedItem(dynamic selectedValue) async {
    if (selectedValue is String) {
      if (selectedValue != '') {
        bottomsheetState!(() {
          // _isLoading = true;
        });
        await widget.serviceFunction!(
          selectedValue.toString(),
          widget.requestData ?? widget.requestData2,
        );
        bottomsheetState!(() {
          // _isLoading = false;
        });
      }
    }
  }

  List<String> getDefaultDownloadItems() {
    return ['PDF', 'Word', 'Excel'];
  }

  SizedBox pressedDownloadButton() => const SizedBox.shrink();
}
