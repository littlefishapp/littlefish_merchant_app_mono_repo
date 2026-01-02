// removed ignore: depend_on_referenced_packages, implementation_imports
import 'package:flutter/cupertino.dart';
import 'package:littlefish_interfaces/inventory_interface.dart';
import 'package:littlefish_interfaces/print_address_interface.dart';
import 'package:littlefish_interfaces/printer_request_interface.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_cart_item.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_refund_item.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_transaction.dart';
import 'package:littlefish_merchant/models/shared/data/address.dart'
    as profile_address;
import 'package:littlefish_merchant/models/store/business_profile.dart';
import 'package:littlefish_merchant/providers/locale_provider.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_payments/models/shared/payment_gateway.dart';
import 'package:redux/src/store.dart';

import '../../../../common/view_models/store_collection_viewmodel.dart';
import '../../../../models/sales/checkout/checkout_refund.dart';
import '../../data/data_source/pos_service.dart';

class PosPrintVM extends StoreViewModel<AppState> {
  late PosService posPrintService;
  CheckoutTransaction? checkoutTransaction;
  Refund? refundTransaction;
  late PaymentPrintResult pResult;
  late BusinessProfile? profile;
  late String? imageUrl;

  @override
  PosPrintVM.fromStore(Store<AppState>? store, {BuildContext? context})
    : super.fromStore(store, context: context);

  Future<PaymentPrintResult> lastReceipt() async {
    return await posPrintService.lastReceipt();
  }

  @override
  loadFromStore(Store<AppState>? store, {BuildContext? context}) {
    posPrintService = PosService.fromStore(store: store);
    profile = store?.state.businessState.profile;
    imageUrl = store?.state.storeState.store?.logoUrl;

    isLoading ??= false;
  }

  List<InventoryInterface> mapToInventoryList(List<CheckoutCartItem>? items) {
    List<InventoryInterface> list = [];
    for (var element in items!) {
      list.add(
        InventoryInterface(
          itemDescription: element.description ?? '',
          quantity: element.quantity.toInt(),
          price: element.itemValue ?? 0.0,
        ),
      );
    }
    return list;
  }

  List<InventoryInterface> mapToRefundInventoryList(List<RefundItem>? items) {
    List<InventoryInterface> list = [];
    for (var element in items!) {
      list.add(
        InventoryInterface(
          itemDescription: element.displayName ?? '',
          quantity: element.quantity!.toInt(),
          price: element.itemValue ?? 0.0,
        ),
      );
    }
    return list;
  }

  PrintAddressInterface mapToPrintAddress(profile_address.Address? address) {
    return PrintAddressInterface(
      address1: address!.address1 ?? '',
      address2: address.address2 ?? '',
      state: address.state ?? '',
      postalCode: address.postalCode ?? '',
      country: address.country ?? '',
      city: address.city ?? '',
    );
  }

  Future<PaymentPrintResult> print({bool isReprint = false}) async {
    try {
      pResult = await posPrintService.print(
        PrinterRequestInterface(
          transactionID:
              (checkoutTransaction?.refunds != null &&
                  checkoutTransaction!.refunds!.isNotEmpty)
              ? 'Refund # ${((checkoutTransaction?.transactionNumber?.toStringAsFixed(0)) ?? (checkoutTransaction?.referenceNo) ?? '').toString()}'
              : ((checkoutTransaction?.transactionNumber?.toStringAsFixed(0)) ??
                        (checkoutTransaction?.referenceNo) ??
                        '')
                    .toString(),
          footer: profile?.receiptData?.footer ?? '',
          website: profile?.website ?? '',
          transactionTime: TextFormatter.toTimeFormat(
            dateTime: checkoutTransaction?.transactionDate?.toLocal(),
          ),
          transactionDate: TextFormatter.toFullDate(
            dateTime: checkoutTransaction?.transactionDate?.toLocal(),
          ),
          customerName: checkoutTransaction?.customerName ?? '',
          customerMobile: checkoutTransaction?.customerMobile ?? '',
          customerEmail: checkoutTransaction?.customerEmail ?? '',
          customerId: checkoutTransaction?.customerId ?? '',
          displayCustomer:
              AppVariables
                  .store
                  ?.state
                  .businessState
                  .profile
                  ?.receiptData
                  ?.displayCustomer ??
              false,
          displaySeller:
              AppVariables
                  .store
                  ?.state
                  .businessState
                  .profile
                  ?.receiptData
                  ?.displaySeller ??
              false,
          sellerId: checkoutTransaction?.sellerId ?? '',
          sellerName: checkoutTransaction?.sellerName ?? '',
          currencyCode:
              LocaleProvider.instance.currencyCode ??
              LocaleProvider.instance.currentLocale?.currencyCode ??
              'R',
          whatsapp: profile?.receiptData?.displayWhatsappLine != null
              ? profile!.receiptData!.displayWhatsappLine
                    ? profile?.whatsappLine ?? ''
                    : ''
              : '',
          instagram: profile?.receiptData?.displayInstagramHandle != null
              ? profile!.receiptData!.displayInstagramHandle
                    ? profile!.instagramHandle ?? ''
                    : ''
              : '',
          items: mapToInventoryList(checkoutTransaction?.items),
          address: mapToPrintAddress(profile?.address),
          businessName: AppVariables.businessName,
          totalValue: checkoutTransaction?.totalValue ?? 0.0,
          taxValue: checkoutTransaction?.totalTax ?? 0.0,
          totalCost: checkoutTransaction?.totalCost ?? 0.0,
          totalDiscount: checkoutTransaction?.totalDiscount ?? 0.0,
          totalTax: checkoutTransaction?.totalTax ?? 0.0,
          amountChange: checkoutTransaction?.amountChange ?? 0.0,
          tell: profile?.phoneNumber ?? '',
          header: profile?.receiptData?.header ?? '',
          totalMarkup: checkoutTransaction?.totalMarkup ?? 0.0,
          amountTendered: checkoutTransaction?.amountTendered ?? 0,
          cashbackAmount: checkoutTransaction?.cashbackAmount ?? 0,
          tipAmount: checkoutTransaction?.tipAmount ?? 0,
          withdrawalAmount: checkoutTransaction?.withdrawalAmount ?? 0,
          paymentType: checkoutTransaction?.paymentType?.name,
          totalDue:
              ((checkoutTransaction?.totalValue ?? 0) +
                  (checkoutTransaction?.cashbackAmount ?? 0) +
                  (checkoutTransaction?.tipAmount ?? 0)) -
              (checkoutTransaction?.totalDiscount ?? 0),
          taxInclusive: checkoutTransaction?.taxInclusive ?? false,
        ),
        // This is to have the reprint flags on transactions that already exists and not new ones
        // This will only be a header on transactions that are existing and not on new transactions
        // On our custom prints
        reprintHeaderRequired: isReprint,
      );
    } catch (e) {
      rethrow;
    }
    return pResult;
  }

  Future<PaymentPrintResult> printRefund() async {
    try {
      final transactionNr =
          refundTransaction?.transactionNumber?.toStringAsFixed(0) ?? '';
      pResult = await posPrintService.printRefund(
        PrinterRequestInterface(
          transactionID: 'Refund # $transactionNr',
          footer: profile?.receiptData?.footer ?? '',
          website: profile?.website ?? '',
          transactionTime: TextFormatter.toTimeFormat(
            dateTime: refundTransaction?.transactionDate?.toLocal(),
          ),
          transactionDate: TextFormatter.toFullDate(
            dateTime: refundTransaction?.transactionDate?.toLocal(),
          ),
          customerName: refundTransaction?.customerName ?? '',
          customerMobile: refundTransaction?.customerMobile ?? '',
          customerEmail: refundTransaction?.customerEmail ?? '',
          customerId: refundTransaction?.customerId ?? '',
          sellerId: refundTransaction?.sellerId ?? '',
          sellerName: refundTransaction?.sellerName ?? '',
          currencyCode:
              LocaleProvider.instance.currencyCode ??
              LocaleProvider.instance.currentLocale?.currencyCode ??
              'R',
          whatsapp: profile?.receiptData?.displayWhatsappLine != null
              ? profile!.receiptData!.displayWhatsappLine
                    ? profile?.whatsappLine ?? ''
                    : ''
              : '',
          instagram: profile?.receiptData?.displayInstagramHandle != null
              ? profile!.receiptData!.displayInstagramHandle
                    ? profile!.instagramHandle ?? ''
                    : ''
              : '',
          displayCustomer:
              AppVariables
                  .store
                  ?.state
                  .businessState
                  .profile
                  ?.receiptData
                  ?.displayCustomer ??
              false,
          displaySeller:
              AppVariables
                  .store
                  ?.state
                  .businessState
                  .profile
                  ?.receiptData
                  ?.displaySeller ??
              false,
          items: mapToRefundInventoryList(refundTransaction?.items),
          address: mapToPrintAddress(profile?.address),
          businessName: AppVariables.businessName,
          totalValue: refundTransaction?.totalRefund ?? 0.0,
          taxValue: 0.0,
          totalCost: refundTransaction?.totalRefundCost ?? 0.0,
          totalDiscount: 0.0,
          totalTax: 0.0,
          amountChange: 0.0,
          tell: profile?.phoneNumber ?? '',
          header: profile?.receiptData?.header ?? '',
          totalMarkup: 0.0,
          amountTendered: refundTransaction?.totalRefund ?? 0.0,
          cashbackAmount: 0,
          tipAmount: 0,
          withdrawalAmount: 0,
          paymentType: refundTransaction?.paymentType?.name,
          totalDue: refundTransaction?.totalRefund ?? 0.0,
          taxInclusive: false,
        ),
      );
    } catch (e) {
      rethrow;
    }
    return pResult;
  }

  setTransaction(CheckoutTransaction? value) => checkoutTransaction = value;
  setRefundTransaction(Refund? value) => refundTransaction = value;
}
