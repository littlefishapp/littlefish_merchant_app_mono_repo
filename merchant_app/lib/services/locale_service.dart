// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/services.dart';

// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';
import 'package:littlefish_core/logging/services/logger_service.dart';

// Core imports:
import 'package:littlefish_core/core/littlefish_core.dart';

// Project imports:
import 'package:littlefish_merchant/models/settings/locale/country_stub.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/tools/http/rest_client.dart';

class LocaleService {
  LocaleService({required this.store}) {
    client = RestClient(store: store as Store<AppState>?);
  }

  Store store;

  late RestClient client;

  Future<List<CountryStub>> getCountryStubs(
    String? baseUrl, {
    bool refresh = false,
  }) async {
    var response = await client.get(url: '$baseUrl/Business/GetCountryStubs');

    var result = <CountryStub>[];

    if (response?.statusCode == 200) {
      for (var c in (response!.data as List)) {
        var country = CountryStub.fromJson(c);
        result.add(country);

        if (country.countryCode!.toLowerCase() == 'za' ||
            country.countryCode!.toLowerCase() == 'tz') {
          LittleFishCore.instance.get<LoggerService>().debug(
            'services.locale_service',
            'Country data: ${country.toJson()}',
          );
        }
      }
    } else {
      throw Exception('unable to load locales');
    }

    return result;
  }

  Future<List<CountryStub>> getCountryStubsFromAsset() async {
    var assetName = 'supported_locales.json';

    var configFilePath = 'assets/locale/$assetName';

    final ByteData data = await rootBundle.load(configFilePath);
    String content = utf8.decode(data.buffer.asUint8List());

    var countries = jsonDecode(content);

    return (countries as List).map((c) => CountryStub.fromJson(c)).toList();
  }
}
