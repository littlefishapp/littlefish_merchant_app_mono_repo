// Dart imports:
// remove ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_picker/image_picker.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_tabbar.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/footer_buttons_secondary_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/toggle_switch.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/services/modal_service.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_tabbed_scaffold.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/stock/full_product.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/models/stock/product_option.dart';
import 'package:littlefish_merchant/models/stock/stock_run_helper.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/redux/store/store_actions.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:littlefish_merchant/common/presentaion/components/keyboard_dismissal_utility.dart';
import 'package:littlefish_merchant/tools/helpers/sku_generator.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/HelperUtilities/product_catalogue_utils.dart';
import 'package:littlefish_merchant/ui/products/products/widgets/branded_info_container.dart';
import 'package:littlefish_merchant/ui/products/products/widgets/margin_profit_row.dart';
import 'package:littlefish_merchant/ui/products/products/widgets/multi_image_manager.dart';
import 'package:littlefish_merchant/ui/products/products/widgets/product_options_content.dart';
import 'package:littlefish_merchant/ui/products/products/widgets/stock_control_fields.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:quiver/strings.dart';

// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';
import 'package:uuid/uuid.dart';

// Project imports:
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/models/shared/form_view_model.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/tools/file_manager.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/tools/extensions/extensions.dart';
import 'package:littlefish_merchant/ui/products/products/view_models/product_item_vm.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/alphanumeric_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/barcode_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/currency_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/dropdown_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/string_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/yes_no_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';

import '../../../../app/theme/applied_system/applied_text_icon.dart';
import '../../../../injector.dart';
import '../../../../common/presentaion/pages/scaffolds/app_scaffold.dart';
import '../../../../models/tax/vat_level.dart';
import '../../../../shared/constants/permission_name_constants.dart';
import '../view_models/product_collection_vm.dart';

class ProductPage extends StatefulWidget {
  static const String route = '/products/product';
  final ProductsViewModel? vmParent;

  final String? productId;

  final bool isEmbedded;

  final BuildContext? parentContext;

  final Function? onProductUpdate;
  final bool useTabletConfig;

  final ProductPageContext pageContext;

  const ProductPage({
    Key? key,
    this.productId,
    this.vmParent,
    this.isEmbedded = false,
    this.parentContext,
    this.onProductUpdate,
    this.pageContext = ProductPageContext.general,
    this.useTabletConfig = false,
  }) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late List<ProductOption> _productOptions;
  final GlobalKey<FormState> formKey = GlobalKey();
  StockProduct? _product;
  double checkerHeight = 56;
  bool isValidCheck = true;
  bool hasScanBarcodePerm = true;
  bool isVatEnabled = false;
  String oldBarCode = '';
  String newBarCode = '';
  late bool enableProductVarianceManagement;

  FormManager? form;
  List<VatLevel>? vatRates;

  @override
  void initState() {
    form = FormManager(formKey);
    hasScanBarcodePerm = userHasPermission(allowScanBarcode);
    enableProductVarianceManagement =
        AppVariables.store?.state.enableProductVarianceManagement ?? false;
    vatRates = AppVariables.store?.state.appSettingsState.vatLevelsList;
    isVatEnabled =
        AppVariables.store?.state.businessState.profile?.vatEnabled ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('#### ProductPage build');
    final isTablet = EnvironmentProvider.instance.isLargeDisplay ?? false;
    return StoreConnector<AppState, ProductViewModelNew>(
      onInit: (store) {
        final vm = ProductViewModelNew.fromStore(store);
        _productOptions = List<ProductOption>.from(vm.productOptions);
        _product = vm.item?.copyWith() ?? StockProduct.create();
        _product?.isStockTrackable ??= true;
        _product?.taxId ??=
            vatRates?.any((t) => t.vatLevelId == _product?.taxId) == true
            ? _product!.taxId
            : AppVariables.store?.state.appSettingsState.salesTax?.id;
        _productOptions = setProductOptionsTax(_product?.taxId ?? '');

        // Set isOnline to true for the online store context
        if (widget.pageContext == ProductPageContext.onlineStore) {
          _product!.isOnline = true;
        }
      },
      converter: (Store store) {
        debugPrint('### ProductPage converter called');
        return ProductViewModelNew.fromStore(store as Store<AppState>)
          ..form = form;
      },
      builder: (BuildContext ctx, ProductViewModelNew vm) {
        if (_productOptions.isEmpty && vm.productOptions.isNotEmpty) {
          _productOptions = List<ProductOption>.from(vm.productOptions);
        }
        if (isTablet) {
          final productIsNotNew =
              _product != null &&
              _product!.sku != null &&
              _product!.sku!.isNotEmpty;
          if (productIsNotNew) {
            _product = (vm.item as StockProduct).copyWith();
          }
        } else {
          _product ??= (vm.item as StockProduct).copyWith();
        }
        debugPrint(
          '### ProductPage called with product: ${_product?.displayName}',
        );

        if (_product?.regularBarCode?.isNotEmpty ?? false) {
          oldBarCode = _product!.regularBarCode!;
        }
        return KeyboardDismissalUtility(
          content: scaffold(widget.parentContext ?? context, vm),
          parentContext: context,
        );
      },
    );
  }

  Widget scaffold(context, ProductViewModelNew vm) {
    final isNewProduct = _product?.displayName == null;
    final title = isNewProduct ? 'Add Product' : _product?.displayName;
    return AppScaffold(
      title: title ?? 'Add Product',
      resizeToAvoidBottomPadding: true,
      displayAppBar: widget.isEmbedded ? false : true,
      persistentFooterButtons: vm.isLoading == true
          ? null
          : [
              FooterButtonsSecondaryPrimary(
                useTabletConfig: widget.useTabletConfig,
                primaryButtonText: _isOnlineStorePage()
                    ? 'Publish Product'
                    : 'Save',
                onPrimaryButtonPressed: (ctx) async {
                  await _saveProduct(vm);
                },
                onSecondaryButtonPressed: (ctx) {
                  Navigator.of(context).pop();
                },
                secondaryButtonText: _isOnlineStorePage() ? 'Cancel' : 'Back',
              ),
            ],
      actions: <Widget>[
        if (!isNewProduct)
          IconButton(
            onPressed: () async {
              bool? result = await getIt<ModalService>().showActionModal(
                context: context,
                title: 'Delete Product',
                acceptText: 'Yes, Delete Product',
                cancelText: 'No, Cancel',
                description:
                    'Are you sure you want to delete this product?'
                    '\nThis cannot be undone.'
                    '\n\nIf the product is online, it will be deleted from the online store as well.',
              );

              if (result == true && context.mounted) {
                vm.onRemoveProduct!(vm.item!);
                Navigator.of(context).pop();
              }
            },
            icon: const Icon(Icons.delete),
            color: Theme.of(context).extension<AppliedTextIcon>()?.error,
          ),
      ],
      body: vm.isLoading!
          ? const AppProgressIndicator()
          : Form(
              key: vm.form!.key,
              child: enableProductVarianceManagement
                  ? AppTabBar(
                      tabs: [
                        TabBarItem(
                          text: 'General',
                          content: _generalTabContent(vm),
                        ),
                        TabBarItem(
                          text: 'Options',
                          content: _optionsTabContent(vm),
                        ),
                      ],
                      onTabChanged: (int index) {
                        FocusScope.of(context).unfocus();
                      },
                    )
                  : _generalTabContent(vm),
            ),
    );
  }

  Widget _generalTabContent(ProductViewModelNew vm) {
    return Container(
      padding: widget.isEmbedded
          ? const EdgeInsets.symmetric(horizontal: 8)
          : null,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            _productImages(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: formDetails(context, vm),
            ),
          ],
        ),
      ),
    );
  }

  Widget _optionsTabContent(ProductViewModelNew vm) {
    return ProductOptionsContent(
      productWithOptions: FullProduct(
        product: _product!,
        productOptions: _productOptions,
      ),
      allOptionAttributes: vm.allOptionAttributes,
      onUpsert: (optionAttribute, originalOptionName) {
        setState(() {
          _product!.productOptionAttributes ??= [];
          _product!.productOptionAttributes?.upsertWhere(
            optionAttribute,
            (existing) => existing.option == originalOptionName,
          );
          _productOptions = vm.regenerateVariants(_product!, _productOptions);
        });
      },
      onDelete: (optionAttribute) {
        setState(() {
          _product!.productOptionAttributes ??= [];
          _product!.productOptionAttributes?.removeWhere(
            (element) => element.option == optionAttribute.option,
          );
          _productOptions = vm.regenerateVariants(_product!, _productOptions);
        });
      },
      onSaveVariant: (ProductOption updatedOption) {
        final idx = _productOptions.indexWhere(
          (opt) => opt.id == updatedOption.id,
        );
        if (idx != -1) {
          setState(() {
            _productOptions[idx] = updatedOption;
          });
        }
      },
      maxOptions: 3,
      onManageVariantStockChanged: (bool isManageVariantStock) {
        setState(() {
          _product!.manageVariantStock = isManageVariantStock;
          _product!.isStockTrackable = !isManageVariantStock;
          _productOptions = vm.updateVariantStockManagement(
            options: _productOptions,
            isVariantStockManagement: isManageVariantStock,
          );
        });
      },
    );
  }

  Future<void> _saveProduct(ProductViewModelNew vm) async {
    if (_product == null || vm.store == null) {
      showMessageDialog(
        context,
        'Something went wrong while initialising your product, please try again.',
        LittleFishIcons.error,
      );
      return;
    }

    if (vm.form?.key?.currentState?.validate() ?? false) {
      vm.form!.key!.currentState!.save();

      if (_productOptions.any(
        (option) => (option.regularSellingPrice ?? 0) <= 0,
      )) {
        showMessageDialog(
          context,
          'Please ensure that all product options have a selling price greater than zero.',
          LittleFishIcons.error,
        );
        return;
      }

      if (_productOptions.isNotEmpty &&
          (_product?.regularSellingPrice ?? 0) <= 0) {
        showMessageDialog(
          context,
          'Products with options must have a selling price greater than zero.',
          LittleFishIcons.error,
        );
        return;
      }

      if (vm.isNew == true) {
        var isUnique = await vm.isBarcodeUnique!(newBarCode);
        _product!.regularBarCode = newBarCode;

        if (!isUnique) {
          if (context.mounted) {
            await showMessageDialog(
              context,
              'The Item barcode is already assigned to a product',
              LittleFishIcons.info,
            );
            return;
          }
        }
      } else {
        if (oldBarCode != newBarCode && newBarCode.isNotEmpty) {
          var isUnique1 = await vm.isBarcodeUnique!(newBarCode);

          if (!isUnique1) {
            if (context.mounted) {
              await showMessageDialog(
                context,
                'The Item barcode is already assigned to a product',
                LittleFishIcons.info,
              );
              return;
            }
          } else {
            _product!.regularBarCode = newBarCode;
          }
        }
      }

      // in tablet mode, it seems  handleSkuUniqueness is breaking _product content
      final theProduct = _product!;

      bool isSuccess = await handleSkuUniqueness(vm);
      if (!isSuccess) return;

      _product = theProduct;

      // Online store specific logic
      if (widget.pageContext == ProductPageContext.onlineStore) {
        bool isProductOffline = _product!.isOnline != true;
        bool storeHasNoProducts = isNullOrEmpty(
          vm.store!.state.storeState.products,
        );
        bool shouldAddProduct = true;
        if (isProductOffline && storeHasNoProducts) {
          shouldAddProduct = await _offLineProductWarning() ?? true;
        }

        if (!shouldAddProduct) {
          return;
        }

        if (vm.store!.state.storeState.store == null) {
          vm.store!.dispatch(CreateDefaultStoreAction());
        }

        var onlineStore = vm.store!.state.storeState.store;
        if (await doesOnlineStoreExist(vm) == false) {
          vm.store!.dispatch(addOnlineStoreToAccount(onlineStore!));
        }
      }

      await vm.onUpsertProduct(_product!, _productOptions);

      if (widget.onProductUpdate != null) {
        widget.onProductUpdate!();
      }
    }
  }

  Future<bool?> _offLineProductWarning() async {
    return await getIt<ModalService>().showActionModal(
      context: context,
      title: 'Product Not Online',
      description:
          'Please note, to complete your online store setup at least one product must be set to online. Are you sure you want to add an offline product?',
    );
  }

  _productImages() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: context.labelMediumBold('Images'),
          ),
          const SizedBox(height: 16),
          MultiImageManager(
            images: _product?.imageUris ?? [],
            onAddImage: _handleAddImage,
            onUpdateImage: _handleUpdateImage,
            onDeleteImage: _handleDeleteImage,
            imageHeight: 150,
            imageWidth: 150,
          ),
        ],
      ),
    );
  }

  Future<String?> _uploadImageFromSource(ImageSource source) async {
    final selectedImage = await ImagePicker().pickImage(source: source);
    if (selectedImage == null) return null;

    if (!await FileManager().isFileTypeAllowed(selectedImage, context)) {
      return null;
    }

    showProgress(context: context);

    try {
      final state = AppVariables.store!.state;
      final file = File(selectedImage.path);

      final downloadUrl = await FileManager().uploadFile(
        file: file,
        businessId: state.businessId!,
        category: 'products',
        // Generate a new UUID for each image to ensure they are stored as separate files
        id: const Uuid().v4(),
        businessName: '',
      );

      hideProgress(context);
      return downloadUrl.downloadUrl;
    } catch (e) {
      hideProgress(context);
      // Report and show error
      reportCheckedError(e, trace: StackTrace.current);
      showMessageDialog(
        context,
        'Something went wrong, please try again later.',
        LittleFishIcons.error,
      );
      return null;
    }
  }

  Future<void> _handleAddImage() async {
    final imageSource = await FileManager().selectFileSource(context);
    if (imageSource == null) return;

    final newImageUrl = await _uploadImageFromSource(imageSource);

    if (newImageUrl != null) {
      setState(() {
        _product!.imageUris ??= [];
        _product!.imageUris!.add(newImageUrl);
      });
    }
  }

  Future<void> _handleUpdateImage(int index) async {
    final imageSource = await FileManager().selectFileSource(context);
    if (imageSource == null) return;

    final newImageUrl = await _uploadImageFromSource(imageSource);

    if (newImageUrl != null) {
      setState(() {
        _product!.imageUris![index] = newImageUrl;
      });
    }
  }

  void _handleDeleteImage(int index) async {
    final modalService = getIt<ModalService>();

    bool? isAccepted = await modalService.showActionModal(
      status: StatusType.destructive,
      title: 'Discard Image',
      context: context,
      description:
          'Are you sure you would like to discard this image?\n\nThe image will be permanently removed from the product.',
      acceptText: 'Yes, Discard',
      cancelText: 'No, Cancel',
    );

    if (isAccepted == true) {
      setState(() {
        _product!.imageUris!.removeAt(index);
      });
    }
  }

  ///Todo: make separate file for this form details
  Widget formDetails(BuildContext context, ProductViewModelNew vm) {
    int categoryIndex = 0;

    var formFields = <Widget>[
      const SizedBox(height: 16),
      //Heading
      Container(
        alignment: Alignment.centerLeft,
        child: context.labelMediumBold('General'),
      ),
      const SizedBox(height: 24),
      //Product Name
      StringFormField(
        enforceMaxLength: true,
        useOutlineStyling: true,
        maxLength: 255,
        hintText: 'Keloggs, Omo, Jik',
        maxLines: 3,
        key: const Key('productName'),
        labelText: 'Product Name',
        onFieldSubmitted: (value) {
          _product!.displayName = _product!.name = value;
        },
        inputAction: TextInputAction.next,
        initialValue: _product!.displayName ?? _product!.name,
        isRequired: true,
        onSaveValue: (value) {
          _product!.name = _product!.displayName = value;
        },
      ),
      //Categories
      Visibility(
        visible:
            vm.state!.categories != null && vm.state!.categories!.isNotEmpty,
        child: Column(
          children: [
            const SizedBox(height: 8),
            DropdownFormField(
              labelText: 'Category',
              hintText: 'Select a category',
              useOutlineStyling: true,
              isRequired: false,
              key: const Key('category'),
              onSaveValue: (value) {
                _product!.categoryId = value?.value;
              },
              onFieldSubmitted: (value) {
                _product!.categoryId = value?.value;
              },
              initialValue: _product?.categoryId,
              values: vm.state!.categories
                  ?.map(
                    (c) => DropDownValue(
                      displayValue: c.displayName,
                      index: categoryIndex += 1,
                      value: c.id,
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      //Description
      StringFormField(
        enforceMaxLength: true,
        maxLines: 5,
        maxLength: 255,
        useOutlineStyling: true,
        hintText: 'Describe your product',
        key: const Key('description'),
        labelText: 'Description',
        onFieldSubmitted: (value) {
          _product!.description = value;
        },
        inputAction: TextInputAction.next,
        initialValue: _product!.description,
        isRequired: false,
        onSaveValue: (value) {
          _product!.description = value;
        },
      ),
      const SizedBox(height: 8),
      //Barcode
      Visibility(
        visible: _product!.productType == ProductType.physical,
        child: BarcodeFormField(
          onChanged: (value) {
            newBarCode = value;
          },
          canScanBarcode: hasScanBarcodePerm,
          laserScannerAvailable: AppVariables.laserScanningSupported,
          hintText: hasScanBarcodePerm
              ? 'Enter or Scan Barcode'
              : 'Enter Barcode',
          key: const Key('barcode'),
          labelText: 'Item Barcode',
          useOutlineStyling: true,
          onFieldSubmitted: (value) {
            newBarCode = value;
          },
          inputAction: TextInputAction.next,
          initialValue: _product!.regularBarCode,
          isRequired: false,
          onSaveValue: (value) {
            newBarCode = value;
          },
        ),
      ),
      const SizedBox(height: 24),
      // Online Settings/ catalog
      Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: context.labelMediumBold('Selling Settings'),
          ),
          const SizedBox(height: 16),
          Visibility(
            visible: vm.isStoreOnline && vm.store!.state.enableOnlineStore!,
            child: Column(
              children: [
                YesNoFormField(
                  key: const Key('onlineProduct'),
                  labelText: 'Sell Online',
                  initialValue: _product?.isOnline ?? false,
                  onSaved: (value) {
                    setState(() {
                      if (_isGeneralPage()) {
                        _product!.isOnline = value;
                        return;
                      }

                      _product!.isOnline = true;
                      showMessageDialog(
                        context,
                        'In order to publish a product to the online store, it must be set to online.',
                        LittleFishIcons.info,
                      );
                    });
                  },
                  description: 'Add Product to Online Store',
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          YesNoFormField(
            key: const Key('inStoreProduct'),
            padding: const EdgeInsets.all(0),
            prefixIcon: Icons.store,
            labelText: 'Sell In-store',
            initialValue: _product?.isInStore ?? true,
            onSaved: (value) {
              _product!.isInStore = value;
              if (mounted) setState(() {});
            },
            description: 'Add Product to In-store Catalog',
          ),
          const SizedBox(height: 24),
        ],
      ),

      //Pricing and Additional items
      Column(
        children: [
          //Price heading
          Container(
            alignment: Alignment.centerLeft,
            child: context.labelMediumBold('Pricing'),
          ),
          const SizedBox(height: 24),
          //Selling Price
          CurrencyFormField(
            showExtra: false,
            prefixIcon: Icons.sell_outlined,
            hintText: 'Selling Price',
            isRequired: false,
            useOutlineStyling: true,
            key: const Key('sellingPrice'),
            labelText: 'Selling Price',
            enableCustomKeypad: true,
            customKeypadHeading: 'Selling Price :',
            validator:
                (_productOptions.isNotEmpty &&
                    (_product?.regularSellingPrice ?? 0) <= 0)
                ? (value) {
                    if (_productOptions.isNotEmpty &&
                        (_product?.regularSellingPrice ?? 0) <= 0) {
                      return 'Please enter a value greater than zero.';
                    }
                  }
                : null,
            onFieldSubmitted: (value) {
              setState(() {
                _product!.regularVariance!.sellingPrice = value;
              });
              FocusScope.of(context).unfocus();
            },
            inputAction: TextInputAction.next,
            initialValue: _product!.regularVariance!.sellingPrice,
            onSaveValue: (value) {
              setState(() {
                _product!.regularVariance!.sellingPrice = value;
              });
              FocusScope.of(context).unfocus();
            },
          ),
          const SizedBox(height: 20),
          //Cost Price
          CurrencyFormField(
            showExtra: false,
            prefixIcon: Icons.sell_outlined,
            hintText: 'Cost Price',
            isRequired: false,
            useOutlineStyling: true,
            key: const Key('costPrice'),
            labelText: 'Cost Price',
            enableCustomKeypad: true,
            customKeypadHeading: 'Cost Price :',
            onFieldSubmitted: (value) {
              setState(() {
                _product!.regularVariance!.costPrice = value;
              });
              FocusScope.of(context).unfocus();
            },
            inputAction: TextInputAction.next,
            initialValue: _product!.regularVariance!.costPrice ?? 0,
            onSaveValue: (value) {
              setState(() {
                _product!.regularVariance!.costPrice = value;
              });
              FocusScope.of(context).unfocus();
            },
          ),
          if (isVatEnabled == true) ...[
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              key: const Key('default_vat_rate'),
              decoration: const InputDecoration(
                labelText: 'Product VAT Type',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              value:
                  vatRates?.any((v) => v.vatLevelId == _product?.taxId) == true
                  ? _product!.taxId
                  : vatRates
                        ?.firstWhere(
                          (v) => v.isDefault,
                          orElse: () => vatRates!.first,
                        )
                        .vatLevelId,
              items: vatRates?.map((vat) {
                final percentage = ((vat.rate ?? 0) * 100).toStringAsFixed(0);
                return DropdownMenuItem<String>(
                  value: vat.vatLevelId,
                  child: context.labelSmall('${vat.name} ($percentage%)'),
                );
              }).toList(),
              onChanged: (selectedId) {
                setState(() {
                  _product!.taxId = selectedId;
                  _productOptions = setProductOptionsTax(_product?.taxId ?? '');
                });
              },
              onSaved: (selectedId) {
                _product!.taxId = selectedId;
                _productOptions = setProductOptionsTax(_product?.taxId ?? '');
              },
              validator: (value) => value == null || value.isEmpty
                  ? 'Please select a VAT rate'
                  : null,
            ),
          ],
          const SizedBox(height: 16),
          MarginProfitRow(
            margin: productChecker('margin'),
            profit: productChecker('profit'),
            color: productColourChecker(),
          ),
          const SizedBox(height: 24),
          //Details Heading
          Container(
            alignment: Alignment.centerLeft,
            child: context.labelMediumBold('Details'),
          ),
          const SizedBox(height: 24),
          Container(
            padding: EdgeInsets.only(
              bottom: _product!.isStockTrackable == true ? 16 : 0,
            ),
            child: trackStockWidget(vm),
          ),
          const SizedBox(height: 24),
          _stockControlFields(vm),
          const SizedBox(height: 16),
          //Product type
          DropdownFormField(
            isRequired: true,
            hintText: 'Product or Service',
            key: const Key('productType'),
            useOutlineStyling: true,
            initialValue: _product!.productType ?? ProductType.physical,
            labelText: 'Product Type',
            onSaveValue: (value) {
              _product!.productType = value.value;
              if (mounted) setState(() {});
            },
            onFieldSubmitted: (value) {
              _product!.productType = value.value;
              if (_product!.productType != ProductType.physical) {
                _product!.isStockTrackable = false;
              }
              if (mounted) setState(() {});
            },
            values: <DropDownValue>[
              DropDownValue(
                index: 0,
                displayValue: 'Item - Something you sell',
                value: ProductType.physical,
              ),
              DropDownValue(
                index: 1,
                displayValue: 'Service - Something you do',
                value: ProductType.service,
              ),
            ],
          ),
          const SizedBox(height: 20),
          //SKU
          Visibility(
            visible: _product!.productType == ProductType.physical,
            child: AlphaNumericFormField(
              isDense: true,
              enforceMaxLength: true,
              maxLines: 5,
              maxLength: 255,
              useOutlineStyling: true,
              suffixIcon: MdiIcons.codeArray,
              hintText: 'Product SKU',
              key: const Key('skuCode'),
              labelText: 'SKU',
              onFieldSubmitted: (value) {},
              inputAction: TextInputAction.next,
              initialValue: _product!.sku ?? SkuGenerator.generateSKU(),
              isRequired: true,
              onSaveValue: (value) {
                _product!.sku = value;
              },
            ),
          ),
        ],
      ),
    ];

    return Column(children: formFields);
  }

  Widget _stockControlFields(ProductViewModelNew vm) {
    return StockControlFields(
      isStockTrackable: _product!.isStockTrackable ?? false,
      productType: _product!.productType ?? ProductType.physical,
      unitType: _product!.unitType ?? StockUnitType.byUnit,

      // Pass display names and other info FOR THE MODAL
      productDisplayName: _product!.displayName ?? '',
      productId: _product!.id,
      imageUri: _product!.imageUri,
      productCategoryName: vm.store!.state.productState
          .getCategory(categoryId: _product!.categoryId)
          ?.displayName,

      // Pass data for the form fields themselves
      unitOfMeasure: _product!.unitOfMeasure,
      stockCount: _product!.regularVariance!.quantityAsNonNegative,
      lowStockValue: _product!.regularVariance!.lowQuantityValue ?? 10,

      // Implement the callbacks for direct field changes
      onUnitOfMeasureChanged: (value) {
        setState(() {
          _product!.unitOfMeasure = value;
        });
      },
      onStockCountChanged: (value) {
        setState(() {
          _product!.regularVariance!.quantity = value;
        });
      },
      onLowStockValueChanged: (value) {
        setState(() {
          _product!.regularVariance!.lowQuantityValue = value;
        });
      },

      onStockAdjusted: (difference, reason) async {
        try {
          if (!_product!.isNew!) {
            vm.onMakeStockAdjustment!(context, difference, reason, true);
            Navigator.of(context).pop();
            return;
          }

          double diff = difference;
          Navigator.of(context).pop();
          if (StockRunHelper.isDecreaseByReason(reason)) {
            diff = -diff;
          }
          setState(() {
            double newValue = (_product!.regularVariance!.quantity ?? 0) + diff;
            _product!.regularVariance!.quantity = max(0, newValue);
          });
        } catch (e) {
          setState(() {});
        }
      },
    );
  }

  Future<bool> handleSkuUniqueness(ProductViewModelNew vm) async {
    // Check if the parent product has a unique SKU
    try {
      if (isBlank(_product?.sku)) return true;

      bool uniqueSKU = await SkuGenerator.isUniqueSkuDatabaseCheck(
        store: vm.store!,
        productId: _product!.id ?? '',
        sku: _product!.sku ?? '',
      );
      if (!uniqueSKU) {
        setState(() {
          checkerHeight = 78;
        });
        await showMessageDialog(
          context,
          'SKU is not Unique',
          LittleFishIcons.info,
        );
        return false;
      }

      // Check if the product options have unique SKUs
      bool uniqueOptionSKUs = SkuGenerator.areAllSkusUniqueInState(
        store: vm.store!,
        skusAndIds: _productOptions
            .where((product) => isNotBlank(product.sku))
            .map((option) {
              return ProductIdAndSku(
                productId: option.id ?? '',
                sku: option.sku,
              );
            })
            .toList(),
      );

      if (!uniqueOptionSKUs) {
        setState(() {
          checkerHeight = 78;
        });
        await showMessageDialog(
          context,
          'One or more product options have duplicate SKUs',
          LittleFishIcons.info,
        );
        return false;
      }

      return true;
    } catch (e) {
      showMessageDialog(
        context,
        'An error occurred while checking SKU uniqueness. Please ensure all provided SKU values are unique.',
        LittleFishIcons.error,
        status: StatusType.destructive,
      );
      return false;
    }
  }

  String productChecker(String type) {
    if (_product != null &&
        _product!.regularVariance!.sellingPrice != null &&
        _product!.regularVariance?.costPrice != null) {
      if (type == 'profit') {
        return '${TextFormatter.formatCurrency(((_product!.regularVariance!.sellingPrice! - _product!.regularVariance!.costPrice!) * 100).toStringAsFixed(2))}';
      } else {
        return _product!.regularVariance!.sellingPrice! > 0 &&
                _product!.regularVariance!.costPrice! > 0
            ? '${((_product!.regularVariance!.sellingPrice! - _product!.regularVariance!.costPrice!) / _product!.regularVariance!.costPrice! * 100).toStringAsFixed(2)}%'
            : '0.00%';
      }
    } else {
      _product!.regularVariance!.sellingPrice = 0;
      _product!.regularVariance!.costPrice = 0;
      return type == 'margin'
          ? '0.00%'
          : "${TextFormatter.formatCurrency("0")}";
    }
  }

  Color productColourChecker() {
    if (_product!.regularVariance!.sellingPrice == null ||
        _product!.regularVariance!.costPrice == null) {
      return Theme.of(context).extension<AppliedTextIcon>()?.emphasized ??
          Colors.red;
    }
    return _product!.regularVariance!.sellingPrice! >=
            _product!.regularVariance!.costPrice!
        ? Theme.of(context).extension<AppliedTextIcon>()?.emphasized ??
              Colors.red
        : Theme.of(context).extension<AppliedTextIcon>()?.error ?? Colors.red;
  }

  List<ProductOption> setProductOptionsTax(String taxId) {
    return _productOptions.map((option) {
      option.taxId = taxId;
      return option;
    }).toList();
  }

  Widget trackStockWidget(ProductViewModelNew vm) {
    final bool variantStockTracking = _product?.manageVariantStock ?? false;
    final bool enableToggle =
        variantStockTracking == false ||
        AppVariables.enableProductVariance == false;
    return Column(
      children: [
        Row(
          children: [
            const Icon(Icons.bar_chart_outlined),
            const SizedBox(width: 8),
            context.labelSmall('Track stock for this product'),
            const Spacer(),
            if (enableToggle)
              ToggleSwitch(
                initiallyEnabled: _product?.isStockTrackable ?? false,
                enabledColor: Theme.of(
                  context,
                ).extension<AppliedTextIcon>()?.brand,
                onChanged: (value) {
                  if (_product == null) return;

                  if (mounted) {
                    setState(() {
                      FullProduct productWithVariants = vm
                          .onParentProductStockTrackableChanged(
                            isParentProductStockTrackable: value,
                            parentProduct: _product!,
                            productOptions: _productOptions,
                          );
                      _product = productWithVariants.product;
                      _productOptions =
                          productWithVariants.productOptions ?? [];
                    });
                  }
                },
              ),
          ],
        ),
        if (variantStockTracking && AppVariables.enableProductVariance)
          Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: BrandedInfoContainer(
              title: 'Stock managed by variants',
              description:
                  'Individual variant tracking is enabled.\n'
                  'Manage stock in the Options tab.',
              icon: LittleFishIcons.warning,
            ),
          ),
      ],
    );
  }

  bool _isOnlineStorePage() {
    return widget.pageContext == ProductPageContext.onlineStore;
  }

  bool _isGeneralPage() {
    return widget.pageContext == ProductPageContext.general;
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}
