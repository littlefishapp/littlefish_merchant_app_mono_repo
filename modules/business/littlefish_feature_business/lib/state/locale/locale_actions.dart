// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

// Project imports:
import 'package:littlefish_merchant/models/settings/locale/country_stub.dart';
import 'package:littlefish_merchant/models/shared/country.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/services/locale_service.dart';

late LocaleService localeService;

ThunkAction<AppState> initializeLocale() {
  return (Store<AppState> store) async {
    Future(() async {
      localeService = LocaleService(store: store);

      var s = store.state.localeState;

      if (s.locales == null || s.locales!.isEmpty) {
        var supportedLocales = countryList
            .map((e) => CountryHelper.fromCountry(e))
            .toList();
        // localeService
        //     .getCountryStubs(
        //         store.state.environmentState.environmentConfig!.baseUrl)
        //     .then((result) {
        // });
        store.dispatch(LocaleLoadedAction(supportedLocales));
      }
    });
  };
}

class SetUserLocaleAction {
  String? value;

  SetUserLocaleAction(this.value);
}

class LocaleSetLoading {
  bool value;

  LocaleSetLoading(this.value);
}

class LocaleLoadedAction {
  List<CountryStub> value;

  LocaleLoadedAction(this.value);
}

class SetLocaleAction {
  CountryStub? value;

  SetLocaleAction(this.value);
}
