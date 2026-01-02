// Flutter imports:
import 'dart:io';

import 'package:littlefish_merchant/models/reports/paged_product_sales_summary_view.dart';
import 'package:path_provider/path_provider.dart';

// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';
import 'package:uuid/uuid.dart';

// Project imports:
import 'package:littlefish_merchant/models/analysis/analysis_overviews.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/reports/business_financials_view.dart';
import 'package:littlefish_merchant/models/reports/business_summary.dart';
import 'package:littlefish_merchant/models/reports/customer_overview.dart';
import 'package:littlefish_merchant/models/reports/customer_report.dart';
import 'package:littlefish_merchant/models/reports/inventory_overview.dart';
import 'package:littlefish_merchant/models/reports/number_filter.dart';
import 'package:littlefish_merchant/models/reports/paged_checkout_transaction_view.dart';
import 'package:littlefish_merchant/models/reports/paged_products.dart';
import 'package:littlefish_merchant/models/reports/product_report.dart';
import 'package:littlefish_merchant/models/reports/sales_report.dart';
import 'package:littlefish_merchant/models/reports/store_credit_overview.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/tools/http/rest_client.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';

class AnalysisService {
  AnalysisService({
    required this.baseUrl,
    required this.token,
    required this.businessId,
    required this.store,
  }) {
    client = RestClient(store: store as Store<AppState>?);
  }

  AnalysisService.fromStore(Store<AppState> this.store) {
    baseUrl = store?.state.reportsUrl;
    // this.baseUrl = "http://10.0.2.2:5001/reports/api";
    businessId = store?.state.businessId;
    token = store?.state.token;

    client = RestClient(store: store as Store<AppState>?);
  }

  Store? store;
  String? baseUrl;
  String? businessId;
  String? token;

  late RestClient client;

  Future<BusinessOverviewCount> getBusinessCountOverview({
    DateGroupType mode = DateGroupType.daily,
  }) async {
    var url =
        '$baseUrl/Analysis/BusinessOverviewCounts/businessId=$businessId,dateType=${mode.index}';

    var response = await client.get(url: url, token: token);

    if (response?.statusCode == 200) {
      return BusinessOverviewCount.fromJson(response!.data);
    } else {
      throw Exception(
        'Unable to get business overview counts, bad server response',
      );
    }
  }

  Future<CustomerTopTen> getCustomersOverview() async {
    var response = await client.get(
      url: '$baseUrl/Analysis/GetCustomerTopTen/businessId=$businessId',
      token: token,
    );

    if (response?.statusCode == 200) {
      return CustomerTopTen.fromJson(response!.data);
    } else {
      throw Exception(
        'Unable to get business overview counts, bad server response',
      );
    }
  }

  Future<ProductTopTen> getTopProducts({int count = 5}) async {
    var response = await client.get(
      url:
          '$baseUrl/Analysis/GetTopProducts/businessId=$businessId,count=$count',
      token: token,
    );

    if (response?.statusCode == 200) {
      return ProductTopTen.fromJson(response!.data);
    } else {
      throw Exception('Unable to get top products, bad server response');
    }
  }

  Future<BusinessOverviewCount> getBusinessOverview({int count = 5}) async {
    var response = await client.get(
      url:
          '$baseUrl/Analysis/BusinessOverviewCounts/businessId=$businessId,dateType=${DateGroupType.daily.index}',
      token: token,
    );

    if (response?.statusCode == 200) {
      return BusinessOverviewCount.fromJson(response!.data);
    } else {
      throw Exception('Unable to get business overview, bad server response');
    }
  }

  Future<List<CustomerStatistic>?> getTopTenCustomers() async {
    var response = await client.get(
      url: '$baseUrl/Analysis/GetTopTenCustomers/businessId=$businessId',
      token: token,
    );

    if (response?.statusCode == 200) {
      if (response!.data != null) {
        return (response.data as List)
            .map((c) => CustomerStatistic.fromJson(c))
            .toList();
      } else {
        return response.data;
      }
    } else {
      throw Exception(
        'Unable to get business overview counts, bad server response',
      );
    }
  }
}

class ReportService {
  ReportService({
    required this.baseUrl,
    required this.token,
    required this.businessId,
    required this.store,
  }) {
    client = RestClient(store: store as Store<AppState>?);
  }

  ReportService.fromStore(Store<AppState> this.store) {
    baseUrl = store?.state.reportsUrl;
    // this.baseUrl = "http://10.0.2.2:5001/reports/api";
    businessId = store?.state.businessId;
    token = store?.state.token;

    client = RestClient(store: store as Store<AppState>?);
  }

  Store? store;
  String? baseUrl;
  String? businessId;
  String? token;

  late RestClient client;

  Future<String> getTemporaryFilePath(String fileName) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File file = File('$tempPath/$fileName');
    return file.path;
  }

  Future<SalesReport?> getSalesReportByGroup(DateGroupType groupType) async {
    var response = await client.get(
      url:
          '$baseUrl/Report/GetSalesReport/businessId=$businessId,dateGroup=${groupType.index}',
      token: token,
    );

    if (response?.statusCode == 200) {
      if (response!.data == null) return null;
      var result = SalesReport.fromJson(response.data);

      return result;
    } else {
      throw Exception('Failed to get sales report');
    }
  }

  Future<BusinessSummary?> getBusinessSummary() async {
    var response = await client.get(
      url: '$baseUrl/Report/GetBusinessSummary/businessId=$businessId',
      token: token,
    );

    if (response?.statusCode == 200) {
      if (response!.data == null) return null;

      return BusinessSummary.fromJson(response.data);
    } else {
      throw Exception('Failed to get business summary');
    }
  }

  Future<BusinessFinancialsView?> getBusinessFinancialStatement({
    startDate,
    endDate,
  }) async {
    var response = await client.get(
      url:
          '$baseUrl/Report/GetBusinessFinancials/businessId=$businessId,startDate=$startDate,endDate=$endDate',
      token: token,
    );

    if (response?.statusCode == 200) {
      if (response!.data == null) {
        return null;
      } else {
        return BusinessFinancialsView.fromJson(response.data);
      }
    } else {
      throw Exception('Failed to get financial statement');
    }
  }

  Future<CustomerOverview?> getCustomerStatement({
    String? customerId,
    DateTime? startDate,
    DateTime? endDate,
    List<String?>? sellers,
    int? offset,
    int? limit,
  }) async {
    var response = await client.put(
      url:
          '$baseUrl/Report/GetCustomerStatement/businessId=$businessId,customerId=$customerId',
      token: token,
      requestData: {
        'startDate': TextFormatter.toShortDate(dateTime: startDate),
        'endDate': TextFormatter.toShortDate(dateTime: endDate),
        'limit': limit,
        'offset': offset,
        'sellers': sellers,
      },
    );

    if (response?.statusCode == 200) {
      if (response!.data == null) {
        return null;
      } else {
        return CustomerOverview.fromJson(response.data);
      }
    } else {
      throw Exception('Failed to get customer statement');
    }
  }

  Future<List<InventoryOverview>?> getInventoryOverview() async {
    var response = await client.put(
      url: '$baseUrl/Report/GetInventoryOverview/businessId=$businessId',
      token: token,
      requestData: {},
    );
    if (response?.statusCode == 200) {
      if (response!.data == null) {
        return null;
      } else {
        return (response.data as List)
            .map((e) => InventoryOverview.fromJson(e))
            .toList();
      }
    } else {
      throw Exception('Failed to get customer statement');
    }
  }

  Future<StoreCreditOverview?> getStoreCreditOverview() async {
    var response = await client.put(
      url: '$baseUrl/Report/GetStoreCreditOverview/businessId=$businessId',
      token: token,
      requestData: {},
    );
    if (response?.statusCode == 200) {
      if (response!.data == null) {
        return null;
      } else {
        return StoreCreditOverview.fromJson(response.data);
      }
    } else {
      throw Exception('Failed to get customer statement');
    }
  }

  Future<String> downloadSalesReport(
    DateGroupType groupType, {
    bool isPdf = true,
  }) async {
    String url =
        "$baseUrl/Download/GetTransactions${isPdf ? "PDF" : "Excel"}/businessId=$businessId,dateGroup=${groupType.index}";

    var filename =
        "Sales Report - ${TextFormatter.toShortDate(dateTime: DateTime.now().toUtc(), format: "ddyyyyMM")}_${const Uuid().v4()}.${isPdf ? "pdf" : "xlsx"}";
    String savePath = await getTemporaryFilePath(filename);
    var response = await client.getFileStream(
      url: url,
      token: token,
      savePath: savePath,
    );

    if (response != null && response.statusCode == 200) {
      return savePath;
    } else {
      //logger.debug('services.analysis.report', 'Unable to get sales report');
      throw Exception('Unable to download sales report at this time');
    }
  }

  Future<String> downloadSalesReportDateRange(
    DateTime startDate,
    DateTime endDate, {
    isPDF = true,
  }) async {
    String url =
        '$baseUrl/Download/GetTransactions${isPDF ? 'PDF' : 'Excel'}/businessId=$businessId,startDate=${TextFormatter.toShortDate(dateTime: startDate)},endDate=${TextFormatter.toShortDate(dateTime: endDate)}';

    String fileName =
        'Sales Report - ${TextFormatter.toShortDate(dateTime: startDate, format: 'ddyyyyMM')}_${TextFormatter.toShortDate(dateTime: endDate, format: 'ddddyyMM')}_${const Uuid().v4()}.${isPDF ? 'pdf' : 'xlsx'}';

    String savePath = await getTemporaryFilePath(fileName);
    var response = await client.getFileStream(
      url: url,
      savePath: savePath,
      token: token,
    );

    if (response != null && response.statusCode == 200) {
      return savePath;
    } else {
      throw Exception('Cannot download sales report, please try again later');
    }
  }

  Future<String> downloadProductsList({bool isPDF = true}) async {
    String url =
        '$baseUrl/Download/GetProducts${isPDF ? 'PDF' : 'Excel'}/businessId=$businessId,dateGroup=${DateGroupType.all.index}';

    String filename =
        'Product List - ${TextFormatter.toShortDate(dateTime: DateTime.now().toUtc(), format: 'ddyyyyMM')}_${const Uuid().v4()}.${isPDF ? 'pdf' : 'xlsx'}';

    String savePath = await getTemporaryFilePath(filename);
    var response = await client.getFileStream(
      url: url,
      token: token,
      savePath: savePath,
    );
    if (response != null && response.statusCode == 200) {
      return savePath;
    } else {
      throw Exception('Unable to download product report');
    }
  }

  Future<SalesReport?> getSalesReportByRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    var response = await client.put(
      url: '$baseUrl/Report/GetSalesReportByRange/businessId=$businessId',
      token: token,
      requestData: {
        'startDate': TextFormatter.toShortDate(dateTime: startDate),
        'endDate': TextFormatter.toShortDate(dateTime: endDate),
      },
    );

    if (response?.statusCode == 200) {
      if (response!.data == null) {
        return null;
      } else {
        return SalesReport.fromJson(response.data);
      }
    } else {
      throw Exception('Failed to get sales report');
    }
  }

  Future<List<AnalysisPair>?> getProductSummary({
    List<String?>? products,
    List<String?>? categories,
    NumberFilter? marginFilter,
  }) async {
    var response = await client.put(
      url: '$baseUrl/Report/GetProductSummaryFiltered/businessId=$businessId',
      token: token,
      requestData: {
        'categories': categories,
        'products': products,
        'marginFilter': marginFilter,
      },
    );

    if (response?.statusCode == 200) {
      if (response!.data == null) {
        return null;
      } else {
        return (response.data as List)
            .map((f) => AnalysisPair.fromJson(f))
            .toList();
      }
    } else {
      throw Exception('Failed to get product summary');
    }
  }

  Future<PagedProducts?> getProductListFiltered({
    required int limit,
    required int offset,
    List<String?>? products,
    List<String?>? categories,
    NumberFilter? marginFilter,
  }) async {
    var response = await client.put(
      url: '$baseUrl/Report/GetProductListFiltered/businessId=$businessId',
      token: token,
      requestData: {
        'categories': categories,
        'products': products,
        'limit': limit,
        'offset': offset,
        'marginFilter': marginFilter,
      },
    );

    if (response?.statusCode == 200) {
      if (response!.data == null) {
        return null;
      } else {
        return PagedProducts.fromJson(response.data);
      }
    } else {
      throw Exception('Failed to get product list');
    }
  }

  Future<SalesReport?> getSalesByProductReportFiltered({
    DateTime? startDate,
    DateTime? endDate,
    products,
    categories,
    customers,
    sellers,
  }) async {
    var response = await client.put(
      url: '$baseUrl/Report/GetSalesReportFiltered/businessId=$businessId',
      token: token,
      requestData: {
        'startDate': TextFormatter.toShortDate(dateTime: startDate),
        'endDate': TextFormatter.toShortDate(dateTime: endDate),
        'products': products,
        'customers': customers,
        'categories': categories,
        'sellers': sellers,
      },
    );

    if (response?.statusCode == 200) {
      if (response!.data == null) {
        return null;
      } else {
        return SalesReport.fromJson(response.data);
      }
    } else {
      throw Exception('Failed to get sales report');
    }
  }

  Future<PagedProductSalesSummaryView?> getProductSalesSummaryFiltered({
    DateTime? startDate,
    DateTime? endDate,
    products,
    categories,
    customers,
    sellers,
  }) async {
    var response = await client.put(
      url: '$baseUrl/Report/GetProductSalesSummary/businessId=$businessId',
      token: token,
      requestData: {
        'startDate': TextFormatter.toShortDate(dateTime: startDate),
        'endDate': TextFormatter.toShortDate(dateTime: endDate),
        'products': products,
        'customers': customers,
        'categories': categories,
        'sellers': sellers,
      },
    );

    if (response?.statusCode == 200) {
      if (response!.data == null) {
        return null;
      } else {
        return PagedProductSalesSummaryView.fromJson(response.data);
      }
    } else {
      throw Exception('Failed to get sales report');
    }
  }

  Future<PagedCheckoutTransactionView?> getProductReportFiltered({
    required int limit,
    required int offset,
    DateTime? startDate,
    DateTime? endDate,
    products,
    categories,
    customers,
    sellers,
  }) async {
    var response = await client.put(
      url: '$baseUrl/Report/GetProductReportFiltered/businessId=$businessId',
      token: token,
      requestData: {
        'startDate': TextFormatter.toShortDate(dateTime: startDate),
        'endDate': TextFormatter.toShortDate(dateTime: endDate),
        'products': products,
        'customers': customers,
        'categories': categories,
        'sellers': sellers,
        'offset': offset,
        'limit': limit,
      },
    );

    if (response?.statusCode == 200) {
      if (response!.data == null) {
        return null;
      } else {
        return PagedCheckoutTransactionView.fromJson(response.data);
      }
    } else {
      throw Exception('Failed to get sales report');
    }
  }

  Future<CustomerReport?> getCustomerReportByGroup(
    DateGroupType groupType,
  ) async {
    var response = await client.get(
      url:
          '$baseUrl/Report/GetCustomerReport/businessId=$businessId,dateGroup=${groupType.index}',
      token: token,
    );

    if (response?.statusCode == 200) {
      if (response!.data == null) return null;
      // //logger.debug('services.analysis.customer', 'Response data: ${response.data}');
      var result = CustomerReport.fromJson(response.data);

      return result;
    } else {
      throw Exception('Failed to get customer report');
    }
  }

  Future<ProductReport?> getProductReportByGroup(
    DateGroupType groupType,
  ) async {
    var response = await client.get(
      url:
          '$baseUrl/Report/GetProductReport/businessId=$businessId,dateGroup=${groupType.index}',
      token: token,
    );

    if (response?.statusCode == 200) {
      if (response!.data == null) return null;
      // //logger.debug('services.analysis.product', 'Response data: ${response.data}');
      var result = ProductReport.fromJson(response.data);

      return result;
    } else {
      throw Exception('Failed to get customer report');
    }
  }

  Future<ProductReport?> getProductReportByGroupRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    //ToDo: Throw managed exception
    var response = await client.put(
      url: '$baseUrl/Report/GetProductReportByRange/businessId=$businessId',
      token: token,
      requestData: {
        'startDate': TextFormatter.toShortDate(dateTime: startDate),
        'endDate': TextFormatter.toShortDate(dateTime: endDate),
      },
    );

    if (response?.statusCode == 200) {
      if (response!.data == null) return null;
      // //logger.debug(this,response.data);
      var result = ProductReport.fromJson(response.data);

      return result;
    } else {
      throw Exception('Failed to get customer report');
    }
  }
}
