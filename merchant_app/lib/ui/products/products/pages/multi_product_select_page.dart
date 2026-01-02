// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/ui/products/products/widgets/product_category_tile.dart';
//Package Imports:
import 'package:sliding_up_panel/sliding_up_panel.dart';
// Project imports:
import 'package:littlefish_merchant/ui/products/products/widgets/products_list.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/products/categories/view_models/category_item_vm.dart';
import 'package:littlefish_merchant/ui/products/product_discounts/view_models/product_discount_vm.dart';

class MultiProductSelectPage extends StatefulWidget {
  final bool isEmbedded;
  final bool? isDiscount;
  final ProductDiscountVM? productDiscountVM;
  final Function(List<StockProduct>?)? getProducts;

  final String? categoryId;

  final bool canAddNew;

  const MultiProductSelectPage({
    Key? key,
    this.isEmbedded = false,
    this.categoryId,
    this.productDiscountVM,
    this.getProducts,
    this.isDiscount = false,
    this.canAddNew = false,
  }) : super(key: key);

  @override
  State<MultiProductSelectPage> createState() => _MultiProductSelectPageState();
}

class _MultiProductSelectPageState extends State<MultiProductSelectPage> {
  List<StockProduct>? selectedProducts;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CategoryViewModel>(
      onInit: (store) {
        if (selectedProducts == null) {
          if (widget.productDiscountVM != null) {
            selectedProducts = List.from(
              widget.productDiscountVM!.currentDiscount?.products ?? [],
            );
          }
        }
      },
      converter: (store) => CategoryViewModel.fromStore(store),
      builder: (BuildContext context, CategoryViewModel vm) {
        return scaffold(context, vm);
      },
    );
  }

  Padding categoryProductsPageItemList(
    BuildContext context,
    CategoryViewModel vm,
    List<StockProduct> selectedProducts,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 70, bottom: 64),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount: selectedProducts.length,
          itemBuilder: (BuildContext ctx, int index) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: 104,
              color: Colors.red,
              padding: const EdgeInsets.all(16),
            );
          },
          separatorBuilder: (BuildContext context, int index) =>
              const CommonDivider(height: 0.5),
        ),
      ),
    );
  }

  Widget scaffold(context, CategoryViewModel vm) {
    if (selectedProducts == null) {
      if (vm.item!.products != null && vm.item!.products!.isNotEmpty) {
        selectedProducts = [...vm.item!.products!];
      } else {
        selectedProducts = [];
      }
    }
    final isTablet = EnvironmentProvider.instance.isLargeDisplay ?? false;
    final showSideNav =
        isTablet || (AppVariables.store!.state.enableSideNavDrawer ?? false);
    final availableWidth = MediaQuery.of(context).size.width;
    final widthUsed = isTablet ? availableWidth / 3 : availableWidth;

    return AppScaffold(
      title: 'Add Products',
      enableProfileAction: !showSideNav,
      hasDrawer: false,
      displayNavDrawer: false,
      body: SlidingUpPanel(
        minHeight: 126,
        onPanelClosed: () {
          debugPrint('Panel Closed.');
        },
        onPanelOpened: () {
          debugPrint('Panel Opened.');
        },
        header: SizedBox(
          height: isTablet ? 60 : 52,
          width: widthUsed,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 4.0,
                width: widthUsed, // 78.0,
                color: const Color(0xFFD7D7D7),
                margin: const EdgeInsets.all(8.0),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  selectedProducts!.length == 1
                      ? '${selectedProducts!.length} product selected'
                      : '${selectedProducts!.length} products selected',
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF8E8C8F),
                  ),
                ),
              ),
            ],
          ),
        ),
        footer: Container(
          height: 56,
          width: widthUsed,
          color: Colors.white,
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
          child: ButtonPrimary(
            text: 'Save Added Products',
            buttonColor: Theme.of(context).colorScheme.secondary,
            upperCase: false,
            onTap: (context) {
              if (widget.productDiscountVM != null) {
                widget.getProducts!(selectedProducts);
                Navigator.of(context).pop();
              } else {
                Navigator.of(context).pop(selectedProducts);
              }
            },
          ),
        ),
        panel: Padding(
          padding: const EdgeInsets.only(top: 70, bottom: 64),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: selectedProducts!.length,
            itemBuilder: (BuildContext ctx, int index) {
              StockProduct item = selectedProducts![index];

              return ProductCategoryTile(
                item: item,
                selected: selectedProducts!.contains(item),
                onTap: (item) {},
                onRemove: (item) {
                  setState(() {
                    selectedProducts!.removeWhere(
                      ((element) => element.id == item.id),
                    );
                  });
                },
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const CommonDivider(height: 0.5),
          ),
        ),
        body: Center(
          child: SizedBox(
            width: widthUsed,
            child: ProductsList(
              isStockListing: true,
              isMultiSelect: true,
              canAddNew: widget.canAddNew,
              categoryId: widget.categoryId,
              selectedProducts: selectedProducts,
              onTap: (item) {
                setState(() {
                  if (selectedProducts!.indexWhere(
                        (element) => element.id == item.id,
                      ) ==
                      -1) {
                    selectedProducts!.add(item);
                  }
                });
              },
              onRemove: (item) {
                setState(() {
                  selectedProducts!.removeWhere(
                    (element) => element.id == item.id,
                  );
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
