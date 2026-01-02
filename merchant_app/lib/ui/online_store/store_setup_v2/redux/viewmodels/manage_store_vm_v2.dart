// removed ignore: depend_on_referenced_packages

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/models/stock/stock_category.dart';
import 'package:redux/redux.dart';
import 'package:quiver/strings.dart';
import 'package:littlefish_merchant/features/ecommerce_shared/models/store/store.dart'
    as store_ui;
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/common/presentaion/components/completers.dart';
import 'package:littlefish_merchant/features/ecommerce_shared/models/internationalization/country_codes.dart';
import 'package:littlefish_merchant/providers/locale_provider.dart';
import 'package:littlefish_merchant/features/ecommerce_shared/models/store/store_product.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/redux/store/store_actions.dart';
import 'package:littlefish_merchant/ui/online_store/services/littlefish/littlefish_firestore.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/store/store_state.dart';
import 'package:littlefish_merchant/common/view_models/store_collection_viewmodel.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:littlefish_icons/littlefish_icons.dart';

import '../../../../../common/presentaion/components/dialogs/common_dialogs.dart';
import '../../../../../common/presentaion/components/dialogs/services/modal_service.dart';
import '../../../../../injector.dart';
import '../../../../../redux/product/product_actions.dart';

class ManageStoreVMv2 extends StoreItemViewModel<store_ui.Store, StoreState> {
  ManageStoreVMv2.fromStore(Store<AppState> store) : super.fromStore(store);

  String? get storeName => item == null ? '' : item?.displayName;

  StoreUIState? get storeUIState => store?.state.storeUIState;

  late Function(store_ui.Store store, {Completer? completer}) upsertStore;
  late Future<bool> Function() doesStoreExist;

  late bool Function() isBusinessInfoSetupComplete;
  late bool Function() isContactInfoComplete;
  late bool Function() isAddressInfoComplete;
  late bool Function() isBrandInfoComplete;
  late bool Function() isProductCatalogueComplete;
  late bool Function() isFeaturedCategoriesComplete;
  late bool Function() isDeliveryandCollectionComplete;
  late bool isDomainNameComplete;

  late void Function() setDeliveryCostToFixedAmount;
  late void Function() setDeliveryCostToVariableAmount;
  late Future<void> Function(BuildContext ctx) onResetCategory;

  late Future<void> Function(BuildContext ctx, bool? isConfigured)
  setConfigured;
  late Future<void> Function(BuildContext ctx) publishStore;

  late Future<void> Function(BuildContext ctx) submitStoreForReview;
  late Future<void> Function(BuildContext ctx) isStoreReviewed;

  late Function(BuildContext ctx, List<StockCategory> categories)
  updateCategory;

  List<StoreProduct> get onlineProducts =>
      store!.state.storeState.products ?? [];

  List<StoreProductCategory> get onlineCategories =>
      store!.state.storeState.productCategories ?? [];

  List<StockProduct> get inStoreProducts =>
      store!.state.productState.products ?? [];

  List<StockCategory> get inStoreCategories =>
      store!.state.productState.categories ?? [];

  late SortBy sortProductsBy;
  late SortOrder sortProductsOrder;

  @override
  loadFromStore(Store<AppState>? store, {BuildContext? context}) {
    this.store = store;
    state = store!.state.storeState;

    item = state!.store;

    isLoading = state!.isLoading ?? false;

    hasError = state!.hasError;
    errorMessage = state!.errorMessage;

    sortProductsBy = storeUIState?.sortProductsBy ?? SortBy.createdDate;
    sortProductsOrder = storeUIState?.sortProductsOrder ?? SortOrder.ascending;

    upsertStore = (onlineStore, {completer}) async {
      if (isNotBlank(onlineStore.uniqueSubdomain)) {
        onlineStore.uniqueSubdomain = onlineStore.uniqueSubdomain!
            .toLowerCase();
      }
      if (await doesStoreExist()) {
        store.dispatch(updateStore(onlineStore, completer: completer));
      } else {
        store.dispatch(
          addOnlineStoreToAccount(onlineStore, completer: completer),
        );
      }
    };

    doesStoreExist = () async {
      store.dispatch(SetStoreLoadingAction(true));
      String? userId = store.state.currentUser?.uid;
      String? businessId = store.state.businessId;
      if (isBlank(userId) || isBlank(businessId)) return false;

      bool doesExist = await FirestoreService().doesStoreExistForUser(
        userId!,
        businessId!,
      );
      store.dispatch(SetStoreLoadingAction(false));
      return doesExist;
    };

    isBusinessInfoSetupComplete = () {
      bool isNameSet = isNotBlank(item?.name);
      bool isDescriptionSet = isNotBlank(item?.description);
      bool isContactInfoSet = isContactInfoComplete();
      bool isAddressSet = isAddressInfoComplete();
      return isNameSet && isDescriptionSet && isContactInfoSet && isAddressSet;
    };

    isDeliveryandCollectionComplete = () {
      bool isDeliverySet = item?.deliverySettings?.enabled != null;
      bool isCollectionSet = item?.collectionSettings?.enabled != null;
      return isDeliverySet && isCollectionSet;
    };

    isContactInfoComplete = () {
      if (item == null || item?.contactInformation == null) return false;
      store_ui.ContactInformation? contactInfo = item?.contactInformation;
      bool isMobileNumberSet = isNotBlank(contactInfo?.mobileNumber);
      bool isEmailSet = isNotBlank(contactInfo?.email);
      return isMobileNumberSet && isEmailSet;
    };

    isAddressInfoComplete = () {
      if (item?.primaryAddress == null) return false;
      bool isLine1Set = isNotBlank(item?.primaryAddress?.addressLine1);
      bool isCitySet = isNotBlank(item?.primaryAddress?.city);
      bool isStateSet = isNotBlank(item?.primaryAddress?.state);
      bool isPostalCodeSet = isNotBlank(item?.primaryAddress?.postalCode);
      return isLine1Set && isCitySet && isStateSet && isPostalCodeSet;
    };

    isBrandInfoComplete = () {
      var storeTheme = item?.storePreferences?.theme;
      if (storeTheme == null) return false;
      String? primaryColor = storeTheme.primaryColor;
      String? secondaryColour = storeTheme.secondaryColor;
      return isNotBlank(item!.logoUrl) &&
          isNotBlank(primaryColor) &&
          isNotBlank(secondaryColour);
    };

    isProductCatalogueComplete = () {
      var productState = store.state.productState;
      List<StockProduct>? stateProducts = productState.products;
      if (isNullOrEmpty(stateProducts)) return false;
      List<StockProduct>? onlineStockProducts = stateProducts!
          .where((product) => product.isOnline == true)
          .toList();
      return isNotNullOrEmpty(onlineStockProducts);
    };

    isFeaturedCategoriesComplete = () {
      var categoryState = store.state.productState;
      List<StockCategory>? stateCategory = categoryState.categories;
      if (isNullOrEmpty(stateCategory)) return false;
      List<StockCategory>? onlineFeaturedCategories = stateCategory!
          .where((category) => category.isFeatured == true)
          .toList();
      return isNotNullOrEmpty(onlineFeaturedCategories);
    };

    isDomainNameComplete =
        isNotBlank(item?.uniqueSubdomain) && isTrue(item?.isDomainLive);

    setConfigured = (ctx, isConfigured) async {
      if (item == null) return;
      store.dispatch(SetStoreConfigured(isConfigured!));
      if (item!.countryData == null) {
        var countryCode = CountryCode.fromIsoCode(
          LocaleProvider.instance.countryCode!,
        );
        store.dispatch(SetStoreCountryCode(countryCode));
      }

      item?.totalProducts = onlineProducts.length;

      var completer = snackBarCompleter(
        Navigator.of(ctx).context,
        'Your store is setup and ready to be published.',
        shouldPop: false,
        durationMilliseconds: 2500,
      );
      store.dispatch(updateStore(item, completer: completer));
    };

    publishStore = (ctx) async {
      var completer = snackBarCompleter(
        Navigator.of(ctx).context,
        'Congratulations! Your store is now live and ready for business.',
        shouldPop: false,
      );

      store.dispatch(publishStoreAction(item, completer: completer));

      await completer?.future;
    };

    submitStoreForReview = (ctx) async {
      var completer = snackBarCompleter(
        Navigator.of(ctx).context,
        'Congratulations! Your store is has been submitted for review.',
        shouldPop: false,
      );

      store.dispatch(
        submitStoreForReviewAction(item, storeUrl: item!.storeUrl!),
      );
      await completer?.future;
    };

    isStoreReviewed = (ctx) async {
      store.dispatch(isStoreReviewedAction(item));
    };

    setDeliveryCostToFixedAmount = () {
      item!.storePreferences!.onlineFee!.isFixedAmount = true;
      item!.storePreferences!.onlineFee!.isVariableAmount = false;
    };

    setDeliveryCostToVariableAmount = () {
      item!.storePreferences!.onlineFee!.isFixedAmount = false;
      item!.storePreferences!.onlineFee!.isVariableAmount = true;
    };

    updateCategory = (ctx, categories) async {
      StoreProductCategory? onlineCategory;
      StockCategory? stateCategory;

      bool? syncChangesToOnlineStore = false;
      bool? syncChangesToOnlineStore2;
      bool promptUser = false;
      bool promptUser2 = false;
      bool notify = false;

      for (var category in categories) {
        if (store.state.storeState.productCategories != null) {
          try {
            onlineCategory = store.state.storeState.productCategories!
                .where((element) => element.categoryId == category.id)
                .first;
          } catch (e) {
            onlineCategory = null;
          }
        }

        if (store.state.productState.categories != null) {
          try {
            stateCategory = store.state.productState.categories!.firstWhere(
              (element) => element.id == category.id,
            );
          } catch (e) {
            stateCategory = null;
          }
        }

        if (onlineCategory != null &&
            stateCategory != null &&
            !onlineCategory.deleted! &&
            (stateCategory.isOnline ?? false)) {
          if (category.isOnline!) {
            promptUser = true;
          } else {
            if (store.state.storeState.products != null &&
                store.state.storeState.products!
                    .where((p) => p.baseCategoryId == category.id)
                    .isNotEmpty) {
              promptUser2 = true;
              syncChangesToOnlineStore = true;
              promptUser = false;
            }
          }
        } else if (category.isOnline!) {
          syncChangesToOnlineStore = true;
          notify = true;
        }
      }

      if (promptUser) {
        syncChangesToOnlineStore = await getIt<ModalService>().showActionModal(
          context: context!,
          title: 'Sync Changes?',
          description:
              'Do you want to sync the changes on these categories to your Online Store as well?',
        );
      }

      if (promptUser2) {
        syncChangesToOnlineStore2 = await getIt<ModalService>().showActionModal(
          context: context!,
          title: 'Unpublish Category Products?',
          description:
              'Do you want to unpublish the online products associated with these categories as well?',
        );
        if ((syncChangesToOnlineStore2 ?? true)) {
          syncChangesToOnlineStore = true;
        }
      }

      if (notify) {
        await showMessageDialog(
          ctx,
          'Please note, all the products associated with these categories will also be published to your Online Store',
          LittleFishIcons.info,
        );
      }

      store.dispatch(
        updateCategoryAndProducts(
          ecommerceUpdate: (syncChangesToOnlineStore ?? false),
          updateProducts: (syncChangesToOnlineStore2 ?? true),
          categories: categories,
          deletedItems: categories
              .expand((c) => c.removedProducts.map((p) => p.id))
              .toList(),
          newItems: categories
              .expand((c) => c.newProducts.map((p) => p.id))
              .toList(),
          completer: snackBarCompleter(
            context ?? ctx,
            'Featured Categories saved successfully!',
            shouldPop: false,
          ),
        ),
      );
    };

    onResetCategory = (ctx) async {
      store.dispatch(ResetCategoryAction());
    };
  }
}
