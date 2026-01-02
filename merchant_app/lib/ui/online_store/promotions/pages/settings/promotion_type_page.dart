// remove ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/online_store/categories/store_categories_page.dart';
import 'package:littlefish_merchant/ui/online_store/products/widgets/product_list.dart';
import 'package:littlefish_merchant/ui/online_store/viewmodels/manage_store_vm.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';
import '../../../../../features/ecommerce_shared/models/store/promotion.dart';
import '../../../../../features/ecommerce_shared/models/store/store_product.dart';
import '../../../../../models/enums.dart';
import '../../../../../common/presentaion/components/dialogs/common_dialogs.dart';
import '../../../../../common/presentaion/components/common_divider.dart';
import '../posts/post_promotion_page.dart';

class PromotionTypePage extends StatefulWidget {
  final Promotion? item;

  const PromotionTypePage({Key? key, required this.item}) : super(key: key);

  @override
  State<PromotionTypePage> createState() => _PromotionTypePageState();
}

class _PromotionTypePageState extends State<PromotionTypePage> {
  Promotion? item;
  @override
  void initState() {
    item = widget.item;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ManageStoreVM>(
      converter: (store) => ManageStoreVM.fromStore(store),
      builder: (ctx, vm) {
        return AppSimpleAppScaffold(
          title: 'Promotion Type',
          body: SafeArea(
            child: Column(
              children: [
                ListTile(
                  tileColor: Theme.of(context).colorScheme.background,
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      ListTile(
                        tileColor: Theme.of(context).colorScheme.background,
                        title: const Text('Product'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () async {
                          // var result = await Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (ctx) => AppSimpleAppScaffold(
                          //       title: "Please Choose a Product",
                          //       body: SafeArea(
                          //         child: ProductsList(
                          //           listViewMode: ListViewMode.select,
                          //           // onTap: (product) {
                          //           //   Navigator.of(ctx).pop(product);
                          //           // },
                          //           // popOnClose: true,
                          //           // returnSelected: true,
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // );
                          // var result = await Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (ctx) => AppSimpleAppScaffold(
                          //       title: "Please Choose a Product",
                          //       body: SafeArea(
                          //         child: ProductsList(
                          //           listViewMode: ListViewMode.select,
                          //           // onTap: (product) {
                          //           //   Navigator.of(ctx).pop(product);
                          //           // },
                          //           // popOnClose: true,
                          //           // returnSelected: true,
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // );

                          var result = await showPopupDialog(
                            context: context,
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            content: const AppSimpleAppScaffold(
                              title: 'Please Choose a Product',
                              body: SafeArea(
                                child: ProductsList(
                                  listViewMode: ListViewMode.select,
                                  // onTap: (product) {
                                  //   Navigator.of(ctx).pop(product);
                                  // },
                                  // popOnClose: true,
                                  // returnSelected: true,
                                ),
                              ),
                            ),
                          );
                          if (result != null) {
                            item!.title =
                                '${"Buy"} ${result.displayName} for ${result.sellingPrice}';
                            item!.message = 'Click Visit Store for More';
                            item!.type = PromotionType.product;

                            item!.imageUrl =
                                (result as StoreProduct).featureImageUrl;
                            item!.imageAddress = result.featureImageAddress;
                            item!.data = PromotionData(
                              itemId: result.id,
                              name: result.displayName,
                            );

                            // var re = await Navigator.of(context).push(
                            //   MaterialPageRoute(
                            //     builder: (ctx) => PostPromotionPage(
                            //       item: item,
                            //     ),
                            //   ),
                            // );
                            // var re = await Navigator.of(context).push(
                            //   MaterialPageRoute(
                            //     builder: (ctx) => PostPromotionPage(
                            //       item: item,
                            //     ),
                            //   ),
                            // );
                            var re = await showPopupDialog(
                              context: context,
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              content: PostPromotionPage(item: item),
                            );

                            Navigator.of(context).pop(re);
                          }
                        },
                      ),
                      const CommonDivider(),
                      ListTile(
                        tileColor: Theme.of(context).colorScheme.background,
                        title: const Text('Category'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () async {
                          var result = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) {
                                return StoreCategoriesPage(
                                  onTap: (item) =>
                                      Navigator.of(context).pop(item),
                                  canAddNew: false,
                                );
                              },
                            ),
                          );

                          if (result != null) {
                            item!.title = '${result.displayName} ${"Are Here"}';
                            item!.message = 'Visit Store';
                            item!.type = PromotionType.category;

                            item!.imageUrl = (result as StoreProductCategory)
                                .featureImageUrl;
                            item!.data = PromotionData(
                              itemId: result.id,
                              name: result.displayName,
                            );

                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) => PostPromotionPage(item: item),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
