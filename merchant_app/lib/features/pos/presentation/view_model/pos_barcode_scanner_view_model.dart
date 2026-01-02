// removed ignore: depend_on_referenced_packages, implementation_imports
import 'package:flutter/cupertino.dart';
import 'package:littlefish_core/hardware/scanners/littlefish_scanner.dart';
import 'package:littlefish_interfaces/scan_result_interface.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:redux/src/store.dart';

import '../../../../common/view_models/store_collection_viewmodel.dart';
import '../../data/data_source/pos_service.dart';

class PosBarcodeScannerViewModel extends StoreViewModel<AppState> {
  final Function(String? value)? onItemScanned;
  late PosService posScanService;
  late ScanResultInterface scanResultInterface;

  @override
  PosBarcodeScannerViewModel.fromStore(
    Store<AppState>? store, {
    this.onItemScanned,
    BuildContext? context,
  }) : super.fromStore(store, context: context);

  @override
  loadFromStore(Store<AppState>? store, {BuildContext? context}) {
    posScanService = PosService.fromStore(store: store);
    isLoading ??= false;
  }

  Future<ScanResultInterface> scanHW({required ScanMode scanMode}) async {
    final callResult = await posScanService.scanHW(scanMode: scanMode);
    scanResultInterface = callResult;
    onItemScanned!(scanResultInterface.resultString);
    return scanResultInterface;
  }

  Future<ScanResultInterface> scan() async {
    final callResult = await posScanService.scan();
    scanResultInterface = callResult;
    onItemScanned!(scanResultInterface.resultString);
    return scanResultInterface;
  }
}
