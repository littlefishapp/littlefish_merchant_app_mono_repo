// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:littlefish_merchant/ui/reports/shared/models/item.dart';
import 'package:littlefish_merchant/ui/reports/shared/widgets/multi_select_page/multi_filter_select_page.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/long_text.dart';

import '../../../../../app/theme/applied_system/applied_text_icon.dart';

typedef SelectCallback = Function(List? selectedValue);

class MultiFilterSelect extends StatefulWidget {
  final double? height;
  final String? placeholder;
  final double? fontSize;
  final Widget? tail;
  final List<Item> allItems;
  final List? initValue;
  final SelectCallback selectCallback;

  const MultiFilterSelect({
    Key? key,
    this.height,
    this.placeholder,
    this.fontSize,
    this.tail,
    required this.allItems,
    this.initValue,
    required this.selectCallback,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => MultiFilterSelectState();
}

class MultiFilterSelectState extends State<MultiFilterSelect> {
  List? _selectedValue = [];

  @override
  Widget build(BuildContext context) {
    if (widget.initValue != null) {
      _selectedValue = widget.initValue;
    }

    return _layout();
  }

  Widget _layout() {
    return ListTile(
      tileColor: Theme.of(context).colorScheme.background,
      onTap: () async {
        _selectedValue = await showPopupDialog(
          defaultPadding: false,
          context: context,
          content: MultiFilterSelectPage(
            title: 'Search ${widget.placeholder}',
            allItems: widget.allItems,
            initValue: widget.initValue ?? [],
          ),
        );

        widget.selectCallback(_selectedValue);
      },
      title: Text(widget.placeholder!),
      subtitle: LongText(
        (widget.initValue ?? []).isEmpty
            ? 'None selected'
            : (widget.initValue ?? []).map((v) => v.displayName).join(', '),
        maxLines: 1,
      ),
      trailing: Padding(
        padding: const EdgeInsets.only(right: 8),
        child:
            widget.tail ??
            Container(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
              child: Icon(
                Icons.list,
                color: Theme.of(
                  context,
                ).extension<AppliedTextIcon>()?.emphasized,
                size: 25,
              ),
            ),
      ),
    );
  }
}
