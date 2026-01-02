// Dart imports:
import 'dart:async';

// Flutter imports:

// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

// Project imports:
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/promotions/promotion.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/services/promotions_service.dart';

late PromotionsService service;

ThunkAction<AppState> getPromotions({bool refresh = false}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      var state = store.state.promotionsState;

      if (!refresh && (state.items?.length ?? 0) > 0) {
        return;
      }

      store.dispatch(SetPromotionsLoadingAction(true));

      await service
          .getPromotions()
          .catchError((e) {
            store.dispatch(SetPromotionFaultAction(e.toString()));
            store.dispatch(SetPromotionsLoadingAction(false));
            return null;
          })
          .then((result) {
            store.dispatch(SetPromotionsLoadedAction(result));
            store.dispatch(SetPromotionsLoadingAction(false));
          });
    });
  };
}

ThunkAction<AppState> updateOrCreatePromotion({
  required Promotion? item,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      if (item == null) {
        completer?.complete();
        return;
      }

      store.dispatch(SetPromotionsLoadingAction(true));

      await service
          .updateOrCreatePromotion(item)
          .catchError((e) {
            store.dispatch(SetPromotionFaultAction(e.toString()));
            store.dispatch(SetPromotionsLoadingAction(false));

            if (!completer!.isCompleted) completer.completeError(e);
            return Promotion();
          })
          .then((result) {
            store.dispatch(
              SetPromotionChangedAction(
                result,
                ChangeType.updated,
                completer: completer,
              ),
            );
            store.dispatch(SetPromotionsLoadingAction(false));
          });
    });
  };
}

ThunkAction<AppState> removePromotion({
  required Promotion? item,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      if (item == null) {
        completer?.complete();
        return;
      }

      store.dispatch(SetPromotionsLoadingAction(true));

      bool hasError = false;

      await service
          .deletePromotion(promotionId: item.id)
          .catchError((e) {
            store.dispatch(SetPromotionFaultAction(e.toString()));
            store.dispatch(SetPromotionsLoadingAction(false));
            hasError = true;

            if (!completer!.isCompleted) completer.completeError(e);
          })
          .then((_) {
            if (!hasError) {
              store.dispatch(
                SetPromotionChangedAction(
                  item,
                  ChangeType.removed,
                  completer: completer,
                ),
              );

              store.dispatch(SetPromotionsLoadingAction(false));
              if (!completer!.isCompleted) completer.complete();
            }
          });
    });
  };
}

_initializeService(Store<AppState> store) {
  service = PromotionsService(
    store: store,
    baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
    token: store.state.authState.token,
    businessId: store.state.currentBusinessId,
  );
}

class SetPromotionsLoadingAction {
  bool value;

  SetPromotionsLoadingAction(this.value);
}

class SetPromotionsLoadedAction {
  List<Promotion>? value;

  SetPromotionsLoadedAction(this.value);
}

class SetPromotionFaultAction {
  String value;

  SetPromotionFaultAction(this.value);
}

class SetPromotionChangedAction {
  Promotion item;

  ChangeType type;

  Completer? completer;

  SetPromotionChangedAction(this.item, this.type, {this.completer});
}
