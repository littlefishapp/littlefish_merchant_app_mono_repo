import 'dart:async';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/online_store/products/pages/product_categorization_page.dart';
import 'package:littlefish_merchant/ui/online_store/products/pages/product_gallery_page.dart';
import 'package:littlefish_merchant/ui/online_store/products/pages/product_settings_page.dart';
import 'package:littlefish_merchant/ui/online_store/products/pages/related_products_page.dart';
import 'package:littlefish_merchant/ui/online_store/products/pages/store_product_details.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/ui/online_store/products/viewmodels/product_vm.dart';
import 'package:littlefish_merchant/ui/online_store/products/widgets/product_reviews_list.dart';
import 'package:quiver/strings.dart';

import '../../../common/presentaion/components/custom_app_bar.dart';
import '../../../features/ecommerce_shared/models/store/store_product.dart';
import '../../../common/presentaion/components/dialogs/common_dialogs.dart';

class StoreProductPage extends StatefulWidget {
  static const String route = '/store/product-detail';

  final BuildContext? parentContext;

  const StoreProductPage({Key? key, this.parentContext}) : super(key: key);

  @override
  State<StoreProductPage> createState() => _StoreProductPageState();
}

class _StoreProductPageState extends State<StoreProductPage>
    with SingleTickerProviderStateMixin {
  GlobalKey<FormState>? formKey;
  ProductVM? vm;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  StoreProduct? _item;
  dynamic argsItem;

  bool _isLoading = true;

  late List<Tab> tabHeaders;

  late List<Widget> tabBodyContent;

  TabController? _tabController;

  @override
  void initState() {
    formKey = GlobalKey();
    setLoading(false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    argsItem = ModalRoute.of(context)!.settings.arguments as StoreProduct?;

    _tabController ??= TabController(
      length: argsItem != null
          ? !(argsItem.isNew ?? true) &&
                    argsItem.storeProductVariantType ==
                        StoreProductVariantType.variant
                ? 6
                : 6
          : 6,
      vsync: this,
    );
    return StoreConnector<AppState, ProductVM>(
      converter: (store) => ProductVM.fromStore(store, null, product: argsItem),
      builder: (context, vm) {
        if (argsItem != null) {
          vm.uneditedProduct = StoreProduct.fromProduct(argsItem);
        }

        if (_item == null) {
          if (argsItem != null) {
            _item = argsItem;

            var json = (_item as StoreProduct).toJson();
            _item = StoreProduct.fromJson(json);
          } else {
            _item = StoreProduct.create(
              AppVariables.store!.state.storeState.store!.businessId!,
            );
          }
        }

        return body(widget.parentContext ?? context, vm);
      },
    );
  }

  dynamic body(BuildContext context, ProductVM vm) {
    tabHeaders = [];
    tabBodyContent = [];

    tabHeaders.addAll([
      Tab(child: Text('Info'.toUpperCase())),
      Tab(child: Text('Gallery'.toUpperCase())),
      Tab(child: Text('Category'.toUpperCase())),
      // Tab(child: Text("Options".toUpperCase())),
      // if (!(_item?.isNew ?? true) &&
      // _item!.storeProductVariantType == StoreProductVariantType.variant)
      // Tab(child: Text("Product Options".toUpperCase())),
      Tab(child: Text('Related'.toUpperCase())),
      // if (argsItem != null)
      //   Tab(child: Text(S.of(context).attributesLabel.toUpperCase())),
      if (argsItem != null) Tab(child: Text('Reviews'.toUpperCase())),
      Tab(child: Text('Settings'.toUpperCase())),
    ]);

    tabBodyContent.addAll([
      StoreProductDetails(item: _item, formKey: formKey),
      ProductGalleryPage(item: _item, vm: vm),
      ProductCategorizationPage(
        item: _item,
        baseCategory: vm.categories.firstWhereOrNull(
          (element) => element.categoryId == _item!.baseCategoryId,
        ),
      ),
      // Container(
      //   child: ProductOptionsPage(
      //     item: _item,
      //     vm: vm,
      //     formKey: formKey,
      //   ),
      // ),
      // if (!(_item?.isNew ?? true) &&
      //     _item!.storeProductVariantType == StoreProductVariantType.variant)
      //   Container(
      //     child: ProductOptionsProductSelect(
      //       item: _item,
      //       vm: vm,
      //     ),
      //   ),
      RelatedProductsPage(item: _item, vm: vm),

      //reviews page
      // if (argsItem != null)
      // Container(
      // child: ProductAttributesPage(item: _item!),
      // ),
      if (argsItem != null)
        ProductReviewsList(
          businessId: vm.currentStore!.id,
          productId: _item!.id,
          managementLayout: true,
        ),
      ProductSettingsPage(item: _item),
    ]);

    return scaffold(context, vm, _item!);
  }

  void setLoading(bool value) {
    if (mounted) {
      setState(() {
        _isLoading = value;
      });
    } else {
      _isLoading = value;
    }
  }

  Scaffold scaffold(context, ProductVM vm, StoreProduct product) => Scaffold(
    key: scaffoldKey,
    appBar: CustomAppBar(
      elevation: 0,
      title: Text(
        product.displayName ?? 'New Product',
        style: TextStyle(color: Theme.of(context).colorScheme.secondary),
      ),
      bottom: TabBar(
        onTap: (val) {
          if (_tabController!.previousIndex == 0) {
            formKey!.currentState?.save();
          }
        },
        controller: _tabController,
        isScrollable: true,
        tabs: tabHeaders,
      ),
    ),
    persistentFooterButtons: _isLoading
        ? null
        : <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                child: Text(
                  'Save'.toUpperCase(),
                  style: const TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  try {
                    setLoading(true);

                    if (_tabController!.index == 0) {
                      bool isValid = formKey?.currentState?.validate() ?? false;
                      if (isValid) formKey?.currentState?.save();
                    }

                    if (_item!.formComplete) {
                      if (_item!.productVariant?.variantTitles?.isNotEmpty ??
                          false) {
                        var hasValues = _item!.productVariant!.variantTitles!
                            .every((element) => isNotBlank(element.values![0]));
                        if (hasValues) {
                          if (vm.totalCombinations != null) {
                            for (var element
                                in (vm.totalCombinations as List)) {
                              _item!.productVariant!.totalCombinations!.add(
                                element as String,
                              );
                            }
                          }
                          _item!.storeProductVariantType =
                              StoreProductVariantType.variant;
                          await vm.upsertProduct(context, _item!);
                        } else {
                          showMessageDialog(
                            context,
                            'Must have at least one option name per option',
                            LittleFishIcons.info,
                          );
                          _tabController!.animateTo(3);
                        }
                      } else {
                        _item!.storeProductVariantType =
                            StoreProductVariantType.standalone;
                        await vm.upsertProduct(context, _item!);
                      }
                    } else {
                      showMessageDialog(
                        context,
                        'Form Incomplete',
                        LittleFishIcons.info,
                      );

                      _tabController!.animateTo(0);

                      Timer(
                        const Duration(milliseconds: 200),
                        () => formKey?.currentState?.validate(),
                      );
                    }
                  } catch (e) {
                    reportCheckedError(e);
                  } finally {
                    setLoading(false);
                  }
                },
              ),
            ),
          ],
    body: Column(
      children: <Widget>[
        if (_isLoading) const LinearProgressIndicator(),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: tabBodyContent,
          ),
        ),
      ],
    ),
  );
}
