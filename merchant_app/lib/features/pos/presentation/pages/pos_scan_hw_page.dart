import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_core/hardware/scanners/littlefish_scanner.dart';
import 'package:littlefish_interfaces/scan_result_interface.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/features/multi_cart_item_infrared_barcode_scanner/data/multi_item_infrared_barcode_scanner.dart';
import 'package:littlefish_merchant/features/multi_cart_item_infrared_barcode_scanner/presentation/viewmodel/pos_multi_barcode_scanner_vm.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';

import '../../../../common/presentaion/components/app_progress_indicator.dart';
import '../../../../common/presentaion/components/buttons/button_secondary.dart';
import '../../../../common/presentaion/components/common_divider.dart';
import '../../../../common/presentaion/components/decorated_text.dart';
import '../../../../common/presentaion/pages/scaffolds/app_scaffold.dart';
import '../view_model/pos_barcode_scanner_view_model.dart';
import 'package:littlefish_core/logging/services/logger_service.dart';
import 'package:littlefish_core/core/littlefish_core.dart';

class PosScanHWPage extends StatefulWidget {
  final BuildContext? parentContext;

  const PosScanHWPage(this.parentContext, {Key? key}) : super(key: key);

  @override
  State<PosScanHWPage> createState() => _PosScanHWPageState();
}

class _PosScanHWPageState extends State<PosScanHWPage> {
  LoggerService get logger => LittleFishCore.instance.get<LoggerService>();
  PosBarcodeScannerViewModel? vm;
  BuildContext? parentContext;
  LittleFishCore get core => LittleFishCore.instance;

  Future<ScanResultInterface> doScan() async {
    var result = ScanResultInterface();

    if (AppVariables.laserScanningSupported &&
        core.isRegistered<MultiCartItemInfraBarcodeScanner>()) {
      result = await vm!.posScanService.scanHW(scanMode: ScanMode.singleScan);
    } else {
      result = await vm!.posScanService.scan();
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    parentContext = widget.parentContext;
    vm ??=
        PosBarcodeScannerViewModel.fromStore(
            StoreProvider.of<AppState>(context),
            context: context,
            onItemScanned: (barcode) {
              if (vm!.scanResultInterface.resultString.contains(
                    'Execution timeout',
                  ) ||
                  vm!.scanResultInterface.resultFormat.contains(
                    'Execution timeout',
                  )) {
                return false;
              } else {
                Navigator.of(context).pop(barcode);
              }
            },
          )
          ..onLoadingChanged = () {
            if (mounted) setState(() {});
          };

    return PopScope(
      canPop: true,
      child: AppScaffold(
        displayBackNavigation: false,
        title: 'Scan Barcode',
        centreTitle: true,
        body: FutureBuilder<ScanResultInterface>(
          future: doScan(),
          builder:
              (
                BuildContext context,
                AsyncSnapshot<ScanResultInterface> snapshot,
              ) {
                if (snapshot.hasData && snapshot.data != null) {
                  if (snapshot.data!.resultString.toLowerCase().contains(
                    'execution timeout',
                  )) {
                    AudioPlayer().play(AssetSource('sounds/beep_error.m4a'));
                    return layout(context, vm);
                  } else {
                    Navigator.of(context).pop(snapshot.data!.resultString);
                    return const SizedBox.shrink();
                  }
                } else {
                  return const Center(
                    child: Column(
                      children: [
                        Spacer(),
                        AppProgressIndicator(),
                        Spacer(),
                        DecoratedText(
                          'Scanning...',
                          alignment: Alignment.center,
                          fontSize: null,
                          textColor: Colors.grey,
                        ),
                        Spacer(),
                      ],
                    ),
                  );
                }
              },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  Widget layout(context, PosBarcodeScannerViewModel? vm) {
    final widthUsed = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const CommonDivider(),
            const SizedBox(height: 16),
            SizedBox(
              height: 25,
              width: widthUsed,
              child: const Center(child: DecoratedText('Timeout')),
            ),
            const CommonDivider(),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
              width: widthUsed / 3,
              child: ButtonSecondary(
                text: 'Cancel',
                onTap: (tapContext) {
                  vm!.scanResultInterface = ScanResultInterface();
                  Navigator.of(tapContext).pop();
                },
              ),
            ),
            SizedBox(
              width: widthUsed / 3,
              child: ButtonPrimary(
                text: 'Retry',
                onTap: (ontapContext) {
                  setState(() {
                    vm!.scanResultInterface = ScanResultInterface();
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
