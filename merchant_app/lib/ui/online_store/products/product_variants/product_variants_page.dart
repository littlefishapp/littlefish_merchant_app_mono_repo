// remove ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/online_store/common/config.dart';
import 'package:littlefish_merchant/ui/online_store/products/product_variants/pages/product_variant_page.dart';
import 'package:littlefish_merchant/ui/online_store/viewmodels/manage_store_vm.dart';
import 'package:littlefish_icons/littlefish_icons.dart';

import '../../../../common/presentaion/components/custom_app_bar.dart';
import '../../../../common/presentaion/components/icons/delete_icon.dart';
import '../../../../features/ecommerce_shared/models/store/store_product.dart';
import '../../../../common/presentaion/components/dialogs/common_dialogs.dart';
import '../../../../common/presentaion/components/common_divider.dart';

class ProductVariantsPage extends StatefulWidget {
  static const String route = 'store/productvariantsmain';

  const ProductVariantsPage({Key? key}) : super(key: key);

  @override
  State<ProductVariantsPage> createState() => _ProductVariantsPageState();
}

class _ProductVariantsPageState extends State<ProductVariantsPage> {
  List<StoreProduct>? _productVariants;
  bool? _isLoading;
  @override
  void initState() {
    _productVariants = [];
    _isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ManageStoreVM>(
      converter: (store) => ManageStoreVM.fromStore(store),
      builder: (context, vm) {
        return Scaffold(
          appBar: const CustomAppBar(title: Text('Product Variants')),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () async {
              var res = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ProductVariantPage(),
                ),
              );

              if (res != null) {
                setState(() {});
              }
            },
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          body: mainBody(vm),
        );
      },
    );
  }

  FutureBuilder<List<StoreProduct>> mainBody(ManageStoreVM vm) =>
      FutureBuilder<List<StoreProduct>>(
        future: vm.getStoreProductVariants(),
        builder: (context, snapshot) {
          if (snapshot.data != null) _productVariants = snapshot.data;
          return Column(
            children: [
              if (snapshot.connectionState != ConnectionState.done ||
                  ((_isLoading ?? false)))
                const LinearProgressIndicator(),
              if (snapshot.connectionState == ConnectionState.done &&
                  _productVariants!.isEmpty)
                const Expanded(child: Center(child: Text('No Data'))),
              if (_productVariants?.isNotEmpty == true)
                Expanded(child: body(_productVariants, vm)),
            ],
          );
        },
      );

  ListView body(data, ManageStoreVM vm) => ListView.separated(
    itemCount: data?.length ?? 0,
    itemBuilder: (context, index) {
      var item = data[index];

      return itemTile(productVariant: item, vm: vm);
    },
    separatorBuilder: (BuildContext context, int index) =>
        const CommonDivider(),
  );

  ListTile itemTile({
    required StoreProduct productVariant,
    ManageStoreVM? vm,
  }) => ListTile(
    tileColor: Theme.of(context).colorScheme.background,
    onTap: () async {
      // var res = await Navigator.of(context).push(
      //   MaterialPageRoute(
      //     builder: (ctx) => ProductVariantPage(
      //       productVariant: productVariant,
      //     ),
      //   ),
      // );

      // if (res != null) {
      //   setState(() {});
      // }
    },
    trailing: IconButton(
      icon: const DeleteIcon(),
      onPressed: () async {
        try {
          _isLoading = true;
          setState(() {});
          await vm!.deleteProductVariant(productVariant);
          showMessageDialog(context, 'Success', LittleFishIcons.info);
        } catch (e) {
          showMessageDialog(context, 'Error', LittleFishIcons.error);
        }
        _isLoading = false;
        setState(() {});
      },
    ),
    leading: Material(
      elevation: 2.0,
      color: Theme.of(context).colorScheme.secondary,
      borderRadius: BorderRadius.circular(kBorderRadius!),
      child: Container(
        alignment: Alignment.center,
        height: 36,
        width: 36,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kBorderRadius!),
        ),
        child: Text(
          '${productVariant.productVariant!.products?.length ?? 0}',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    ),
    title: Text('${productVariant.displayName}'),
  );
}
