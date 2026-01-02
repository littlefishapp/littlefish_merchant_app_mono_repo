// flutter imports
import 'package:flutter/material.dart';

// package imports
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_core_utils/error/error_code_manager.dart';
import 'package:littlefish_core_utils/error/models/error_codes/activation_error_codes.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/string_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/toggle/term_and_condition_toggle.dart';

// project imports
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/auth/auth_actions.dart';
import 'package:littlefish_merchant/redux/device/device_actions.dart';
import 'package:littlefish_merchant/ui/security/login/viewmodels/login_viewmodel.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/ui/security/registration/functions/activation_functions.dart';
import 'package:quiver/strings.dart';

import '../../../common/presentaion/pages/scaffolds/app_scaffold.dart';

class MerchantIdentifierPage extends StatefulWidget {
  final String merchantId; // information for the form

  const MerchantIdentifierPage({required this.merchantId, Key? key})
    : super(key: key);

  @override
  State<MerchantIdentifierPage> createState() => _MerchantIdentifierPageState();
}

class _MerchantIdentifierPageState extends State<MerchantIdentifierPage> {
  late String
  _merchantId; // we will modify the form's field values with user's entered data
  bool? _isTermsAndConditionsAccepted = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  double bottomValue = 0.0;

  @override
  void initState() {
    _merchantId = formatMidValue(widget.merchantId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bottomValue = MediaQuery.of(context).viewInsets.bottom;
    return StoreConnector<AppState, RegisterVM?>(
      converter: (store) => RegisterVM.fromStore(store),
      onInit: (store) {
        if (store.state.deviceState.deviceDetails == null) {
          store.dispatch(InitializeDeviceDetailsAction());
        }
      },
      onDidChange: (oldVM, currentVM) {
        if (oldVM?.hasDeviceDetailsLoaded != true &&
            currentVM?.hasDeviceDetailsLoaded == true &&
            currentVM?.store?.state.deviceState.deviceDetails != null) {
          if (currentVM?.hasDeviceDetailsLoaded == true) {
            _merchantId = formatMidValue(
              currentVM!.store!.state.deviceState.deviceDetails!.merchantId,
            );
            setState(() {});
          }
        }
      },
      builder: (context, vm) {
        return AppScaffold(
          title: 'Getting Started',
          centreTitle: false,
          persistentFooterButtons: [nextControl(vm)],
          body: vm?.isLoading == true
              ? const AppProgressIndicator()
              : layout(context, vm!),
        );
      },
    );
  }

  Widget nextControl(RegisterVM? vm) {
    return ButtonPrimary(
      text: 'Next',
      disabled: _isTermsAndConditionsAccepted == false,
      onTap: (context) async {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();

          try {
            final result = await vm?.merchantLookup(context, _merchantId);

            if (result == null) {
              showErrorDialog(
                context,
                ActivationErrorCodes.failedToCheckActivationStatus,
              );
              return;
            }

            if (result.containsKey('error')) {
              showErrorDialog(
                context,
                result['error'] ?? 'Something went wrong',
              );
              return;
            }

            final hasMidBeenActivatedBefore = result['value'];

            if (hasMidBeenActivatedBefore) {
              showErrorDialog(
                context,
                ActivationErrorCodes.merchantAlreadyActivated,
              );

              return;
            }

            if (context.mounted) {
              vm!.store!.dispatch(createActivation(merchantId: _merchantId));
            }
          } catch (error) {
            if (context.mounted) {
              showErrorDialog(context, error);
            }
          }
        }
      },
    );
  }

  Widget layout(BuildContext context, RegisterVM vm) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 80),
                child: Center(
                  child: context.headingXSmall(
                    'Register your merchant \naccount',
                    isSemiBold: true,
                    color: Theme.of(
                      context,
                    ).extension<AppliedTextIcon>()?.emphasized,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: context.paragraphMedium(
                  'You can find your Merchant Number on your monthly statement. Alternatively, contact us at '
                  '${AppVariables.store!.state.clientSupportEmail ?? ""} or '
                  '${AppVariables.store!.state.clientSupportMobileNumber ?? ""}',
                ),
              ),
              const SizedBox(height: 24),
              form(),
            ],
          ),
          if (bottomValue == 0.0)
            TermAndConditionToggle(
              url: AppVariables.termsAndConditions,
              isAccepted: _isTermsAndConditionsAccepted ?? false,
              onChanged: (value) {
                if (mounted) {
                  setState(() {
                    _isTermsAndConditionsAccepted = value;
                  });
                }
              },
            ),
        ],
      ),
    );
  }

  Padding form() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StringFormField(
              key: const Key('merchantId'),
              labelText: 'Merchant Number',
              initialValue: _merchantId,
              isRequired: true,
              enabled: !AppVariables.isPOSBuild,
              useOutlineStyling: true,
              onSaveValue: (String? value) {
                if (isBlank(value)) {
                  _merchantId = '';
                  return;
                }
                if (value!.length < 10) {
                  _merchantId = value.padLeft(10, '0');
                }
                _merchantId = value;
              },
              maxLength: 10,
              onFieldSubmitted: (value) {
                if (isBlank(value)) {
                  _merchantId = '';
                  return;
                }
                if (value.length < 10) {
                  _merchantId = value.padLeft(10, '0');
                  return;
                }
                _merchantId = value;
              },
              useRegex: true,
              customerRegex: RegExp(r'^[0-9]+$'),
              hintText: 'Enter your Merchant Number',
            ),
          ],
        ),
      ),
    );
  }
}
