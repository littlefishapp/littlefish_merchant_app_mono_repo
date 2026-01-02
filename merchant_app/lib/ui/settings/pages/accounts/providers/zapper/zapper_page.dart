import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/models/assets/app_assets.dart';
import 'package:littlefish_merchant/models/settings/accounts/linked_account.dart';
import 'package:littlefish_merchant/ui/settings/pages/accounts/linked_account_vm.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/string_form_field.dart';

class ZapperPage extends StatefulWidget {
  final LinkedAccountVM? vm;
  final bool showHeader;
  final LinkedAccount? initialValue;

  const ZapperPage(
    this.vm, {
    Key? key,
    this.showHeader = true,
    this.initialValue,
  }) : super(key: key);

  @override
  State<ZapperPage> createState() => _ZapperPageState();
}

class _ZapperPageState extends State<ZapperPage> {
  static const imagePath = AppAssets.zapperPng;
  LinkedAccount? account;
  LinkedAccountVM? vm;
  String? merchantId, siteId;

  FocusNode focusNode1 = FocusNode();

  FocusNode focusNode2 = FocusNode();

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    vm ??= widget.vm;

    if (widget.initialValue != null) {
      vm!.account = widget.initialValue;

      var config = jsonDecode(widget.initialValue!.config!);

      merchantId = config['merchantId'];
      siteId = config['siteId'];
    }

    return AppSimpleAppScaffold(
      title: 'Zapper Settings',
      isEmbedded: true,
      body: Column(
        children: <Widget>[
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.asset(imagePath, height: 40),
            ),
          ),
          Expanded(child: _layout(context, widget.vm)),
          ButtonPrimary(
            text: 'Save Settings',
            textColor: Colors.white,
            onTap: (c) {
              _save(context);
            },
          ),
        ],
      ),
    );
  }

  _save(context) {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      Map<String, String?> result = {
        'merchantId': merchantId,
        'siteId': siteId,
      };

      var config = jsonEncode(result);

      account = LinkedAccount(
        deleted: false,
        enabled: true,
        hasQRCode: true,
        isQRCodeEnabled: true,
        imageURI: imagePath,
        providerName: 'Zapper',
        linkedAccountType: LinkedAccountType.payment,
        providerType: ProviderType.zapper,
        config: config,
      );

      vm!.setAccount(account);
      vm!.runUpsert(context);
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    }
  }

  Padding _layout(BuildContext context, LinkedAccountVM? vm) {
    var formFields = <Widget>[
      StringFormField(
        hintStyle: context.appThemeTextFormHint,
        labelStyle: context.appThemeTextFormLabel,
        textStyle: context.appThemeTextFormText,
        hintText: 'From the Zapper Merchant Portal',
        focusNode: focusNode1,
        nextFocusNode: focusNode2,
        key: const Key('merchantId'),
        initialValue: merchantId ?? '',
        isRequired: true,
        inputAction: TextInputAction.next,
        labelText: 'Merchant ID',
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
      StringFormField(
        hintStyle: context.appThemeTextFormHint,
        labelStyle: context.appThemeTextFormLabel,
        textStyle: context.appThemeTextFormText,
        hintText: 'From the Zapper Merchant Portal',
        key: const Key('siteId'),
        focusNode: focusNode2,
        nextFocusNode: FocusNode(),
        inputAction: TextInputAction.done,
        initialValue: siteId ?? '',
        isRequired: true,
        labelText: 'Site ID',
        asyncValidator: (value) {
          if (value == null) return null;
          if (!RegExp(r'^(\d|\w)+$').hasMatch(value)) {
            return 'Site ID cannot have special characters or spaces';
          }
        },
        onSaveValue: (String? value) {
          siteId = value;
        },
        onFieldSubmitted: (String value) {
          siteId = value;
          _save(context);
        },
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
}
