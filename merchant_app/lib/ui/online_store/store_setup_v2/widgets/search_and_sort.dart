// flutter imports
import 'package:flutter/material.dart';

// project imports
import 'package:littlefish_merchant/common/presentaion/components/form_fields/search_text_field.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/widgets/sort_products_button.dart';

class SearchAndSort extends StatelessWidget {
  final String? searchText;
  final void Function(String?) onSearchChanged;
  final void Function(SortBy, SortOrder) onSortChanged;
  final SortOrder sortOrder;
  final SortBy sortBy;

  const SearchAndSort({
    Key? key,
    required this.onSearchChanged,
    required this.onSortChanged,
    this.searchText,
    this.sortOrder = SortOrder.ascending,
    this.sortBy = SortBy.createdDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SearchTextField(
            onChanged: (value) => onSearchChanged(value),
            onClear: () => onSearchChanged(''),
          ),
        ),
        const SizedBox(width: 8),
        SortProductsButton(
          order: sortOrder,
          sortBy: sortBy,
          onChanged: (sortBy, sortOrder) => onSortChanged(sortBy, sortOrder),
        ),
      ],
    );
  }
}
