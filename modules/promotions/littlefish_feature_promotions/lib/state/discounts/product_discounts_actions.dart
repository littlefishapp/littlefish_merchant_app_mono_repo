// Dart imports:
import 'dart:async';

// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

// Project imports:
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/models/products/product_discount.dart';
import 'package:littlefish_merchant/services/product_discount_service.dart';

late ProductDiscountService service;

ThunkAction<AppState> getProductDiscounts({bool refresh = false}) {
  return (Store<AppState> store) async {
    Future(() async {
      store.dispatch(ProductDiscountsLoadingAction(true));
      _initializeService(store);

      var state = store.state.discountState;

      if (!refresh && (state.discounts?.length ?? 0) > 0) {
        store.dispatch(ProductDiscountsLoadingAction(false));
        return;
      }
      try {
        var result = await service.getProductDiscounts();
        store.dispatch(ProductDiscountsLoadingAction(false));
        store.dispatch(ProductDiscountsLoadedAction(result));
      } catch (error) {
        store.dispatch(ProductDiscountsLoadingAction(false));
        store.dispatch(ProductDiscountsErrorAction(error.toString()));
      }
      store.dispatch(ProductDiscountsLoadingAction(false));
    });
  };
}

ThunkAction<AppState> createOrUpdateProductDiscount({
  required ProductDiscount item,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      store.dispatch(ProductDiscountsLoadingAction(true));
      try {
        var result = await service.upsertProductDiscount(item);
        store.dispatch(
          ProductDiscountChangedAction(ChangeType.updated, result[0]),
        );
        store.dispatch(ProductDiscountsLoadingAction(false));
        completer?.complete();
      } catch (error) {
        store.dispatch(ProductDiscountsErrorAction(error.toString()));
        store.dispatch(ProductDiscountsLoadingAction(false));
        completer?.completeError(error, StackTrace.current);
      }
    });
  };
}

ThunkAction<AppState> updateProductDiscounts({
  required List<ProductDiscount> discounts,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      store.dispatch(ProductDiscountsLoadingAction(true));
      try {
        var result = await service.updateProductDiscounts(discounts);

        store.dispatch(ProductDiscountsLoadedAction(result));
        store.dispatch(ProductDiscountsLoadingAction(false));
      } catch (error) {
        store.dispatch(ProductDiscountsErrorAction(error.toString()));
        store.dispatch(ProductDiscountsLoadingAction(false));
      }
    });
  };
}

ThunkAction<AppState> deleteProductDiscount({
  required ProductDiscount item,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      store.dispatch(ProductDiscountsLoadingAction(true));
      try {
        var result = await service.deleteProductDiscount(item);
        store.dispatch(
          ProductDiscountChangedAction(ChangeType.removed, result),
        );
        store.dispatch(ProductDiscountsLoadingAction(false));
        completer?.complete();
      } catch (error) {
        store.dispatch(ProductDiscountsErrorAction(error.toString()));
        store.dispatch(ProductDiscountsLoadingAction(false));
        completer?.completeError(error, StackTrace.current);
      }
    });
  };
}

_initializeService(store) {
  service = ProductDiscountService.fromStore(store);
}

class ProductDiscountsLoadingAction {
  bool value;

  ProductDiscountsLoadingAction(this.value);
}

class ProductDiscountChangedAction {
  ChangeType type;

  ProductDiscount value;

  ProductDiscountChangedAction(this.type, this.value);
}

class ProductDiscountsLoadedAction {
  List<ProductDiscount> value;

  ProductDiscountsLoadedAction(this.value);
}

class ProductDiscountsErrorAction {
  String value;

  ProductDiscountsErrorAction(this.value);
}

class SelectProductDiscountAction {
  ProductDiscount value;

  SelectProductDiscountAction(this.value);
}
