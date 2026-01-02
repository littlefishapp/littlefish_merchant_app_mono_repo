// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/stock/goods_received_voucher.dart';
import 'package:littlefish_merchant/models/stock/stock_run.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/tools/http/rest_client.dart';

class InventoryService {
  InventoryService({
    required this.baseUrl,
    required this.businessId,
    required this.token,
    required this.store,
  }) {
    client = RestClient(store: store as Store<AppState>?);
  }

  String? baseUrl;
  String? businessId;
  String? token;

  Store store;

  late RestClient client;

  Future<StockRun?> uploadSingleStockRun(StockRun run) async {
    if (run.items!.isEmpty || run.items == null) return null;
    var requestData = run.toJson();

    var response = await client.post(
      url: '$baseUrl/Inventory/UploadStockRun/businessId=$businessId',
      token: token,
      requestData: requestData,
    );

    if (response?.statusCode == 200) {
      return StockRun.fromJson(response!.data);
    } else {
      throw Exception('bad response from server, unable to upload stock run');
    }
  }

  Future<StockRun?> uploadStockRun(StockRun run) async {
    if (run.items!.isNotEmpty) {
      var requestData = run.toJson();

      var response = await client.post(
        url: '$baseUrl/Inventory/UploadStockTake/businessId=$businessId',
        token: token,
        requestData: requestData,
      );

      if (response?.statusCode == 200) {
        return StockRun.fromJson(response!.data);
      } else {
        throw Exception('bad response from server, unable to upload stock run');
      }
    } else {
      return null;
    }
  }

  Future<List<StockRun>> getStockRunList() async {
    var response = await client.get(
      url: '$baseUrl/Inventory/GetStockRunList/businessId=$businessId',
      token: token,
    );

    if (response?.statusCode == 200) {
      return (response!.data as List)
          .map((sr) => StockRun.fromJson(sr))
          .toList();
    } else {
      throw Exception('unable to get stock run list, bad server response');
    }
  }

  Future<List<GoodsRecievedVoucher>> getGRVs() async {
    var response = await client.get(
      url: '$baseUrl/Inventory/GetGRVList/businessId=$businessId',
      token: token,
    );

    if (response?.statusCode == 200) {
      return (response!.data as List)
          .map((sr) => GoodsRecievedVoucher.fromJson(sr))
          .toList();
    } else {
      throw Exception('unable to load GRVs');
    }
  }

  Future<GoodsRecievedVoucher?> uploadGRV(GoodsRecievedVoucher value) async {
    if (value.items!.isNotEmpty) {
      //logger.debug(this,jsonEncode(value.toJson()));

      var response = await client.post(
        url: '$baseUrl/Inventory/UploadGRV/businessId=$businessId',
        token: token,
        requestData: value.toJson(),
      );

      if (response?.statusCode == 200) {
        return GoodsRecievedVoucher.fromJson(response!.data);
      } else {
        throw Exception('bad response from server, unable upload GRV');
      }
    } else {
      return null;
    }
  }

  Future<GoodsRecievedVoucher?> cancelGRV(GoodsRecievedVoucher value) async {
    if (value.items!.isNotEmpty) {
      var response = await client.delete(
        url: '$baseUrl/Inventory/CancelGRV/businessId=$businessId',
        token: token,
        requestData: value.toJson(),
      );

      if (response?.statusCode == 200) {
        return GoodsRecievedVoucher.fromJson(response!.data);
      } else {
        throw Exception('bad response from server, unable to cancel GRV');
      }
    } else {
      return null;
    }
  }
}
