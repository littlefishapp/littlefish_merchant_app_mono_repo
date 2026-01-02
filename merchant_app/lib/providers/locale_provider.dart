// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:littlefish_merchant/models/settings/locale/country_stub.dart';

class LocaleProvider with ChangeNotifier {
  static final LocaleProvider instance = LocaleProvider._internal();

  LocaleProvider._internal();

  factory LocaleProvider({required String token}) {
    instance.token = token;
    return instance;
  }

  static LocaleProvider of(BuildContext context, {bool listen = true}) =>
      Provider.of<LocaleProvider>(context, listen: listen);

  String? token;

  CountryStub? _currentLocale;

  CountryStub? get currentLocale {
    return _currentLocale;
  }

  set currentLocale(CountryStub? value) {
    if (_currentLocale != value) {
      _currentLocale = value;
      notifyListeners();
    }
  }

  String? get countryCode {
    return _currentLocale?.countryCode;
  }

  String? get countryName {
    return _currentLocale?.countryName;
  }

  String? get dialingCode {
    return _currentLocale?.diallingCode;
  }

  String? get currencyCode {
    return _currentLocale?.currencyCode;
  }

  List<CountryStub>? _countries;

  List<CountryStub> get countries {
    _countries ??= [];

    return List.from(_countries!);
  }
}
