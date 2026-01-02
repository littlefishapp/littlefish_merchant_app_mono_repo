import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/models/security/user/business_user_profile.dart';
import 'package:littlefish_merchant/ui/checkout/layouts/library/select_products_page.dart';

import '../../../../app/app.dart';
import '../../../../app/custom_route.dart';
import '../../../../common/presentaion/components/buttons/button_primary.dart';
import '../../../../common/presentaion/components/form_fields/string_form_field.dart';
import '../../../../common/presentaion/pages/scaffolds/app_scaffold.dart';
import '../../../../redux/app/app_state.dart';
import '../../model/business_store.dart';
import '../../redux/actions/business_actions.dart';
import '../../redux/viewmodels/business_store_view_model.dart';

class UnableToLinkStorePage extends StatefulWidget {
  static const route = '/unable_to_link_new_store';

  final BusinessUserProfile? profile;

  const UnableToLinkStorePage({this.profile, super.key});

  @override
  State<UnableToLinkStorePage> createState() => _UnableToLinkStorePageState();
}

class _UnableToLinkStorePageState extends State<UnableToLinkStorePage> {
  late final BusinessStore? business;

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
          title: 'Linking Failed',
          body: _body(context),
          persistentFooterButtons: [
            ButtonPrimary(
              text: 'Back',
              onTap: (context) {
                Navigator.of(context).push(
                  CustomRoute(
                    builder: (BuildContext context) {
                      return const SelectProductsPage();
                    },
                  ),
                );
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
          context.headingSmall('Email Address Mismatch', isBold: true),
          const SizedBox(height: 12),
          context.labelMedium(
            'The email address you\'re currently logged in '
            'with doesn\'t match the email address of the store owner. '
            'Please check below and try again.',
            isBold: false,
          ),
          const SizedBox(height: 18),
          StringFormField(
            initialValue: AppVariables.store?.state.userState.profile?.email,
            labelText: 'Current logged in email:',
            onSaveValue: (String? value) {},
            hintText: '',
            enabled: false,
            useOutlineStyling: true,
            isRequired: false,
          ),
          const SizedBox(height: 8),
          StringFormField(
            initialValue: widget.profile?.user?.email,
            labelText: 'Store owner email:',
            onSaveValue: (String? value) {},
            hintText: '',
            enabled: false,
            useOutlineStyling: true,
            isRequired: false,
          ),
          const SizedBox(height: 16),

          Align(
            alignment: Alignment.centerLeft,
            child: context.labelMedium('To resolve this issue:', isBold: true),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _numberCircle('1'),
              const SizedBox(width: 12),
              Expanded(
                child: context.paragraphMedium(
                  'Log out of your current account',
                  alignLeft: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _numberCircle('2'),
              const SizedBox(width: 12),
              Expanded(
                child: context.paragraphMedium(
                  'Log in using the store owner\'s email address ${widget.profile?.user?.email ?? ''}',
                  alignLeft: true,
                ),
              ),
            ],
          ),
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
        ).extension<AppliedSurface>()?.warningSubTitle,
        radius: 62.0,
        child: CircleAvatar(
          backgroundColor: Theme.of(
            context,
          ).extension<AppliedTextIcon>()?.warning,
          radius: 48.0,
          child: successIndicator(context),
        ),
      ),
    ],
  );

  Widget successIndicator(BuildContext context) =>
      const Icon(Icons.close, size: 64.0);

  Widget _numberCircle(String number) {
    return Container(
      width: 24,
      height: 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).extension<AppliedTextIcon>()?.positive,
        shape: BoxShape.circle,
      ),
      child: context.paragraphMedium(
        number,
        alignLeft: true,
        color: Theme.of(context).extension<AppliedSurface>()?.secondary,
      ),
    );
  }
}
