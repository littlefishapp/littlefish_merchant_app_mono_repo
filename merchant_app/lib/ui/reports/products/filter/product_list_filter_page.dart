// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:littlefish_merchant/models/reports/number_filter.dart';
import 'package:littlefish_merchant/models/stock/stock_category.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/ui/reports/products/filter/product_list_vm.dart';
import 'package:littlefish_merchant/ui/reports/shared/models/item.dart';
import 'package:littlefish_merchant/ui/reports/shared/widgets/multi_select_page/multi_select_page.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';

import '../../../../common/presentaion/pages/scaffolds/app_scaffold.dart';

class ProductListFilterPage extends StatefulWidget {
  final ProductListVM? vm;

  final bool showHeader;

  final BuildContext? parentContext;

  const ProductListFilterPage(
    this.vm, {
    Key? key,
    this.showHeader = true,
    this.parentContext,
  }) : super(key: key);

  @override
  State<ProductListFilterPage> createState() => _ProductListFilterPageState();
}

class _ProductListFilterPageState extends State<ProductListFilterPage> {
  List<Item>? selectedProducts;
  List<Item>? selectedCategories;
  List<Item>? selectedSellers;
  List<Item>? selectedCustomers;

  @override
  Widget build(BuildContext context) {
    return layout(context, widget.vm!);
  }

  List<Item> buildListItem(List<dynamic> array) {
    return List.generate(
      array.length,
      (index) => Item.build(
        content: array[index].displayName,
        display: array[index].displayName,
        value: array[index],
      ),
    );
  }

  Widget layout(context, ProductListVM vm) {
    return AppScaffold(
      displayNavBar: false,
      displayAppBar: widget.showHeader,
      title: 'Products Filters',
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: <Widget>[
                const CommonDivider(),
                MultiFilterSelect(
                  placeholder: 'Products',
                  allItems: buildListItem(vm.products),
                  initValue: vm.selectedProducts.isNotEmpty
                      ? vm.selectedProducts
                      : null,
                  tail: Text(
                    '${vm.selectedProducts.length} of ${vm.products.length}',
                  ),
                  selectCallback: (List? selectedValue) {
                    var result = selectedValue!.cast<StockProduct>().toList();
                    vm.onSelectProduct(result);

                    if (mounted) setState(() {});
                  },
                ),
                const CommonDivider(),
                MultiFilterSelect(
                  placeholder: 'Categories',
                  allItems: buildListItem(vm.categories!),
                  initValue: vm.selectedCategories.isNotEmpty
                      ? vm.selectedCategories
                      : null,
                  tail: Text(
                    '${vm.selectedCategories.length} of ${vm.categories!.length}',
                  ),
                  selectCallback: (List? selectedValue) {
                    var result = selectedValue!.cast<StockCategory>().toList();
                    vm.onSelectCategory(result);
                    if (mounted) setState(() {});
                  },
                ),
                const CommonDivider(),
              ],
            ),
          ),
          ButtonPrimary(
            onTap: (c) {
              vm.runReport(widget.parentContext ?? context);
              vm.getNextPage(widget.parentContext ?? context);

              if (mounted) setState(() {});

              if (widget.showHeader) {
                Navigator.of(context).pop();
              }
            },
            text: 'APPLY FILTERS',
            textColor: Colors.white,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Text setSubtitle(NumberFilter filter) {
    switch (filter.filterType) {
      case FilterType.greater:
        return Text('Margins greater than ${filter.firstValue}');
      case FilterType.lessThan:
        return Text('Margins less than ${filter.firstValue}');
      case FilterType.between:
        return Text(
          'Margins betweeen ${filter.firstValue} and ${filter.secondValue}',
        );
      case FilterType.exclude:
        return Text(
          'Margins excluding values between ${filter.firstValue} and ${filter.secondValue}',
        );
      default:
    }
    return const Text('');
  }

  Widget setTrailing(NumberFilter filter) {
    switch (filter.filterType) {
      case FilterType.greater:
        return const Icon(Icons.keyboard_arrow_right);
      case FilterType.lessThan:
        return const Icon(Icons.keyboard_arrow_left);
      case FilterType.between:
        return const Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.keyboard_arrow_left),
            Icon(Icons.keyboard_arrow_right),
          ],
        );
      case FilterType.exclude:
        return const Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.keyboard_arrow_right),
            Icon(Icons.keyboard_arrow_left),
          ],
        );
      default:
    }
    return const SizedBox.shrink();
  }
}
