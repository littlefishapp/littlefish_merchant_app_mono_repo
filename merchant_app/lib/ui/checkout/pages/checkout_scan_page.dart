// Flutter imports:
// remove ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_core/logging/services/logger_service.dart';
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';

// Project imports:
import 'package:littlefish_merchant/ui/checkout/viewmodels/checkout_scan_viewmodel.dart';
import 'package:littlefish_merchant/ui/checkout/widgets/checkout_scan.dart';

import '../../../common/presentaion/components/app_progress_indicator.dart';
import '../../../common/presentaion/components/dialogs/services/modal_service.dart';
import '../../../common/presentaion/pages/scaffolds/app_scaffold.dart';
import '../../../injector.dart';
import '../../../models/enums.dart';
import '../../../redux/app/app_state.dart';

class CheckoutScanPage extends StatefulWidget {
  const CheckoutScanPage({Key? key}) : super(key: key);

  @override
  State<CheckoutScanPage> createState() => _CheckoutScanPageState();
}

class _CheckoutScanPageState extends State<CheckoutScanPage> {
  LoggerService get logger => LittleFishCore.instance.get<LoggerService>();

  CheckoutScanViewModel? vm;
  bool enableTorch = false;

  @override
  void initState() {
    super.initState();
    vm = CheckoutScanViewModel(context: context);
    ;
  }

  Future<bool> _getBarcodeScannerPermissions({
    required BuildContext context,
    required CheckoutScanViewModel? vm,
  }) async {
    logger.debug(
      'ui.checkout.scan',
      'Starting barcode scanner permissions check',
    );
    var scanPermission = await vm?.scanAllowed ?? false;
    if (scanPermission) {
      logger.debug('ui.checkout.scan', 'Barcode scanner permissions granted');
      return true;
    } else {
      scanPermission = await vm?.requestScanPermission() ?? false;

      if (scanPermission == true && mounted) {
        StoreProvider.of<AppState>(
          context,
        ).state.productState.rebuild((p0) => null);
        logger.debug(
          'ui.checkout.scan',
          'Barcode scanner permissions requested and granted',
        );
        return true;
      } else {
        return false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    logger.debug('ui.checkout.scan', 'Building CheckoutScanPage');

    return FutureBuilder<bool>(
      future: _getBarcodeScannerPermissions(context: context, vm: vm),
      builder: (ctx, snapshot) {
        logger.debug(
          'ui.checkout.scan',
          'CheckoutScan permission check state: ${snapshot.connectionState}',
        );
        if (snapshot.connectionState != ConnectionState.done) {
          return const AppProgressIndicator();
        } else if (snapshot.data != null && snapshot.data! == false) {
          return noAccessCamera(context);
        }
        return scaffold(context);
      },
    );
  }

  Widget scaffold(context) {
    final isTablet = EnvironmentProvider.instance.isLargeDisplay ?? false;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final showSideNav =
        isTablet || (AppVariables.store!.state.enableSideNavDrawer ?? false);
    return AppScaffold(
      onBackPressed: () async {
        if (vm!.scannedItems.isEmpty) {
          Navigator.of(context).pop();
        } else {
          bool? continueAction = await confirmClearAction(context);

          if (continueAction) {
            Navigator.of(context).pop();
          }
        }
      },
      title: 'Scan Items',
      enableProfileAction: !showSideNav,
      hasDrawer: false,
      displayNavDrawer: false,
      body: CheckoutScan(
        vm: vm,
        onClearTap: () async => await confirmClearAction(context),
      ),
    );
  }

  Future<bool> confirmClearAction(context) async {
    final modalService = getIt<ModalService>();

    final bool? continueAction = await modalService.showActionModal(
      context: context,
      title: 'Warning',
      description:
          'This action will clear the list of scanned products. Contiue?',
      status: StatusType.warning,
      acceptText: 'Yes, clear',
      cancelText: 'No, dont clear',
    );
    return continueAction ?? false;
  }

  Widget torch() {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: InkWell(
        onTap: () {
          setState(() {
            debugPrint('### CameraView torch tapped');
            enableTorch = !enableTorch;
          });
        },
        child: enableTorch
            ? const Icon(Icons.flashlight_off)
            : const Icon(Icons.flashlight_on),
      ),
    );
  }

  Container noAccessCamera(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 5,
      color: Theme.of(context).colorScheme.error,
    );
  }
}
