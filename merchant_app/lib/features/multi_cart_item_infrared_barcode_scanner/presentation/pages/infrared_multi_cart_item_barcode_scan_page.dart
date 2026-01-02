import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_interfaces/scan_result_interface.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/features/multi_cart_item_infrared_barcode_scanner/data/multi_item_infrared_barcode_scanner.dart';
import 'package:littlefish_merchant/features/multi_cart_item_infrared_barcode_scanner/presentation/components/barcode_product_not_found_banner.dart';
import 'package:littlefish_merchant/features/multi_cart_item_infrared_barcode_scanner/presentation/components/scanned_item_list_tile.dart';
import 'package:littlefish_merchant/features/multi_cart_item_infrared_barcode_scanner/presentation/components/scanner_has_error_banner.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:redux/redux.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';

import '../components/infrared_multi_scan_add_to_cart_btn.dart';
import '../components/infrared_multi_scan_cancel_btn.dart';
import '../components/scanner_is_active_banner.dart';

class InfraredMultiCartItemBarcodeScanPage extends StatefulWidget {
  const InfraredMultiCartItemBarcodeScanPage({super.key});

  @override
  State<InfraredMultiCartItemBarcodeScanPage> createState() =>
      _InfraredMultiCartItemBarcodeScanPageState();
}

class _InfraredMultiCartItemBarcodeScanPageState
    extends State<InfraredMultiCartItemBarcodeScanPage> {
  Future<ScanResultInterface> getFuture({
    required MultiCartItemInfraBarcodeScanner vm,
    required BuildContext context,
  }) async {
    try {
      final result = await vm.scan(context: context);
      debugPrint(
        '### Scanner InfraredMultiCartItemBarcodeScanPage '
        'getFuture: ${result.resultString}',
      );
      return result;
    } catch (e) {
      debugPrint(
        '### Scanner InfraredMultiCartItemBarcodeScanPage getFuture: $e',
      );
    }
    return ScanResultInterface(resultString: 'Error');
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('### Scanner InfraredMultiCartItemBarcodeScanPage build');
    return StoreConnector(
      converter: (Store<AppState> store) {
        final vm = getIt.get<MultiCartItemInfraBarcodeScanner>();
        vm.loadFromStore(store, context: context);
        vm.onItemScanned = _onItemScanned;
        vm.refresUI = refreshUI;
        vm.beepOnce = beepOnce;
        vm.dismissScanner = dismissScanner;
        debugPrint(
          '### Scanner InfraredMultiCartItemBarcodeScanPage '
          'redux converter ${DateTime.now().millisecondsSinceEpoch}',
        );
        return vm;
      },
      builder: (context, MultiCartItemInfraBarcodeScanner vm) {
        return _layout(vm);
      },
    );
  }

  Widget _layout(MultiCartItemInfraBarcodeScanner vm) {
    debugPrint(
      '### Scanner InfraredMultiCartItemBarcodeScanPage'
      ' redux builder ${DateTime.now().millisecondsSinceEpoch}',
    );

    return AppScaffold(
      displayBackNavigation: true,
      title: 'Scan Items',
      onBackPressed: () {
        vm.cancelScan(context: context);
      },
      body: FutureBuilder<ScanResultInterface>(
        future: getFuture(vm: vm, context: context),
        builder: (context, snapshot) {
          debugPrint(
            '### Scanner InfraredMultiCartItemBarcodeScanPage '
            'snapshot: ${snapshot.connectionState}',
          );
          var hasItems = (vm.scannedItems?.isNotEmpty ?? false);
          final hasError = snapshot.hasError;
          final noProductFound =
              snapshot.hasData &&
              snapshot.data!.resultString == vm.notFoundText;
          final isActive = !hasError && !noProductFound;
          if (snapshot.connectionState == ConnectionState.done) {
            Future.delayed(const Duration(milliseconds: 500), () {
              refreshUI();
              if (isActive) {}
            });
          }
          return Column(
            children: [
              if (hasError)
                ScannerHasErrorBanner(
                  retryCallback: () {
                    setState(() {});
                  },
                ),
              if (noProductFound) const BarcodeProductNotFoundBanner(),
              if (isActive) const ScannerIsActiveBanner(),
              hasItems ? _bodyWithListItems(vm) : _bodyWithoutItems(),
            ],
          );
        },
      ),
      persistentFooterButtons: [
        Row(
          children: [
            InfraredMultiScanCancelBtn(vm),
            const SizedBox(width: 10),
            InfraredMultiScanAddToCartBtn(vm),
          ],
        ),
      ],
    );
  }

  Widget _bodyWithListItems(MultiCartItemInfraBarcodeScanner vm) {
    return ListView.builder(
      itemCount: (vm.scannedItems?.length ?? 0),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        var item = vm.scannedItems![index];
        return ScannedItemListTile(vm: vm, context: context, item: item);
      },
    );
  }

  Widget _bodyWithoutItems() {
    return const Expanded(child: Center(child: Text('Please Scan Items')));
  }

  Future<void> _onItemScanned(String value) async {
    debugPrint(
      '### Scanner InfraredMultiCartItemBarcodeScanPage '
      ' onItemScanned value: $value',
    );

    if (value.isNotEmpty) {
      beepOnce();
      setState(() {});
      //Delay to prevent rapid scanning of the same item more than once
      await Future.delayed(const Duration(seconds: 500), () {});
      return;
    }

    setState(() {});
  }

  void refreshUI() {
    debugPrint('### Scanner InfraredMultiCartItemBarcodeScanPage refreshUI');
    if (context.mounted) {
      setState(() {});
    }
  }

  void dismissScanner() {
    debugPrint(
      '### Scanner InfraredMultiCartItemBarcodeScanPage dismissScanner',
    );
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  void beepOnce() {
    debugPrint('### Scanner InfraredMultiCartItemBarcodeScanPage beep');
    AudioPlayer().play(AssetSource('sounds/beep.m4a'), volume: 1.0);
  }
}
