// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';
import 'package:littlefish_core/logging/services/logger_service.dart';

// Core imports:
import 'package:littlefish_core/core/littlefish_core.dart';

// Project imports:
import 'package:littlefish_merchant/models/promotions/promotion.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/tools/http/rest_client.dart';

class PromotionsService {
  PromotionsService({
    required this.baseUrl,
    required this.businessId,
    required this.token,
    required this.store,
  }) {
    client = RestClient(store: store as Store<AppState>?);
  }

  Store store;
  late RestClient client;

  String? baseUrl, businessId, token;

  Future<List<Promotion>?> getPromotions() async {
    var response = await client.get(
      url: '$baseUrl/Promotion/GetAllPromotions/businessId=$businessId',
      token: token,
    );

    if (response?.statusCode == 200) {
      return (response!.data as List?)
          ?.map((d) => Promotion.fromJson(d))
          .toList();
    } else {
      throw Exception('Bad server response, unable to load promotions');
    }
  }

  Future<void> deletePromotion({required String? promotionId}) async {
    var response = await client.delete(
      url:
          '$baseUrl/Promotion/DeletePromotion/businessId=$businessId,promotionId=$promotionId',
      token: token,
    );

    if (response?.statusCode == 200) {
      return;
    } else {
      throw Exception('Bad server response, unable remove promotion');
    }
  }

  Future<Promotion> updateOrCreatePromotion(Promotion promotion) async {
    promotion.totalCost = promotion.items!
        .map((pi) => pi.quantity! * pi.costPrice!)
        .reduce((a, b) => a + b);

    promotion.totalValue = promotion.items!
        .map((pi) => pi.quantity! * pi.promoUnitPrice!)
        .reduce((a, b) => a + b);

    LittleFishCore.instance.get<LoggerService>().debug(
      'services.promotions_service',
      'Promotion data: ${promotion.toJson()}',
    );

    var response = await client.put(
      url: '$baseUrl/Promotion/UpsertPromotion/businessId=$businessId',
      token: token,
      requestData: promotion.toJson(),
    );

    if (response?.statusCode == 200) {
      return Promotion.fromJson(response!.data);
    } else {
      throw Exception('Bad server response, unable update / create promotion');
    }
  }
}
