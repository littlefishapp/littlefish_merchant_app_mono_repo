// Package imports:
import 'package:quiver/strings.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';
import 'package:uuid/uuid.dart';

// Project imports:
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/tools/http/rest_client.dart';

import '../../../../../features/ecommerce_shared/models/checkout/checkout_order.dart';
import '../../../../../features/ecommerce_shared/models/checkout/order_receipt.dart';

class OrderServiceCF {
  OrderServiceCF({required this.store}) {
    client = RestClient(store: store);
    token = 'Bearer ${store.state.token}';
    baseUrl =
        '${store.state.environmentState.environmentConfig!.cloudFunctionsUrl}orderAPI';
  }

  String? baseUrl;
  String? token;
  Store<AppState> store;
  late RestClient client;

  Future<dynamic> upsertOrderStatus(OrderStatus status) async {
    status.businessId = store.state.storeState.store!.businessId;
    var response = await client.post(
      url: '$baseUrl/upsertOrderStatus',
      token: token,
      requestData: status.toJson(),
    );

    if (response?.statusCode == 200) {
      return store;
    } else {
      throw Exception(response!.data);
    }
  }

  Future<dynamic> upsertOrder(CheckoutOrder order) async {
    var response = await client.post(
      url: '$baseUrl/upsertOrder',
      token: token,
      requestData: order.toJson(),
    );

    if (response?.statusCode == 200) {
      return store;
    } else {
      throw Exception(response!.data);
    }
  }

  Future<dynamic> upsertReceipt(OrderReceipt storeProduct) async {
    var response = await client.post(
      url: '$baseUrl/upsertReceipt',
      token: token,
      requestData: storeProduct.toJson(),
    );

    if (response?.statusCode == 200) {
      return true;
    } else {
      throw Exception(response!.data);
    }
  }

  Future<String?> sendEmailReceipt(
    CheckoutOrder order, {
    newOrder = true,
  }) async {
    var simpleOrder = SimpleOrder.fromCheckoutOrder(order);
    if (isBlank(simpleOrder.customerEmail)) {
      simpleOrder.customerEmail = 'omonare@nybble.africa';
    }
    var json = simpleOrder.toJson();
    var response = await client.post(
      url:
          'https://dev.merchantapi.littlefish.africa/api/Notification/SendReceipt',
      token: token,
      requestData: json,
    );

    if (response?.statusCode == 200) {
      if (newOrder) {
        var receipt = OrderReceipt(
          id: const Uuid().v4(),
          customerEmail: simpleOrder.customerEmail,
          customerName: simpleOrder.customerName,
          items: order.items,
          orderId: order.orderId,
          orderValue: order.orderValue,
          quantity: order.orderItemCount.toInt(),
          receiptPDF: response!.data,
          storeId: order.storeId,
          userId: order.customerId,
        );

        upsertReceipt(receipt);
      }
      return response!.data;
    } else {
      throw Exception(response!.data);
    }
  }

  Future<dynamic> deleteOrderStatus(String? id, String? businessId) async {
    var response = await client.delete(
      url: '$baseUrl/deleteOrderStatus?businessId=$businessId&id=$id',
      token: token,
    );

    if (response?.statusCode == 200) {
      return id;
    } else {
      throw Exception(response!.data);
    }
  }
}
