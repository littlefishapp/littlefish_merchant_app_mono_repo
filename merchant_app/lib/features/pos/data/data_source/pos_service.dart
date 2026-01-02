// removed ignore: depend_on_referenced_packages
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:littlefish_core/configuration/config_service.dart';
import 'package:littlefish_core/hardware/printers/drivers/pos_printer.dart';
import 'package:littlefish_core/hardware/printers/littlefish_text_printer.dart';
import 'package:littlefish_core/hardware/scanners/littlefish_scanner.dart';
import 'package:littlefish_hardware_manager/managers/littlefish_printer_manager.dart';
import 'package:littlefish_hardware_manager/managers/littlefish_scanner_manager.dart';
import 'package:littlefish_interfaces/printer_request_interface.dart';
import 'package:littlefish_interfaces/scan_result_interface.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_button.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/bootstrap.dart';
import 'package:littlefish_merchant/features/order_common/data/model/app_constants.dart';
import 'package:littlefish_merchant/features/pos/presentation/helpers/payment_action_helper.dart';
import 'package:littlefish_merchant/models/device/terminal_details.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/device/device_actions.dart';
import 'package:littlefish_merchant/tools/payment_types_helper/soft_pos_helper.dart';
import 'package:littlefish_merchant/ui/online_store/common/constants.dart';
import 'package:littlefish_merchant/ui/security/registration/functions/activation_functions.dart';
import 'package:littlefish_payments/managers/payments_manager.dart';
import 'package:littlefish_payments/models/accounts/linked_account.dart';
import 'package:littlefish_payments/models/registration/payment_provider_device_info.dart';
import 'package:littlefish_payments/models/shared/payment_gateway.dart';
import 'package:littlefish_payments/models/shared/payment_result.dart';
import 'package:littlefish_payments/models/terminal/terminal_data.dart';
import 'package:littlefish_payments/models/terminal/terminal_enrol_data.dart';
import 'package:littlefish_payments/models/theme/provider_theme.dart';
import 'package:redux/redux.dart';
import 'package:uuid/uuid.dart';
import 'package:littlefish_core/logging/services/logger_service.dart';
import 'package:littlefish_core/core/littlefish_core.dart';

class PosService {
  LittleFishCore core = LittleFishCore.instance;

  LoggerService get logger => core.get<LoggerService>();

  late PaymentManager paymentManager;
  late LittleFishScannerManager scannerManager;
  late LittleFishPrinterManager printerManager;

  Store<AppState>? store;

  AppState? get appState => store?.state;

  String? get businessId => appState?.currentBusinessId;

  String? get isoCurrencyCode => appState?.localeState.currencyCode;

  bool get isPOSDevice => appState?.appSettingsState.isPOSBuild ?? false;

  ConfigService get configService => core.get<ConfigService>();

  String? siteId;
  String? merchantId;
  bool isConfigured = false;

  PosService.fromStore({this.store}) {
    paymentManager = PaymentManager();
    scannerManager = LittleFishScannerManager();
    printerManager = LittleFishPrinterManager();
    BuildContext context = globalNavigatorKey.currentContext!;
    final buttonColours =
        Theme.of(context).extension<AppliedButton>() ?? const AppliedButton();
    final textIconColours =
        Theme.of(context).extension<AppliedTextIcon>() ??
        const AppliedTextIcon();

    paymentManager.initialise(
      paymentsUrl: store!.state.paymentsUrl ?? '',
      baseUrl: store!.state.baseUrl ?? '',
      businessId: store!.state.currentBusinessId ?? '',
      businessName: store!.state.businessState.profile?.name ?? '',
      theme: ProviderTheme(
        primaryColor: buttonColours.primaryDefault,
        secondaryColor: textIconColours.inversePrimary,
        successColor: textIconColours.success,
        failureColor: textIconColours.error,
      ),
    );

    merchantId = AppVariables.merchantId;
    siteId = '';

    isConfigured = true;
  }

  bool canDoCardPayment() {
    return paymentManager.canDoPaymentType(
      isPOSDevice ? PaymentChannel.pos : PaymentChannel.mobile,
      PaymentType.card,
    );
  }

  Future<BalanceInquiryResult> balanceInquiry() async {
    return paymentManager.performBalanceEnquiry(
      channel: isPOSDevice ? PaymentChannel.pos : PaymentChannel.mobile,
      accountType: PaymentType.card,
      merchantId: merchantId ?? '',
      isoCurrencyCode: isoCurrencyCode ?? '',
    );
  }

  Future<SettlementResult> closeBatch() async {
    return await paymentManager.closeBatch(
      channel: isPOSDevice ? PaymentChannel.pos : PaymentChannel.mobile,
      merchantId: merchantId ?? '',
      paymentType: PaymentType.card,
      isoCurrencyCode: isoCurrencyCode ?? '',
    );
  }

  Future<PaymentResult?> charge({required Decimal amount}) async {
    if (amount == Decimal.zero) {
      return null;
    }
    PaymentResult? result;
    try {
      if (AppVariables.isMobile && SoftPosHelper.hasSoftPosProvider()) {
        await paymentManager.updateBuildContext(
          context: globalNavigatorKey.currentContext!,
          channel: PaymentChannel.mobile,
          paymentType: PaymentType.card,
        );
      }
      if (AppVariables.isMobile) {
        result = await paymentManager.processPurchase(
          channel: PaymentChannel.mobile,
          amount: amount,
          cashAmount: Decimal.zero,
          merchantId: merchantId ?? '',
          isoCurrencyCode: isoCurrencyCode ?? '',
          transactionId: const Uuid().v4(),
          paymentType: PaymentType.card,
          shortCurrencyCode: isoCurrencyCode ?? '',
          reference: SoftPosHelper.createReference(),
          onAction: (completer, data) async {
            printRelease('action received ${data.action.name}.');
            logger.info(this, 'action received');
            await PaymentActionHelper.doPaymentAction(
              completer: completer,
              data: data,
            );

            return;
          },
        );
      } else {
        result = await paymentManager.processPurchase(
          channel: isPOSDevice ? PaymentChannel.pos : PaymentChannel.mobile,
          amount: amount,
          cashAmount: Decimal.zero,
          merchantId: merchantId ?? '',
          isoCurrencyCode: isoCurrencyCode ?? '',
          transactionId: const Uuid().v4(),
          paymentType: PaymentType.card,
          shortCurrencyCode: isoCurrencyCode ?? '',
          reference: SoftPosHelper.createReference(),
        );
      }
    } catch (e) {
      logger.error(
        this,
        'Error occurred while processing payment',
        error: e,
        stackTrace: StackTrace.current,
      );
      rethrow;
    }

    return result;
  }

  Future<PaymentResult?> refund({
    required Decimal amount,
    String? reference,
  }) async {
    if (amount == Decimal.zero) {
      return null;
    }
    if (AppVariables.isMobile && SoftPosHelper.hasSoftPosProvider()) {
      await paymentManager.updateBuildContext(
        context: globalNavigatorKey.currentContext!,
        channel: isPOSDevice ? PaymentChannel.pos : PaymentChannel.mobile,
        paymentType: PaymentType.card,
      );
    }

    try {
      final result = await paymentManager.processRefund(
        channel: isPOSDevice ? PaymentChannel.pos : PaymentChannel.mobile,
        amount: amount,
        merchantId: merchantId ?? '',
        isoCurrencyCode: isoCurrencyCode ?? '',
        transactionId: reference ?? SoftPosHelper.createReference(),
        paymentType: PaymentType.card,
        onAction: (completer, data) async {
          await PaymentActionHelper.doPaymentAction(
            completer: completer,
            data: data,
          );
          return;
        },
      );

      return result;
    } catch (e) {
      logger.error(
        this,
        'Error occurred while processing refund',
        error: e,
        stackTrace: StackTrace.current,
      );
      rethrow;
    }
  }

  Future<TerminalData> getTerminalInfo() async {
    final result = await paymentManager.getTerminalData(
      PaymentType.card,
      isPOSDevice ? PaymentChannel.pos : PaymentChannel.mobile,
    );

    //always update the store, with the latest device details, ensuring that we maintain consistency throughout the application.
    store?.dispatch(SetDeviceDetails(TerminalDetails(result)));

    return result;
  }

  Future<PaymentResult?> withdraw({required Decimal amount}) async {
    if (amount == Decimal.zero) {
      return null;
    }

    final result = await paymentManager.processWithdrawal(
      channel: isPOSDevice ? PaymentChannel.pos : PaymentChannel.mobile,
      amount: amount,
      merchantId: merchantId ?? '',
      isoCurrencyCode: isoCurrencyCode ?? '',
      transactionId: const Uuid().v4(),
      paymentType: PaymentType.card,
    );

    return result;
  }

  Future<PaymentResult?> purchaseWithCashBack({
    required Decimal amount,
    required Decimal cashBackAmount,
  }) async {
    if (amount == Decimal.zero || cashBackAmount == Decimal.zero) {
      return null;
    }

    final result = await paymentManager.processPurchase(
      channel: isPOSDevice ? PaymentChannel.pos : PaymentChannel.mobile,
      amount: amount,
      cashAmount: cashBackAmount,
      merchantId: merchantId ?? '',
      isoCurrencyCode: isoCurrencyCode ?? '',
      transactionId: const Uuid().v4(),
      paymentType: PaymentType.card,
      reference: SoftPosHelper.createReference(),
    );
    return result;
  }

  //RECEIPT FUNCTIONS

  Future<PaymentPrintResult> lastReceipt({String? transactionId}) async {
    final result = paymentManager.printPaymentReceipt(
      channel: isPOSDevice ? PaymentChannel.pos : PaymentChannel.mobile,
      transactionId: transactionId ?? const Uuid().v4(),
      merchantId: merchantId ?? '',
      paymentType: PaymentType.card,
      printOption: ReceiptPrintOption.printBothCustomerAndMerchantCopy,
    );

    return result;
  }

  Future<PaymentPrintResult> reprint(String refNum) async {
    final result = paymentManager.printPaymentReceipt(
      channel: isPOSDevice ? PaymentChannel.pos : PaymentChannel.mobile,
      transactionId: const Uuid().v4(),
      merchantId: merchantId ?? '',
      paymentType: PaymentType.card,
      printOption: ReceiptPrintOption.printBothCustomerAndMerchantCopy,
      receiptNumber: refNum,
    );

    return result;
  }

  //SCAN FUNCTIONS

  Future<ScanResultInterface> scanHW({required ScanMode scanMode}) async {
    ScanResultInterface? result;

    if (scannerManager.hasScanner<LittleFishScanner>()) {
      final scanner = scannerManager.getScanner<LittleFishScanner>();

      await scanner!.scan(
        scanFunction: SupportedScanFunction.scanBarcode,
        scanMode: scanMode,
        onScanResult: (e) {
          if (e is ScanResultInterface) {
            result = e;
          }
        },
      );
    }

    return result ?? ScanResultInterface();
  }

  Future<ScanResultInterface> scan() async {
    ScanResultInterface? result;

    if (scannerManager.hasScanner<LittleFishScanner>()) {
      final scanner = scannerManager.getScanner<LittleFishScanner>();

      await scanner!.scan(
        scanFunction: SupportedScanFunction.scanBarcode,
        scanMode: ScanMode.singleScan,
        onScanResult: (e) {
          if (e is ScanResultInterface) {
            result = e;
          }
        },
      );
    }

    return result ?? ScanResultInterface();
  }

  //PRINT FUNCTIONS

  Future<PaymentPrintResult> print(
    PrinterRequestInterface printerRequestInterface, {
    bool reprintHeaderRequired = false,
  }) async {
    PrinterRequestInterface printerRequestInterfaceUpdated =
        printerRequestInterface;

    final LittleFishPrinter? printer = printerManager
        .getSpecificPrinter<POSPrinter>();

    bool result = false;

    if (printer != null) {
      final bool isPrintReprintHeaderEnabled = configService.getBoolValue(
        key: 'config_print_reprint_header',
        defaultValue: false,
      );
      final String lastReprintHeader = configService.getStringValue(
        key: 'config_last_reprint_header',
        defaultValue: '*** RE-PRINT ***',
      );
      if (isPrintReprintHeaderEnabled && reprintHeaderRequired != false) {
        if (printer.name == 'ar_ttf_printer') {
          printer.builder.append('*text c $lastReprintHeader\n');
        } else {
          printer.builder.newLine().center().bold().content(lastReprintHeader);
        }
        await printer.print();
      }

      result = await printer.printLegacy(printerRequestInterfaceUpdated);
    }

    return PaymentPrintResult(
      status: result ? AppConstants.success : AppConstants.failed,
      statusCode: result ? AppConstants.success : AppConstants.failed,
      statusDescription: result ? AppConstants.success : AppConstants.failed,
    );
  }

  //ToDo: We need to confirm the difference on this, perhaps update the interface to give the indication rather than an added method?
  Future<PaymentPrintResult> printRefund(
    PrinterRequestInterface printerRequestInterface,
  ) async {
    PrinterRequestInterface printerRequestInterfaceUpdated =
        printerRequestInterface;

    final LittleFishPrinter? printer = printerManager
        .getSpecificPrinter<POSPrinter>();

    bool result = false;

    if (printer != null) {
      result = await printer.printLegacy(printerRequestInterfaceUpdated);
    }

    return PaymentPrintResult(
      status: result ? AppConstants.success : AppConstants.failed,
      statusCode: result ? AppConstants.success : AppConstants.failed,
      statusDescription: result ? AppConstants.success : AppConstants.failed,
    );
  }

  Future<PaymentPrintResult> printBothCustomerAndMerchantCopy(
    String refNum,
  ) async {
    final result = await paymentManager.printPaymentReceipt(
      channel: isPOSDevice ? PaymentChannel.pos : PaymentChannel.mobile,
      transactionId: refNum,
      merchantId: merchantId ?? '',
      paymentType: PaymentType.card,
      printOption: ReceiptPrintOption.printBothCustomerAndMerchantCopy,
    );

    return result;
  }

  Future<PaymentPrintResult> printCustomerCopy(String refNum) async {
    final result = await paymentManager.printPaymentReceipt(
      channel: isPOSDevice ? PaymentChannel.pos : PaymentChannel.mobile,
      transactionId: refNum.isEmpty ? const Uuid().v4() : refNum,
      merchantId: merchantId ?? '',
      paymentType: PaymentType.card,
      printOption: ReceiptPrintOption.printCustomerCopy,
      receiptNumber: refNum,
    );

    return result;
  }

  Future<PaymentPrintResult> printMerchantCopy(String refNum) async {
    final result = await paymentManager.printPaymentReceipt(
      channel: isPOSDevice ? PaymentChannel.pos : PaymentChannel.mobile,
      transactionId: refNum.isEmpty ? const Uuid().v4() : refNum,
      merchantId: merchantId ?? '',
      paymentType: PaymentType.card,
      printOption: ReceiptPrintOption.printMerchantCopy,
      receiptNumber: refNum,
    );

    return result;
  }

  Future<bool> isDeviceEnrolled() async {
    try {
      final result = await paymentManager.isDeviceEnrolled(
        channel: isPOSDevice ? PaymentChannel.pos : PaymentChannel.mobile,
        paymentType: PaymentType.card,
      );
      return result;
    } catch (e) {
      logger.error(
        this,
        'Error occurred while registering device',
        error: e,
        stackTrace: StackTrace.current,
      );
      rethrow;
    }
  }

  Future<bool> validateDeviceCorrectlyLinked() async {
    try {
      final result = await paymentManager.validateDeviceCorrectlyLinked(
        channel: isPOSDevice ? PaymentChannel.pos : PaymentChannel.mobile,
        paymentType: PaymentType.card,
        merchantId: merchantId ?? '',
        provider: '',
      );
      return result;
    } catch (e) {
      logger.error(
        this,
        'Error occurred while registering device',
        error: e,
        stackTrace: StackTrace.current,
      );
      rethrow;
    }
  }

  Future<PaymentProviderDeviceInfo?> getProviderDeviceInfo() async {
    try {
      final result = await paymentManager.getPaymentProviderDeviceInfo(
        channel: isPOSDevice ? PaymentChannel.pos : PaymentChannel.mobile,
        paymentType: PaymentType.card,
      );
      return result;
    } catch (e) {
      logger.error(
        this,
        'Error occurred while getting provider device info',
        error: e,
        stackTrace: StackTrace.current,
      );
      rethrow;
    }
  }

  Future<TerminalEnrolData> enrollDevice(String deviceId) async {
    try {
      final result = await paymentManager.enrollDevice(
        channel: isPOSDevice ? PaymentChannel.pos : PaymentChannel.mobile,
        merchantId: merchantId ?? '',
        paymentType: PaymentType.card,
      );
      return result;
    } catch (e) {
      logger.error(
        this,
        'Error occurred while registering device',
        error: e,
        stackTrace: StackTrace.current,
      );
      rethrow;
    }
  }

  Future<bool> unEnrollDevice() async {
    try {
      final result = await paymentManager.unEnrollDevice(
        channel: isPOSDevice ? PaymentChannel.pos : PaymentChannel.mobile,
        merchantId: formatMidValue(merchantId) ?? '',
        paymentType: PaymentType.card,
      );
      return result;
    } catch (e) {
      logger.error(
        this,
        'Error occurred while registering device',
        error: e,
        stackTrace: StackTrace.current,
      );
      rethrow;
    }
  }

  Future<LinkedAccount?> enrollProviderMerchant({
    required String providerName,
  }) async {
    try {
      final result = await paymentManager.registerProviderMerchant(
        providerName: providerName,
        businessId: AppVariables.businessId,
        merchantId: AppVariables.merchantId,
      );
      return result;
    } catch (e) {
      logger.error(
        this,
        'Error occurred while registering device',
        error: e,
        stackTrace: StackTrace.current,
      );
      rethrow;
    }
  }

  Future<LinkedAccount?> updateLinkedAccount({LinkedAccount? account}) async {
    try {
      return await paymentManager.updateLinkedAccount(account: account);
    } catch (e) {
      logger.error(
        this,
        'Error occurred while getting linked account',
        error: e,
        stackTrace: StackTrace.current,
      );
      rethrow;
    }
  }

  Future<LinkedAccount?> getLinkedAccount() async {
    try {
      return await paymentManager.getLinkedAccount();
    } catch (e) {
      logger.error(
        this,
        'Error occurred while getting linked account',
        error: e,
        stackTrace: StackTrace.current,
      );
      rethrow;
    }
  }

  Future<bool> updateDeviceParameters() async {
    try {
      return await paymentManager.updateDeviceParameters();
    } catch (e) {
      logger.error(
        this,
        'Error occurred while updating device parameters',
        error: e,
        stackTrace: StackTrace.current,
      );
      rethrow;
    }
  }

  Future<PaymentPrintResult> reprintBatch({
    String? batchNumber,
    required BatchPrintOption option,
  }) async {
    try {
      return await paymentManager.printBatchReport(
        channel: isPOSDevice ? PaymentChannel.pos : PaymentChannel.mobile,
        transactionId: '',
        merchantId: '',
        paymentType: PaymentType.card,
        printOption: option,
        batchId: batchNumber ?? '',
      );
    } catch (e) {
      logger.error(
        this,
        'Error occurred while updating device parameters',
        error: e,
        stackTrace: StackTrace.current,
      );
      rethrow;
    }
  }
}
