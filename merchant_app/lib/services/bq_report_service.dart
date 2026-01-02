// Dart imports:

// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/analysis/analysis_overviews.dart';
import 'package:littlefish_merchant/models/reports/bq_bus_details_request.dart';
import 'package:littlefish_merchant/models/reports/bq_comparison_overview_report.dart';
import 'package:littlefish_merchant/models/reports/bq_customer_sales_comparison_report.dart';
import 'package:littlefish_merchant/models/reports/bq_payments_comparison_report.dart';
import 'package:littlefish_merchant/models/reports/bq_products_comparison_report.dart';
import 'package:littlefish_merchant/models/reports/bq_profits_comparison_report.dart';
import 'package:littlefish_merchant/models/reports/bq_report.dart';
import 'package:littlefish_merchant/models/reports/bq_report_date_range.dart';
import 'package:littlefish_merchant/models/reports/bq_revenue_comparison_report.dart';
import 'package:littlefish_merchant/models/reports/bq_staff_sales_comparison_report.dart';
import 'package:littlefish_merchant/models/reports/bq_tax_comparison_report.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/tools/file_manager.dart';
import 'package:littlefish_merchant/tools/http/rest_client.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';

class BqReportService {
  BqReportService({
    required this.baseUrl,
    required this.token,
    required this.businessId,
    required this.store,
    this.reportDownloadBaseUrl,
  }) {
    client = RestClient(store: store as Store<AppState>?);
  }

  BqReportService.fromStore(Store<AppState> storeValue) {
    store = storeValue;

    //this.baseUrl = store.state.reportsUrl;
    //will replace with url from store when deploying to PROD
    baseUrl =
        '${storeValue.state.environmentState.environmentConfig!.cloudFunctionsUrl!}bqReportingAPI';
    //"http://10.0.2.2:6001/littlefish-merchant-dev/europe-west1/apiGroup-bqReportingAPI";
    businessId = storeValue.state.businessId;
    token = storeValue.state.token;
    reportDownloadBaseUrl = storeValue
        .state
        .environmentState
        .environmentConfig!
        .bqDownloadReportsUrl!;

    client = RestClient(store: store as Store<AppState>?);
  }

  Store? store;
  String? baseUrl;
  String? businessId;
  String? token;
  String? reportDownloadBaseUrl;

  late RestClient client;

  Future<List<BqReport>?> getCustomerSales({
    required String businessId,
    required DateTime startDate,
    required DateTime endDate,
    String? orderBy,
  }) async {
    var response = await client.post(
      url: '$baseUrl/GetBusCustomerSales',
      token: token,
      requestData: {
        'startDate': startDate.toUtc().toString(),
        'endDate': endDate.toUtc().toString(),
        'businessId': businessId,
      },
    );

    if (response?.statusCode == 200) {
      if (response!.data == null) {
        return null;
      } else {
        return (response.data as List)
            .map((e) => BqReport.fromJson(e))
            .toList();
      }
    } else {
      throw Exception('Failed to get Customer Sales Report');
    }
  }

  Future<List<AnalysisPair>?> getPaymentTypePercents({
    required String businessId,
    required DateTime startDate,
    required DateTime endDate,
    String? orderBy,
  }) async {
    var response = await client.post(
      url: '$baseUrl/GetPaymentTypePercents',
      token: token,
      requestData: {
        'startDate': startDate.toUtc().toString(),
        'endDate': endDate.toUtc().toString(),
        'businessId': businessId,
      },
    );

    if (response?.statusCode == 200) {
      if (response!.data == null) {
        return null;
      } else {
        List<AnalysisPair> analysisReport = (response.data as List).map((e) {
          var item = BqReport.fromJson(e);
          AnalysisPair pair = AnalysisPair(
            id: item.paymentType,
            value: item.percentage,
            max: 100,
            min: 0,
          );

          return pair;
        }).toList();

        return analysisReport;
      }
    } else {
      throw Exception('Failed to get Payment Percents Report');
    }
  }

  Future<List<BqReport>?> getRevenueReportByFilter({
    required String businessId,
    required DateTime startDate,
    required DateTime endDate,
    required String filter,
    String? orderBy,
  }) async {
    var response = await client.post(
      url: '$baseUrl/GetBusSalesRevByFilter',
      token: token,
      requestData: {
        'startDate': startDate.toUtc().toString(),
        'endDate': endDate.toUtc().toString(),
        'businessId': businessId,
        'filter': filter,
      },
    );

    if (response?.statusCode == 200) {
      if (response!.data == null) {
        return null;
      } else {
        List<BqReport> report = (response.data as List)
            .map((e) => BqReport.fromJson(e))
            .toList();

        return report;
      }
    } else {
      throw Exception('Failed to get Sales Revenue Report Data');
    }
  }

  Future<List<RevenueComparisonReport>?> getRevenueReportByFilterCompare({
    required String? businessId,
    required List<BqReportDateRange>? series,
    required String? filter,
    String? orderBy,
    bool isOnline = false,
  }) async {
    var response = await client.post(
      url: !isOnline
          ? '$baseUrl/GetBusSalesRevByFilter/Compare'
          : '$baseUrl/GetBusOnlineSalesRevByFilter/Compare',
      token: token,
      requestData: {
        'series': series,
        'businessId': businessId,
        'filter': filter,
      },
    );

    if (response?.statusCode == 200) {
      if (response!.data == null) {
        return null;
      } else {
        List<RevenueComparisonReport> report = (response.data as List)
            .map((e) => RevenueComparisonReport.fromJson(e))
            .toList();

        return report;
      }
    } else {
      throw Exception('Failed to get Sales Revenue Compare Report Data');
    }
  }

  Future<List<RevenueComparisonReport>?> getOnlineRevenueReportByFilterCompare({
    required String? businessId,
    required List<BqReportDateRange>? series,
    required String? filter,
    String? orderBy,
  }) async {
    var response = await client.post(
      url: '$baseUrl/GetBusOnlineSalesRevByFilter/Compare',
      token: token,
      requestData: {
        'series': series,
        'businessId': businessId,
        'filter': filter,
      },
    );

    if (response?.statusCode == 200) {
      if (response!.data == null) {
        return null;
      } else {
        List<RevenueComparisonReport> report = (response.data as List)
            .map((e) => RevenueComparisonReport.fromJson(e))
            .toList();

        return report;
      }
    } else {
      throw Exception('Failed to get Online Sales Revenue Compare Report Data');
    }
  }

  Future<List<PaymentsComparisonReport>?> getPaymentsReportByFilterCompare({
    required String? businessId,
    required List<BqReportDateRange>? series,
    String? orderBy,
  }) async {
    var response = await client.post(
      url: '$baseUrl/GetPaymentTypeDetails/Compare',
      token: token,
      requestData: {'series': series, 'businessId': businessId},
    );

    if (response?.statusCode == 200) {
      if (response!.data == null) {
        return null;
      } else {
        List<PaymentsComparisonReport> report = (response.data as List)
            .map((e) => PaymentsComparisonReport.fromJson(e))
            .toList();

        return report;
      }
    } else {
      throw Exception('Failed to get Payment Type Compare Report Data');
    }
  }

  Future<List<ProductsComparisonReport>?> getProductsReportCompare({
    required String? businessId,
    required List<BqReportDateRange>? series,
    String? orderBy,
  }) async {
    var response = await client.post(
      url: '$baseUrl/GetProductSalesDetails/Compare',
      token: token,
      requestData: {'series': series, 'businessId': businessId},
    );

    if (response?.statusCode == 200) {
      if (response!.data == null) {
        return null;
      } else {
        List<ProductsComparisonReport> report = (response.data as List)
            .map((e) => ProductsComparisonReport.fromJson(e))
            .toList();

        return report;
      }
    } else {
      throw Exception('Failed to get Products Compare Report Data');
    }
  }

  Future<List<CustomerSalesComparisonReport>?> getCustomerSalesReportCompare({
    required String? businessId,
    required List<BqReportDateRange>? series,
    String? orderBy,
  }) async {
    var response = await client.post(
      url: '$baseUrl/GetBusCustomerSales/Compare',
      token: token,
      requestData: {'series': series, 'businessId': businessId},
    );

    if (response?.statusCode == 200) {
      if (response!.data == null) {
        return null;
      } else {
        List<CustomerSalesComparisonReport> report = (response.data as List)
            .map((e) => CustomerSalesComparisonReport.fromJson(e))
            .toList();

        return report;
      }
    } else {
      throw Exception('Failed to get Customer Sales Compare Report Data');
    }
  }

  Future<List<StaffSalesComparisonReport>?> getStaffSalesReportCompare({
    required String? businessId,
    required List<BqReportDateRange>? series,
    String? orderBy,
  }) async {
    var response = await client.post(
      url: '$baseUrl/GetBusSalesByStaff/Compare',
      token: token,
      requestData: {'series': series, 'businessId': businessId},
    );

    if (response?.statusCode == 200) {
      if (response!.data == null) {
        return null;
      } else {
        List<StaffSalesComparisonReport> report = (response.data as List)
            .map((e) => StaffSalesComparisonReport.fromJson(e))
            .toList();

        return report;
      }
    } else {
      throw Exception('Failed to get Staff Compare Report Data');
    }
  }

  Future<List<TaxComparisonReport>?> getTaxReportByFilterCompare({
    required String? businessId,
    required List<BqReportDateRange>? series,
    required String? filter,
    String? orderBy,
  }) async {
    var response = await client.post(
      url: '$baseUrl/GetBusSalesTaxFilter/Compare',
      token: token,
      requestData: {
        'series': series,
        'businessId': businessId,
        'filter': filter,
      },
    );

    if (response?.statusCode == 200) {
      if (response!.data == null) {
        return null;
      } else {
        List<TaxComparisonReport> report = (response.data as List)
            .map((e) => TaxComparisonReport.fromJson(e))
            .toList();

        return report;
      }
    } else {
      throw Exception('Failed to get Sales Taxes Compare Report Data');
    }
  }

  Future<List<ProfitsComparisonReport>?> getProfitsReportByFilterCompare({
    required String? businessId,
    required List<BqReportDateRange>? series,
    required String? filter,
    String? orderBy,
  }) async {
    var response = await client.post(
      url: '$baseUrl/GetBusProfitsByFilter/Compare',
      token: token,
      requestData: {
        'series': series,
        'businessId': businessId,
        'filter': filter,
      },
    );

    if (response?.statusCode == 200) {
      if (response!.data == null) {
        return null;
      } else {
        List<ProfitsComparisonReport> report = (response.data as List)
            .map((e) => ProfitsComparisonReport.fromJson(e))
            .toList();

        return report;
      }
    } else {
      throw Exception('Failed to get Sales Profits Compare Report Data');
    }
  }

  Future<List<OverviewComparisonReport>?> getSalesOverviewReportCompare({
    required String? businessId,
    required List<BqReportDateRange>? series,
    String? orderBy,
  }) async {
    var response = await client.post(
      url: '$baseUrl/GetBusAllSalesTotals/Compare',
      token: token,
      requestData: {'series': series, 'businessId': businessId},
    );

    if (response?.statusCode == 200) {
      if (response!.data == null) {
        return null;
      } else {
        List<OverviewComparisonReport> report = (response.data as List)
            .map((e) => OverviewComparisonReport.fromJson(e))
            .toList();

        return report;
      }
    } else {
      throw Exception('Failed to get Sales Overview sCompare Report Data');
    }
  }

  Future<String> downloadPaymentTypeReport(
    String fileType,
    List<PaymentsComparisonReport> reportData,
    BqBusDetailsRequest? busDetailsReq,
  ) async {
    String url = '$reportDownloadBaseUrl/PaymentType2/type=$fileType';

    var filename =
        "Payment Type Report - ${TextFormatter.toShortDate(dateTime: DateTime.now().toUtc(), format: "ddyyyyMM")}.${getReportFileExtension(fileType)}";
    var savePath = await FileManager().getDownloadFilePath(filename);

    var response = await client.getFileStream(
      url: url,
      token: token,
      savePath: savePath,
      timeout: 60000000,
      data: {'busDetails': busDetailsReq!.toJson(), 'objectList': reportData},
      method: 'POST',
    );

    if (response != null && response.statusCode == 200) {
      return savePath;
    } else {
      throw Exception('Unable to download Payments Report at this time');
    }
  }

  Future<String> downloadProductsReport(
    String fileType,
    List<ProductsComparisonReport> reportData,
    BqBusDetailsRequest? busDetailsReq,
  ) async {
    String url = '$reportDownloadBaseUrl/Products2/type=$fileType';

    var filename =
        "Products Report - ${TextFormatter.toShortDate(dateTime: DateTime.now().toUtc(), format: "ddyyyyMM")}.${getReportFileExtension(fileType)}";
    var savePath = await FileManager().getDownloadFilePath(filename);

    var response = await client.getFileStream(
      url: url,
      token: token,
      savePath: savePath,
      timeout: 60000000,
      data: {'busDetails': busDetailsReq, 'objectList': reportData},
      method: 'POST',
    );

    if (response != null && response.statusCode == 200) {
      return savePath;
    } else {
      throw Exception('Unable to download Products Report at this time');
    }
  }

  Future<String> downloadCustomerSalesReport(
    String fileType,
    List<CustomerSalesComparisonReport> reportData,
    BqBusDetailsRequest? busDetailsReq,
  ) async {
    String url = '$reportDownloadBaseUrl/CustomerSales2/type=$fileType';

    var filename =
        "Customer Sales Report - ${TextFormatter.toShortDate(dateTime: DateTime.now().toUtc(), format: "ddyyyyMM")}.${getReportFileExtension(fileType)}";
    var savePath = await FileManager().getDownloadFilePath(filename);

    var response = await client.getFileStream(
      url: url,
      token: token,
      savePath: savePath,
      timeout: 60000000,
      data: {'busDetails': busDetailsReq, 'objectList': reportData},
      method: 'POST',
    );

    if (response != null && response.statusCode == 200) {
      return savePath;
    } else {
      throw Exception('Unable to download Products Report at this time');
    }
  }

  Future<String> downloadStaffSalesReport(
    String fileType,
    List<StaffSalesComparisonReport> reportData,
    BqBusDetailsRequest? busDetailsReq,
  ) async {
    String url = '$reportDownloadBaseUrl/StaffSales2/type=$fileType';

    var filename =
        "Customer Sales Report - ${TextFormatter.toShortDate(dateTime: DateTime.now().toUtc(), format: "ddyyyyMM")}.${getReportFileExtension(fileType)}";
    var savePath = await FileManager().getDownloadFilePath(filename);
    var response = await client.getFileStream(
      url: url,
      token: token,
      savePath: savePath,
      timeout: 60000000,
      data: {'busDetails': busDetailsReq, 'objectList': reportData},
      method: 'POST',
    );

    if (response != null && response.statusCode == 200) {
      return savePath;
    } else {
      throw Exception('Unable to download Products Report at this time');
    }
  }

  Future<String> downloadRevenueReport(
    String fileType,
    Map<String, List<dynamic>> reportData,
    BqBusDetailsRequest? busDetailsReq,
  ) async {
    String url = '$reportDownloadBaseUrl/Revenue2/type=$fileType';

    var filename =
        "Revenue Report - ${TextFormatter.toShortDate(dateTime: DateTime.now().toUtc(), format: "ddyyyyMM")}.${getReportFileExtension(fileType)}";
    var savePath = await FileManager().getDownloadFilePath(filename);

    var response = await client.getFileStream(
      url: url,
      token: token,
      savePath: savePath,
      timeout: 60000000,
      data: {'busDetails': busDetailsReq, 'objectList': reportData},
      method: 'POST',
    );

    if (response != null && response.statusCode == 200) {
      return savePath;
    } else {
      throw Exception('Unable to download Revenue Report at this time');
    }
  }

  Future<String> downloadProfitsReport(
    String fileType,
    Map<String, List<dynamic>> reportData,
    BqBusDetailsRequest? busDetailsReq,
  ) async {
    String url = '$reportDownloadBaseUrl/Profits2/type=$fileType';

    var filename =
        "Profits Report - ${TextFormatter.toShortDate(dateTime: DateTime.now().toUtc(), format: "ddyyyyMM")}.${getReportFileExtension(fileType)}";
    var savePath = await FileManager().getDownloadFilePath(filename);

    var response = await client.getFileStream(
      url: url,
      token: token,
      savePath: savePath,
      timeout: 60000000,
      data: {'busDetails': busDetailsReq, 'objectList': reportData},
      method: 'POST',
    );

    if (response != null && response.statusCode == 200) {
      return savePath;
    } else {
      throw Exception('Unable to download Profits Report at this time');
    }
  }

  Future<String> downloadTaxReport(
    String fileType,
    Map<String, List<dynamic>> reportData,
    BqBusDetailsRequest? busDetailsReq,
  ) async {
    String url = '$reportDownloadBaseUrl/Tax2/type=$fileType';

    var filename =
        "Tax Report - ${TextFormatter.toShortDate(dateTime: DateTime.now().toUtc(), format: "ddyyyyMM")}.${getReportFileExtension(fileType)}";
    var savePath = await FileManager().getDownloadFilePath(filename);

    var response = await client.getFileStream(
      url: url,
      token: token,
      savePath: savePath,
      timeout: 60000000,
      data: {'busDetails': busDetailsReq, 'objectList': reportData},
      method: 'POST',
    );

    if (response != null && response.statusCode == 200) {
      return savePath;
    } else {
      throw Exception('Unable to download Tax Report at this time');
    }
  }

  Future<String> downloadOverviewReport(
    String fileType,
    List<OverviewComparisonReport> reportData,
    BqBusDetailsRequest? busDetailsReq,
  ) async {
    String url = '$reportDownloadBaseUrl/Overview2/type=$fileType';

    var filename =
        "Overview Report - ${TextFormatter.toShortDate(dateTime: DateTime.now().toUtc(), format: "ddyyyyMM")}.${getReportFileExtension(fileType)}";
    var savePath = await FileManager().getDownloadFilePath(filename);

    var json = reportData.map((e) => e.toJson()).toList();

    var response = await client.getFileStream(
      url: url,
      token: token,
      savePath: savePath,
      timeout: 60000000,
      data: {'busDetails': busDetailsReq, 'objectList': json},
      method: 'POST',
    );

    if (response != null && response.statusCode == 200) {
      return savePath;
    } else {
      throw Exception('Unable to download Overview Report at this time');
    }
  }

  String getReportFileExtension(String fileType) {
    switch (fileType) {
      case 'PDF':
        return 'pdf';
      case 'Word':
        return 'docx';
      case 'Excel':
        return 'xlsx';
      default:
        return '';
    }
  }
}
