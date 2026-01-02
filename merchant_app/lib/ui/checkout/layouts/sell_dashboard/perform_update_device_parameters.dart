import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/features/pos/data/data_source/pos_service.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:redux/redux.dart';

class PerformUpdateDeviceParameters extends StatefulWidget {
  static const route = '/update-device-parameters-dialog';
  const PerformUpdateDeviceParameters({super.key});

  @override
  State<PerformUpdateDeviceParameters> createState() =>
      _PerformUpdateDeviceParametersState();
}

class _PerformUpdateDeviceParametersState
    extends State<PerformUpdateDeviceParameters> {
  var isTablet = false;

  Future<bool>? _closeBatchFuture;

  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      if (_closeBatchFuture == null) {
        final store = StoreProvider.of<AppState>(context);
        _closeBatchFuture = futureAction(store);
      }
      _isInitialized = true;
    }
  }

  Future<bool> futureAction(Store<AppState> store) async {
    debugPrint('### PerformUpdateDeviceParameters: futureAction entry');
    try {
      var posService = PosService.fromStore(store: store);
      final result = await posService.updateDeviceParameters();
      debugPrint('### PerformUpdateDeviceParameters: futureAction $result');
      return result;
    } catch (e) {
      var message = 'Update Unsuccessful';
      debugPrint('###  PerformUpdateDeviceParameters $e');
      if (e is PlatformException) {
        message = e.details ?? message;
      } else if (e is Exception) {
        message = e.toString();
      }
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => showMessageDialog(
          context,
          'Update cannot be done currently',
          Icons.cancel,
        ).then((value) => Navigator.of(context).pop()),
      );
      return false; // TODO
    }
  }

  @override
  Widget build(BuildContext context) {
    isTablet = EnvironmentProvider.instance.isLargeDisplay ?? false;
    return StoreBuilder(
      builder: (BuildContext context, Store<AppState> store) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return FutureBuilder<bool>(
              future: _closeBatchFuture,
              builder: (context, snapshot) {
                debugPrint(
                  '#### PerformUpdateDeviceParameters: '
                  '${snapshot.connectionState}',
                );

                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData && snapshot.data == true) {
                    WidgetsBinding.instance.addPostFrameCallback((_) async {
                      await showMessageDialog(
                        context,
                        'Device parameters updated successfully',
                        Icons.done,
                      );
                      Navigator.of(context).pop();
                    });
                  } else {
                    WidgetsBinding.instance.addPostFrameCallback((_) async {
                      await showMessageDialog(
                        context,
                        'Failed to update device parameters',
                        Icons.cancel,
                      );
                      Navigator.of(context).pop();
                    });
                  }
                }
                return loadingScaffold();
              },
            );
          },
        );
      },
    );
  }

  Widget mobileScaffold({
    required BuildContext context,
    required Store<AppState> store,
    required BoxConstraints constraints,
  }) {
    return AppScaffold(title: 'Update Device Parameters', body: scaffoldBody());
  }

  Widget tabletScaffold({
    required BuildContext context,
    required Store<AppState> store,
    required BoxConstraints constraints,
  }) {
    return AppScaffold(title: 'Closing Batch', body: scaffoldBody());
  }

  Widget loadingScaffold() {
    return const AppScaffold(body: AppProgressIndicator());
  }

  Widget scaffoldBody() {
    return Container(
      color: Theme.of(context).extension<AppliedSurface>()!.primary,
      child: const AppProgressIndicator(),
    );
  }
}
