// removed ignore: depend_on_referenced_packages, implementation_imports
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:littlefish_core/business/models/business_user.dart';
import 'package:littlefish_interfaces/inventory_interface.dart';
import 'package:littlefish_interfaces/print_address_interface.dart';
import 'package:littlefish_interfaces/printer_request_interface.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order_line_item.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order_refund.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order_refund_line_item.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order_transaction.dart';
import 'package:littlefish_merchant/features/order_transaction_history/presentation/redux/middleware/order_transaction_history_middleware.dart';
import 'package:littlefish_merchant/models/shared/data/address.dart'
    as profile_address;
import 'package:littlefish_merchant/models/store/business_profile.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_payments/models/shared/payment_gateway.dart';
import 'package:redux/src/store.dart';

import '../../../../common/view_models/store_collection_viewmodel.dart';
import '../../data/data_source/pos_service.dart';

class OrderPosPrintVM extends StoreViewModel<AppState> {
  late PosService posPrintService;
  Order? order;
  OrderRefund? refund;
  OrderTransaction? transaction;
  late PaymentPrintResult pResult;
  late BusinessProfile? profile;
  late String? imageUrl;

  @override
  OrderPosPrintVM.fromStore(Store<AppState>? store, {BuildContext? context})
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

  List<InventoryInterface> mapToInventoryList(List<OrderLineItem>? items) {
    List<InventoryInterface> list = [];
    if (items == null) {
      return list;
    }
    for (var element in items) {
      list.add(
        InventoryInterface(
          itemDescription: element.displayName,
          quantity: element.quantity.toInt(),
          price: element.unitPrice,
        ),
      );
    }
    return list;
  }

  List<InventoryInterface> mapToRefundInventoryList(
    List<OrderRefundLineItem>? items,
  ) {
    List<InventoryInterface> list = [];
    for (var element in items!) {
      list.add(
        InventoryInterface(
          itemDescription: element.name,
          quantity: element.quantity.toInt(),
          price:
              order?.orderLineItems
                  .firstWhereOrNull(
                    (lineItem) => lineItem.productId == element.productId,
                  )
                  ?.unitPrice ??
              0.0,
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

  Future<PaymentPrintResult> print() async {
    try {
      BusinessUser? seller = await getSalesConsultant(
        store: AppVariables.store!,
        id: transaction?.createdBy ?? '',
      );
      pResult = await posPrintService.print(
        PrinterRequestInterface(
          transactionID:
              transaction?.transactionNumber.toStringAsFixed(0) ?? '',
          footer: profile?.receiptData?.footer ?? '',
          website: profile?.website ?? '',
          transactionTime: TextFormatter.toTimeFormat(
            dateTime: transaction?.dateCreated,
          ),
          transactionDate: TextFormatter.toFullDate(
            dateTime: transaction?.dateCreated,
          ),
          customerName: transaction?.customer.firstName ?? '',
          customerMobile: transaction?.customer.mobileNumber ?? '',
          customerEmail: transaction?.customer.email ?? '',
          customerId: transaction?.customer.id ?? '',
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
          sellerId: seller?.id ?? '',
          sellerName: seller?.name ?? '',
          currencyCode: 'R',
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
          items: mapToInventoryList(order?.orderLineItems),
          address: mapToPrintAddress(profile?.address),
          businessName: profile?.name ?? '',
          totalValue: transaction?.amount ?? 0.0,
          taxValue: order?.totalTax ?? 0.0,
          totalCost: order?.totalCost ?? 0.0,
          totalDiscount: order?.totalDiscount ?? 0.0,
          totalTax: order?.totalTax ?? 0.0,
          amountChange: order?.totalChange ?? 0.0,
          tell: profile?.phoneNumber ?? '',
          header: profile?.receiptData?.header ?? '',
          totalMarkup: 0.0,
          amountTendered: order?.totalAmountPaid ?? 0,
          cashbackAmount: order?.totalCashBack ?? 0,
          tipAmount: order?.totalTip ?? 0,
          withdrawalAmount: order?.totalWithdrawal ?? 0,
          paymentType: transaction?.paymentType.acceptanceChannel.name,
          totalDue: order?.orderTotal ?? 0.0,
          taxInclusive: false,
        ),
      );
    } catch (e) {
      rethrow;
    }
    return pResult;
  }

  Future<PaymentPrintResult> printRefund() async {
    try {
      BusinessUser? seller = await getSalesConsultant(
        store: AppVariables.store!,
        id: transaction?.createdBy ?? '',
      );
      pResult = await posPrintService.printRefund(
        PrinterRequestInterface(
          transactionID: transaction?.id ?? '',
          footer: profile?.receiptData?.footer ?? '',
          website: profile?.website ?? '',
          transactionTime: TextFormatter.toTimeFormat(
            dateTime: transaction?.dateCreated,
          ),
          transactionDate: TextFormatter.toFullDate(
            dateTime: transaction?.dateCreated,
          ),
          customerName: transaction?.customer.firstName ?? '',
          customerMobile: transaction?.customer.mobileNumber ?? '',
          customerEmail: transaction?.customer.email ?? '',
          customerId: transaction?.customer.id ?? '',
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
          sellerId: seller?.id ?? '',
          sellerName: seller?.name ?? '',
          currencyCode: 'R',
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
          items: mapToRefundInventoryList(refund?.refundLineItems),
          address: mapToPrintAddress(profile?.address),
          businessName: profile?.name ?? '',
          totalValue: refund?.totalPrice ?? 0.0,
          taxValue: 0.0,
          totalCost: 0.0,
          totalDiscount: 0.0,
          totalTax: 0.0,
          amountChange: 0.0,
          tell: profile?.phoneNumber ?? '',
          header: profile?.receiptData?.header ?? '',
          totalMarkup: 0.0,
          amountTendered: transaction?.amountTendered ?? 0.0,
          cashbackAmount: 0,
          tipAmount: 0,
          withdrawalAmount: 0,
          paymentType: transaction?.paymentType.acceptanceChannel.name,
          totalDue: transaction?.amount ?? 0.0,
          taxInclusive: true,
        ),
      );
    } catch (e) {
      rethrow;
    }
    return pResult;
  }

  setOrder(Order? value) => order = value;

  setRefund(OrderRefund? value) => refund = value;

  setTransaction(OrderTransaction? value) => transaction = value;
}
