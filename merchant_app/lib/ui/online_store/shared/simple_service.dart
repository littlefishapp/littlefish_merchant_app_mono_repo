// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/tools/http/rest_client.dart';
import 'package:littlefish_merchant/ui/online_store/services/littlefish/littlefish_firestore.dart';

abstract class SimpleService {
  SimpleService.fromStore(
    Store<AppState>? storeValue, {
    bool enableMonitoring = true,
  }) {
    store = storeValue;
    client = RestClient(store: storeValue, monitor: enableMonitoring);
  }

  //load the store from the current context
  SimpleService.fromContext(
    BuildContext context, {
    bool enableMonitoring = true,
  }) {
    store = StoreProvider.of<AppState>(context);
    client = RestClient(store: store, monitor: enableMonitoring);
  }

  Store<AppState>? store;

  RestClient? client;

  String? baseUrl;

  FirestoreService? firestoreService;
}
