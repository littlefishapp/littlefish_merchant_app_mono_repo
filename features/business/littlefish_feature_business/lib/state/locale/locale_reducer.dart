// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/providers/locale_provider.dart';
import 'package:littlefish_merchant/redux/locale/locale_actions.dart';
import 'package:littlefish_merchant/redux/locale/locale_state.dart';

final localeReducer = combineReducers<LocaleState>([
  TypedReducer<LocaleState, LocaleLoadedAction>(onLoadedLocale).call,
  TypedReducer<LocaleState, SetLocaleAction>(onSetLocale).call,
  TypedReducer<LocaleState, SetUserLocaleAction>(onSetUserLocale).call,
]);

LocaleState onLoadedLocale(LocaleState state, LocaleLoadedAction action) {
  return state.rebuild((b) {
    b.locales = action.value;
  });
}

LocaleState onSetUserLocale(LocaleState state, SetUserLocaleAction action) {
  return state.rebuild((b) {
    if (b.locales == null || b.locales!.isEmpty) return;

    if (b.locales!.any((l) => l.countryCode == action.value)) {
      b.currentLocale = b.locales!.firstWhere(
        (l) => l.countryCode == action.value,
      );

      b.countryCode = b.currentLocale?.countryCode;
      b.countryName = b.currentLocale?.countryName;

      b.currencyCode = b.currentLocale?.currencyCode;
      b.dialingCode = b.currentLocale?.diallingCode;

      b.currentLocale?.shortCurrencyCode = b.currentLocale?.currencyCode;

      LocaleProvider.instance.currentLocale = b.currentLocale;
    }
  });
}

LocaleState onSetLocale(LocaleState state, SetLocaleAction action) {
  return state.rebuild((b) {
    var cl = action.value;
    b.currentLocale = cl;
    b.countryCode = cl?.countryCode;
    b.countryName = cl?.countryName;
    b.currencyCode = cl?.currencyCode;
    b.dialingCode = cl?.diallingCode;

    LocaleProvider.instance.currentLocale = b.currentLocale;
  });
}
