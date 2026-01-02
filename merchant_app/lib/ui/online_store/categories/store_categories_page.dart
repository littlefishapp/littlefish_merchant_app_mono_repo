// remove ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/services/modal_service.dart';
import 'package:littlefish_merchant/injector.dart';

import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/online_store/categories/store_category_page.dart';
import 'package:littlefish_merchant/ui/online_store/common/config.dart';
import 'package:littlefish_merchant/ui/online_store/shared/firebase_image.dart';
import 'package:littlefish_merchant/ui/online_store/viewmodels/manage_store_vm.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:quiver/strings.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../../../common/presentaion/components/custom_app_bar.dart';
import '../../../features/ecommerce_shared/models/store/store_product.dart';
import '../../../common/presentaion/components/dialogs/common_dialogs.dart';
import '../../../common/presentaion/components/form_fields/auto_complete_text_field.dart';
import '../../../common/presentaion/components/common_divider.dart';
import '../tools.dart';

class StoreCategoriesPage extends StatefulWidget {
  static const String route = 'store/categories';

  final Function(StoreProductCategory item)? onTap;

  final bool canAddNew;

  final bool subCategory;

  const StoreCategoriesPage({
    Key? key,
    this.onTap,
    this.canAddNew = true,
    this.subCategory = false,
  }) : super(key: key);

  @override
  State<StoreCategoriesPage> createState() => _StoreCategoriesPageState();
}

class _StoreCategoriesPageState extends State<StoreCategoriesPage> {
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
                    captureCategory(context, vm);
                  },
                )
              : null,
          appBar: const CustomAppBar(title: Text('Categories')),
          body: SafeArea(child: layout(context, vm)),
        );
      },
      converter: (Store store) =>
          ManageStoreVM.fromStore(store as Store<AppState>),
    );
  }

  Container layout(context, ManageStoreVM vm) =>
      Container(child: categoryList(context, vm));

  Column categoryList(BuildContext context, ManageStoreVM vm) => Column(
    children: [
      if (vm.isLoading!) const LinearProgressIndicator(),
      Expanded(
        child: vm.isLoading == false || vm.hasCategories
            ? vm.hasCategories
                  ? ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemCount: (vm.categories.length),
                      itemBuilder: (BuildContext context, int index) {
                        var item = vm.categories[index];
                        return StoreStoreCategoriesPageTile(
                          item: item,
                          dismissAllowed: true,
                          onTap: (item) {
                            if (widget.onTap == null) {
                              captureCategory(context, vm, cat: item);
                            } else {
                              widget.onTap!(item);
                            }
                          },
                          trailing: PopupMenuButton(
                            onSelected: (dynamic value) async {
                              switch (value) {
                                case 1:
                                  var res = await Tools.createCategoryLink(
                                    context,
                                    vm.categories[index],
                                  );

                                  await Share.share(
                                    res,
                                    subject:
                                        "${'Share'} ${vm.categories[index].displayName}",
                                  );
                                  break;
                                case 2:
                                  var result = await getIt<ModalService>()
                                      .showActionModal(
                                        context: context,
                                        title: 'Delete Category?',
                                        description:
                                            'Are you sure you want to delete this category?',
                                        acceptText: 'Yes, Delete',
                                        cancelText: 'No, Cancel',
                                      );

                                  if (result == true) {
                                    // setLoading(true);
                                    try {
                                      await vm.deleteProdCategory(
                                        vm.categories[index],
                                        context,
                                      );
                                    } catch (e) {
                                      showMessageDialog(
                                        context,
                                        e as String,
                                        LittleFishIcons.error,
                                      );
                                    } finally {
                                      // setLoading(false);
                                    }
                                  }
                                  break;
                              }
                            },
                            itemBuilder: (BuildContext ctx) => [
                              PopupMenuItem(
                                value: 1,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Share'),
                                    Icon(MdiIcons.share),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 2,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Delete'),
                                    Icon(Icons.delete),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const CommonDivider(),
                    )
                  : const Center(child: Text('Nothing found'))
            : const SizedBox.shrink(),
      ),
    ],
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

          return StoreCategoryPage(vm: vm, item: cat);
        },
      ),
    );
  } else {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) {
          return StoreCategoryPage(vm: vm);
        },
      ),
    );
  }
}

class StoreStoreCategoriesPageTile extends StatelessWidget {
  const StoreStoreCategoriesPageTile({
    Key? key,
    required this.item,
    this.onTap,
    this.dismissAllowed = false,
    this.onRemove,
    this.selected = false,
    required this.trailing,
  }) : super(key: key);

  final bool selected;

  final StoreProductCategory item;

  final Widget trailing;

  final bool dismissAllowed;

  final Function(StoreProductCategory item)? onTap;

  final Function(StoreProductCategory item)? onRemove;

  @override
  Widget build(BuildContext context) {
    return categoryTile(context, item);
  }

  ListTile categoryTile(BuildContext context, StoreProductCategory item) =>
      ListTile(
        tileColor: Theme.of(context).colorScheme.background,
        selected: selected,
        title: Text('${item.displayName}'),
        leading: isBlank(item.featureImageUrl)
            ? Icon(
                Icons.image,
                size: 52,
                color: Theme.of(context).colorScheme.secondary,
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(kBorderRadius!),
                child: SizedBox(
                  height: 48,
                  width: 48,
                  child: FirebaseImage(imageAddress: item.featureImageUrl),
                ),
              ),
        subtitle: Text('${item.productCount} ${"Items"}'),
        trailing: trailing,
        onTap: onTap == null
            ? null
            : () {
                if (onTap != null) onTap!(item);
              },
      );
}

enum ProductViewMode { productsView, stockView }
