import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_core/business/models/business.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/models/security/user/business_user_profile.dart';
import 'package:littlefish_icons/littlefish_icons.dart';

import '../../../../common/presentaion/components/buttons/button_primary.dart';
import '../../../../common/presentaion/components/dialogs/common_dialogs.dart';
import '../../../../common/presentaion/pages/scaffolds/app_scaffold.dart';
import '../../../../redux/app/app_state.dart';
import '../../model/business_store.dart';
import '../../redux/actions/business_actions.dart';
import '../../redux/viewmodels/business_store_view_model.dart';

class StoreAddedSuccessfully extends StatefulWidget {
  static const route = '/store_added_successfully';

  final BusinessUserProfile? profile;
  final String? userId;
  final String? businessId;
  final Business? newBusiness;

  const StoreAddedSuccessfully({
    this.profile,
    this.newBusiness,
    this.userId,
    this.businessId,
    super.key,
  });

  @override
  State<StoreAddedSuccessfully> createState() => _StoreAddedSuccessfullyState();
}

class _StoreAddedSuccessfullyState extends State<StoreAddedSuccessfully> {
  late final BusinessStore? business;

  @override
  void initState() {
    super.initState();
    business = BusinessStore(
      userId: widget.userId,
      businessId: widget.businessId,
      businessName: widget.profile?.business?.name,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, BusinessStoreViewModel>(
      converter: (store) => BusinessStoreViewModel.fromStore(store),
      onInit: (store) {
        store.dispatch(SetBusinessStoresLoadingAction(false));
      },
      builder: (context, vm) {
        if (vm.isStoreLoading) {
          return const AppScaffold(
            displayBackNavigation: true,
            title: 'Stores',
            body: AppProgressIndicator(),
          );
        }

        return AppScaffold(
          displayBackNavigation: false,
          title: 'New Store Linked',
          body: _body(context),
          persistentFooterButtons: [
            ButtonPrimary(
              text: 'Done',
              onTap: (context) {
                final completer = Completer();

                vm.selectAndNavigateStore(
                  context,
                  business!,
                  (isLoading) => vm.setBusinessStoresLoading(isLoading),
                  completer,
                );

                completer.future
                    .then((_) {
                      vm.setBusinessStoresLoading(false);
                    })
                    .catchError((_) {
                      vm.setBusinessStoresLoading(false);
                      showMessageDialog(
                        context,
                        'Unable to link stores right now. Please try again later.',
                        LittleFishIcons.error,
                      );
                    });
              },
            ),
          ],
        );
      },
    );
  }

  Widget _body(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 32),
          centerSuccess(context),
          const SizedBox(height: 12),
          Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              children: [
                context.labelMedium(
                  widget.profile?.business?.name ?? '',
                  isBold: true,
                ),
                context.labelMedium(
                  ' successfully linked to your profile!',
                  isBold: false,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Column centerSuccess(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      CircleAvatar(
        backgroundColor: Theme.of(
          context,
        ).extension<AppliedSurface>()?.successSubTitle,
        radius: 62.0,
        child: CircleAvatar(
          backgroundColor: Theme.of(
            context,
          ).extension<AppliedTextIcon>()?.positive,
          radius: 48.0,
          child: successIndicator(context),
        ),
      ),
    ],
  );

  Widget successIndicator(BuildContext context) =>
      const Icon(Icons.check, size: 64.0);
}
