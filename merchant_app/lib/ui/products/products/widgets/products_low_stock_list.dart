// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/ui/products/products/widgets/product_list_tile.dart';
import 'package:littlefish_merchant/ui/products/products/widgets/product_stock_tile.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/products/products/view_models/product_collection_vm.dart';
import 'package:littlefish_merchant/ui/products/products/widgets/products_list.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/auto_complete_text_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';

class ProductsLowStockList extends StatefulWidget {
  final ProductViewMode viewMode;

  final bool showTopBar;

  final BuildContext? parentContext;

  const ProductsLowStockList({
    Key? key,
    this.viewMode = ProductViewMode.productsView,
    this.showTopBar = true,
    this.parentContext,
  }) : super(key: key);

  @override
  State<ProductsLowStockList> createState() => _ProductsLowStockListState();
}

class _ProductsLowStockListState extends State<ProductsLowStockList> {
  GlobalKey<AutoCompleteTextFieldState<StockProduct>>? filterkey;
  GlobalKey? newItemKey;
  @override
  void initState() {
    filterkey = GlobalKey<AutoCompleteTextFieldState<StockProduct>>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ProductsViewModel>(
      builder: (BuildContext context, vm) {
        return layout(context, vm);
      },
      converter: (Store store) =>
          ProductsViewModel.fromStore(store as Store<AppState>),
    );
  }

  AppSimpleAppScaffold layout(context, vm) => AppSimpleAppScaffold(
    title: 'Low Stock Items',
    body: Column(
      children: <Widget>[
        Expanded(
          flex: 20,
          child: vm.isLoading
              ? const AppProgressIndicator()
              : productList(context, vm),
        ),
      ],
    ),
  );

  ListView productList(BuildContext context, ProductsViewModel vm) =>
      ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemCount: vm.state!.lowStockProducts?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          StockProduct item = vm.state!.lowStockProducts![index];

          switch (widget.viewMode) {
            case ProductViewMode.productsView:
              return ProductListTile(
                item: item,
                dismissAllowed: false,
                category: vm.state!.getCategory(categoryId: item.categoryId),
                selected: vm.selectedItem == item,
                onTap: (item) {},
                onRemove: (item) {},
              );
            case ProductViewMode.stockView:
              return ProductStockTile(
                item: item,
                category: vm.state!.getCategory(categoryId: item.categoryId),
                selected: vm.selectedItem == item,
                onTap: (item) {},
              );

            default:
              return Container();
          }
        },
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox.shrink(),
      );
}
