// Flutter imports:
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/models/products/product_combo.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_cart_item.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_refund.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_refund_item.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_transaction.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_transaction_helper.dart';
import 'package:littlefish_merchant/models/stock/stock_category.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
// Project imports:
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/product/product_actions.dart';
import 'package:littlefish_merchant/redux/sales/sales_actions.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/ui/sales/view_models.dart';
// removed ignore: depend_on_referenced_packages, implementation_imports
import 'package:redux/src/store.dart';

bool allParametersNotNull(List<dynamic> params) {
  return params.every((param) => param != null);
}

bool anyParameterIsNull(List<dynamic> params) {
  bool allNotNull = allParametersNotNull(params);
  if (allNotNull == true) return false;
  return true;
}

RefundItem? getItemInCurrentRefund(String checkoutCartItemID, Refund refund) {
  if (checkoutCartItemID.isEmpty) return null;
  if (refund.items == null || refund.items!.isEmpty) return null;

  int? indexOfCartItem = _getRefundItemIndex(checkoutCartItemID, refund);
  bool cartItemFound = indexOfCartItem != null && indexOfCartItem > -1;
  if (cartItemFound) {
    return refund.items![indexOfCartItem];
  }

  return null;
}

int? _getRefundItemIndex(String checkoutCartItemID, Refund refund) {
  if (checkoutCartItemID.isEmpty) return null;

  return refund.items?.indexWhere(
    (RefundItem refundItem) =>
        refundItem.checkoutCartItemId == checkoutCartItemID,
  );
}

RefundItem? createNewRefundItem(
  CheckoutCartItem cartItem,
  double quantity,
  CheckoutTransaction transaction,
) {
  CheckoutTransactionHelper transactionHelper = CheckoutTransactionHelper(
    transaction,
  );
  double cartItemValue = transactionHelper.getCartItemDiscountedValue(
    cartItem.itemValue ?? 0,
  );

  RefundItem refundItem = RefundItem(
    checkoutCartItemId: cartItem.id!,
    displayName: cartItem.description!,
    quantity: quantity,
    itemTotalValue: cartItemValue * quantity,
    itemValue: cartItemValue,
    itemTotalCost: cartItem.itemCost,
    itemCost: cartItem.itemCost,
  );

  return refundItem;
}

void createNewRefundItemAndAddToCart(
  String checkoutCartItemID,
  CheckoutTransaction transaction,
  SalesVM vm,
) {
  CheckoutCartItem? cartItem = _getCartItemByID(
    checkoutCartItemID,
    transaction,
  );
  if (cartItem == null) return;

  RefundItem? newRefundItem = createNewRefundItem(cartItem, 1, transaction);
  if (newRefundItem != null) {
    vm.store?.dispatch(addNewItemToBeRefunded(item: newRefundItem));
  }
}

CheckoutCartItem? _getCartItemByID(
  String cartItemID,
  CheckoutTransaction transaction,
) {
  if (cartItemID.isEmpty) return null;
  if (transaction.items == null || transaction.itemCount == 0) return null;

  int indexOfCartItem = transaction.items!.indexWhere(
    (CheckoutCartItem cartItem) => cartItem.id == cartItemID,
  );
  bool cartItemFound = indexOfCartItem > -1;
  if (cartItemFound) {
    return transaction.items![indexOfCartItem];
  }

  return null;
}

Future<List<TileItemInfo>> fetchAllData({
  required Store<AppState> store,
  required CheckoutTransaction transaction,
}) async {
  List<CheckoutCartItem> productCartItems = [];
  List<CheckoutCartItem> comboCartItems = [];
  List<CheckoutCartItem> customCartItems = [];
  List<TileItemInfo> itemInfoList = [];
  List<CheckoutCartItem>? items = transaction.items;

  if (items == null || items.isEmpty) return [];

  Map<String, dynamic> sortedItems = sortItemsByType(items);
  productCartItems = sortedItems['productItems'];
  comboCartItems = sortedItems['comboItems'];
  customCartItems = sortedItems['customItems'];

  // gather information for products and categories
  if (productCartItems.isNotEmpty) {
    Map<String, List<dynamic>> productsAndCategories =
        await getProductsAndCategories(productCartItems, store);
    List<StockProduct> products =
        productsAndCategories['products'] as List<StockProduct>;
    List<StockCategory> categories =
        productsAndCategories['categories'] as List<StockCategory>;

    for (var product in products) {
      if (product.categoryId != null) {
        StockCategory? productCategory = fetchCategoryForProduct(
          product,
          categories,
        );
        String? categoryName = productCategory != null
            ? productCategory.displayName
            : 'NO CATEGORY';
        CheckoutCartItem? productCartItem = fetchCartItemForProduct(
          product,
          productCartItems,
        );
        if (productCartItem != null) {
          TileItemInfo itemInfo = getItemInfoFromProductAndItem(
            product: product,
            item: productCartItem,
            categoryName: categoryName,
            transaction: transaction,
          );
          itemInfoList.add(itemInfo);
        }
      } else {
        CheckoutCartItem? productCartItem = fetchCartItemForProduct(
          product,
          productCartItems,
        );
        if (productCartItem != null) {
          TileItemInfo itemInfo = getItemInfoFromProductAndItem(
            product: product,
            item: productCartItem,
            categoryName: 'NO CATEGORY',
            transaction: transaction,
          );
          itemInfoList.add(itemInfo);
        }
      }
    }
  }

  // gather information for combos
  if (comboCartItems.isNotEmpty) {
    List<ProductCombo> combos = await getAllCombos(comboCartItems, store);

    for (var combo in combos) {
      CheckoutCartItem? comboCartItem = fetchCartItemForCombo(
        combo,
        comboCartItems,
      );
      if (allParametersNotNull([combo, comboCartItem, transaction])) {
        TileItemInfo itemInfo = getItemInfoFromComboAndItem(
          combo: combo,
          item: comboCartItem!,
          transaction: transaction,
        );
        itemInfoList.add(itemInfo);
      }
    }
  }

  // gather information for custom items
  if (customCartItems.isNotEmpty) {
    for (var customItem in customCartItems) {
      TileItemInfo itemInfo = getItemInfoForCustomItem(
        item: customItem,
        transaction: transaction,
      );
      itemInfoList.add(itemInfo);
    }
  }

  return itemInfoList;
}

CheckoutCartItem? fetchCartItemForCombo(
  ProductCombo combo,
  List<CheckoutCartItem> comboCartItems,
) {
  if (comboCartItems.isEmpty) return null;

  CheckoutCartItem? matchingCartItem = comboCartItems.firstWhereOrNull(
    (comboCartItem) => comboCartItem.comboId == combo.id,
  );

  return matchingCartItem;
}

CheckoutCartItem? fetchCartItemForProduct(
  StockProduct product,
  List<CheckoutCartItem> productCartItems,
) {
  if (productCartItems.isEmpty) return null;

  int index = productCartItems.indexWhere(
    (cartItem) => cartItem.productId == product.id,
  );
  bool itemFound = index != -1;
  if (itemFound == false) return null;

  CheckoutCartItem? matchingCartItem = productCartItems.firstWhereOrNull(
    (productCartItem) => productCartItem.productId == product.id,
  );

  return matchingCartItem;
}

StockCategory? fetchCategoryForProduct(
  StockProduct product,
  List<StockCategory> categoriesList,
) {
  if (categoriesList.isEmpty) return null;

  StockCategory? matchingCategory = categoriesList.firstWhereOrNull(
    (category) => category.id == product.categoryId,
  );

  return matchingCategory;
}

Future<List<ProductCombo>> getAllCombos(
  List<CheckoutCartItem> comboCartItems,
  Store<AppState> store,
) async {
  List<ProductCombo> combosInState = [];
  List<String> comboIDsForCombosNotInState = [];
  List<ProductCombo> combosNotInState = [];

  // get combos from state
  for (var comboInCart in comboCartItems) {
    ProductCombo? comboFromState = getComboFromState(
      comboInCart.comboId!,
      store,
    );
    if (comboFromState != null) {
      combosInState.add(comboFromState);
    } else {
      comboIDsForCombosNotInState.add(comboInCart.comboId!);
    }
  }

  // get combos not in state, pull from backend
  combosNotInState =
      await getCombosByComboIDsFromBackend(
        comboIDsForCombosNotInState,
        store,
      ) ??
      [];

  List<ProductCombo> allCombos = combosInState + combosNotInState;
  return allCombos;
}

StockCategory? getCategoryFromState(String categoryID, Store<AppState> store) {
  return store.state.productState.getCategory(categoryId: categoryID);
}

ProductCombo? getComboFromState(String comboID, Store<AppState> store) {
  // return store.state.productState.getComboById(comboID);
  int? index = store.state.productState.productCombos?.indexWhere(
    (combo) => combo.id == comboID,
  );
  bool comboInState = index != -1 && index != null;
  if (comboInState) {
    return store.state.productState.productCombos?[index];
  } else {
    return null;
  }
}

Future<List<ProductCombo>?> getCombosByComboIDsFromBackend(
  List<String> comboIDs,
  Store<AppState> store,
) async {
  List<ProductCombo>? combos;
  // check api for product
  if (comboIDs.isNotEmpty) {
    combos = await getCombosByComboIDs(store, comboIDs);
  }

  return combos;
}

TileItemInfo getItemInfoForCustomItem({
  required CheckoutCartItem item,
  required CheckoutTransaction transaction,
}) {
  double quantityAlreadyRefunded =
      getTotalQuantityRefundedForItemOverAllRefunds(item.id!, transaction);
  String refundedText = quantityAlreadyRefunded != 0
      ? ', $quantityAlreadyRefunded already refunded.'
      : '';

  CheckoutTransactionHelper transactionHelper = CheckoutTransactionHelper(
    transaction,
  );
  double cartItemValue = transactionHelper.getCartItemDiscountedValue(
    item.itemValue ?? 0,
  );
  return TileItemInfo(
    title: 'QUICK ITEM',
    itemId: item.id!,
    itemType: 'quick_item',
    subtitle: item.description ?? 'Custom Sale',
    subsubtitle: (item.quantity) > 1
        ? '${item.quantity} items sold$refundedText'
        : '${item.quantity} item sold$refundedText',
    trailText: TextFormatter.toStringCurrency(cartItemValue, currencyCode: ''),
    cartItemID: item.id!,
  );
}

TileItemInfo getItemInfoFromComboAndItem({
  required ProductCombo combo,
  required CheckoutCartItem item,
  required CheckoutTransaction transaction,
}) {
  double quantityAlreadyRefunded =
      getTotalQuantityRefundedForItemOverAllRefunds(item.id!, transaction);
  String refundedText = quantityAlreadyRefunded != 0
      ? ', $quantityAlreadyRefunded already refunded.'
      : '';

  CheckoutTransactionHelper transactionHelper = CheckoutTransactionHelper(
    transaction,
  );
  double cartItemValue = transactionHelper.getCartItemDiscountedValue(
    item.itemValue ?? 0,
  );

  return TileItemInfo(
    itemId: combo.id!,
    itemType: 'combos',
    imageUri: combo.imageUri,
    title: combo.displayName,
    subtitle:
        "Saving: ${TextFormatter.toStringCurrency(item.itemSaving, displayCurrency: false, currencyCode: '')}",
    subsubtitle: item.quantity > 1
        ? '${item.quantity} items sold$refundedText'
        : '${item.quantity} item sold$refundedText',
    trailText: TextFormatter.toStringCurrency(cartItemValue, currencyCode: ''),
    cartItemID: item.id!,
  );
}

TileItemInfo getItemInfoFromProductAndItem({
  required StockProduct product,
  required CheckoutCartItem item,
  required CheckoutTransaction transaction,
  String? categoryName,
}) {
  double quantityAlreadyRefunded =
      getTotalQuantityRefundedForItemOverAllRefunds(item.id!, transaction);
  String refundedText = quantityAlreadyRefunded != 0
      ? ', $quantityAlreadyRefunded already refunded.'
      : '';

  CheckoutTransactionHelper transactionHelper = CheckoutTransactionHelper(
    transaction,
  );
  double cartItemValue = transactionHelper.getCartItemDiscountedValue(
    item.itemValue ?? 0,
  );

  return TileItemInfo(
    imageUri: product.imageUri,
    itemId: product.id!,
    itemType: 'products',
    title: categoryName ?? 'NO CATEGORY',
    subtitle: product.displayName,
    subsubtitle: item.quantity > 1
        ? '${item.quantity} items sold$refundedText'
        : '${item.quantity} item sold$refundedText',
    trailText: TextFormatter.toStringCurrency(cartItemValue, currencyCode: ''),
    cartItemID: item.id!,
  );
}

Future<StockProduct?>? getProductFromBackend(
  BuildContext context,
  String productID,
  Store<AppState> store,
) async {
  StockProduct? product = await getProductById(store, productID);
  return product;
}

StockProduct? getProductFromState(String productID, Store<AppState> store) {
  return store.state.productState.getProductById(productID);
}

Future<Map<String, List<dynamic>>> getProductsAndCategories(
  List<CheckoutCartItem> productItems,
  Store<AppState> store,
) async {
  List<StockProduct> productsInState = [];
  List<StockCategory> categoriesInState = [];
  List<String> productIDsForProductsNotInState = [];
  List<StockProduct> productsNotInState = [];
  List<StockCategory> categoriesNotInState = [];

  for (CheckoutCartItem item in productItems) {
    StockProduct? product = getProductFromState(item.productId!, store);
    if (product == null) {
      // Product not in state
      productIDsForProductsNotInState.add(item.productId!);
      continue;
    }

    StockCategory? category;

    // Check if product does not have a category
    if (product.categoryId == null) {
      productsInState.add(product);
      continue;
    }

    // product has a categoryID so try get category from state
    category = getCategoryFromState(product.categoryId!, store);

    if (category != null) {
      productsInState.add(product);
      categoriesInState.add(category);
    } else {
      // Product has a category, but category is not in state
      productIDsForProductsNotInState.add(item.productId!);
    }
  }

  if (productIDsForProductsNotInState.isNotEmpty) {
    Map<String, List<dynamic>?>? productsAndCategiesNotInState =
        await getProductsAndCategoriesFromBackend(
          productIDsForProductsNotInState,
          store,
        );

    if (productsAndCategiesNotInState != null &&
        productsAndCategiesNotInState['products']!.isNotEmpty) {
      productsNotInState =
          productsAndCategiesNotInState['products'] as List<StockProduct>;
    }

    if (productsAndCategiesNotInState != null &&
        productsAndCategiesNotInState['categories']!.isNotEmpty) {
      categoriesNotInState =
          productsAndCategiesNotInState['categories'] as List<StockCategory>;
    }
  }

  Map<String, List<dynamic>> allProductsAndCategories = {
    'products': productsInState + productsNotInState,
    'categories': categoriesInState + categoriesNotInState,
  };

  return allProductsAndCategories;
}

Future<Map<String, List<dynamic>?>?>? getProductsAndCategoriesFromBackend(
  List<String> productIDs,
  Store<AppState> store,
) async {
  Map<String, List<dynamic>?>? productsAndCategegories;
  // check api for product
  if (productIDs.isNotEmpty) {
    productsAndCategegories = await getProductsAndCategoriesByID(
      store,
      productIDs,
    );
  }

  return productsAndCategegories;
}

double getQuantityRemainingForItem(
  String? cartItemID,
  CheckoutTransaction? transaction,
) {
  if (transaction == null ||
      transaction.items == null ||
      transaction.itemCount == 0) {
    return 0;
  }
  if (cartItemID == null) return 0;

  CheckoutCartItem? cartItem = transaction.items?.firstWhere(
    (item) => item.id == cartItemID,
  );
  double? quantitySold = cartItem?.quantity ?? 0;

  double totalRefundedQuantity = (getTotalQuantityRefundedForItemOverAllRefunds(
    cartItemID,
    transaction,
  ));
  double? itemsRemaining = quantitySold - totalRefundedQuantity;
  return itemsRemaining;
}

double getTotalQuantityRefundedForItemOverAllRefunds(
  String cartItemID,
  CheckoutTransaction transaction,
) {
  if (transaction.refunds == null) {
    return 0;
  }

  double totalQuantityRefunded = 0;

  for (Refund refund in transaction.refunds!) {
    if (refund.items == null || refund.items!.isEmpty) break;

    for (RefundItem refundItem in refund.items!) {
      if (refundItem.checkoutCartItemId == cartItemID) {
        double quantityRefunded = refundItem.quantity ?? 0;
        totalQuantityRefunded += quantityRefunded;
      }
    }
  }

  return totalQuantityRefunded;
}

bool itemIsStockProduct(CheckoutCartItem item) {
  return item.productId != null;
}

Map<String, dynamic> sortItemsByType(List<CheckoutCartItem> transactionItems) {
  List<CheckoutCartItem> productItems = [];
  List<CheckoutCartItem> comboItems = [];
  List<CheckoutCartItem> customItems = [];

  for (CheckoutCartItem item in transactionItems) {
    if (itemIsStockProduct(item)) {
      productItems.add(item);
    } else if (item.isCombo == true) {
      comboItems.add(item);
    } else {
      customItems.add(item);
    }
    // check if item is custom item
    // else if (item.isCustomSale == true){
    // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    // !!!!!WE SHOULD BE USING isCustomSale but for some reason it is false !!!
    // !!!!!when it should be true. For now just using else since it is not !!!
    // !!!!!a registered product or combo we are making an assumption       !!!
    // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  }

  return {
    'productItems': productItems,
    'comboItems': comboItems,
    'customItems': customItems,
  };
}

class TileItemInfo {
  final String itemId;
  final String cartItemID;
  final String itemType;
  final String? title;
  final String? imageUri;
  final String? subtitle;
  final String? subsubtitle;
  final String? trailText;

  TileItemInfo({
    required this.itemId,
    required this.cartItemID,
    required this.itemType,
    this.title,
    this.imageUri,
    this.subtitle,
    this.subsubtitle,
    this.trailText,
  });
}
