// Dart imports:
// remove ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
// Flutter imports:
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/services/modal_service.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:redux/redux.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
// Project imports:
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_transaction.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/view_models/store_collection_viewmodel.dart';
import 'package:littlefish_merchant/redux/business/business_selectors.dart'
    as business_selector;
import '../services/littlefishpay_qr_sdk.dart';
import '../services/snapscan_service.dart';

class SnapscanVM extends StoreViewModel<AppState> {
  SnapscanVM.fromStore(Store<AppState> store, {BuildContext? context})
    : super.fromStore(store, context: context);

  CheckoutTransaction? transaction;
  late SnapScanService snapScanSdk;

  late String qrCodeUrl;

  Future _showPaymentNotVerifiedDialog(BuildContext ctx) => showMessageDialog(
    ctx,
    'Cannot proceed, payment still pending',
    LittleFishIcons.error,
  );

  verifyPayment(BuildContext ctx, {bool cancel = false}) async {
    toggleLoading(value: true);

    try {
      var result = await snapScanSdk.getPaymentByMerchRef(transaction!.id!);
      if (isNullOrEmpty(result)) {
        if (!cancel) {
          await _showPaymentNotVerifiedDialog(ctx);
        } else {
          Navigator.of(ctx).pop({
            'proceed': false,
            'paid': false,
            'authCode':
                result
                    ?.firstWhereOrNull((x) => x.status == 'completed')
                    ?.authCode
                    .toString() ??
                '',
          });
        }
        toggleLoading(value: false);

        return;
      }

      if (result!.any((x) => x.status == 'completed')) {
        if (!cancel) {
          await _showPaymentSuccessfulPopup(ctx);
          Navigator.of(ctx).pop({
            'proceed': true,
            'paid': true,
            'providerPaymentReference':
                result
                    .firstWhereOrNull((x) => x.status == 'completed')
                    ?.id
                    .toString() ??
                '',
            'authCode':
                result
                    .firstWhereOrNull((x) => x.status == 'completed')
                    ?.authCode
                    .toString() ??
                '',
          });
          return;
        }

        await _showCannotCancelPaymentPopup(ctx);
        Navigator.of(ctx).pop({
          'proceed': true,
          'paid': true,
          'providerPaymentReference':
              result
                  .firstWhereOrNull((x) => x.status == 'completed')
                  ?.id
                  .toString() ??
              '',
          'authCode':
              result
                  .firstWhereOrNull((x) => x.status == 'completed')
                  ?.authCode
                  .toString() ??
              '',
        });
        return;
      }

      if (!cancel) {
        var res = await _showPaymentErrorDialog(ctx);
        if (res == true) {
          Navigator.of(ctx).pop({
            'proceed': true,
            'paid': false,
            'providerPaymentReference':
                result
                    .firstWhereOrNull((x) => x.status == 'completed')
                    ?.id
                    .toString() ??
                '',
            'authCode':
                result
                    .firstWhereOrNull((x) => x.status == 'completed')
                    ?.authCode
                    .toString() ??
                '',
          });
        }
        return;
      }

      Navigator.of(ctx).pop({'proceed': false, 'paid': false});
    } catch (error) {
      log(error.toString(), stackTrace: StackTrace.current);
      reportCheckedError(error, trace: StackTrace.current);
      showMessageDialog(
        ctx,
        'Unable to process Snapscan payment',
        LittleFishIcons.error,
      );
    }
  }

  Future _showPaymentSuccessfulPopup(BuildContext ctx) => showMessageDialog(
    ctx,
    'The payment was successful',
    LittleFishIcons.info,
  );

  Future _showCannotCancelPaymentPopup(BuildContext ctx) => showMessageDialog(
    ctx,
    'The payment was successful, cannot cancel',
    LittleFishIcons.info,
  );

  Future<bool?> _showPaymentErrorDialog(BuildContext ctx) {
    final ModalService modalService = getIt<ModalService>();

    return modalService.showActionModal(
      context: ctx,
      title: 'Warning',
      description:
          'Snapscan has indicated that the payment encountered an error, would you still like to proceed?',
      acceptText: 'Yes',
      cancelText: 'No',
    );
  }

  void generateQRString() {
    qrCodeUrl = snapScanSdk.generateQRCodeUrl(
      transaction!.id,
      (transaction!.checkoutTotal * 100).truncate(),
    );
  }

  CheckoutTransaction setTransaction(CheckoutTransaction value) =>
      transaction = value;

  Widget generateQRCode() {
    return snapScanSdk.generateQRCodeWidget(qrCodeUrl);
  }

  @override
  loadFromStore(Store<AppState>? store, {BuildContext? context}) {
    if (business_selector.hasSnapscanAccount(store!.state)) {
      var snapscanAccount = business_selector.snapscanAccount(store.state)!;

      if (snapscanAccount.config != null) {
        Map<String, dynamic> decodedConfig = jsonDecode(
          snapscanAccount.config!,
        );

        if (decodedConfig.containsKey('merchantId') &&
            decodedConfig.containsKey('apiKey')) {
          final merchantId = decodedConfig['merchantId'];
          final apiKey = decodedConfig['apiKey'];
          snapScanSdk = LittleFishPayQr().initializeSnapScan(
            merchantId,
            apiKey,
          );
        }
      }

      isLoading ??= false;
    }
  }
}
