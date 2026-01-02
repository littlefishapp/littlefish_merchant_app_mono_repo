// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/promotions/promotion.dart';
import 'package:littlefish_merchant/redux/auth/auth_actions.dart';
import 'package:littlefish_merchant/redux/promotions/promotions_actions.dart';
import 'package:littlefish_merchant/redux/promotions/promotions_state.dart';

final promotionsReducer = combineReducers<PromotionsState>([
  TypedReducer<PromotionsState, SetPromotionsLoadingAction>(onSetLoading).call,
  TypedReducer<PromotionsState, SetPromotionsLoadedAction>(
    onSetPromotions,
  ).call,
  TypedReducer<PromotionsState, SetPromotionFaultAction>(onSetFault).call,
  TypedReducer<PromotionsState, SetPromotionChangedAction>(
    onPromotionChanged,
  ).call,
  TypedReducer<PromotionsState, SignoutAction>(onClearState).call,
]);

PromotionsState onClearState(PromotionsState state, SignoutAction action) =>
    state.rebuild((b) {
      b.isLoading = false;
      b.hasError = false;
      b.errorMessage = null;

      b.items = [];
    });

PromotionsState onSetLoading(
  PromotionsState state,
  SetPromotionsLoadingAction action,
) => state.rebuild((b) => b.isLoading = action.value);

PromotionsState onSetPromotions(
  PromotionsState state,
  SetPromotionsLoadedAction action,
) => state.rebuild((b) => b.items = action.value);

PromotionsState onSetFault(
  PromotionsState state,
  SetPromotionFaultAction action,
) => state.rebuild((b) {
  b.hasError = true;
  b.errorMessage = action.value;
});

PromotionsState onPromotionChanged(
  PromotionsState state,
  SetPromotionChangedAction action,
) {
  //logger.debug(this,'promotion changed reducer called');

  return state.rebuild((b) {
    if (action.type == ChangeType.removed) {
      b.items = _removeItem(b.items!, action.item);
    } else {
      b.items = _addOrUpdatePromotion(b.items, action.item);
    }

    if (action.completer != null && !action.completer!.isCompleted) {
      action.completer?.complete();
    }
  });
}

List<Promotion> _addOrUpdatePromotion(List<Promotion>? state, Promotion item) {
  if (state == null || state.isEmpty) return [item];

  var existingIndex = state.indexWhere(
    (i) => i.id == item.id || i.name == item.name,
  );

  if (existingIndex >= 0) {
    return state..[existingIndex] = item;
  } else {
    return state..add(item);
  }
}

List<Promotion> _removeItem(List<Promotion> state, Promotion item) {
  return state..remove(item);
}
