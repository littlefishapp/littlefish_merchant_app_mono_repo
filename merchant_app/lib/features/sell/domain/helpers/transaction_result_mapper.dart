import 'dart:convert';

import 'package:littlefish_merchant/features/order_common/data/model/order_transaction.dart';
import 'package:littlefish_merchant/models/device/interfaces/device_details.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_refund.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_transaction.dart';
import 'package:littlefish_merchant/tools/helpers.dart';

class TransactionResultMapper {
  static Map<String, dynamic> buildAdditionalInfoMap(
    Map<String, dynamic>? resultMap,
  ) {
    if (resultMap == null) return <String, dynamic>{};

    return {
      'entry': resultMap['entry'] ?? '',
      'authCode': resultMap['authCode'] ?? '',
      'cardType': resultMap['cardType'] ?? '',
      'maskedPAN': resultMap['maskedPAN'] ?? '',
      'batchNumber': resultMap['batchNumber'] ?? '',
      'uti': resultMap['uti'] ?? '',
      'traceID': resultMap['traceID'] ?? '',
      'mid': resultMap['mid'] ?? '',
      'tid': resultMap['tid'] ?? '',
      'authResponse': resultMap['authResponse'] ?? '',
      'authResponseCode': resultMap['authResponseCode'] ?? '',
      'rrn': resultMap['rrn'] ?? '',
      'stan': resultMap['stan'] ?? '',
      'aid': resultMap['aid'] ?? '',
      'tvr': resultMap['tvr'] ?? '',
      'tsi': resultMap['tsi'] ?? '',
      'cvr': resultMap['cvr'] ?? '',
      'reference': resultMap['reference'] ?? '',
    };
  }

  static CheckoutTransaction setTransactionData({
    required CheckoutTransaction currentTransaction,
    required Map<String, dynamic> resultMap,
    DeviceDetails? deviceDetails,
  }) {
    if (resultMap.isEmpty) {
      return currentTransaction;
    }

    CheckoutTransaction trx = currentTransaction;

    trx.paymentType!.paid = safeParseBool(
      resultMap['paid'],
      defaultValue: false,
    );
    trx.paymentType!.providerPaymentReference = safeParseString(
      resultMap['providerPaymentReference'],
      defaultValue: '',
    );
    trx.terminalId = safeParseString(
      deviceDetails?.terminalId,
      defaultValue: '',
    );
    trx.deviceId = safeParseString(deviceDetails?.deviceId, defaultValue: '');
    trx.batchNo = safeParseInt(resultMap['batchNumber'], defaultValue: 0);
    trx.referenceNo = safeParseString(
      resultMap['referenceNumber'],
      defaultValue: '',
    );
    trx.transactionStatus = safeParseString(
      resultMap['status'],
      defaultValue: '',
    );

    trx.additionalInfo ??= <String, dynamic>{};

    final additionalData = buildAdditionalInfoMap(resultMap);

    additionalData.forEach((key, value) {
      trx.additionalInfo!.putIfAbsent(key, () => value);
    });
    return trx;
  }

  static Refund setRefundData({
    required Refund trx,
    required Map<String, dynamic>? resultMap,
    DeviceDetails? deviceDetails,
  }) {
    if (resultMap != null) {
      trx.paymentType!.paid = safeParseBool(resultMap['paid']);
      trx.paymentType!.providerPaymentReference = safeParseString(
        resultMap['providerPaymentReference'],
        defaultValue: '',
      );
      trx.terminalId = safeParseString(
        deviceDetails?.terminalId,
        defaultValue: '',
      );
      trx.deviceId = safeParseString(deviceDetails?.deviceId, defaultValue: '');
      trx.batchNo = safeParseInt(resultMap['batchNumber'], defaultValue: 0);
      trx.referenceNo = safeParseString(resultMap['referenceNumber']);
      trx.transactionStatus = safeParseString(
        resultMap['status'],
        defaultValue: '',
      );

      trx.additionalInfo ??= <String, dynamic>{};

      final additionalData = buildAdditionalInfoMap(resultMap);

      additionalData.forEach((key, value) {
        trx.additionalInfo!.putIfAbsent(key, () => value);
      });
    } else {
      // This if/else comes from legacy code, but it's not clear why it's needed
      trx.deviceId = safeParseString(deviceDetails?.deviceId, defaultValue: '');
      trx.terminalId = safeParseString(
        deviceDetails?.terminalId,
        defaultValue: '',
      );
      trx.transactionStatus = 'Approved';
    }
    return trx;
  }

  static OrderTransaction setOrderTransactionData({
    required OrderTransaction currentOrderTransaction,
    required Map<String, dynamic>? resultMap,
  }) {
    if (resultMap == null || resultMap.isEmpty) {
      return currentOrderTransaction;
    }

    final newDeviceId = safeParseString(
      resultMap['deviceId'],
      defaultValue: currentOrderTransaction.deviceId,
    );
    final newTerminalId = safeParseString(
      resultMap['terminalId'],
      defaultValue: currentOrderTransaction.terminalId,
    );
    final newBatchNo = safeParseInt(
      resultMap['batchNumber'],
      defaultValue: currentOrderTransaction.batchNo,
    );
    final newTraceId = safeParseString(
      resultMap['traceID'],
      defaultValue: currentOrderTransaction.traceId,
    );

    final statusString = safeParseString(resultMap['status'], defaultValue: '');
    final newStatus = TransactionStatus.values.firstWhere(
      (e) => e.toString() == 'TransactionStatus.$statusString',
      orElse: () => currentOrderTransaction.transactionStatus,
    );

    final existingAdditionalData =
        currentOrderTransaction.additionalData.isNotEmpty
        ? jsonDecode(currentOrderTransaction.additionalData)
              as Map<String, dynamic>
        : <String, dynamic>{};

    final newAdditionalDataMap = buildAdditionalInfoMap(resultMap);

    // Merge existing data with new fields (new data overwrites old keys)
    final mergedAdditionalData = {
      ...existingAdditionalData,
      ...newAdditionalDataMap,
    };

    return currentOrderTransaction.copyWith(
      deviceId: newDeviceId,
      terminalId: newTerminalId,
      batchNo: newBatchNo,
      traceId: newTraceId,
      transactionStatus: newStatus,
      additionalData: jsonEncode(mergedAdditionalData),
    );
  }
}
