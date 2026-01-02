// removed ignore: depend_on_referenced_packages, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/services/modal_service.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/ui/online_store/products/viewmodels/product_vm.dart';
import 'package:littlefish_merchant/ui/online_store/products/widgets/product_tile.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:redux/redux.dart';
import 'package:quiver/strings.dart';

import '../../../../common/presentaion/components/app_progress_indicator.dart';
import '../../../../features/ecommerce_shared/models/store/store_product.dart';
import '../../../../models/enums.dart';
import '../../../../common/presentaion/components/dialogs/common_dialogs.dart';

class ProductsList extends StatefulWidget {
  final String layout;

  final bool manageLayout;

  final bool captureQtyEnabled;

  final bool manageStock;

  final Function(StoreProduct item)? onTap;

  final Function? onLongPress;

  final Function? onFetched;

  final bool isFeatured;

  final bool onSale;

  final String? categoryId;

  final StoreProductCategory? category;

  final bool showImage;

  final ListViewMode listViewMode;

  const ProductsList({
    Key? key,
    this.layout = 'list',
    this.captureQtyEnabled = false,
    this.manageStock = false,
    this.onLongPress,
    this.onTap,
    this.showImage = true,
    this.onFetched,
    this.manageLayout = false,
    this.categoryId,
    this.isFeatured = false,
    this.onSale = false,
    this.category,
    this.listViewMode = ListViewMode.view,
  }) : super(key: key);

  @override
  ProductsListState createState() => ProductsListState();
}

class ProductsListState extends State<ProductsList> {
  final _scrollController = ScrollController();

  final _scrollThreshold = 200.0;

  ProductVM? vm;

  late Store<AppState> store;

  bool isLoading = false;

  String? subCategoryId;

  String? subCategoryName;

  refresh() {
    if (mounted) {
      setState(() {
        vm!.clear();
        vm!.fetchProducts(categoryId: widget.categoryId, onSale: widget.onSale);
      });
    } else {
      vm!.clear();
      vm!.fetchProducts(categoryId: widget.categoryId, onSale: widget.onSale);
    }
  }

  setLoading(bool value) {
    if (mounted) {
      setState(() {
        isLoading = value;
      });
    } else {
      isLoading = value;
    }
  }

  onFetchError(error) {
    debugPrint('something went wrong');
  }

  onFetched() {
    if (null != widget.onFetched) widget.onFetched!();
  }

  @override
  void initState() {
    // if (vm == null) {
    store = AppVariables.store!;

    // ProductSearchParams params;

    // if (widget.categoryId != null || widget.isFeatured || widget.onSale) {
    //   params = ProductSearchParams(
    //     categories: widget.categoryId != null ? [widget.categoryId] : [],
    //     subCategories: isNotBlank(subCategoryId) ? [subCategoryId] : [],
    //     searchFeatured: widget.isFeatured,
    //     searchOnSale: widget.onSale,
    //   );
    // }

    vm = ProductVM.fromStore(store, null)
      ..onFetching = setLoading
      ..onFetchError = onFetchError
      ..onFetched = onFetched;

    //start fetching the products
    vm!.fetchProducts(categoryId: widget.categoryId, onSale: widget.onSale);
    // }

    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      vm!.fetchProducts(categoryId: widget.categoryId, onSale: widget.onSale);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (vm!.productCount <= 0 && !isLoading && isBlank(subCategoryId)) {
      return const Center(child: Text('No Data'));
    }

    if (vm!.productCount <= 0 && isLoading) {
      return const Column(
        children: <Widget>[
          LinearProgressIndicator(),
          Expanded(child: Center(child: Text('Loading'))),
        ],
      );
    }

    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            shrinkWrap: true,
            itemBuilder: (c, i) {
              var product = vm!.products![i];
              return widget.listViewMode == ListViewMode.view
                  ? viewModeTile(product, vm)
                  : selectModeTile(product, vm, context);
            },
            itemCount: vm!.products?.length ?? 0,
          ),
        ),
        if (isLoading) const LinearProgressIndicator(),
      ],
    );
  }

  viewModeTile(StoreProduct product, ProductVM? vm) => ProductTile(
    product: product,
    displayMode: ItemDisplayMode.list,
    captureQtyEnabled: widget.captureQtyEnabled,
    onTap: widget.onTap,
    onLongPress: widget.onLongPress,
    onRemove: (item) async {
      var result = await getIt<ModalService>().showActionModal(
        context: context,
        title: 'Delete item?',
        description: 'Are you sure you want to delete this item?',
      );

      if (result == true) {
        setLoading(true);
        try {
          await vm!.deleteProduct(context, item);
        } catch (e) {
          showMessageDialog(context, (e as dynamic), LittleFishIcons.error);
        } finally {
          setLoading(false);
        }
      }
    },
    trailing: PopupMenuButton(
      onSelected: (dynamic value) async {
        switch (value) {
          case 1:
            // var res = await createProductLink(context, product);

            // await Share.share(
            //   res,
            //   subject:
            //       "${'Share'} ${product.displayName}",
            // );
            break;
          case 2:
            var result = await getIt<ModalService>().showActionModal(
              context: context,
              title: 'Delete item?',
              description: 'Are you sure you want to delete this item?',
            );

            if (result == true) {
              setLoading(true);
              try {
                await vm!.deleteProduct(context, product);
              } catch (e) {
                showMessageDialog(
                  context,
                  (e as dynamic),
                  LittleFishIcons.error,
                );
              } finally {
                setLoading(false);
              }
            }
            break;
        }
      },
      itemBuilder: (BuildContext ctx) => [
        PopupMenuItem(
          value: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Text('Share'), Icon(MdiIcons.share)],
          ),
        ),
        const PopupMenuItem(
          value: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text('Delete'), Icon(Icons.delete)],
          ),
        ),
      ],
    ),
  );

  selectModeTile(StoreProduct product, ProductVM? vm, BuildContext? ctx) =>
      ProductTile(
        product: product,
        displayMode: ItemDisplayMode.list,
        captureQtyEnabled: widget.captureQtyEnabled,
        onTap: () {
          Navigator.of(ctx ?? context).pop(product);
        },
        onLongPress: widget.onLongPress,
        trailing: const SizedBox.shrink(),
      );
}

class BottomLoader extends StatelessWidget {
  const BottomLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: const Center(
        child: SizedBox(width: 33, height: 33, child: AppProgressIndicator()),
      ),
    );
  }
}
