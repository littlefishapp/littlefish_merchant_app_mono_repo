// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:littlefish_merchant/app/app.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/tools/http/rest_client.dart';

class SystemService {
  SystemService({required this.baseUrl, required this.store}) {
    client = RestClient(store: store as Store<AppState>?);
  }

  String? baseUrl;

  Store store;
  late RestClient client;

  Future<bool> isOnline() async {
    try {
      var url = '$baseUrl/LivenessMerchant/alive';

      var response = await client.get(url: url);

      if (response?.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on Exception catch (e) {
      reportCheckedError(e, trace: StackTrace.current);

      rethrow;
    }
  }
}
