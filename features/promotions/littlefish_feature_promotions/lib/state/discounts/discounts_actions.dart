import 'dart:async';
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/bootstrap.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_discount.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/services/checkout_service.dart';
import 'package:littlefish_merchant/ui/products/discounts/pages/discount_page.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';

late CheckoutService service;

ThunkAction<AppState> getDiscounts({bool refresh = false}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      var state = store.state.discountState;

      if (!refresh && (state.discounts?.length ?? 0) > 0) {
        return;
      }

      store.dispatch(DiscountsLoadingAction(true));

      await service
          .getDiscounts()
          .catchError((error) {
            store.dispatch(DiscountsErrorAction(error.toString()));
            return <CheckoutDiscount>[];
          })
          .then((result) {
            store.dispatch(DiscountsLoadedAction(result));
          })
          .whenComplete(() {
            store.dispatch(DiscountsLoadingAction(false));
          });
    });
  };
}

ThunkAction<AppState> createOrUpdateDiscount({
  required CheckoutDiscount item,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      store.dispatch(DiscountsLoadingAction(true));
      try {
        var result = await service.createOrUpdateDiscount(item);

        store.dispatch(DiscountChangedAction(ChangeType.updated, result));
        store.dispatch(DiscountsLoadingAction(false));
        completer?.complete();
      } catch (error) {
        store.dispatch(DiscountsErrorAction(error.toString()));
        store.dispatch(DiscountsLoadingAction(false));
        completer?.completeError(error, StackTrace.current);
      }
    });
  };
}

ThunkAction<AppState> deleteDiscount({
  required CheckoutDiscount item,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      store.dispatch(DiscountsLoadingAction(true));
      try {
        var result = await service.createOrUpdateDiscount(item);

        store.dispatch(DiscountChangedAction(ChangeType.removed, result));
        store.dispatch(DiscountsLoadingAction(false));
        completer?.complete();
      } catch (error) {
        store.dispatch(DiscountsErrorAction(error.toString()));
        store.dispatch(DiscountsLoadingAction(false));
        completer?.completeError(error, StackTrace.current);
      }
    });
  };
}

ThunkAction<AppState> createDiscount({required BuildContext context}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      store.dispatch(DiscountsLoadingAction(true));

      store.dispatch(CreateDiscountAction());

      if (store.state.isLargeDisplay ?? false) {
        showPopupDialog(
          content: const DiscountPage(isEmbedded: true),
          context: context,
        );
      } else {
        Navigator.pushNamed(
          globalNavigatorKey.currentContext!,
          DiscountPage.route,
          arguments: null,
        );
      }

      store.dispatch(DiscountsLoadingAction(false));
    });
  };
}

ThunkAction<AppState> editDiscount(
  CheckoutDiscount item, {
  required BuildContext context,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      store.dispatch(SelectDiscountAction(item));

      if (!(store.state.isLargeDisplay ?? false)) {
        Navigator.pushNamed(
          globalNavigatorKey.currentContext!,
          DiscountPage.route,
          arguments: item,
        );
      } else {
        // showPopupDialog(
        //   content: DiscountPage(isEmbedded: true),
        //   context: context,
        // );
      }
    });
  };
}

_initializeService(store) {
  service = CheckoutService.fromStore(store);
}

class DiscountsLoadingAction {
  bool value;

  DiscountsLoadingAction(this.value);
}

class DiscountChangedAction {
  ChangeType type;

  CheckoutDiscount value;

  DiscountChangedAction(this.type, this.value);
}

class DiscountsLoadedAction {
  List<CheckoutDiscount> value;

  DiscountsLoadedAction(this.value);
}

class DiscountsErrorAction {
  String value;

  DiscountsErrorAction(this.value);
}

class CreateDiscountAction {}

class SelectDiscountAction {
  CheckoutDiscount value;

  SelectDiscountAction(this.value);
}
