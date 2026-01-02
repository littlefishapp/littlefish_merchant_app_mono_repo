// remove ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/providers/locale_provider.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/store/store_actions.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:littlefish_merchant/ui/online_store/common/config.dart' as cfg;
import 'package:littlefish_merchant/ui/online_store/services/littlefish/littlefish_firestore.dart';
import 'package:littlefish_merchant/common/presentaion/components/completers.dart';
import 'package:littlefish_merchant/common/view_models/store_collection_viewmodel.dart';
import 'package:quiver/strings.dart';
// removed ignore: depend_on_referenced_packages, implementation_imports
import 'package:redux/src/store.dart';
import '../../../../features/ecommerce_shared/models/checkout/checkout_order.dart';
import '../../../../features/ecommerce_shared/models/online/system_variant.dart';
import '../../../../features/ecommerce_shared/models/store/store_preferences.dart';
import '../../../../features/ecommerce_shared/models/store/store_product.dart';
import '../../../../features/ecommerce_shared/models/store/store.dart'
    as e_store;
import '../../../../common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_icons/littlefish_icons.dart';

//NOTE:
//This is a local UI State VM and is not designed to interact on a one to one state binding
class ProductVM extends StoreViewModel<AppState> {
  ProductVM.fromStore(Store<AppState> store, this.productId, {this.product})
    : super.fromStore(store);

  StoreProduct? product;
  StoreProduct? uneditedProduct;
  String? productId;

  List<SystemVariant> selectedVariants = [];

  dynamic totalCombinations;
  List? separatedCombinations = [];

  ProductVariant? get currentVariant => product?.productVariant;

  List<StoreProductCategory> get categories =>
      store!.state.storeState.productCategories ?? <StoreProductCategory>[];

  List<SystemVariant> get productVariants =>
      store!.state.systemDataState.variants ?? <SystemVariant>[];

  String? get userId => store!.state.authUser!.uid;

  String? get userName => store!.state.authUser!.email;

  bool get onlineOrderingAllowed =>
      currentStore?.storePreferences?.acceptsOnlineOrders ?? false;

  StorePreferences? get preferences => currentStore?.storePreferences;

  String? get currencyCode => product?.currencyCode;
  set currencyCode(String? value) => product?.currencyCode = value;

  String? get shortCurrencyCode => product?.shortCurrencyCode;
  set shortCurrencyCode(String? value) => product?.shortCurrencyCode = value;

  String? get countryCode => product?.countryCode;
  set countryCode(String? value) => product?.countryCode = value;

  bool get hasRelatedProducts =>
      product!.relatedProducts != null && product!.relatedProducts!.isNotEmpty;

  bool get hasProduct => product != null;

  List<String> get productGallery => (product!.gallery ?? <String>[]);

  bool get hasStore => store?.state.storeState.store != null;

  String? get storeId =>
      hasStore ? store?.state.storeState.store?.businessId : null;

  bool get allowWishList => product?.productSettings?.allowWishList ?? true;

  bool get allowComments => product?.productSettings?.allowComments ?? false;

  bool get allowReview => product?.productSettings?.allowReview ?? true;

  bool get trackStock => product?.productSettings?.showInStock ?? false;

  bool get trackViews => product?.productSettings?.trackViews ?? true;

  CheckoutOrder? currentOrder;

  Function(bool value)? onSetLoading;

  double? quantity;

  late bool isInCart;

  bool isFetching = false;

  List<StoreProduct>? products;

  StoreProduct? firstProduct;

  StoreProduct? lastProduct;

  int get productCount => products?.length ?? 0;

  int? get totalProducts => currentStore?.totalProducts;

  e_store.Store? currentStore;

  late bool hasReachedMax;

  Function(bool value)? onFetching;

  Function()? onFetched;

  Function(dynamic error)? onFetchError;

  @override
  loadFromStore(Store<AppState>? store, {BuildContext? context}) {
    state = store!.state;
    this.store = store;

    currentStore = state!.storeState.store;

    hasReachedMax = false;

    isLoading = state!.storeState.isLoading ?? true;
  }

  clear() {
    lastProduct = null;
    products = [];
    isFetching = hasReachedMax = false;
  }

  deleteProduct(ctx, prod) async {
    var completer = snackBarCompleter(ctx, 'Product Deleted', shouldPop: false);

    store!.dispatch(deleteProductAction(prod, completer: completer));

    await completer?.future;

    products = products!.where((element) => element.id != prod.id).toList();
  }

  void trackLostSale() {
    if (!hasStore) return;

    if (!hasProduct) return;

    store!.dispatch(
      StoreSaleLostAction(product!.displayName, product!.id, quantity),
    );
  }

  Future<StoreProduct> upsertProduct(
    BuildContext ctx,
    StoreProduct prod,
  ) async {
    if (prod.currencyCode == null) {
      prod.currencyCode = LocaleProvider.instance.currencyCode!;
      prod.countryCode = cfg.kCountryCode;
      prod.shortCurrencyCode = LocaleProvider.instance.currencyCode!;
    }

    if (prod.isNew ?? false) {
      prod.businessId = store!.state.storeState.store!.businessId;
      prod.createdBy = store!.state.authUser!.uid;
      prod.dateCreated = DateTime.now();
      prod.currencyCode = LocaleProvider.instance.currencyCode!;
      prod.countryCode = cfg.kCountryCode;
      prod.shortCurrencyCode = LocaleProvider.instance.currencyCode!;
      prod.productId = prod.id;
      store!.dispatch(StoreIncrementProductAction());
    }

    if (prod.storeProductVariantType == StoreProductVariantType.variant) {
      if (prod.productVariant == null) {
        showMessageDialog(
          ctx,
          'Must have at least one option name per option',
          LittleFishIcons.error,
        );

        return StoreProduct();
      } else {
        prod.productVariant!.products = prod.productVariant!.products?.map((
          element,
        ) {
          element.currencyCode = LocaleProvider.instance.currencyCode!;
          element.countryCode = cfg.kCountryCode;
          element.shortCurrencyCode = LocaleProvider.instance.currencyCode!;
          element.productId = element.id;

          return element;
        }).toList();
      }
    }

    prod.name = prod.searchName = cleanString(prod.displayName);

    var completer = actionCompleter(ctx, () async {
      await showMessageDialog(ctx, 'Product Saved', LittleFishIcons.info);

      Navigator.of(ctx).pop(prod);
    });

    try {
      store!.dispatch(upsertProductAction(prod, completer: completer));

      await completer.future;

      isLoading = false;
      if (uneditedProduct?.baseCategoryId != prod.baseCategoryId) {
        if (isNotBlank(prod.baseCategoryId)) {
          store!.dispatch(
            StoreIncrementProductCategoryAction(prod.baseCategoryId),
          );
        }

        if (isNotBlank(uneditedProduct!.baseCategoryId)) {
          store!.dispatch(
            StoreDecrementProductCategoryAction(
              uneditedProduct!.baseCategoryId,
            ),
          );
        }
      }
      return prod;
    } catch (e) {
      debugPrint(e.toString());
    }
    return StoreProduct();
  }

  Future<void> fetchProducts({
    int limit = 20,
    String? categoryId,
    bool onSale = false,
    bool isFeatured = false,
  }) async {
    try {
      if (isFetching || hasReachedMax) return;

      if (currentStore == null) return;

      setFetching(true);

      store!.dispatch(SetStoreLoadingAction(true));

      products ??= <StoreProduct>[];

      var collection = currentStore!.productCollection!;

      var query = collection.where('deleted', isEqualTo: false);

      if (isNotBlank(categoryId)) {
        query = query.where('baseCategoryId', isEqualTo: categoryId);
      }

      if (onSale) query = query.where('onSale', isEqualTo: true);

      if (isFeatured) query = query.where('isFeatured', isEqualTo: true);

      // query = query.orderBy('dateCreated', descending: true);

      if (lastProduct != null) {
        query = query.startAt([
          lastProduct!.dateCreated!.millisecondsSinceEpoch,
        ]);
      }

      query = query.limit(limit);

      var snapshot = await query.get();

      List<StoreProduct> fetchResult = snapshot.docs
          .map(
            (e) => StoreProduct.fromDocumentSnapshot(
              e,
              reference: collection.doc(e.id),
            ),
          )
          .toList();

      if (fetchResult.isEmpty) {
        hasReachedMax = true;
        return;
      }

      if (fetchResult.length > 1) {
        firstProduct = fetchResult.first;
      }

      lastProduct = fetchResult.last;

      if (fetchResult.length < limit - 1) {
        hasReachedMax = true;
      }

      for (var element in fetchResult) {
        if (!products!.any((e) => element.productId == e.productId)) {
          products!.add(element);
        }
      }

      if (onFetched != null) onFetched!();
    } catch (error) {
      reportCheckedError(error);

      if (null != onFetchError) onFetchError!(error);
    } finally {
      setFetching(false);
      store!.dispatch(SetStoreLoadingAction(false));
    }
  }

  setFetching(bool value) {
    isFetching = value;
    if (onFetching != null) onFetching!(value);
  }

  Future<DocumentSnapshot?> getProduct(String productId) async {
    DocumentSnapshot? result;

    this.productId = productId;

    if (onSetLoading != null) onSetLoading!(true);

    try {
      if (!hasStore) {
        // result = await FirestoreService().getProductByIdOnly(productId);
      } else {
        result = await FirestoreService().getProductById(
          store!.state.storeState.store!,
          productId,
        );
      }

      product = StoreProduct.fromJson(result?.data() as Map<String, dynamic>);

      return result;
    } catch (e) {
      reportCheckedError(e);

      rethrow;
    } finally {
      if (onSetLoading != null) onSetLoading!(false);
    }
  }

  setProduct(StoreProduct? product) {
    this.product = product;
  }
}
