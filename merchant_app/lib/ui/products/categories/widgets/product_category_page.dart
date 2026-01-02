// Flutter imports:
// remove ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/footer_buttons_icon_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/footer_buttons_secondary_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/cards/card_square_flat.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/services/modal_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:littlefish_merchant/models/assets/app_assets.dart';
import 'package:littlefish_merchant/tools/helpers/product_barcode_helper.dart';
import 'package:littlefish_merchant/ui/products/categories/widgets/category_edit_page.dart';
import 'package:littlefish_merchant/ui/products/categories/widgets/product_category_selector_page_list.dart';
import 'package:littlefish_merchant/tools/file_manager.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:quiver/strings.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';
import 'package:littlefish_merchant/models/shared/form_view_model.dart';
import 'package:littlefish_merchant/models/stock/stock_category.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/products/categories/view_models/category_item_vm.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_tabbed_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/app/custom_route.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_tabbar.dart';
import 'package:uuid/uuid.dart';
import 'package:littlefish_icons/littlefish_icons.dart';

import '../../../../app/app.dart';
import '../../../../app/theme/applied_system/applied_text_icon.dart';
import '../../../../common/presentaion/components/icons/warning_icon.dart';
import '../../../../common/presentaion/pages/popup_forms/barcode_popup_form.dart';
import '../../../../injector.dart';
import '../../../../common/presentaion/pages/scaffolds/app_scaffold.dart';
import '../../../../providers/environment_provider.dart';
import '../../../../redux/product/product_actions.dart';
import '../../../../common/presentaion/components/form_fields/string_form_field.dart';
import '../../../../tools/helpers.dart';
import '../../../../tools/network_image/flutter_network_image.dart';
import '../../products/pages/multi_product_select_page.dart';
import '../view_models/category_collection_vm.dart';

class ProductCategoryPage extends StatefulWidget {
  static const String route = 'products/categories/category';

  final bool isEmbedded;
  final CategoriesViewModel? vmParent;

  final bool displayProducts;

  final BuildContext? parentContext;

  final Function()? onCategoryUpdate;

  const ProductCategoryPage({
    Key? key,
    this.isEmbedded = false,
    this.vmParent,
    this.displayProducts = true,
    this.parentContext,
    this.onCategoryUpdate,
  }) : super(key: key);

  @override
  State<ProductCategoryPage> createState() => _ProductCategoryPageState();
}

class _ProductCategoryPageState extends State<ProductCategoryPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String _numProductsCount = '0';

  StockCategory? category;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = EnvironmentProvider.instance.isLargeDisplay ?? false;
    return StoreConnector<AppState, CategoryViewModel>(
      converter: (Store<AppState> store) =>
          CategoryViewModel.fromStore(
              store,
              context: widget.parentContext ?? context,
            )
            ..key = formKey
            ..form = FormManager(formKey),
      builder: (BuildContext context, CategoryViewModel vm) {
        category = StockCategory().copyWith(vm.item!);
        category!.productCount = vm.item!.products!.length;

        _numProductsCount = (category!.productCount ?? 0).toString();

        return PopScope(
          canPop: true,
          onPopInvoked: (bool didPop) {
            if (vm.item!.isNew == false) {
              vm.store!.dispatch(initializeCategories(refresh: true));
            }
            if (didPop) return;
          },
          child: AppScaffold(
            enableProfileAction: false,
            displayBackNavigation: !isTablet,
            persistentFooterButtons: [
              category!.isNew == true
                  ? addCategoryCancelBtn(context, vm)
                  : addProductScanBtn(context, vm),
            ],
            actions: <Widget>[
              if (category!.isNew == false)
                IconButton(
                  onPressed: () async {
                    bool? result = await getIt<ModalService>().showActionModal(
                      context: context,
                      title: 'Delete Category',
                      description:
                          'Are you sure you want to delete this category?'
                          '\nThis cannot be undone.'
                          '\n\nProducts in this category will not be deleted - they will have no category.',
                      acceptText: 'Yes, Delete Category',
                      cancelText: 'No, Cancel',
                    );

                    if (result == true) {
                      Navigator.of(context).pop();
                      widget.vmParent!.onRemove(vm.item!, context);
                    }
                  },
                  icon: const Icon(Icons.delete),
                  color: Theme.of(context).extension<AppliedTextIcon>()?.error,
                ),
            ],
            title: category?.displayName ?? 'New Category',
            body: vm.isLoading!
                ? const AppProgressIndicator()
                : AppTabBar(reverse: true, tabs: tabs(context, vm)),
          ),
        );
      },
    );
  }

  Widget addCategoryCancelBtn(BuildContext context, CategoryViewModel vm) {
    return FooterButtonsSecondaryPrimary(
      primaryButtonText: 'Add Category',
      onPrimaryButtonPressed: (c) async {
        category!.removedProducts = vm.item != null
            ? vm.item!.removedProducts
            : category!.removedProducts;

        category!.newProducts = vm.item != null
            ? vm.item!.newProducts
            : category!.newProducts;

        vm.onUpdate(c, category!, true, true);
      },
      secondaryButtonText: 'Cancel',
      onSecondaryButtonPressed: (_) {
        Navigator.pop(context);
      },
    );
  }

  Widget addProductScanBtn(BuildContext context, CategoryViewModel vm) {
    return FooterButtonsIconPrimary(
      primaryButtonText: 'Add Product',
      allSecondaryControls: true,
      onPrimaryButtonPressed: (_) async {
        (EnvironmentProvider.instance.isLargeDisplay!
                ? showPopupDialog<List<StockProduct>>(
                    content: const MultiProductSelectPage(isEmbedded: true),
                    context: context,
                  )
                : Navigator.of(context).push(
                    CustomRoute<List<StockProduct>>(
                      maintainState: false,
                      builder: (BuildContext context) =>
                          const MultiProductSelectPage(),
                    ),
                  ))
            .onError((error, stackTrace) {
              debugPrint(
                '#### ProductCategoryPage: Error selecting products: $error',
              );
              return [];
            })
            .then((selectedProducts) {
              debugPrint(
                '#### ProductCategoryPage: Selected products: ${selectedProducts?.length ?? -1}',
              );
              _handleProductsSelection(
                context,
                selectedProducts!,
                vm,
                updateProductCount,
                widget.onCategoryUpdate!,
              );
            });
      },
      secondaryButtonIcon: MdiIcons.barcodeScan,
      onSecondaryButtonPressed: (context) async {
        if (cardPaymentRegistered == CardPaymentRegistered.pos) {
          String? barcode;
          barcode = await showPopupDialog(
            content: BarcodePopupForm(
              store: vm.store,
              laserScannerAvailable: AppVariables.laserScanningSupported,
            ),
            context: context,
            height: 392,
          );

          if (barcode == null || barcode.isEmpty) return;

          var product = await ProductBarcodeHelper.getProductByBarcode(
            barcode: barcode,
            store: vm.store,
          );

          // var product = vm.state!.getProductByBarcode(barcode);

          if (product == null) return;

          _handleProductSelection(context, product, vm);
        } else {
          getCameraAccess().then((result) async {
            if (result) {
              String? barcode;
              barcode = await showPopupDialog(
                context: context,
                content: BarcodePopupForm(
                  store: vm.store,
                  laserScannerAvailable: AppVariables.laserScanningSupported,
                ),
                height: 392,
              );

              if (barcode == null || barcode.isEmpty) {
                return;
              }

              var product = await ProductBarcodeHelper.getProductByBarcode(
                barcode: barcode,
                store: AppVariables.store,
              );

              // var product = vm.state!.getProductByBarcode(barcode);

              if (product == null) return;
              _handleProductSelection(context, product, vm);
            } else {
              showMessageDialog(
                context,
                'We require access to the camera to scan barcodes',
                Icons.camera,
              );
            }
          });
        }
      },
    );
  }

  List<TabBarItem> tabs(context, CategoryViewModel vm) {
    return <TabBarItem>[
      TabBarItem(text: 'Details', content: categoryContext(context, vm)),
    ];
  }

  SingleChildScrollView categoryContext(
    BuildContext context,
    CategoryViewModel vm,
  ) => SingleChildScrollView(
    physics: const BouncingScrollPhysics(),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Form(
          key: vm.key,
          child: Column(children: contextFill(context, vm, category!)),
        ),
        if (category!.isNew == false)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: CardSquareFlat(
              child: CategoryProductsList(
                categoryId: category!.id,
                parentContext: context,
                category: category,
                vm: vm,
                onProductSelect: (selectedProduct) {
                  if (selectedProduct != null) {
                    _handleProductSelection(context, selectedProduct, vm);
                  }
                },
                setCategory: (item) {
                  int updatedNum =
                      int.parse(_numProductsCount) +
                      vm.item!.newProducts.length -
                      vm.item!.removedProducts.length;
                  updateProductCount(updatedNum);

                  category!.productCount = vm.item!.products!.length;
                },
                onProductsSelected: (selectedProducts) {
                  _handleProductsSelection(
                    context,
                    selectedProducts!,
                    vm,
                    updateProductCount,
                    widget.onCategoryUpdate!,
                  );
                },
              ),
            ),
          ),
      ],
    ),
  );

  void _handleProductsSelection(
    BuildContext context,
    List<StockProduct> selectedProducts,
    CategoryViewModel vm,
    Function updateProductCount,
    Function onCategoryUpdate,
  ) {
    if (selectedProducts.isEmpty) return;

    List<StockProduct> newProducts = [];
    List<StockProduct> removedProducts = [];

    /// Determine new products (not in `vm.item!.products!`)
    for (StockProduct selectedProduct in selectedProducts) {
      if (!vm.item!.products!.any((p) => p.id == selectedProduct.id)) {
        newProducts.add(selectedProduct);
      }
    }

    /// Determine removed products (products in `vm.item!.products!` but not in `selectedProducts`)
    for (StockProduct existingProduct in vm.item!.products!) {
      if (!selectedProducts.any((p) => p.id == existingProduct.id)) {
        removedProducts.add(existingProduct);
      }
    }

    category!.newProducts = newProducts;
    category!.removedProducts = removedProducts;

    // Update the UI state
    setState(() {
      for (StockProduct selectedProduct in selectedProducts) {
        var product = StockProduct.clone(product: selectedProduct);

        if (!category!.products!.any((p) => p.id == product.id)) {
          product.categoryId = vm.item!.id;

          int updatedNum =
              int.parse(_numProductsCount) +
              category!.newProducts.length -
              category!.removedProducts.length;
          updateProductCount(updatedNum);

          category!.productCount = category!.products!.length;
        }
      }
    });

    // Trigger updates
    vm.onUpdate(context, category!, false, false);
    if (widget.onCategoryUpdate != null) {
      onCategoryUpdate();
    }
  }

  void _handleProductSelection(
    BuildContext context,
    StockProduct selectedProduct,
    CategoryViewModel vm,
  ) {
    var product = StockProduct.clone(product: selectedProduct);

    var existingIndex = vm.item!.products!.indexWhere(
      (p) => p.id == product.id,
    );

    if (existingIndex >= 0) {
      showMessageDialog(
        context,
        '${product.displayName} already exists in category',
        MdiIcons.information,
      );
      return; // Exit early to avoid duplicate addition
    }

    setState(() {
      product.categoryId = vm.item!.id;

      // Remove product from removedProducts if it was previously removed
      vm.item!.removedProducts.removeWhere((p) => p.id == product.id);

      // Add new product if it doesn't already exist
      if (!vm.item!.products!.any((p) => p.id == selectedProduct.id)) {
        vm.item!.newProducts.add(product);
        vm.item!.products!.add(product);
      }

      int updatedNum =
          int.parse(_numProductsCount) +
          vm.item!.newProducts.length -
          vm.item!.removedProducts.length;
      updateProductCount(updatedNum);

      category!.productCount = vm.item!.products!.length;
    });

    category = vm.item;
    vm.onUpdate(context, category!, false, false);
  }

  List<Widget> contextFill(
    BuildContext context,
    CategoryViewModel vm,
    StockCategory category,
  ) {
    return <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 24),
        child: category.imageUri == null
            ? InkWell(
                onTap: () async {
                  var imageType = await FileManager().selectFileSource(context);
                  if (imageType != null) {
                    return uploadImage(context, category, imageType, vm);
                  }
                },
                child: Container(
                  height: 170,
                  width: 170,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Theme.of(
                      context,
                    ).extension<AppliedSurface>()?.secondary,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate_outlined,
                        size: MediaQuery.of(context).size.width * (10 / 100),
                        color: Theme.of(
                          context,
                        ).extension<AppliedTextIcon>()?.primary,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * (3 / 100),
                      ),
                      Text(
                        'Add Image\n(optional)',
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).extension<AppliedTextIcon>()?.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : SizedBox(
                height: 170,
                width: 170,
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                        image: isNotBlank(category.imageUri)
                            ? DecorationImage(
                                image: getIt<FlutterNetworkImage>()
                                    .asImageProviderById(
                                      legacyUrl: category.imageUri!,
                                      id: category.id!,
                                      category: 'categories',
                                    ),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: category.isNew == false
                          ? Container(color: Colors.blue.withOpacity(0))
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                isNotBlank(category.imageUri)
                                    ? Container()
                                    : Icon(
                                        Icons.add_photo_alternate_outlined,
                                        size:
                                            MediaQuery.of(context).size.width *
                                            (10 / 100),
                                      ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.width *
                                      (3 / 100),
                                ),
                                isNotBlank(category.imageUri)
                                    ? Container()
                                    : Text(
                                        'Add Image\n(optional)',
                                        style: TextStyle(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.secondary,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                              ],
                            ),
                    ),
                    Positioned.fill(
                      right: -4,
                      top: -4,
                      child: Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: SvgPicture.asset(
                            AppAssets.closeButtonSvg,
                            width: 24,
                            height: 24,
                          ),
                          onPressed: () {
                            category.imageUri = null;

                            category.removedProducts = vm.item != null
                                ? vm.item!.removedProducts
                                : category.removedProducts;

                            category.newProducts = vm.item != null
                                ? vm.item!.newProducts
                                : category.newProducts;

                            vm.onSetCategory(category);
                            // vm.onUpdate(context, category, false, false);
                            if (mounted) setState(() {});
                          },
                        ),
                      ),
                    ),
                    if (category.imageUri != null)
                      InkWell(
                        child: Container(
                          height:
                              MediaQuery.of(context).size.width *
                              (45 / 100) *
                              (0.25),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade700.withOpacity(0.75),
                            borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(8),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              'Edit Image',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        onTap: () async {
                          var imageType = await FileManager().selectFileSource(
                            context,
                          );
                          if (imageType != null) {
                            return uploadImage(
                              context,
                              category,
                              imageType,
                              vm,
                            );
                          }
                        },
                      ),
                  ],
                ),
              ),
      ),
      //Category Name
      category.isNew == true
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: StringFormField(
                enforceMaxLength: false,
                maxLength: 24,
                hintText: 'Name',
                minLines: 1,
                useOutlineStyling: true,
                maxLines: 1,
                key: const Key('name'),
                labelText: 'Category Name',
                nextFocusNode: vm.form.setFocusNode('description'),
                onFieldSubmitted: (value) {
                  category.name = category.displayName = value;
                },
                inputAction: TextInputAction.next,
                initialValue: this.category!.displayName ?? this.category!.name,
                isRequired: true,
                onSaveValue: (value) {
                  category.name = category.displayName = value;
                },
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 5,
                    child: context.labelMedium(
                      category.displayName ?? category.name ?? '',
                      alignLeft: true,
                      isBold: true,
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: IconButton(
                      icon: const Icon(Icons.edit),
                      color: Colors.grey.shade600,
                      onPressed: () => Navigator.of(context).push(
                        CustomRoute(
                          maintainState: false,
                          builder: (BuildContext context) =>
                              ProductCategoryFormNew(
                                category: category,
                                vm: vm,
                                key: widget.key,
                                onSubmit: (category) {
                                  vm.onUpdate(context, category, false, false);
                                },
                                isEmbedded: true,
                              ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      category.isNew == true ? const SizedBox(height: 12) : const SizedBox(),
      // Description
      category.isNew == true
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: StringFormField(
                enforceMaxLength: true,
                maxLength: 500,
                maxLines: 120,
                minLines: 1,
                useOutlineStyling: true,
                hintText: 'Describe your product',
                key: const Key('description'),
                labelText: 'Description',
                focusNode: vm.form.setFocusNode('description'),
                nextFocusNode: vm.form.setFocusNode('new'),
                onFieldSubmitted: (value) {
                  category.description = value;
                },
                inputAction: TextInputAction.newline,
                initialValue: category.description,
                isRequired: false,
                onSaveValue: (value) {
                  category.description = value;
                },
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: context.labelMedium(
                  category.description ?? '',
                  alignLeft: true,
                  isBold: false,
                ),
              ),
            ),
      const CommonDivider(),
      const SizedBox(height: 8),
      if (category.isNew == false)
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: context.labelMedium(
            '$_numProductsCount ${int.parse(_numProductsCount) == 1 ? 'Product' : 'Products'}',
            alignLeft: true,
            isSemiBold: true,
          ),
        ),
    ];
  }

  Column customDeleteBody(BuildContext context) => Column(
    children: [
      Material(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          child: const SizedBox(
            height: 56,
            width: 56,
            child: WarningIcon(size: 24),
          ),
        ),
      ),
      const SizedBox(height: 24),
      const Text(
        'Delete category?',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 18,
        ),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 8),
      Text(
        'Are you sure you want to delete this category? This cannot be undone.',
        style: TextStyle(
          color: Colors.grey.shade700,
          fontSize: 16,
          height: 1.5,
        ),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 16),
      Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            height: 24,
            width: 24,
            child: Icon(LittleFishIcons.info, size: 24),
          ),
        ),
      ),
      Text(
        'Products in this category will not be deleted - they will have no category.',
        style: TextStyle(
          color: Colors.grey.shade700,
          fontSize: 16,
          height: 1.5,
        ),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 24),
    ],
  );

  Future<void> uploadImage(
    BuildContext context,
    StockCategory? item,
    ImageSource source,
    CategoryViewModel? vm,
  ) async {
    var selectedImage = await imagePicker.pickImage(source: source);

    if (selectedImage == null) return;

    if (!await FileManager().isFileTypeAllowed(selectedImage, context)) {
      return;
    }

    showProgress(context: context);

    try {
      var state = AppVariables.store!.state;
      var file = File(selectedImage.path);
      var downloadUrl = await FileManager().uploadFile(
        file: file,
        businessId: state.businessId!,
        category: 'categories',
        id: category?.id ?? const Uuid().v4(),
        businessName: '',
      );

      category!.businessId = state.businessId;
      category!.imageUri = downloadUrl.downloadUrl;

      hideProgress(context);
      //we should change the image to the new one

      if (category!.isNew == true) {
        if (mounted) {
          setState(() {
            vm?.onSetCategory(category!);
          });
        }
      } else {
        vm!.onUpdate(context, category!, false, false);
      }
    } on PlatformException catch (e) {
      hideProgress(context);

      showMessageDialog(
        context,
        '${e.code}: ${e.message}',
        LittleFishIcons.warning,
      );
    } catch (e) {
      hideProgress(context);

      reportCheckedError(e, trace: StackTrace.current);

      showMessageDialog(
        context,
        'Something went wrong, please try again later',
        LittleFishIcons.error,
      );
    }
  }

  updateProductCount(int value) {
    setState(() {
      _numProductsCount = value.toString();
    });
  }
}
