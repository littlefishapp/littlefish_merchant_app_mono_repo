// flutter imports
import 'package:flutter/material.dart';

// project imports
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/common/presentaion/components/controls/control_check_box.dart';
import 'package:littlefish_merchant/tools/helpers.dart';

typedef ItemBuilder = Widget? Function(BuildContext, int);
typedef OnSelectionChanged = void Function(bool, int);
typedef SeparatorBuilder = Widget Function(BuildContext, int);

class SelectableListView extends StatefulWidget {
  final int itemCount;
  final ItemBuilder itemBuilder;
  final SeparatorBuilder? separatorBuilder;
  final OnSelectionChanged onSelectedChanged;
  final List<bool>? isSelectedList; // length should match itemCount
  final bool shrinkWrap;
  final bool enableSelectAll;
  final EdgeInsetsGeometry tilePadding;

  const SelectableListView({
    Key? key,
    required this.itemBuilder,
    required this.itemCount,
    required this.onSelectedChanged,
    this.separatorBuilder,
    this.isSelectedList,
    this.shrinkWrap = false,
    this.enableSelectAll = true,
    this.tilePadding = EdgeInsets.zero,
  }) : super(key: key);

  @override
  State<SelectableListView> createState() => _SelectableListViewState();
}

class _SelectableListViewState extends State<SelectableListView> {
  late List<bool> _isSelectedList;
  late Set<int> _manuallySelectedIndices;
  late List<bool> _initialIsSelectedList;
  late bool _areAllInitiallySelected;

  @override
  void initState() {
    _manuallySelectedIndices = <int>{};
    _isSelectedList =
        isNotNullOrEmpty(widget.isSelectedList) &&
            widget.isSelectedList?.length == widget.itemCount
        ? List.from(widget.isSelectedList!)
        : List.generate(widget.itemCount, (index) => false);
    _initialIsSelectedList = List.from(_isSelectedList);
    _areAllInitiallySelected = !_initialIsSelectedList.contains(false);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SelectableListView oldWidget) {
    if (widget.isSelectedList != oldWidget.isSelectedList) {
      _isSelectedList =
          isNotNullOrEmpty(widget.isSelectedList) &&
              widget.isSelectedList?.length == widget.itemCount
          ? List.from(widget.isSelectedList!)
          : List.generate(widget.itemCount, (index) => false);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.enableSelectAll) ...[
          selectAllCheckbox(),
          const CommonDivider(),
        ],
        Expanded(
          child: ListView.separated(
            shrinkWrap: widget.shrinkWrap,
            itemCount: widget.itemCount,
            itemBuilder: (context, index) {
              return Padding(
                padding: widget.tilePadding,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: ControlCheckBox(
                        isSelected: _isSelectedList[index],
                        onChanged: (bool? isSelected) {
                          _handleIndividualSelection(isSelected, index);
                        },
                        width: 20,
                        height: 20,
                      ),
                    ),
                    Expanded(
                      child:
                          widget.itemBuilder(context, index) ??
                          const SizedBox.shrink(),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder:
                widget.separatorBuilder ??
                (context, index) => const CommonDivider(),
          ),
        ),
      ],
    );
  }

  Widget selectAllCheckbox() {
    bool isAllSelected = _isSelectedList.every((isSelected) => isSelected);
    return Padding(
      padding: widget.tilePadding,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 0,
              top: 16,
              bottom: 16,
            ),
            child: ControlCheckBox(
              isSelected: isAllSelected,
              onChanged: (bool? isAllSelected) {
                _handleSelectAllChanged(isAllSelected);
              },
              height: 20,
              width: 20,
            ),
          ),
          const SizedBox(width: 16),
          context.paragraphMedium('Select all', isSemiBold: true),
        ],
      ),
    );
  }

  void _handleIndividualSelection(bool? isSelected, int index) {
    if (isSelected != null) {
      _isSelectedList[index] = isSelected;
      if (isSelected) {
        _manuallySelectedIndices.add(index);
      } else {
        _manuallySelectedIndices.remove(index);
      }
      widget.onSelectedChanged(isSelected, index);
      setState(() {});
    }
  }

  void _handleSelectAllChanged(bool? isAllSelected) {
    if (isTrue(isAllSelected)) {
      for (int i = 0; i < _isSelectedList.length; i++) {
        _isSelectedList[i] = true;
        widget.onSelectedChanged(true, i);
      }
    } else {
      for (int i = 0; i < _isSelectedList.length; i++) {
        if (_areAllInitiallySelected) {
          _isSelectedList[i] = false;
          widget.onSelectedChanged(false, i);
        } else if (!_manuallySelectedIndices.contains(i) &&
            !_initialIsSelectedList[i]) {
          _isSelectedList[i] = false;
          widget.onSelectedChanged(false, i);
        }
      }
    }
    setState(() {});
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}
