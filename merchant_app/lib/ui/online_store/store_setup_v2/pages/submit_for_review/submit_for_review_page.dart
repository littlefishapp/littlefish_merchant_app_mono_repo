import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/services/modal_service.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/pages/submit_for_review/submitted_for_review_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:littlefish_icons/littlefish_icons.dart';

import '../../../../../app/app.dart';
import '../../../../../app/custom_route.dart';
import '../../../../../common/presentaion/components/app_progress_indicator.dart';
import '../../../../../common/presentaion/components/buttons/button_primary.dart';
import '../../../../../common/presentaion/components/dialogs/common_dialogs.dart';
import '../../../../../common/presentaion/pages/scaffolds/app_scaffold.dart';
import '../../../../../features/order_fulfilment /presentation/components/confirm_cancel_buttons.dart';
import '../../../../../redux/app/app_state.dart';
import '../../redux/viewmodels/manage_store_vm_v2.dart';

class SubmitForReviewPage extends StatefulWidget {
  const SubmitForReviewPage({super.key});

  @override
  State<SubmitForReviewPage> createState() => _SubmitForReviewPageState();
}

class _SubmitForReviewPageState extends State<SubmitForReviewPage> {
  bool hasReviewed = false;
  final state = AppVariables.store?.state ?? AppState();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ManageStoreVMv2>(
      converter: (store) => ManageStoreVMv2.fromStore(store),
      builder: (BuildContext reduxContext, ManageStoreVMv2 vm) {
        return scaffold(vm, reduxContext);
      },
    );
  }

  scaffold(ManageStoreVMv2 vm, BuildContext context) {
    return AppScaffold(
      onBackPressed: () async {
        await vm.setConfigured(context, false);
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      },
      backgroundColor: Theme.of(context).colorScheme.background,
      title: 'Submit for Review',
      displayNavBar: vm.store!.state.enableBottomNavBar!,
      hasDrawer: vm.store!.state.enableSideNavDrawer!,
      centreTitle: false,
      persistentFooterButtons: [
        AppVariables.isPOSBuild
            ? ButtonPrimary(
                text: 'Submit',
                onTap: (_) async {
                  await vm.publishStore(context);
                  hasReviewed = true;
                  hasReviewed
                      ? await getIt<ModalService>().showActionModal(
                          context: context,
                          title: 'Submit Online Store For Review?',
                          description: state.customStoreReviewMessage,
                          cancelText: 'No, Cancel',
                          acceptText: 'Yes, Submit For Review',
                          onTap: (context) async {
                            if (mounted) {
                              setState(() {
                                Navigator.of(context).pushReplacement(
                                  CustomRoute(
                                    builder: (ctx) =>
                                        const SubmittedForReviewPage(),
                                  ),
                                );
                              });
                            }
                          },
                        )
                      : showCustomMessageDialog(
                          context: context,
                          title: 'Please Preview Store',
                          content: const Text(
                            'Kindly preview your store and confirm all details are correct before submitting for review. ',
                          ),
                          buttonText: 'Close',
                        );
                },
              )
            : ConfirmCancelButtons(
                isNegative: false,
                cancelText: 'Preview Store',
                confirmText: 'Submit',
                onCancel: () async {
                  await vm.publishStore(context);
                  hasReviewed = true;
                  try {
                    Uri url = Uri.parse(vm.item!.storeUrl!);
                    if (!await launchUrl(url)) {
                      throw Exception('Could not launch $url');
                    }
                  } catch (e) {
                    if (context.mounted) {
                      showMessageDialog(
                        context,
                        'Could not find store url',
                        LittleFishIcons.error,
                      );
                    }
                  }
                },
                onConfirm: () async {
                  hasReviewed
                      ? await getIt<ModalService>().showActionModal(
                          context: context,
                          title: 'Submit Online Store For Review?',
                          description: state.customStoreReviewMessage,
                          cancelText: 'No, Cancel',
                          acceptText: 'Yes, Submit For Review',
                          onTap: (context) async {
                            if (mounted) {
                              setState(() {
                                Navigator.of(context).pushReplacement(
                                  CustomRoute(
                                    builder: (ctx) =>
                                        const SubmittedForReviewPage(),
                                  ),
                                );
                              });
                            }
                          },
                        )
                      : showCustomMessageDialog(
                          context: context,
                          title: 'Please Preview Store',
                          content: const Text(
                            'Kindly preview your store and confirm all details are correct before submitting for review. ',
                          ),
                          buttonText: 'Close',
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            context.labelLarge(
              'Submit for Review',
              color: Theme.of(context).extension<AppliedTextIcon>()?.secondary,
              isBold: true,
              alignLeft: true,
            ),
            const SizedBox(height: 16),
            context.paragraphMedium(
              'Please preview your store and verify that all details are correct. '
              'Once you are satisfied that everything is in order, you can submit '
              'your store to the bank for review. The review process will be completed within '
              '48 hours.',
              color: Theme.of(
                context,
              ).extension<AppliedTextIcon>()?.deEmphasized,
              alignLeft: true,
            ),
            const SizedBox(height: 16),
            context.paragraphMedium(
              'Please note that you will not be able to accept'
              ' payments on your online store until it has'
              ' been reviewed and approved by the bank. ',
              color: Theme.of(context).extension<AppliedTextIcon>()?.error,
              alignLeft: true,
            ),
            const SizedBox(height: 16),
            context.labelLarge(
              vm.item!.storeUrl!,
              color: Theme.of(context).extension<AppliedTextIcon>()?.secondary,
              isBold: true,
              alignLeft: true,
            ),
            const SizedBox(height: 16),
            context.paragraphMedium(
              'This is your domain and will be how people can find your store online.',
              color: Theme.of(
                context,
              ).extension<AppliedTextIcon>()?.deEmphasized,
              alignLeft: true,
            ),
          ],
        ),
      ),
    );
  }
}
