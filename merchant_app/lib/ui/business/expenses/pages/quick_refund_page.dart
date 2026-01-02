// remove ignore_for_file: use_build_context_synchronously

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/services/modal_service.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/business/expenses/pages/quick_refund_payment_page.dart';
import 'package:littlefish_merchant/ui/checkout/viewmodels/checkout_viewmodels.dart';
import 'package:littlefish_merchant/common/presentaion/components/custom_keypad.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/app/custom_route.dart';
import 'package:quiver/strings.dart';

class QuickRefundPage extends StatelessWidget {
  static const route = 'quick_refund';
  final bool isEmbedded;
  final String? sourcePageRoute;

  const QuickRefundPage({
    Key? key,
    this.isEmbedded = false,
    this.sourcePageRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CheckoutVM>(
      converter: (store) => CheckoutVM.fromStore(store),
      builder: (context, vm) {
        return PopScope(
          canPop: false,
          onPopInvoked: (bool didPop) async {
            if (didPop) {
              return;
            }

            bool? shouldPop = await shouldPopDialog(context);

            if (shouldPop == true) {
              vm.onClear();
              vm.clearRefund();
              Navigator.of(context).pop();
            }

            return;
          },
          child: layout(context, vm),
        );
      },
    );
  }

  layout(ctx, CheckoutVM vm) => vm.isLoading!
      ? _pageLoader(ctx)
      : CustomKeyPad(
          isDescriptionRequired: false,
          initialDescriptionValue: vm.state?.quickRefund?.description ?? '',
          initialValue: vm.state?.quickRefund?.totalRefund ?? 0,
          parentContext: ctx,
          confirmButtonText: 'CONTINUE TO REFUND',
          key: key ?? GlobalKey(),
          enableAppBar: true,
          title: 'Quick Refund',
          confirmErrorMessage: 'Please enter the amount to be refunded',
          isFullPage: true,
          enableChange: false,
          enableDescription: true,
          onSubmit: (value, description) async {
            if (value > 0) {
              String descript = description == null || description.isEmpty
                  ? 'Quick Refund'
                  : description;

              vm.setQuickRefundAmount(Decimal.parse(value.toString()));
              vm.setQuickRefundDescription(descript);
              await Navigator.of(ctx).push(
                CustomRoute(
                  builder: (BuildContext ctx) => QuickRefundPaymentMethodPage(
                    refund: vm.state!.quickRefund!,
                    isEmbedded: false,
                    sourcePageRoute: sourcePageRoute,
                  ),
                ),
              );
            }
          },
          onValueChanged: (value) {
            // vm.setQuickRefundAmount(value);
          },
          onDescriptionChanged: (description) {
            // vm.setQuickRefundDescription(description);
          },
        );

  Container _pageLoader(ctx) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: AppProgressIndicator(
        backgroundColor: Theme.of(ctx).colorScheme.background,
        hasScaffold: true,
      ),
    );
  }

  Future<bool?> shouldPopDialog(BuildContext ctx) async =>
      await getIt<ModalService>().showActionModal(
        title: 'Cancel Refund',
        context: ctx,
        description:
            'Are you sure you want to return? You will lose your progress.',
        status: StatusType.destructive,
      );
}
