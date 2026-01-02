// Flutter imports:
// remove ignore_for_file: use_build_context_synchronously

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/bootstrap.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/services/modal_service.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_merchant/models/stock/full_product.dart';
import 'package:littlefish_merchant/models/stock/product_option.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/tools/helpers/product_barcode_helper.dart';

// Package imports:
import 'package:quiver/strings.dart';

// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/stock/stock_take_item.dart';
import 'package:littlefish_merchant/models/shared/form_view_model.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/product/product_actions.dart';
import 'package:littlefish_merchant/redux/product/product_state.dart';
import 'package:littlefish_merchant/common/presentaion/components/completers.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/view_models/store_collection_viewmodel.dart';

import '../../../../features/ecommerce_shared/models/store/store_product.dart';

class ProductViewModelNew
    extends StoreItemViewModel<StockProduct?, ProductState> {
  ProductViewModelNew.fromStore(Store<AppState> store)
    : super.fromStore(store) {
    //in case an item is available, this will prevent a lookup
    if (item != null) item = item;
  }

  CaptureMode? mode;
  FormManager? form;

  bool get hasImage =>
      item?.imageUri != null && !(item?.imageUri?.isEmpty ?? true);

  String get shortDescription {
    if (item?.displayName == null || item!.displayName!.isEmpty) {
      return '....';
    }

    if (item!.displayName!.length < 4) {
      return item!.displayName!.trim();
    }

    return item!.displayName!.substring(0, 4).trim();
  }

  Function(StockProduct)? onRemoveProduct;
  Function(BuildContext, double, StockRunType, bool)? onMakeStockAdjustment;

  Future<bool> Function(String? barcode)? isBarcodeUnique;

  late List<ProductOptionAttribute> allOptionAttributes;

  late List<ProductOptionAttribute> productOptionAttributes;

  late void Function(String productId) getProductWithOptions;

  late FullProduct? productWithOptions;

  late List<ProductOption> productOptions;

  late void Function(ProductOptionAttribute optionAttribute)
  onAddOptionAttribute;

  late void Function(ProductOptionAttribute optionAttribute)
  onDeleteOptionAttribute;

  late List<String> Function(List<ProductOptionAttribute>)
  generateProductVariationNames;

  late Future<void> Function(StockProduct product, List<ProductOption>? options)
  onUpsertProduct;

  late Map<String, List<StockProduct>> productVariants;

  @override
  loadFromStore(Store<AppState> store, {BuildContext? context}) {
    state = store.state.productState;
    this.store = store;
    item = store.state.productsUIState!.item;
    isNew = item?.isNew;
    onRemoveProduct = (product) async {
      store.dispatch(removeProduct(item: product));
    };
    productVariants = state?.productVariants ?? {};
    onMakeStockAdjustment = (ctx, diff, reason, isEmbedded) async {
      store.dispatch(
        stockAdjustmentProductUpdate(
          context: ctx,
          diff: diff,
          item: item!,
          reason: reason,
          isProductPage: isEmbedded,
        ),
      );
    };

    allOptionAttributes = state?.allOptionAttributes ?? [];

    productOptionAttributes =
        state?.productWithOptions?.product.productOptionAttributes ?? [];

    productOptions = state?.productWithOptions?.productOptions ?? [];

    onAddOptionAttribute = (optionAttribute) {
      store.dispatch(AddProductOptionAttributeAction(optionAttribute));
    };

    onDeleteOptionAttribute = (optionAttribute) {
      store.dispatch(DeleteProductOptionAttributeAction(optionAttribute));
    };

    getProductWithOptions = (productId) {
      if (productOptions.isNotEmpty) return;
      store.dispatch(getFullProductById(productId: productId));
    };

    productWithOptions = state?.productWithOptions;

    generateProductVariationNames = (List<ProductOptionAttribute> options) {
      // Return an empty list if the input is empty or if any
      //    option has a null or empty 'attributes' list, as no variations can be formed.
      if (options.isEmpty ||
          options.any(
            (opt) => opt.attributes == null || opt.attributes!.isEmpty,
          )) {
        return [];
      }

      // Extract Attribute Lists: Safely map to a list of lists.
      final allAttributeLists = options.map((opt) => opt.attributes!).toList();

      // Set Initial Combinations: Start with the attributes from the first option.
      List<String> initialCombinations = allAttributeLists.first;

      // Combine Iteratively
      return allAttributeLists.skip(1).fold(initialCombinations, (
        previousCombinations,
        nextAttributes,
      ) {
        return previousCombinations
            .expand((prev) => nextAttributes.map((next) => '$prev/$next'))
            .toList();
      });
    };

    onAdd = (item, ctx) async {
      if (item!.regularVariance?.costPrice == null) {
        item.regularVariance?.costPrice = 0;
      }
      item.regularCostPrice ??= 0;

      if (isBlank(item.displayName)) {
        showMessageDialog(
          ctx!,
          'Please enter a name for the product.',
          LittleFishIcons.info,
        );
      } else {
        StoreProduct? onlineProduct;
        StockProduct? stateProduct;

        if (store.state.storeState.hasProducts) {
          try {
            onlineProduct = store
                .state
                .storeState
                .products! // TODO: DO WE STILL NEED THIS ??????????
                .where((element) => element.productId == item.id)
                .first;
          } catch (e) {
            onlineProduct = null;
          }
        }

        if (store.state.productState.categories != null) {
          try {
            stateProduct = store.state.productState.products!.firstWhereOrNull(
              (element) => element.id == item.id,
            );
          } catch (e) {
            stateProduct = null;
          }
        }

        // ignore: unused_local_variable
        bool? syncChangesToOnlineStore =
            false; // TODO: DO WE STILL NEED THESE ONLINE STORE SYNC CHECKS - PRODUCTS ARE STORED IN OUR MAIN DATABASE NOW ?????????????
        bool promptUser = false;

        if (onlineProduct != null &&
            stateProduct != null &&
            !onlineProduct.deleted! &&
            (stateProduct.isOnline ?? false)) {
          promptUser = true;
        } else if (item.isOnline!) {
          syncChangesToOnlineStore = true;
        }

        if (store.state.enableOnlineStore == false) {
          item.isOnline = false;
          promptUser = false;
        }

        var completer = snackBarCompleter(
          ctx!,
          '${item.displayName ?? item.name} saved successfully',
          shouldPop: true,
        );

        if (promptUser && ctx.mounted) {
          syncChangesToOnlineStore = await getIt<ModalService>().showActionModal(
            context: ctx,
            title: 'Sync changes?',
            description:
                'Do you want to sync the changes on the ${item.displayName} product to your Online Store as well?',
          );
        }

        await store.dispatch(
          addProduct(
            product: item,
            context: ctx,
            completer: completer,
            runCompleter: true,
          ),
        );
      }
    };

    onUpsertProduct = (product, options) async {
      product.manageVariant = true;
      options = ensureDeprecatedFieldsAreNull(options);
      if (product.imageUris != null && product.imageUris!.isNotEmpty) {
        product.imageUri = product.imageUris!.first;
      } else {
        product.imageUri = null;
      }
      if (product.businessId == null || product.businessId!.isEmpty) {
        product.businessId = AppVariables.businessId;
      }

      bool productVarianceDisabled =
          store.state.enableProductVarianceManagement != true;
      if (options == null || options.isEmpty || productVarianceDisabled) {
        onAdd(product, globalNavigatorKey.currentContext);
        return;
      }

      var completer = snackBarCompleter(
        globalNavigatorKey.currentContext!,
        '${product.displayName ?? item?.name ?? 'Product'} saved successfully',
        shouldPop: true,
      );

      store.dispatch(
        upsertProductWithOptions(
          productWithOptions: FullProduct(
            product: product,
            productOptions: options,
          ),
          completer: completer,
        ),
      );

      // Clear the product variants in state for the parent product.
      // This ensures that when selling, the product variants must be fetched again, reducing risk of bad state.
      // TODO: Leaving this commented out for now, until we have a way to sync variant changes from web to app.
      // store.dispatch(
      //   ClearProductVariantsInStateAction(product.id ?? ''),
      // );

      await completer?.future;
    };

    isLoading = store.state.productState.isLoading ?? false;

    hasError = store.state.productState.hasError ?? false;

    isBarcodeUnique = (barcode) async {
      if (barcode == null) return false;

      var product = await ProductBarcodeHelper.getProductByBarcode(
        barcode: barcode,
        store: AppVariables.store,
      );

      // var product = state?.getProductByBarcode(barcode);
      return product == null;
    };
  }

  List<ProductOption> updateAllProductOptions({
    required List<ProductOption> productOptions,
    double? newCostPrice,
    double? newSellingPrice,
  }) {
    List<ProductOption> productVariants = List.from(productOptions);
    if (productVariants.isEmpty) return [];
    for (final option in productVariants) {
      if (option.variances.isNotEmpty) {
        for (final variance in option.variances) {
          if (newCostPrice != null) {
            variance.costPrice = newCostPrice;
          }
          if (newSellingPrice != null) {
            variance.sellingPrice = newSellingPrice;
          }
        }
      }
    }
    return productVariants;
  }

  List<ProductOption>? ensureDeprecatedFieldsAreNull(
    List<ProductOption>? productOptions,
  ) {
    return productOptions?.map((option) {
      option.attributeCombinations = null;
      return option;
    }).toList();
  }

  /// Regenerates the list of variants based on the current product attributes.
  List<ProductOption> regenerateVariants(
    StockProduct product,
    List<ProductOption> productOptions,
  ) {
    // Get the main product to use as a template for new variants.
    final mainProduct = product;
    if (mainProduct.productOptionAttributes == null) return productOptions;

    // Generate all required variant names from the current attributes.
    final newVariantNames = generateProductVariationNames(
      mainProduct.productOptionAttributes!,
    );

    // If no combinations can be made, clear the existing variants.
    if (newVariantNames.isEmpty) {
      return [];
    }

    // Create a map of existing variants for efficient lookup.
    // The key is the variant's name (e.g., "Small/Red/Cotton").
    final existingVariantsMap = {
      for (var variant in productOptions) variant.name: variant,
    };
    final List<ProductOption> reconciledVariants = [];

    // Reconcile by iterating through the newly generated names.
    for (final name in newVariantNames) {
      if (existingVariantsMap.containsKey(name)) {
        // KEEP: This variant already exists, so we keep it.
        reconciledVariants.add(existingVariantsMap[name]!);
      } else {
        // CREATE: This is a new variant. Create it with correct stock tracking flag.
        reconciledVariants.add(
          ProductOption.fromStockProduct(
            product: mainProduct,
            name: name,
            isVariantStockTrackable: mainProduct.manageVariantStock ?? false,
          ),
        );
      }
    }

    // Return the new, reconciled list of variants.
    return reconciledVariants;
  }

  List<ProductOption> updateVariantStockManagement({
    required List<ProductOption> options,
    required bool isVariantStockManagement,
  }) {
    return options.map((variant) {
      variant.isStockTrackable = isVariantStockManagement;
      return variant;
    }).toList();
  }

  FullProduct onParentProductStockTrackableChanged({
    required bool isParentProductStockTrackable,
    required StockProduct parentProduct,
    required List<ProductOption> productOptions,
  }) {
    if (parentProduct.productType == ProductType.service) {
      // disable stock tracking for parent and variants
      parentProduct.isStockTrackable = false;
      productOptions = updateVariantStockManagement(
        options: productOptions,
        isVariantStockManagement: false,
      );
      return FullProduct(
        product: parentProduct,
        productOptions: productOptions,
      );
    }
    parentProduct.isStockTrackable = isParentProductStockTrackable;
    if (isParentProductStockTrackable) {
      productOptions = updateVariantStockManagement(
        options: productOptions,
        isVariantStockManagement: false,
      );
    }

    return FullProduct(product: parentProduct, productOptions: productOptions);
  }

  bool get isStoreOnline => store!.state.storeState.store != null;
}

enum CaptureMode { create, edit, readOnly }
