import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/services/modal_service.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/online_store/products/pages/product_categories/sub_category_screen.dart';
import 'package:littlefish_merchant/ui/online_store/viewmodels/manage_store_vm.dart';
import 'package:quiver/strings.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

import '../../../../../features/ecommerce_shared/models/store/store_product.dart';
import '../../../../../common/presentaion/components/form_fields/auto_complete_text_field.dart';
import '../../../../../common/presentaion/components/common_divider.dart';
import '../../../../../common/presentaion/components/app_progress_indicator.dart';
import '../../../../../injector.dart';
import '../../../../../tools/network_image/flutter_network_image.dart';

class SubCategoryList extends StatefulWidget {
  final Function(StoreProductCategory item)? onTap;

  final bool canAddNew;

  final StoreProductCategory? parentCategory;

  const SubCategoryList({
    Key? key,
    this.onTap,
    this.canAddNew = true,
    required this.parentCategory,
  }) : super(key: key);

  @override
  State<SubCategoryList> createState() => _SubCategoryListState();
}

class _SubCategoryListState extends State<SubCategoryList> {
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
        return Scaffold(
          floatingActionButton: widget.canAddNew
              ? FloatingActionButton(
                  child: const Icon(Icons.add),
                  onPressed: () {
                    captureSubCategory(context, vm);
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
        itemCount: widget.parentCategory!.subCategories?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          var item = widget.parentCategory!.subCategories![index];
          return StoreSubCategoryListTile(
            item: item,
            dismissAllowed: true,
            onTap: (item) {
              if (widget.onTap == null) {
                captureSubCategory(context, vm, cat: item);
              } else {
                widget.onTap!(item);
              }
            },
            onRemove: (item) {
              vm.deleteProductSubCategory(item, context);
            },
          );
        },
        separatorBuilder: (BuildContext context, int index) =>
            const CommonDivider(),
      );

  Future<void> captureSubCategory(
    BuildContext context,
    ManageStoreVM vm, {
    StoreProductCategory? cat,
  }) async {
    if (cat != null) {
      // vm.setSelectedItem(product);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) {
            return SubCategoryScreen(
              vm: vm,
              item: cat,
              parentCategory: widget.parentCategory,
            );
          },
        ),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) {
            return SubCategoryScreen(
              vm: vm,
              parentCategory: widget.parentCategory,
            );
          },
        ),
      );
    }
  }
}

class StoreSubCategoryListTile extends StatelessWidget {
  const StoreSubCategoryListTile({
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
    return dismissAllowed
        ? dismissibleProductTile(context, item)
        : productTile(context, item);
  }

  Dismissible dismissibleProductTile(
    BuildContext context,
    StoreProductCategory item,
  ) => Dismissible(
    key: Key(item.id!),
    background: Container(color: Colors.red),
    direction: DismissDirection.endToStart,
    confirmDismiss: (direction) => confirmDismissal(context, item),
    onDismissed: (direction) => onRemove == null ? {} : onRemove!(item),
    child: productTile(context, item),
  );

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
        trailing: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          child: Text(
            item.productCount.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        onTap: onTap == null
            ? null
            : () {
                if (onTap != null) onTap!(item);
              },
      );

  Future<bool?> confirmDismissal(
    BuildContext context,
    StoreProductCategory item,
  ) async {
    return await getIt<ModalService>().showActionModal(
      context: context,
      title: 'Delete item?',
      description: 'Are you sure you want to delete this item?',
    );
  }
}

enum ProductViewMode { productsView, stockView }
