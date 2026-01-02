import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/pages/HomePage/online_store_main_home_page.dart';

import '../../../../../app/custom_route.dart';
import '../../../../../app/theme/applied_system/applied_text_icon.dart';
import '../../../../../common/presentaion/components/app_progress_indicator.dart';
import '../../../../../common/presentaion/components/cards/card_square_flat.dart';
import '../../../../../common/presentaion/pages/scaffolds/app_scaffold.dart';
import '../../../../../features/order_complete_pages/presentation/components/transaction_success_display_section.dart';
import '../../../../../features/order_fulfilment /presentation/components/confirm_cancel_buttons.dart';
import '../../../../../redux/app/app_state.dart';
import '../../redux/viewmodels/manage_store_vm_v2.dart';

class SubmittedForReviewPage extends StatefulWidget {
  const SubmittedForReviewPage({super.key});

  @override
  State<SubmittedForReviewPage> createState() => _SubmittedForReviewPageState();
}

class _SubmittedForReviewPageState extends State<SubmittedForReviewPage> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ManageStoreVMv2>(
      converter: (store) => ManageStoreVMv2.fromStore(store),
      onInit: (store) async {
        ManageStoreVMv2.fromStore(store).submitStoreForReview(context);
      },
      builder: (BuildContext context, ManageStoreVMv2 vm) {
        return scaffold(vm, context);
      },
    );
  }

  scaffold(ManageStoreVMv2 vm, BuildContext context) {
    return AppScaffold(
      backgroundColor: Theme.of(context).extension<AppliedSurface>()?.primary,
      title: 'Submitted for Review',
      displayBackNavigation: false,
      displayNavBar: vm.store!.state.enableBottomNavBar!,
      hasDrawer: vm.store!.state.enableSideNavDrawer!,
      displayNavDrawer: vm.store!.state.enableSideNavDrawer!,
      centreTitle: false,
      persistentFooterButtons: [
        ConfirmCancelButtons(
          showCancelButton: false,
          confirmText: 'Close',
          onCancel: () {},
          onConfirm: () async {
            Navigator.of(context).pushReplacement(
              CustomRoute(builder: (ctx) => const OnlineStoreMainHomePage()),
            );
          },
        ),
      ],
      body: vm.isLoading != true
          ? layout(vm, context)
          : const AppProgressIndicator(),
    );
  }

  layout(ManageStoreVMv2 vm, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const TransactionSuccessDisplaySection(
              message: 'Store Published Successfully',
            ),
            CardSquareFlat(
              margin: const EdgeInsets.all(16.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    context.labelLarge(
                      'Your store is now under review.',
                      color: Theme.of(
                        context,
                      ).extension<AppliedTextIcon>()?.secondary,
                      isBold: true,
                      alignLeft: true,
                    ),
                    const SizedBox(height: 16),
                    context.paragraphMedium(
                      'Congratulations! You have successfully completed '
                      'your online store setup. Before you can start '
                      'trading online, your store will need to be reviewed '
                      'by your bank. This process will take 48 hours. '
                      'In the meantime, you can continue to trade in-store using '
                      'your point-of-sale devices. ',
                      color: Theme.of(
                        context,
                      ).extension<AppliedTextIcon>()?.deEmphasized,
                      alignLeft: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
