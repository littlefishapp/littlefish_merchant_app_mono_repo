import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/footer_buttons_secondary_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/yes_no_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/features/pos/presentation/view_model/pos_pay_view_model.dart';
import 'package:littlefish_merchant/models/settings/accounts/linked_account.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/settings/pages/accounts/linked_account_vm.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/string_form_field.dart';
import 'package:littlefish_merchant/ui/settings/pages/accounts/linked_acounts_page.dart';
import 'package:littlefish_merchant/ui/settings/pages/accounts/utils/linked_account_utils.dart';
import 'package:littlefish_merchant/ui/settings/pages/accounts/widgets/provider_image_display.dart';
import 'package:littlefish_payments/managers/terminal_manager.dart';
import 'package:quiver/strings.dart';

class WizzitPage extends StatefulWidget {
  final bool showHeader;
  final LinkedAccount? initialValue;

  const WizzitPage({Key? key, this.showHeader = true, this.initialValue})
    : super(key: key);

  @override
  State<WizzitPage> createState() => _WizzitPageState();
}

class _WizzitPageState extends State<WizzitPage> {
  LinkedAccount? account;
  // LinkedAccountVM? vm;
  String? merchantId;
  dynamic config;
  bool isNewAccount = false;

  FocusNode focusNode1 = FocusNode();

  FocusNode focusNode2 = FocusNode();

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    merchantId = '';
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, LinkedAccountVM>(
      converter: (store) => LinkedAccountVM.fromStore(store),
      builder: (BuildContext context, LinkedAccountVM vm) {
        if (widget.initialValue != null) {
          vm.setAccount(widget.initialValue);
          if (widget.initialValue!.config != null) {
            config = jsonDecode(widget.initialValue!.config!);
            merchantId = config['merchantId'];
          } else {
            isNewAccount = true;
          }
        }
        return AppScaffold(
          title:
              '${vm.store?.state.softPosProviderName} ${isNewAccount ? 'Registration' : 'Settings'}',
          body: vm.isLoading == true
              ? AppProgressIndicator()
              : Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Center(
                        child: ProviderImageDisplay(
                          imagePath: widget.initialValue?.imageURI ?? '',
                          providerName: 'WizzitTapToPay',
                        ),
                      ),
                    ),
                    Expanded(
                      child: !isNewAccount
                          ? _layoutEdit(context, vm)
                          : _layoutCreate(context, vm),
                    ),
                  ],
                ),
          persistentFooterButtons: [_buildBottomButtons(context, vm)],
        );
      },
    );
  }

  Widget _layoutCreate(BuildContext context, LinkedAccountVM vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Register for ${LinkedAccountUtils.cleanUpProviderName(vm.account?.providerName ?? '')}',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          context.paragraphMedium(
            LinkedAccountUtils.getRegisterSoftPosParagraph(),
            alignLeft: true,
          ),
          const SizedBox(height: 16),
          context.paragraphMedium(
            'Note: You are only allowed up to ${AppVariables.softPosDeviceLimit.toString()} devices registered per business. ${_getSupportString()}',
            alignLeft: true,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _save(BuildContext context, LinkedAccountVM vm) async {
    vm.runUpsert(context);
    //Todo add signal r
    PosPayVM payVM = PosPayVM.fromStore(vm.store);
    await payVM.updateLinkedAccount(account: vm.account);
    LittleFishCore core = LittleFishCore.instance;

    final TerminalManager terminalManager = core.get<TerminalManager>();
    await terminalManager.updateLinkedAccount(
      businessId: AppVariables.businessId,
    );
    Navigator.of(
      context,
    ).popUntil((route) => route.settings.name == LinkedAccountsPage.route);
  }

  void _registerMerchant(LinkedAccountVM vm) {
    vm.registerProviderMerchant(vm.account?.providerName ?? '');
  }

  Widget _layoutEdit(BuildContext context, LinkedAccountVM? vm) {
    var formFields = <Widget>[
      StringFormField(
        hintStyle: context.appThemeTextFormHint,
        labelStyle: context.appThemeTextFormLabel,
        textStyle: context.appThemeTextFormText,
        hintText: 'From the Wizzit Merchant Portal',
        focusNode: focusNode1,
        enabled: false,
        useOutlineStyling: true,
        nextFocusNode: focusNode2,
        key: const Key('merchantId'),
        initialValue: merchantId ?? '',
        isRequired: true,
        inputAction: TextInputAction.next,
        labelText: 'Wizzit Merchant ID',
        asyncValidator: (value) {
          if (value == null) return null;
          if (!RegExp(r'^(\d|\w)+$').hasMatch(value)) {
            return 'Merchant ID cannot have special characters or spaces';
          }
        },
        onSaveValue: (String? value) {
          merchantId = value;
        },
        onFieldSubmitted: (String value) {
          merchantId = value;
        },
      ),
      const SizedBox(height: 16),
      YesNoFormField(
        key: const Key('enablePayments'),
        padding: const EdgeInsets.all(0),
        labelText: 'Enabled',
        initialValue: vm?.account?.enabled ?? false,
        onSaved: (value) {
          LinkedAccount account = vm!.account!;
          account.enabled = value;
          vm.setAccount(account);
          setState(() {});
        },
        description: 'Allow Tap to Pay payments',
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Form(
        key: formKey,
        child: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: formFields,
        ),
      ),
    );
  }

  Widget _buildBottomButtons(BuildContext context, LinkedAccountVM vm) {
    if (!isNewAccount) {
      return FooterButtonsSecondaryPrimary(
        primaryButtonText: 'Save',
        secondaryButtonText: 'Back',
        onPrimaryButtonPressed: (ctx) {
          _save(context, vm);
        },
        onSecondaryButtonPressed: (ctx) {
          Navigator.of(context).pop();
        },
      );
    }
    return ButtonPrimary(
      text: 'Register Merchant',
      disabled: vm.isLoading == true,
      onTap: (ctx) {
        _registerMerchant(vm);
      },
    );
  }

  String _getSupportString() {
    if (isBlank(AppVariables.clientSupportEmail) ||
        isBlank(AppVariables.clientSupportEmail)) {
      return 'Contact support for more information.';
    }
    if (isBlank(AppVariables.clientSupportMobileNumber)) {
      return 'Contact support for more information at ${AppVariables.clientSupportEmail}.';
    }
    if (isBlank(AppVariables.clientSupportEmail)) {
      return 'Contact support for more information at ${AppVariables.clientSupportMobileNumber}.';
    }

    return 'Contact support for more information at ${AppVariables.clientSupportEmail} or ${AppVariables.clientSupportMobileNumber}.';
  }
}
