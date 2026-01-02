import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/online_store/shared/list_trailing_widget.dart';
import 'package:littlefish_merchant/ui/online_store/viewmodels/manage_store_vm.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';
import 'package:quiver/strings.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';
import '../../../../../features/ecommerce_shared/models/store/store_product.dart';
import '../../../../../common/presentaion/components/form_fields/auto_complete_text_field.dart';
import '../../../../../common/presentaion/components/common_divider.dart';
import '../../../../../common/presentaion/components/app_progress_indicator.dart';
import '../../../../../injector.dart';
import '../../../../../tools/network_image/flutter_network_image.dart';
import 'store_product_category_screen.dart';

class ProductCategoryList extends StatefulWidget {
  final Function(StoreProductCategory item)? onTap;
  final bool canAddNew;
  final bool subCategory;
  const ProductCategoryList({
    Key? key,
    this.onTap,
    this.canAddNew = true,
    this.subCategory = false,
  }) : super(key: key);

  @override
  State<ProductCategoryList> createState() => _ProductCategoryListState();
}

class _ProductCategoryListState extends State<ProductCategoryList> {
  GlobalKey<AutoCompleteTextFieldState<StoreProductCategory>>? filterkey;
  GlobalKey? newItemKey;
  @override
  void initState() {
    filterkey = GlobalKey<AutoCompleteTextFieldState<StoreProductCategory>>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ManageStoreVM>(
      builder: (BuildContext context, vm) {
        return AppSimpleAppScaffold(
          title: 'Categories',
          floatingActionButton: widget.canAddNew
              ? FloatingActionButton(
                  child: const Icon(Icons.add),
                  onPressed: () {
                    captureCategory(context, vm);
                  },
                )
              : null,
          body: SafeArea(child: layout(context, vm)),
        );
      },
      converter: (Store store) =>
          ManageStoreVM.fromStore(store as Store<AppState>),
    );
  }

  Container layout(context, ManageStoreVM vm) => Container(
    child: vm.isLoading!
        ? const AppProgressIndicator()
        : categoryList(context, vm),
  );

  ListView categoryList(BuildContext context, ManageStoreVM vm) =>
      ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemCount: (vm.categories.length),
        itemBuilder: (BuildContext context, int index) {
          var item = vm.categories[index];
          return StoreProductCategoryListTile(
            item: item,
            dismissAllowed: true,
            onTap: (item) {
              if (widget.onTap == null) {
                captureCategory(context, vm, cat: item);
              } else {
                widget.onTap!(item);
              }
            },
          );
        },
        separatorBuilder: (BuildContext context, int index) =>
            const CommonDivider(),
      );
}

Future<void> captureCategory(
  BuildContext context,
  ManageStoreVM vm, {
  StoreProductCategory? cat,
}) async {
  if (cat != null) {
    // vm.setSelectedItem(product);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) {
          cat.isNew = false;

          return StoreProductCategoryScreen(vm: vm, item: cat);
        },
      ),
    );
  } else {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) {
          return StoreProductCategoryScreen(vm: vm);
        },
      ),
    );
  }
}

class StoreProductCategoryListTile extends StatelessWidget {
  const StoreProductCategoryListTile({
    Key? key,
    required this.item,
    this.onTap,
    this.dismissAllowed = false,
    this.onRemove,
    this.selected = false,
  }) : super(key: key);

  final bool selected;

  final StoreProductCategory item;

  final bool dismissAllowed;

  final Function(StoreProductCategory item)? onTap;

  final Function(StoreProductCategory item)? onRemove;

  @override
  Widget build(BuildContext context) {
    return productTile(context, item);
  }

  ListTile productTile(BuildContext context, StoreProductCategory item) =>
      ListTile(
        tileColor: Theme.of(context).colorScheme.background,
        selected: selected,
        title: Text('${item.displayName}'),
        leading: isBlank(item.featureImageUrl)
            ? const Icon(Icons.image, size: 48)
            : SizedBox(
                height: 48,
                width: 48,
                child: getIt<FlutterNetworkImage>().asWidget(
                  id: item.id!,
                  category: 'products',
                  legacyUrl: item.featureImageUrl!,
                  height: AppVariables.listImageHeight,
                  width: AppVariables.listImageWidth,
                  httpHeaders: {
                    HttpHeaders.authorizationHeader:
                        'Bearer ${AppVariables.store!.state.token!}',
                  },
                ),
              ),
        subtitle: isBlank(item.description) ? null : Text(item.description!),
        trailing: ListTrailingWidget(
          borderColor: Theme.of(context).colorScheme.secondary,
          child: Text(
            item.productCount.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        onTap: onTap == null
            ? null
            : () {
                if (onTap != null) onTap!(item);
              },
      );
}

enum ProductViewMode { productsView, stockView }
