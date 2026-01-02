// removed ignore: depend_on_referenced_packages

import 'package:collection/collection.dart' show IterableExtension;
import 'package:littlefish_merchant/features/ecommerce_shared/models/store/store.dart'
    as ecom_store;
import 'package:littlefish_merchant/models/enums.dart' as l_enum;
import 'package:littlefish_merchant/tools/hex_color.dart';
import 'package:redux/redux.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/redux/auth/auth_actions.dart';
import 'package:littlefish_merchant/redux/store/store_actions.dart';
import 'package:littlefish_merchant/redux/store/store_state.dart';
import '../../features/ecommerce_shared/models/checkout/checkout_order.dart';
import '../../features/ecommerce_shared/models/store/store_attribute.dart';
import '../../features/ecommerce_shared/models/store/store_product.dart';
import '../../features/ecommerce_shared/models/store/store_subtype.dart';
import '../../models/enums.dart';

// import '../../app_old.dart';

final storeReducer = combineReducers<StoreState>([
  TypedReducer<StoreState, SetCurrentStoreAction>(onSetCurrentStore).call,
  TypedReducer<StoreState, SetCurrentStoreCategoriesAction>(
    onSetCurrentStoreCategories,
  ).call,
  TypedReducer<StoreState, SetStoreCustomersAction>(
    onSetStoreCustomersAction,
  ).call,
  TypedReducer<StoreState, SetStoreCategoriesChangedAction>(
    onSetStoreCategoriesChangedAction,
  ).call,
  TypedReducer<StoreState, SetFollowerCountAction>(
    onSetFollowerCountAction,
  ).call,
  TypedReducer<StoreState, SetStoreProductsAction>(onSetStoreProducts).call,
  TypedReducer<StoreState, SetStoreFeaturedProductsAction>(
    onSetFeaturedProducts,
  ).call,
  TypedReducer<StoreState, SetStoreLoadingAction>(onSetStoreStateLoading).call,
  TypedReducer<StoreState, SetCurrentStoreFeaturedAction>(
    onSetCurrentStoreFeaturedAction,
  ).call,
  TypedReducer<StoreState, SetCurrentStoreTeamAction>(
    onSetCurrentStoreTeam,
  ).call,
  TypedReducer<StoreState, UpdateTradingHoursAction>(
    onUpdateTradingHoursAction,
  ).call,
  TypedReducer<StoreState, ClearCurrentStoreAction>(onClearCurrentStore).call,
  TypedReducer<StoreState, SetStoreOfferingsAction>(
    onSetStoreOfferingsAction,
  ).call,
  TypedReducer<StoreState, SetStoreLogoAction>(onSetStoreLogo).call,
  TypedReducer<StoreState, SetStoreBannerAction>(onSetStoreBanner).call,
  TypedReducer<StoreState, SetStoreAboutImageAction>(onSetStoreAboutImage).call,
  TypedReducer<StoreState, SetStoreCoverImageAction>(onSetStoreCoverImage).call,
  TypedReducer<StoreState, SetStoreAddressAction>(onSetStoreAddress).call,
  TypedReducer<StoreState, SignoutAction>(onSignoutAction).call,
  TypedReducer<StoreState, SetStoreOnlineFeeAction>(
    onSetStoreOnlineFeeAction,
  ).call,
  TypedReducer<StoreState, StoreIncrementProductCategoryAction>(
    onStoreIncrementProductCategoryAction,
  ).call,
  TypedReducer<StoreState, StoreDecrementProductCategoryAction>(
    onStoreDecrementProductCategoryAction,
  ).call,
  // TypedReducer<StoreState, LoadStoreAttributesAction>(
  //     onLoadStoreAttributesAction),
  TypedReducer<StoreState, OrderStatusChangedAction>(
    onOrderStatusChangedAction,
  ).call,
  TypedReducer<StoreState, OrderChangedAction>(onOrderChangedAction).call,
  TypedReducer<StoreState, OrdersLoadedAction>(onOrdersLoadedAction).call,
  TypedReducer<StoreState, OrdersStatusesLoadedAction>(
    onOrdersStatusesLoadedAction,
  ).call,
  TypedReducer<StoreState, StoreDecrementProductAction>(
    onStoreDecrementProductAction,
  ).call,
  TypedReducer<StoreState, StoreIncrementProductAction>(
    onStoreIncrementProductAction,
  ).call,
  TypedReducer<StoreState, StoreDecrementCategoryAction>(
    onStoreDecrementCategoryAction,
  ).call,
  TypedReducer<StoreState, StoreIncrementCategoryAction>(
    onStoreIncrementCategoryAction,
  ).call,
  TypedReducer<StoreState, StoreProductChangedAction>(
    onStoreProductChangedAction,
  ).call,
  TypedReducer<StoreState, SetStoreCollectionSettingsAction>(
    onSetStoreCollectionSettingsAction,
  ).call,
  TypedReducer<StoreState, SetStoreDeliverySettingsAction>(
    onSetStoreDeliverySettingsAction,
  ).call,
  TypedReducer<StoreState, UpdateStoreAction>(onUpdateStoreAction).call,
  TypedReducer<StoreState, UpdateStoreProductAction>(
    onUpdateStoreProductAction,
  ).call,
  TypedReducer<StoreState, UpdateStoreProductCategoryAction>(
    onUpdateStoreProductCategoryAction,
  ).call,
  // TypedReducer<StoreState, SetStoreSubcategoriesTotalAction>(
  //     onSetStoreSubcategoriesTotalAction),
  TypedReducer<StoreState, SetStoreOnSaleProductsAction>(
    onSetOnSaleProducts,
  ).call,
  TypedReducer<StoreState, RemoveStoreProductsAction>(
    onRemoveStoreProductsAction,
  ).call,
  TypedReducer<StoreState, SetStoreNameAction>(onSetStoreName).call,
  TypedReducer<StoreState, SetStoreDescriptionAction>(
    onSetStoreDescription,
  ).call,
  TypedReducer<StoreState, SetStoreSloganAction>(onSetStoreSlogan).call,
  TypedReducer<StoreState, SetStoreMobileNumberAction>(
    onSetStoreMobileNumber,
  ).call,
  TypedReducer<StoreState, SetStoreEmailAddressAction>(onSetStoreEmail).call,
  TypedReducer<StoreState, CreateDefaultStoreAction>(onCreateDefaultStore).call,
  TypedReducer<StoreState, UpdateStoreContactInformationAction>(
    onUpdateStoreContactInfo,
  ).call,
  TypedReducer<StoreState, SetStorePrimaryColourAction>(
    onSetPrimaryColour,
  ).call,
  TypedReducer<StoreState, SetStoreSecondaryColourAction>(
    onSetSecondaryColour,
  ).call,
  TypedReducer<StoreState, SetStoreSubDomainAction>(onSetSubDomain).call,
  TypedReducer<StoreState, SetStoreDomainIsLiveAction>(onSetDomainIsLive).call,
  TypedReducer<StoreState, SetStoreConfigured>(onSetStoreConfigured).call,
  TypedReducer<StoreState, SetStoreCountryCode>(onSetStoreCountryCode).call,
  TypedReducer<StoreState, SetStoreUrlAction>(onSetStoreUrl).call,
]);

StoreState onSetStoreUrl(StoreState state, SetStoreUrlAction action) =>
    state.rebuild((b) => b.store?.storeUrl = action.url);

StoreState onSetStoreConfigured(StoreState state, SetStoreConfigured action) =>
    state.rebuild((b) => b.store?.isConfigured = action.isConfigured);

StoreState onSetStoreCountryCode(
  StoreState state,
  SetStoreCountryCode action,
) => state.rebuild((b) => b.store?.countryData = action.countryCode);

StoreState onSetDomainIsLive(
  StoreState state,
  SetStoreDomainIsLiveAction action,
) => state.rebuild((b) => b.store?.isDomainLive = action.isLive);

StoreState onSetSubDomain(StoreState state, SetStoreSubDomainAction action) =>
    state.rebuild((b) => b.store?.uniqueSubdomain = action.subDomain);

StoreState onSetPrimaryColour(
  StoreState state,
  SetStorePrimaryColourAction action,
) => state.rebuild(
  (b) => b.store?.storePreferences?.theme?.primaryColor = HexColor.colorToHex(
    action.colour,
  ),
);

StoreState onSetSecondaryColour(
  StoreState state,
  SetStoreSecondaryColourAction action,
) => state.rebuild(
  (b) => b.store?.storePreferences?.theme?.secondaryColor = HexColor.colorToHex(
    action.colour,
  ),
);

StoreState onUpdateStoreContactInfo(
  StoreState state,
  UpdateStoreContactInformationAction action,
) => state.rebuild((b) => b.store?.contactInformation = action.contactInfo);

StoreState onCreateDefaultStore(
  StoreState state,
  CreateDefaultStoreAction action,
) => state.rebuild((b) => b.store = ecom_store.Store.defaults());

StoreState onSetStoreName(StoreState state, SetStoreNameAction action) =>
    state.rebuild((b) {
      b.store?.name = action.name;
      b.store?.displayName = action.name;
    });

StoreState onSetStoreDescription(
  StoreState state,
  SetStoreDescriptionAction action,
) => state.rebuild((b) => b.store?.description = action.description);

StoreState onSetStoreSlogan(StoreState state, SetStoreSloganAction action) =>
    state.rebuild((b) => b.store?.slogan = action.slogan);

StoreState onSetStoreMobileNumber(
  StoreState state,
  SetStoreMobileNumberAction action,
) => state.rebuild((b) {
  if (b.store?.contactInformation == null) {
    b.store?.contactInformation = ecom_store.ContactInformation(
      mobileNumber: action.mobileNumber,
    );
  } else {
    b.store!.contactInformation!.mobileNumber = action.mobileNumber;
  }
});

StoreState onSetStoreEmail(
  StoreState state,
  SetStoreEmailAddressAction action,
) => state.rebuild((b) {
  if (b.store?.contactInformation == null) {
    b.store?.contactInformation = ecom_store.ContactInformation(
      email: action.email,
    );
  } else {
    b.store!.contactInformation!.email = action.email;
  }
});

StoreState onSetFeaturedProducts(
  StoreState state,
  SetStoreFeaturedProductsAction action,
) => state.rebuild((b) => b.featuredProducts = action.value);

StoreState onRemoveStoreProductsAction(
  StoreState state,
  RemoveStoreProductsAction action,
) => state.rebuild((p) {
  if (p.products != null) {
    var productIds = action.products.map((e) => e.id).toList();

    p.products!.removeWhere((element) => productIds.contains(element.id));
  }
});

StoreState onSetStoreOnlineFeeAction(
  StoreState state,
  SetStoreOnlineFeeAction action,
) => state.rebuild((b) => b.store!.storePreferences!.onlineFee = action.value);

StoreState onStoreDecrementProductCategoryAction(
  StoreState state,
  StoreDecrementProductCategoryAction action,
) => state.rebuild((b) {
  var pCat = b.productCategories!.firstWhereOrNull(
    (element) => (element.id ?? element.categoryId) == action.id,
  )!;

  pCat.productCount = (pCat.productCount ?? 0) - 1;
});

StoreState onStoreIncrementProductCategoryAction(
  StoreState state,
  StoreIncrementProductCategoryAction action,
) => state.rebuild((b) {
  var pCat = b.productCategories!.firstWhereOrNull(
    (element) => (element.id ?? element.categoryId) == action.id,
  )!;

  pCat.productCount = (pCat.productCount ?? 0) + 1;
});

StoreState onSignoutAction(StoreState state, SignoutAction action) =>
    state.rebuild((b) => b.store = null);

StoreState onSetStoreOfferingsAction(
  StoreState state,
  SetStoreOfferingsAction action,
) => state.rebuild((b) {
  b.store!.storeSubtypeId = action.storeSubtype!.id;
  b.store!.storeTypeId = action.storeType!.id;
});

StoreState onSetCurrentStoreFeaturedAction(
  StoreState state,
  SetCurrentStoreFeaturedAction action,
) => state.rebuild((b) => b.store!.isFeatured = action.value);

// StoreState onSetStoreProductTypeTotalAction(
//         StoreState state, SetStoreProductTypeTotalAction action) =>
//     state.rebuild((b) => b.store.totalStoreProductTypes = action.value);

StoreState onUpdateTradingHoursAction(
  StoreState state,
  UpdateTradingHoursAction action,
) => state.rebuild((b) => b.store!.tradingHours = action.value);

StoreState onSetFollowerCountAction(
  StoreState state,
  SetFollowerCountAction action,
) => state.rebuild((b) => b.followerCount = action.value);

// StoreState onLoadStoreAttributesAction(
//         StoreState state, LoadStoreAttributesAction action) =>
//     state.rebuild((b) => b.storeAttributeGroups = action.value);

StoreState onSetCurrentStore(StoreState state, SetCurrentStoreAction action) =>
    state.rebuild((b) => b.store = action.value);

StoreState onSetStoreCustomersAction(
  StoreState state,
  SetStoreCustomersAction action,
) => state.rebuild((b) => b.customers = action.value);

StoreState onStoreIncrementProductAction(
  StoreState state,
  StoreIncrementProductAction action,
) => state.rebuild(
  (b) => b.store!.totalProducts = b.store!.totalProducts != null
      ? b.store!.totalProducts! + 1
      : 0,
);

StoreState onStoreDecrementProductAction(
  StoreState state,
  StoreDecrementProductAction action,
) => state.rebuild(
  (b) => b.store!.totalProducts = b.store!.totalProducts != null
      ? b.store!.totalProducts! > 0
            ? b.store!.totalProducts! - 1
            : 0
      : 0,
);

StoreState onStoreIncrementCategoryAction(
  StoreState state,
  StoreIncrementCategoryAction action,
) => state.rebuild(
  (b) => b.store!.totalCategories = b.store!.totalCategories != null
      ? b.store!.totalCategories! + 1
      : 0,
);

StoreState onStoreDecrementCategoryAction(
  StoreState state,
  StoreDecrementCategoryAction action,
) => state.rebuild(
  (b) => b.store!.totalCategories = b.store!.totalCategories != null
      ? b.store!.totalCategories! > 0
            ? b.store!.totalCategories! - 1
            : 0
      : 0,
);

StoreState onUpdateStoreAction(StoreState state, UpdateStoreAction action) =>
    state.rebuild((b) => b.store = action.value);

StoreState onSetStoreCollectionSettingsAction(
  StoreState state,
  SetStoreCollectionSettingsAction action,
) => state.rebuild((b) => b.store!.collectionSettings = action.value);

StoreState onOrdersLoadedAction(StoreState state, OrdersLoadedAction action) =>
    state.rebuild((b) => b.orders = action.value);

StoreState onOrdersStatusesLoadedAction(
  StoreState state,
  OrdersStatusesLoadedAction action,
) => state.rebuild((b) => b.orderStatuses = action.value);

StoreState onStoreProductChangedAction(
  StoreState state,
  StoreProductChangedAction action,
) => state.rebuild((b) {
  b.products = action.changeType == ChangeType.removed
      ? _removeProduct(action.value, b.products ?? <StoreProduct>[])
      : _upsertProduct(action.value, b.products ?? <StoreProduct>[]);
  if (b.products!
      .where((element) => (element.deleted ?? false) == false)
      .toList()
      .isEmpty) {
    // b.store!.isPublic = false;
  }
});

StoreState onOrderStatusChangedAction(
  StoreState state,
  OrderStatusChangedAction action,
) => state.rebuild((b) {
  b.orderStatuses = action.changeType == ChangeType.removed
      ? _removeOrderStatus(action.value, b.orderStatuses ?? <OrderStatus>[])
      : _upsertOrderStatus(action.value, b.orderStatuses ?? <OrderStatus>[]);
});

StoreState onOrderChangedAction(StoreState state, OrderChangedAction action) =>
    state.rebuild((b) {
      b.orders = action.changeType == ChangeType.removed
          ? _removeOrder(action.value, b.orders ?? <CheckoutOrder>[])
          : _upsertOrder(action.value, b.orders ?? <CheckoutOrder>[]);
    });

StoreState onSetStoreCategoriesChangedAction(
  StoreState state,
  SetStoreCategoriesChangedAction action,
) => state.rebuild((b) {
  b.productCategories = action.changeType == ChangeType.removed
      ? _removeCategory(
          action.value,
          b.productCategories ?? <StoreProductCategory>[],
        )
      : _upsertCategory(
          action.value,
          b.productCategories ?? <StoreProductCategory>[],
        );
});

StoreState onSetStoreDeliverySettingsAction(
  StoreState state,
  SetStoreDeliverySettingsAction action,
) => state.rebuild((b) => b.store!.deliverySettings = action.value);

StoreState onUpdateStoreProductAction(
  StoreState state,
  UpdateStoreProductAction action,
) {
  return state.rebuild((p) {
    action.changeType == l_enum.ChangeType.removed
        ? removeOnlineProduct(action.product, p.products)
        : addOrUpdateOnlineProduct(action.product, p.products);
  });
}

StoreState onUpdateStoreProductCategoryAction(
  StoreState state,
  UpdateStoreProductCategoryAction action,
) {
  return state.rebuild((p0) {
    p0.productCategories = action.changeType == l_enum.ChangeType.removed
        ? removeOnlineProductCategory(action.category, p0.productCategories)
        : addOrUpdateOnlineCategory(action.category, p0.productCategories);
  });
}

List<StoreProduct> addOrUpdateOnlineProduct(
  StoreProduct value,
  List<StoreProduct>? state,
) {
  var productIndex = state!.indexWhere((p) => p.id == value.id);
  if (productIndex >= 0) {
    state[productIndex] = value;
  } else {
    state.add(value);
  }

  return state;
}

List<StoreProduct> removeOnlineProduct(
  StoreProduct value,
  List<StoreProduct>? state,
) {
  state!.removeWhere((p) => p.id == value.id);

  return state;
}

List<StoreProductCategory> addOrUpdateOnlineCategory(
  StoreProductCategory value,
  List<StoreProductCategory>? state,
) {
  var productIndex = state!.indexWhere((p) => p.id == value.id);
  if (productIndex >= 0) {
    state[productIndex] = value;
  } else {
    state.add(value);
  }

  return state;
}

List<StoreProductCategory> removeOnlineProductCategory(
  StoreProductCategory value,
  List<StoreProductCategory>? state,
) {
  state!.removeWhere((p) => p.id == value.id);

  return state;
}

StoreState onClearCurrentStore(
  StoreState state,
  ClearCurrentStoreAction action,
) => state.rebuild((b) {
  b.store = null;
  b.productCategories = [];
  b.products = [];
  b.featuredProducts = [];
  b.teamMembers = [];
  b.hasError = false;
});

StoreState onSetStoreLogo(StoreState state, SetStoreLogoAction action) =>
    state.rebuild((b) {
      b.store!.logoUrl = action.url;
      b.store!.logoAddress = action.imageAddress;
    });

StoreState onSetStoreBanner(StoreState state, SetStoreBannerAction action) =>
    state.rebuild((b) {
      b.store!.bannerUrl = action.url;
      b.store!.bannerAddress = action.imageAddress;
    });

StoreState onSetStoreAboutImage(
  StoreState state,
  SetStoreAboutImageAction action,
) => state.rebuild((b) {
  b.store!.aboutImageUrl = action.url;
  b.store!.aboutImageAddress = action.imageAddress;
});

StoreState onSetStoreCoverImage(
  StoreState state,
  SetStoreCoverImageAction action,
) => state.rebuild((b) {
  b.store!.coverImageUrl = action.url;
  b.store!.coverImageAddress = action.imageAddress;
});

StoreState onSetCurrentStoreCategories(
  StoreState state,
  SetCurrentStoreCategoriesAction action,
) => state.rebuild((b) {
  b.productCategories = action.value;
});

StoreState onSetCurrentStoreTeam(
  StoreState state,
  SetCurrentStoreTeamAction action,
) => state.rebuild((b) => b.teamMembers = action.value);

StoreState onSetStoreAddress(StoreState state, SetStoreAddressAction action) =>
    state.rebuild((b) => b.store!.primaryAddress = action.value);

StoreState onSetStoreProducts(
  StoreState state,
  SetStoreProductsAction action,
) => state.rebuild((b) => b.products = action.value);

StoreState onSetStoreStateLoading(
  StoreState state,
  SetStoreLoadingAction action,
) => state.rebuild((b) => b.isLoading = action.value);

List<StoreProduct> _removeProduct(
  StoreProduct value,
  List<StoreProduct> state,
) {
  state.removeWhere((p) => p.id == value.id);

  return state;
}

List<StoreProduct> _upsertProduct(
  StoreProduct value,
  List<StoreProduct> state,
) {
  var productIndex = state.indexWhere((p) => p.id == value.id);
  if (productIndex >= 0) {
    state[productIndex] = value;
  } else {
    state.add(value);
  }

  return state;
}

List<OrderStatus> _removeOrderStatus(
  OrderStatus? value,
  List<OrderStatus> state,
) {
  if (value == null) return state;

  state.removeWhere((p) => p.id == value.id);

  return state;
}

List<OrderStatus> _upsertOrderStatus(
  OrderStatus? value,
  List<OrderStatus> state,
) {
  if (value == null) return state;

  var orderIndex = state.indexWhere((p) => p.id == value.id);
  if (orderIndex >= 0) {
    state[orderIndex] = value;
  } else {
    state.add(value);
  }

  return state;
}

List<StoreAttribute> _removeStoreAttribute(
  StoreAttribute value,
  List<StoreAttribute> state,
) {
  state.removeWhere((p) => p.name == value.name);

  return state;
}

List<StoreAttribute> _upsertStoreAttribute(
  StoreAttribute value,
  List<StoreAttribute> state,
) {
  if (value.groupType == StoreAttributeGroupSelectType.multiple) {
    var orderIndex = state.indexWhere((p) => p.name == value.name);
    if (orderIndex >= 0) {
      state[orderIndex] = value;
    } else {
      state.add(value);
    }
  } else {
    state.removeWhere((p) => p.attributeGroup == value.attributeGroup);
    state.add(value);
  }

  return state;
}

List<StoreProductType> _removeStoreProductType(
  StoreProductType value,
  List<StoreProductType> state,
) {
  state.removeWhere((p) => p.name == value.name);

  return state;
}

List<StoreProductType> _upsertStoreProductType(
  StoreProductType value,
  List<StoreProductType> state,
) {
  var orderIndex = state.indexWhere((p) => p.id == value.id);
  if (orderIndex == -1) {
    state.add(value);
  }

  return state;
}

List<CheckoutOrder> _removeOrder(
  CheckoutOrder? value,
  List<CheckoutOrder> state,
) {
  if (value == null) return state;

  state.removeWhere((p) => p.orderId == value.orderId);

  return state;
}

List<CheckoutOrder> _upsertOrder(
  CheckoutOrder? value,
  List<CheckoutOrder> state,
) {
  if (value == null) return state;

  var orderIndex = state.indexWhere((p) => p.orderId == value.orderId);
  if (orderIndex >= 0) {
    state[orderIndex] = value;
  } else {
    state.add(value);
  }

  return state;
}

List<StoreProductCategory> _removeCategory(
  StoreProductCategory? value,
  List<StoreProductCategory> state,
) {
  if (value == null) return state;

  state.removeWhere((p) => p.categoryId == value.categoryId);

  return state;
}

List<StoreProductCategory> _upsertCategory(
  StoreProductCategory? value,
  List<StoreProductCategory> state,
) {
  if (value == null) return state;

  var catIndex = state.indexWhere((p) => p.categoryId == value.categoryId);
  if (catIndex >= 0) {
    state[catIndex] = value;
  } else {
    state.add(value);
  }

  return state;
}

final storeUIReducer = combineReducers<StoreUIState>([
  TypedReducer<StoreUIState, SetStoreLoadingAction>(onSetUIStoreLoading).call,
  TypedReducer<StoreUIState, SetStoreSelectedCategoryAction>(
    onSetSelectedStoreCategory,
  ).call,
  TypedReducer<StoreUIState, SetStoreCategoryProductsAction>(
    onSetCategoryProducts,
  ).call,
  TypedReducer<StoreUIState, SetStoreSubcategoriesAction>(
    onSetSubCategories,
  ).call,
  TypedReducer<StoreUIState, SignoutAction>(onUISignoutAction).call,
  TypedReducer<StoreUIState, ClearCurrentStoreAction>(onClearStoreUI).call,
  TypedReducer<StoreUIState, SetCurrentNavIndexAction>(
    onSetCurrentNavIndexAction,
  ).call,
  TypedReducer<StoreUIState, ClearSelectedPromotionAction>(
    onClearSelectedPromotionAction,
  ).call,
  TypedReducer<StoreUIState, SetSelectedPromotionTypeAction>(
    onSetSelectedPromotionTypeAction,
  ).call,
  TypedReducer<StoreUIState, SetSelectedPromotionContentAction>(
    onSetSelectedPromotionContentAction,
  ).call,
  TypedReducer<StoreUIState, SetSelectedPromotionAction>(
    onSetSelectedPromotionAction,
  ).call,
  TypedReducer<StoreUIState, SetSelectedSubCategoryAction>(
    onSetSelectedSubCategory,
  ).call,
  TypedReducer<StoreUIState, SetStoreSubCategoryProductsAction>(
    onSetSubCategoryProducts,
  ).call,
  TypedReducer<StoreUIState, SetSelectedOrdersAction>(
    onSetSelectedOrdersAction,
  ).call,
  TypedReducer<StoreUIState, SetSelectedOrderStatusAction>(
    onSetSelectedOrderStatusAction,
  ).call,
  TypedReducer<StoreUIState, SetSelectedOrderIndexAction>(
    onSetSelectedOrderIndexAction,
  ).call,
  TypedReducer<StoreUIState, SelectedOrderStatusChangeAction>(
    onSelectedOrderStatusChangeAction,
  ).call,
  TypedReducer<StoreUIState, ResetStoreProductUIAction>(
    onResetStoreProductUIAction,
  ).call,
  TypedReducer<StoreUIState, SetSelectedProductAction>(
    onSetSelectedProductAction,
  ).call,
  TypedReducer<StoreUIState, StoreSetSearchingProductsAction>(
    onSetSearchingProducts,
  ).call,
  TypedReducer<StoreUIState, SetStoreAttributesAction>(
    onSetStoreAttributesAction,
  ).call,
  TypedReducer<StoreUIState, SetStoreProductTypeAction>(
    onSetStoreProductTypesAction,
  ).call,
  TypedReducer<StoreUIState, SetStoreSubtypeAction>(
    onSetStoreSubtypeAction,
  ).call,
  TypedReducer<StoreUIState, SetStoreTypeAction>(onSetStoreTypeAction).call,
  TypedReducer<StoreUIState, SetStoreAttributeOptionsAction>(
    onSetStoreAttributeOptionsAction,
  ).call,
  TypedReducer<StoreUIState, SetStoreProductTypeOptionsAction>(
    onSetStoreProductTypeOptionsAction,
  ).call,
  TypedReducer<StoreUIState, ResetStoreAttributesAction>(
    onResetStoreAttributesAction,
  ).call,
  TypedReducer<StoreUIState, SetProductsOrCategoriesSortOptionsAction>(
    onSetProductsSortOptions,
  ).call,
]);

StoreUIState onSetProductsSortOptions(
  StoreUIState state,
  SetProductsOrCategoriesSortOptionsAction action,
) => state.rebuild((b) {
  b.sortProductsBy = action.type;
  b.sortProductsOrder = action.order;
});

StoreUIState onSetUIStoreLoading(
  StoreUIState state,
  SetStoreLoadingAction action,
) => state.rebuild((b) => b.isLoading = action.value);

StoreUIState onUISignoutAction(StoreUIState state, SignoutAction action) =>
    state.rebuild((b) => b = StoreUIState().toBuilder());

StoreUIState onSetCurrentNavIndexAction(
  StoreUIState state,
  SetCurrentNavIndexAction action,
) => state.rebuild((b) => b.currentNavIndex = action.value);

StoreUIState onSetSelectedPromotionAction(
  StoreUIState state,
  SetSelectedPromotionAction action,
) => state.rebuild((b) => b.selectedPromotion = action.value);

StoreUIState onSetStoreProductTypeOptionsAction(
  StoreUIState state,
  SetStoreProductTypeOptionsAction action,
) => state.rebuild((b) => b.storeProductTypeOptions = action.value);

StoreUIState onSetStoreAttributeOptionsAction(
  StoreUIState state,
  SetStoreAttributeOptionsAction action,
) => state.rebuild((b) => b.storeAttributeOptions = action.value);

StoreUIState onSetSelectedPromotionContentAction(
  StoreUIState state,
  SetSelectedPromotionContentAction action,
) => state.rebuild((b) {
  b.selectedPromotion!.title = action.title;
  b.selectedPromotion!.message = action.message;
  return b;
});

StoreUIState onResetStoreAttributesAction(
  StoreUIState state,
  ResetStoreAttributesAction action,
) => state.rebuild((b) => b.selectedStoreAttributes = <StoreAttribute>[]);

StoreUIState onSetStoreSubtypeAction(
  StoreUIState state,
  SetStoreSubtypeAction action,
) => state.rebuild((b) => b.selectedStoreSubtype = action.value);

StoreUIState onSetStoreTypeAction(
  StoreUIState state,
  SetStoreTypeAction action,
) => state.rebuild((b) => b.selectedStoreType = action.value);

StoreUIState onSetStoreProductTypesAction(
  StoreUIState state,
  SetStoreProductTypeAction action,
) => state.rebuild((b) {
  b.selectedStoreProductTypes = action.changeType == ChangeType.removed
      ? _removeStoreProductType(
          action.value,
          b.selectedStoreProductTypes ?? <StoreProductType>[],
        )
      : _upsertStoreProductType(
          action.value,
          b.selectedStoreProductTypes ?? <StoreProductType>[],
        );
});

StoreUIState onSetStoreAttributesAction(
  StoreUIState state,
  SetStoreAttributesAction action,
) => state.rebuild((b) {
  b.selectedStoreAttributes = action.changeType == ChangeType.removed
      ? _removeStoreAttribute(
          action.value,
          b.selectedStoreAttributes ?? <StoreAttribute>[],
        )
      : _upsertStoreAttribute(
          action.value,
          b.selectedStoreAttributes ?? <StoreAttribute>[],
        );
});

StoreUIState onSetSelectedPromotionTypeAction(
  StoreUIState state,
  SetSelectedPromotionTypeAction action,
) => state.rebuild((b) => b.selectedPromotion!.type = action.value);

StoreUIState onClearSelectedPromotionAction(
  StoreUIState state,
  ClearSelectedPromotionAction action,
) => state.rebuild((b) => b.selectedPromotion = null);

StoreUIState onResetStoreProductUIAction(
  StoreUIState state,
  ResetStoreProductUIAction action,
) => state.rebuild(
  (b) => b.item = StoreProduct.create(
    AppVariables.store!.state.storeState.store!.businessId!,
  ),
);

StoreUIState onSetSelectedProductAction(
  StoreUIState state,
  SetSelectedProductAction action,
) => state.rebuild((b) => b.item = action.value);

StoreUIState onSetSelectedOrdersAction(
  StoreUIState state,
  SetSelectedOrdersAction action,
) => state.rebuild((b) => b.selectedOrders = action.value);

StoreUIState onSetSelectedOrderStatusAction(
  StoreUIState state,
  SetSelectedOrderStatusAction action,
) => state.rebuild((b) => b.selectedOrderStatus = action.value);

StoreUIState onSetSelectedStoreCategory(
  StoreUIState state,
  SetStoreSelectedCategoryAction action,
) => state.rebuild((b) {
  b.selectedCategory = action.value;
});

StoreUIState onSelectedOrderStatusChangeAction(
  StoreUIState state,
  SelectedOrderStatusChangeAction action,
) => state.rebuild((b) {
  b.selectedOrders = _removeOrder(
    action.value,
    b.selectedOrders ?? <CheckoutOrder>[],
  );
});

StoreUIState onSetCategoryProducts(
  StoreUIState state,
  SetStoreCategoryProductsAction action,
) => state.rebuild((b) => b.categoryProducts = action.value);

StoreUIState onSetSubCategories(
  StoreUIState state,
  SetStoreSubcategoriesAction action,
) => state.rebuild((b) => b.subCategories = action.value ?? []);

StoreUIState onClearStoreUI(
  StoreUIState state,
  ClearCurrentStoreAction action,
) => state.rebuild((b) {
  b.isLoading = false;
  b.selectedCategory = null;
  b.subCategories = null;
  b.categoryProducts = null;
});

StoreUIState onSetSelectedSubCategory(
  StoreUIState state,
  SetSelectedSubCategoryAction action,
) => state.rebuild((b) => b.selectedSubCategory = action.value);

StoreUIState onSetSelectedOrderIndexAction(
  StoreUIState state,
  SetSelectedOrderIndexAction action,
) => state.rebuild((b) => b.selectedOrderIndex = action.value);

StoreUIState onSetSubCategoryProducts(
  StoreUIState state,
  SetStoreSubCategoryProductsAction action,
) => state.rebuild((b) => b.subCategoryProducts = action.value);

// StoreUIState onSetCurrentUIStore(
//     StoreUIState state, SetCurrentStoreAction action) => state.rebuild((b) => b.st)

StoreState onSetOnSaleProducts(
  StoreState state,
  SetStoreOnSaleProductsAction action,
) => state.rebuild((b) => b.onsaleProducts = action.value);

StoreUIState onSetSearchingProducts(
  StoreUIState state,
  StoreSetSearchingProductsAction action,
) => state.rebuild((b) => b.isSearchingProducts = action.value);
