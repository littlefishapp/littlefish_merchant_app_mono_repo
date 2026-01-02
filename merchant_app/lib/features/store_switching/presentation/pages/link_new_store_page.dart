import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/string_form_field.dart';
import 'package:quiver/strings.dart';
import 'package:littlefish_icons/littlefish_icons.dart';

import '../../../../common/presentaion/components/app_progress_indicator.dart';
import '../../../../common/presentaion/components/buttons/footer_buttons_secondary_primary.dart';
import '../../../../common/presentaion/components/dialogs/common_dialogs.dart';
import '../../../../common/presentaion/pages/scaffolds/app_scaffold.dart';
import '../../../../redux/app/app_state.dart';
import '../../../../ui/security/registration/functions/activation_functions.dart';
import '../../redux/actions/business_actions.dart';
import '../../redux/viewmodels/business_store_view_model.dart';

class LinkNewStorePage extends StatefulWidget {
  final String? merchantId;
  const LinkNewStorePage({this.merchantId, super.key});

  @override
  State<LinkNewStorePage> createState() => _LinkNewStorePageState();
}

class _LinkNewStorePageState extends State<LinkNewStorePage> {
  final TextEditingController midController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  late TextEditingController _merchantIdController;
  String _merchantId = '';

  @override
  void initState() {
    _merchantId = widget.merchantId ?? "";
    _merchantIdController = TextEditingController(text: _merchantId);
    super.initState();
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
          displayBackNavigation: true,
          title: 'Link New Store',
          body: _body(context),
          persistentFooterButtons: [
            FooterButtonsSecondaryPrimary(
              secondaryButtonText: 'Cancel',
              onSecondaryButtonPressed: (_) {
                Navigator.of(context).pop();
              },
              primaryButtonText: 'Next',
              onPrimaryButtonPressed: (_) async {
                vm.setBusinessStoresLoading(true);

                try {
                  final result = await vm.merchantLookup(context, _merchantId);

                  if (!mounted) return;

                  setState(() {
                    _isLoading = false;
                    vm.setBusinessStoresLoading(false);
                  });

                  if (result.containsKey('error')) {
                    showMessageDialog(
                      context,
                      result['error'] ?? 'Something went wrong',
                      LittleFishIcons.error,
                    );
                    return;
                  }

                  final hasMidBeenActivatedBefore = result['value'];

                  if (hasMidBeenActivatedBefore) {
                    showMessageDialog(
                      context,
                      'This merchant has already been activated, please contact support.',
                      LittleFishIcons.error,
                    );
                    return;
                  }

                  vm.midLookup(context, _merchantId, () {
                    if (mounted) {
                      setState(() {
                        _isLoading = false;
                        vm.setBusinessStoresLoading(false);
                      });
                    }
                  });
                } catch (error) {
                  if (!mounted) return;

                  setState(() {
                    _isLoading = false;
                    vm.setBusinessStoresLoading(false);
                  });
                  showErrorDialog(context, error);
                }
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.only(top: 80),
            child: Center(
              child: context.headingXSmall(
                'Link your merchant \naccount',
                isSemiBold: true,
                color: Theme.of(
                  context,
                ).extension<AppliedTextIcon>()?.emphasized,
              ),
            ),
          ),
          const SizedBox(height: 32),
          context.labelMedium(
            'To get started with linking your business to your profile, provide the Merchant ID.',
            isBold: false,
          ),
          const SizedBox(height: 16),
          form(),
        ],
      ),
    );
  }

  Padding form() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StringFormField(
              key: const Key('merchantId'),
              labelText: 'Merchant Number',
              controller: _merchantIdController,
              isRequired: true,
              enabled: true,
              maxLength: 10,
              useOutlineStyling: true,
              hintText: 'Enter your Merchant Number',
              useRegex: true,
              customerRegex: RegExp(r'^[0-9]+$'),
              onChanged: (value) {
                _merchantId = value;
              },
              onSaveValue: (String? value) {
                if (isBlank(value)) {
                  _merchantId = '';
                  return;
                }

                final padded = formatMidValue(value);
                _merchantId = padded;

                _merchantIdController.value = TextEditingValue(
                  text: padded,
                  selection: TextSelection.collapsed(offset: padded.length),
                );
              },
              onFieldSubmitted: (value) {
                if (isBlank(value)) {
                  _merchantId = '';
                  return;
                }

                final padded = formatMidValue(value);
                _merchantId = padded;

                setState(() {
                  _merchantIdController.value = TextEditingValue(
                    text: padded,
                    selection: TextSelection.collapsed(offset: padded.length),
                  );
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
