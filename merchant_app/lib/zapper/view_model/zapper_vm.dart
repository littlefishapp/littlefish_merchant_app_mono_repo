// Dart imports:
import 'dart:developer';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_svg/flutter_svg.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/services/modal_service.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_transaction.dart';
import 'package:littlefish_merchant/providers/locale_provider.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/view_models/store_collection_viewmodel.dart';
import 'package:littlefish_merchant/zapper/models/zapper.dart';
import 'package:littlefish_merchant/zapper/services/zapper_service.dart';

class ZapperVM extends StoreViewModel<AppState> {
  ZapperVM.fromStore(Store<AppState> store, {BuildContext? context})
    : super.fromStore(store, context: context);

  CheckoutTransaction? transaction;
  late ZapperService zapperService;

  SvgPicture? qrSVG;
  Future<bool?> cancelInvoice(BuildContext ctx) async {
    toggleLoading(value: true);

    zapperService
        .verifyPayment(transaction?.id)
        .then((result) async {
          if (result?.first.status == 2) {
            showMessageDialog(
              ctx,
              'The payment was successful, cannot cancel transaction',
              LittleFishIcons.info,
            ).then((v) {
              Navigator.of(ctx).pop({
                'proceed': true,
                'paid': true,
                'providerPaymentReference': result!.first.zapperId,
              });
            });
          } else {
            Navigator.pop(ctx, {'proceed': false, 'paid': false});
            zapperService
                .closeInvoice(transaction!.id)
                .then((result) {})
                .catchError((error) {
                  log(error, stackTrace: StackTrace.current);
                  reportCheckedError(error, trace: StackTrace.current);
                });
          }
        })
        .catchError((error) {
          log(error, stackTrace: StackTrace.current);
          reportCheckedError(error, trace: StackTrace.current);
          showMessageDialog(ctx, error, LittleFishIcons.error);
        });

    return null;
  }

  Future<SvgPicture?> generateQRCode(BuildContext ctx) async {
    final invoice = createInvoice(transaction!);
    await zapperService
        .createZapperPayment(invoice)
        .then((result) {
          if (result != null) {
            if (result == '403') {
              showMessageDialog(
                ctx,
                'Unable to generate QR code - please verify Zapper details.',
                LittleFishIcons.error,
              ).then((c) {
                Navigator.of(ctx).pop(ctx);
              });

              return null;
            } else {
              qrSVG = SvgPicture.string(result, fit: BoxFit.fitWidth);

              return qrSVG;
            }
          } else {
            return null;
          }
        })
        .catchError((error) {
          log(error, stackTrace: StackTrace.current);
          reportCheckedError(error, trace: StackTrace.current);
          toggleLoading();
          showMessageDialog(ctx, error, LittleFishIcons.error);
          return null;
        });
    return null;
  }

  verifyPayment(BuildContext ctx) async {
    toggleLoading(value: true);

    toggleLoading(value: true);
    zapperService
        .verifyPayment(transaction?.id)
        .then((result) {
          if (result == null || result == []) {
            getIt<ModalService>()
                .showActionModal(
                  context: ctx,
                  title: 'Payment not verified',
                  description:
                      'The payment has not yet been verified. Would you still like to proceed?',
                  acceptText: 'Yes',
                  cancelText: 'No',
                )
                .then((res) {
                  if (res!) {
                    Navigator.of(ctx).pop({'proceed': true, 'paid': false});
                  }
                });
          } else {
            if (result.any((x) => x.status == 2)) {
              showMessageDialog(
                ctx,
                'The payment was successful',
                LittleFishIcons.info,
              ).then((v) {
                Navigator.of(ctx).pop({
                  'proceed': true,
                  'paid': true,
                  'providerPaymentReference': result.first.zapperId,
                });
              });
            } else {
              getIt<ModalService>()
                  .showActionModal(
                    context: ctx,
                    title: 'Warning',
                    description:
                        'Zapper has indicated that the payment was declined, would you still like to proceed?',
                    status: StatusType.destructive,
                  )
                  .then((res) {
                    if (res!) {
                      Navigator.of(ctx).pop({
                        'proceed': true,
                        'paid': false,
                        'providerPaymentReference': result.first.zapperId,
                      });
                    }
                  });
            }
          }
        })
        .catchError((error) {
          log(error, stackTrace: StackTrace.current);
          reportCheckedError(error, trace: StackTrace.current);
          // toggleLoading(value: false);
          showMessageDialog(ctx, error, LittleFishIcons.error);
        });
  }

  CheckoutTransaction setTransaction(CheckoutTransaction value) =>
      transaction = value;

  @override
  loadFromStore(Store<AppState>? store, {BuildContext? context}) {
    //this.store = store;
    //this.state = store.state;
    zapperService = ZapperService.fromStore(store!);

    isLoading ??= false;
  }

  ZapperInvoice createInvoice(CheckoutTransaction transaction) {
    List<LineItem> lineItems = [];

    // TODO(lampian): check error
    for (var i = 0; i < transaction.items!.length; i++) {
      var currentItem = transaction.items![i];

      lineItems.add(
        LineItem(
          name: currentItem.description,
          productCode: currentItem.productId,
          quantity: currentItem.quantity,
          unitPrice: currentItem.itemValue,
        ),
      );

      return ZapperInvoice(
        amount: ((transaction.totalValue ?? 0) * 100).truncate(),
        createdUTCDate: TextFormatter.toShortDate(
          dateTime: DateTime.now().toUtc(),
        ),
        externalReference: transaction.id,
        lineItems: lineItems,
        origin: '', // comes from linked accounts
        siteReference: '', // comes from linked accounts
        originReference: transaction.id,
        currencyISOCode: LocaleProvider.instance.currencyCode,
      );
    }
    return ZapperInvoice(
      origin: null,
      siteReference: null,
      externalReference: null,
      amount: null,
    );
  }
}
