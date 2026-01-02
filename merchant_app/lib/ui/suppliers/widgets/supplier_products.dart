import 'package:flutter/material.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_text.dart';
import 'package:littlefish_merchant/ui/products/products/widgets/product_list_tile.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/models/suppliers/supplier.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/products/products/pages/product_select_page.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';

class SupplierProducts extends StatefulWidget {
  final Supplier? supplier;

  const SupplierProducts({Key? key, required this.supplier}) : super(key: key);

  @override
  State<SupplierProducts> createState() => _SupplierProductsState();
}

class _SupplierProductsState extends State<SupplierProducts> {
  late Supplier? supplier;

  @override
  void initState() {
    supplier = widget.supplier;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var store = StoreProvider.of<AppState>(context);

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                color: Colors.grey.shade50,
                height: 60,
                child: ButtonText(
                  text: 'Import Products',
                  leftIcon: Icons.add,
                  onTap: (_) {
                    (EnvironmentProvider.instance.isLargeDisplay!
                            ? showPopupDialog<StockProduct>(
                                content: const ProductSelectPage(
                                  isEmbedded: true,
                                ),
                                context: context,
                              )
                            : showDialog<StockProduct>(
                                context: context,
                                builder: (ctx) => const ProductSelectPage(),
                              ))
                        .then((result) {
                          if (result != null) {
                            var product = StockProduct.clone(product: result);

                            var existingIndex = supplier!.products!.indexWhere(
                              (p) => p.productId == product.id,
                            );
                            // var existingIndex = supplier!.products!
                            //     .indexWhere((p) => p.productId == result.id);

                            if (existingIndex >= 0) {
                              return showMessageDialog(
                                context,
                                '${product.displayName} already imported.',
                                MdiIcons.information,
                              );
                            } else {
                              supplier!.products!.add(
                                SupplierProduct.fromProduct(result),
                              );
                            }
                            if (mounted) setState(() {});
                          }
                        });
                    // else
                    //   showDialog<StockProduct>(
                    //       context: context,
                    //       builder: (ctx) => ProductSelectPage()).then((result) {
                    //     if (result != null) {
                    //       supplier!.products!.add(
                    //         SupplierProduct.fromProduct(result),
                    //       );
                    //       if (mounted) setState(() {});
                    //     }
                    //   });
                  },
                ),
              ),
            ),
          ],
        ),
        const CommonDivider(),
        Expanded(
          child:
              supplier?.products == null ||
                  (supplier != null &&
                      supplier!.products != null &&
                      supplier!.products!.isEmpty)
              ? Center(
                  child: Text(
                    'No products imported.',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    var item = supplier!.products![index];

                    if (item.product == null) {
                      item.product = store.state.productState.getProductById(
                        item.productId,
                      );

                      if (item.product != null) {
                        item.variance = item.product!.variances!.firstWhere(
                          (v) => v.id == item.varianceId,
                        );
                      }
                    }

                    if (item.product == null) {
                      return const SizedBox(height: 0, width: 0);
                    }

                    return ProductListTile(
                      item: item.product,
                      dismissAllowed: true,
                      onRemove: (item) {
                        supplier!.products!.removeWhere(
                          (p) => p.productId == item.id,
                        );
                        if (mounted) setState(() {});
                      },
                    );
                  },
                  itemCount: supplier!.products!.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      const CommonDivider(),
                ),
        ),
        const CommonDivider(),
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                color: Colors.grey.shade50,
                height: 60,
                child: ButtonPrimary(
                  text: 'Done',
                  onTap: (_) {
                    Navigator.of(context).pop(supplier?.products);
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
