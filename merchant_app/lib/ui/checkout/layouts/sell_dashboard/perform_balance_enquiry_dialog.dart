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

class PerformBalanceEnquiryDialog extends StatefulWidget {
  static const route = 'perform-balance-enquiry-dialog';
  const PerformBalanceEnquiryDialog({super.key});

  @override
  State<PerformBalanceEnquiryDialog> createState() =>
      _PerformBalanceEnquiryDialogState();
}

class _PerformBalanceEnquiryDialogState
    extends State<PerformBalanceEnquiryDialog> {
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
    debugPrint('### PerformBalanceEnquiryDialog: futureAction entry');
    try {
      var posService = PosService.fromStore(store: store);

      final result = await posService.balanceInquiry();
      debugPrint(
        '### PerformBalanceEnquiryDialog: futureAction result: $result  ',
      );

      debugPrint(
        '### PerformBalanceEnquiryDialog: '
        'futureAction result: $result',
      );
      return true;
    } catch (e) {
      var message = 'Batch Close Unsuccessful';
      debugPrint('###  PerformBalanceEnquiryDialog $e');
      if (e is PlatformException) {
        message = e.details ?? message;
      } else if (e is Exception) {
        message = e.toString();
      }
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => showMessageDialog(
          context,
          'Balance cannot be retrieved currently',
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
                  '#### PerformBalanceEnquiryDialog: '
                  '${snapshot.connectionState}',
                );
                if (snapshot.connectionState == ConnectionState.done) {
                  Navigator.of(context).pop();
                  return loadingScaffold();
                } else {
                  return isTablet
                      ? tabletScaffold(
                          context: context,
                          store: store,
                          constraints: constraints,
                        )
                      : mobileScaffold(
                          context: context,
                          store: store,
                          constraints: constraints,
                        );
                }
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
    return AppScaffold(title: 'Perform Balance Enquiry', body: scaffoldBody());
  }

  Widget tabletScaffold({
    required BuildContext context,
    required Store<AppState> store,
    required BoxConstraints constraints,
  }) {
    return AppScaffold(title: 'Perform Balance Enquiry', body: scaffoldBody());
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
