import 'package:flutter/material.dart';
import '../../../common/presentaion/components/form_fields/search_text_field.dart';

class NewSaleSearchProduct extends StatelessWidget {
  final TextEditingController searchController;
  final void Function(String) onChanged;
  const NewSaleSearchProduct({
    Key? key,
    required this.searchController,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SearchTextField(
      controller: searchController,
      onChanged: onChanged,
      onFieldSubmitted: (_) {},
      useOutlineStyling: true,
      onClear: () {
        onChanged('');
      },
    );
  }
}
