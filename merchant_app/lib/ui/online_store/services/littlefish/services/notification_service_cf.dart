// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/tools/http/rest_client.dart';

import '../../../../../features/ecommerce_shared/models/checkout/checkout_order.dart';
import '../../../../../features/ecommerce_shared/models/store/notification.dart';

class NotificationServiceCF {
  NotificationServiceCF({required this.store}) {
    client = RestClient(store: store);
    token = 'Bearer ${store.state.token}';
    baseUrl =
        '${store.state.environmentState.environmentConfig!.cloudFunctionsUrl}notificationAPI';
  }

  String? baseUrl;
  String? token;
  Store<AppState> store;
  late RestClient client;

  Future<dynamic> sendMessageToTopic(StoreNotification notification) async {
    var response = await client.post(
      url: '$baseUrl/sendMessageToTopic',
      token: token,
      requestData: notification.toJson(),
    );

    if (response?.statusCode == 200) {
      return store;
    } else {
      throw Exception(response!.data);
    }
  }

  Future<dynamic> sendOwnerNotification(StoreNotification notification) async {
    var response = await client.post(
      url: '$baseUrl/sendOwnerNotification',
      token: token,
      requestData: notification.toJson(),
    );

    if (response?.statusCode == 200) {
      return store;
    } else {
      throw Exception(response!.data);
    }
  }

  Future<dynamic> updateFollowers(bool follow, String? storeId) async {
    var response = await client.post(
      url: '$baseUrl/updateFollowers?id=$storeId&follow=$follow',
      token: token,
    );

    if (response?.statusCode == 200) {
      return response!.data;
    } else {
      throw Exception(response!.data);
    }
  }

  Future<dynamic> sendMessageToUser(StoreNotification notification) async {
    var response = await client.post(
      url: '$baseUrl/sendMessageToUser',
      token: token,
      requestData: notification.toJson(),
    );

    if (response?.statusCode == 200) {
      return store;
    } else {
      throw Exception(response!.data);
    }
  }

  Future<dynamic> emailReceipt(CheckoutOrder order) async {
    var simpleOrder = SimpleOrder.fromCheckoutOrder(order);
    // simpleOrder.customerEmail = 'omonare@nybble.africa';
    var response = await client.post(
      url: '$baseUrl/sendReceipt',
      token: token,
      requestData: simpleOrder.toJson(),
    );

    if (response?.statusCode == 200) {
      return store;
    } else {
      throw Exception(response!.data);
    }
  }

  Future<dynamic> sendSMS(String content, List<String?> numbers) async {
    // simpleOrder.customerEmail = 'omonare@nybble.africa';
    var response = await client.post(
      url: '$baseUrl/sendSMS',
      token: token,
      requestData: {'content': content, 'target': numbers},
    );

    if (response?.statusCode == 200) {
      return store;
    } else {
      throw Exception(response!.data);
    }
  }
}
