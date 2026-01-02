import 'dart:async';

import 'package:flutter/material.dart';
import 'package:littlefish_merchant/ui/online_store/products/pages/product_gallery_page.dart';
import 'package:littlefish_merchant/ui/online_store/products/pages/store_product_details.dart';
import 'package:littlefish_merchant/ui/online_store/products/viewmodels/product_vm.dart';
import 'package:littlefish_icons/littlefish_icons.dart';

import '../../../../common/presentaion/components/custom_app_bar.dart';
import '../../../../features/ecommerce_shared/models/store/store_product.dart';
import '../../../../common/presentaion/components/dialogs/common_dialogs.dart';

class ProductOptionCreatePage extends StatefulWidget {
  final ProductVM? vm;

  final StoreProduct? item;

  const ProductOptionCreatePage({Key? key, this.item, this.vm})
    : super(key: key);

  @override
  State<ProductOptionCreatePage> createState() =>
      _ProductOptionCreatePageState();
}

class _ProductOptionCreatePageState extends State<ProductOptionCreatePage>
    with SingleTickerProviderStateMixin {
  List<Tab>? tabHeaders;
  List<Widget>? tabBodyContent;
  GlobalKey<FormState>? formKey;
  StoreProduct? item;
  TabController? _tabController;

  @override
  void initState() {
    formKey = GlobalKey();
    item =
        widget.item ?? StoreProduct.create(widget.vm!.currentStore!.businessId!)
          ..storeProductVariantType = StoreProductVariantType.child;

    _tabController = TabController(length: 2, vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: Text(item!.displayName ?? 'New Product')),
      persistentFooterButtons: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
            child: Text('Save'.toUpperCase()),
            onPressed: () async {
              if (_tabController!.index == 0) {
                bool isValid = formKey?.currentState?.validate() ?? false;
                if (isValid) formKey!.currentState!.save();
              }

              if (item!.formComplete) {
                Navigator.of(context).pop(item);
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
            },
          ),
        ),
      ],
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: TabBar(
                controller: _tabController,
                tabs: [
                  Tab(child: Text('Info'.toUpperCase())),
                  Tab(child: Text('Gallery'.toUpperCase())),
                ],
              ),
            ),
            Expanded(
              flex: 18,
              child: TabBarView(
                controller: _tabController,
                children: [
                  StoreProductDetails(item: item, formKey: formKey),
                  ProductGalleryPage(item: item, vm: widget.vm),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
