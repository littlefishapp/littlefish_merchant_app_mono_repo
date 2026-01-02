// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:littlefish_merchant/common/presentaion/components/form_fields/auto_complete_text_field.dart';

class FilterBar<T> extends StatelessWidget {
  final List<T>? suggestions;
  final Filter<T> itemFilter;
  final Comparator<T> itemSorter;
  final InputEventCallback<T> itemSubmitted;
  final AutoCompleteOverlayItemBuilder<T> itemBuilder;
  final GlobalKey<AutoCompleteTextFieldState> filterKey;

  const FilterBar({
    Key? key,
    required this.suggestions,
    required this.itemFilter,
    required this.itemSorter,
    required this.itemSubmitted,
    required this.itemBuilder,
    required this.filterKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return topBar(context);
  }

  SizedBox topBar(BuildContext context) => SizedBox(
    height: 60.0,
    child: Container(
      alignment: Alignment.center,
      color: Colors.grey.shade50,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 9,
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
        ],
      ),
    ),
  );
}
