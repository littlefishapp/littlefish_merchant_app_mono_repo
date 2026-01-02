// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:littlefish_merchant/common/presentaion/components/form_fields/auto_complete_text_field.dart';

class FilterAddBar<T> extends StatelessWidget {
  const FilterAddBar({
    Key? key,
    this.onAdd,
    this.height = 60.0,
    required this.suggestions,
    required this.itemFilter,
    required this.itemSorter,
    required this.itemSubmitted,
    required this.itemBuilder,
    required this.filterKey,
  }) : super(key: key);

  final Function? onAdd;

  final List<T>? suggestions;
  final Filter<T> itemFilter;
  final Comparator<T> itemSorter;
  final InputEventCallback<T> itemSubmitted;
  final AutoCompleteOverlayItemBuilder<T> itemBuilder;
  final GlobalKey<AutoCompleteTextFieldState>? filterKey;
  final double height;

  @override
  Widget build(BuildContext context) {
    return topBar(context);
  }

  SizedBox topBar(BuildContext context) => SizedBox(
    height: height,
    child: Container(
      alignment: Alignment.center,
      color: Colors.grey.shade50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: AutoCompleteTextField<T>(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                border: InputBorder.none,
              ),
              itemBuilder: itemBuilder,
              itemFilter: itemFilter,
              itemSorter: itemSorter,
              itemSubmitted: itemSubmitted,
              key: filterKey as GlobalKey<AutoCompleteTextFieldState<T>>?,
              suggestions: suggestions,
            ),
          ),
          Visibility(
            visible: onAdd != null,
            child: SizedBox(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    if (onAdd != null) onAdd!();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
