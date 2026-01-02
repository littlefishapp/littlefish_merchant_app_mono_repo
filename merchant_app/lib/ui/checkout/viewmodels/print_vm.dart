// Flutter imports:
// remove ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/sales/checkout/checkout_transaction.dart';
import 'package:littlefish_merchant/models/store/business_profile.dart';
import 'package:littlefish_merchant/models/store/receipt_data.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/ui/checkout/pages/select_printer_page.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/view_models/store_collection_viewmodel.dart';

// import 'package:littlefish_printer_driver/littlefish_printer_driver.dart';

class PrintVM extends StoreViewModel<AppState> {
  PrintVM.fromStore(Store<AppState> store, {BuildContext? context})
    : super.fromStore(store, context: context);

  List<dynamic>? configuredPrinters;
  Future<bool> get hasPrinters async {
    //var hardwareProvider = HardwareProvider.instance;
    // await hardwareProvider.initialize();
    // await hardwareProvider.populate(refresh: true);
    // return hardwareProvider.hasPrinter;
    return false;
  }

  // dynamic selectedPrinter;
  ReceiptData? receipt;
  BusinessProfile? businessProfile;
  late Function(CheckoutTransaction? setReceipt) setReceipt;
  Function(ReceiptData receipt)? printReceipt;

  bool defaultSelected() =>
      configuredPrinters?.any((dynamic pr) => pr.isDefault == true) ?? false;

  dynamic getDefault() =>
      configuredPrinters!.firstWhere((x) => x.isDefault == true);

  void debugPrint(BuildContext ctx) async {
    if (configuredPrinters == null || configuredPrinters!.isEmpty) {
      showMessageDialog(
        ctx,
        'Please setup a printer in the settings area before attempting to print receipt',
        LittleFishIcons.info,
      );
      return;
    } else if (!(await hasPrinters)) {
      showMessageDialog(
        ctx,
        'Please connect a printer and try again',
        LittleFishIcons.info,
      );
      return;
    }

    if (defaultSelected()) {
      var printer = getDefault();
      // printer.setPrinterDevice();
      _print(printer);
    } else {
      showPopupDialog<dynamic>(
        context: ctx,
        content: SelectPrinterPage(parentContext: ctx, vm: this),
      ).then((printer) async {
        if (printer != null) _print(printer);
      });
    }
  }

  void _print(dynamic printer) async {
    printer.setPrinterDevice();
    await printer.configurePrinter();
    printer.printReceipt(receipt);
  }

  @override
  loadFromStore(Store<AppState>? store, {BuildContext? context}) async {
    this.store = store;
    state = store!.state;
    configuredPrinters = [];
    //state.hardwareState?.configuredPrinters;
    businessProfile = store.state.businessState.profile;

    setReceipt = (transaction) async {
      // var lineItems = _createLineItems(transaction);
      receipt = ReceiptData(
        // items: lineItems,
        // businessName: businessProfile.name,
        // cartTotal: transaction.checkoutTotal,
        // sellerName: transaction.sellerName,
        // totalDiscount: transaction.totalDiscount,
        // totalQuantity: transaction.totalQty,
        // transactionNumber: transaction.transactionNumber,
        // businessContactNumber: businessProfile?.contactDetails?.value,
        // customerEmail: transaction.customerEmail,
        // customerName: transaction.customerName,
        // totalTax: transaction.totalTax,
        header: businessProfile?.receiptData?.header ?? '',
        footer: businessProfile?.receiptData?.footer,
      );
      // BasePrinter print =
      //     PrinterManager().getPrinter(model: InterfaceType.escPos);
      // await print.configure(
      //     (await PrinterManager().getDevices(ConnectionType.usb)).first);
      // print.printReceipt(receiptData);
    };
  }

  // _createLineItems(CheckoutTransaction trans) => trans.items
  //     .map(
  //       (item) => LineItem(
  //           value: item.itemValue,
  //           productName: item.description,
  //           quantity: item.quantity),
  //     )
  //     .toList();
}
