import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/shared/sort/sort_by_subtypes/tools/sort_by_types.dart';
import '../../../app/theme/applied_system/applied_text_icon.dart';
import '../../../models/enums.dart';

class CheckoutSortActions extends StatefulWidget {
  final SortBy type;
  final SortOrder order;

  final Function(SortBy type, SortOrder order) onUpdateSort;

  const CheckoutSortActions({
    Key? key,
    required this.type,
    required this.order,
    required this.onUpdateSort,
  }) : super(key: key);

  @override
  State<CheckoutSortActions> createState() => _CheckoutSortActions();
}

class _CheckoutSortActions extends State<CheckoutSortActions> {
  late SortOption _selectedOption;

  ProductSortBy sortTypes = ProductSortBy();

  onInitState() {
    _selectedOption = SortOption(widget.type, widget.order);
  }

  @override
  Widget build(BuildContext context) {
    _selectedOption = SortOption(widget.type, widget.order);
    return layout(context);
  }

  Widget layout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: <Widget>[
          Container(
            color: Theme.of(context).extension<AppliedSurface>()?.primaryHeader,
            padding: const EdgeInsets.only(left: 16, bottom: 16),
            child: context.labelLarge(
              'Sort By',
              color: Theme.of(context).extension<AppliedTextIcon>()?.secondary,
              isSemiBold: true,
            ),
          ),
          sortButtons(context),
        ],
      ),
    );
  }

  String capitalize(String input) {
    if (input.isEmpty) {
      return input; // Return empty string if input is empty
    }
    return input.substring(0, 1).toUpperCase() + input.substring(1);
  }

  String getSortName(SortBy type, SortOrder order) {
    if (type == sortTypes.price) {
      if (order == SortOrder.descending) {
        return '${capitalize(type.name.toString())} - High to Low';
      }
      if (order == SortOrder.ascending) {
        return '${capitalize(type.name.toString())} - Low to High';
      }
    }
    if (type == sortTypes.createdDate) {
      if (order == SortOrder.descending) return 'Newest First';
      if (order == SortOrder.ascending) return 'Oldest First';
    }
    return '${capitalize(type.name.toString())} - ${capitalize(order.name.toString())}';
  }

  sortButtons(BuildContext context) => ListView(
    shrinkWrap: true,
    physics: const BouncingScrollPhysics(),
    children: sortTypes.order
        .map(
          (type) => SortOrder.values
              .map(
                (order) => Column(
                  children: [
                    ListTile(
                      tileColor: Theme.of(
                        context,
                      ).extension<AppliedSurface>()?.primary,
                      title: context.paragraphMedium(
                        getSortName(type, order),
                        color: Theme.of(
                          context,
                        ).extension<AppliedTextIcon>()?.secondary,
                        alignLeft: true,
                        isBold: true,
                      ),
                      trailing: Radio(
                        activeColor: Theme.of(
                          context,
                        ).extension<AppliedTextIcon>()?.secondary,
                        onChanged: (_) {
                          _selectedOption = SortOption(type, order);
                          widget.onUpdateSort(type, order);
                          Navigator.of(context).pop();
                        },
                        groupValue: _selectedOption,
                        value: SortOption(type, order),
                      ),
                      onTap: () {
                        _selectedOption = SortOption(type, order);
                        widget.onUpdateSort(type, order);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              )
              .toList(),
        )
        .expand((element) => element)
        .toList(),
  );
}

class SortOption {
  final SortBy sortBy;
  final SortOrder sortOrder;

  SortOption(this.sortBy, this.sortOrder);

  // Helps with comparison of  SortOption instances for use of radio button activating
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SortOption &&
        other.sortBy == sortBy &&
        other.sortOrder == sortOrder;
  }

  @override
  int get hashCode => sortBy.hashCode ^ sortOrder.hashCode;
}
