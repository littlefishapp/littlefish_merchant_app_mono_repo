// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/models/assets/app_assets.dart';
import 'package:littlefish_merchant/models/security/verification.dart';

// Project imports:
import 'package:littlefish_merchant/models/settings/accounts/linked_account.dart';
import 'package:littlefish_merchant/ui/settings/pages/accounts/linked_account_vm.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/string_form_field.dart';

//
class CyberSourceLinkedAccountPage extends StatefulWidget {
  final LinkedAccountVM? vm;
  final bool showHeader;
  final LinkedAccount? initialValue;
  final bool isEditable;

  const CyberSourceLinkedAccountPage(
    this.vm, {
    Key? key,
    this.showHeader = true,
    this.initialValue,
    this.isEditable = false,
  }) : super(key: key);

  @override
  State<CyberSourceLinkedAccountPage> createState() =>
      __CRDBLinkedAccountPageState();
}

class __CRDBLinkedAccountPageState extends State<CyberSourceLinkedAccountPage> {
  LinkedAccount? account;
  LinkedAccountVM? vm;
  String? merchantId, regBusNo, businessName /*, tin*/, email;

  FocusNode focusNode1 = FocusNode();

  FocusNode focusNode2 = FocusNode();
  FocusNode focusNode3 = FocusNode();
  FocusNode focusNode4 = FocusNode();
  //FocusNode focusNode5 = FocusNode();

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
      regBusNo = config['regBusNo'];
      businessName = config['businessName'];
      //this.tin = config['tin'];
      email = config['email'];
    }

    return AppSimpleAppScaffold(
      resizeToAvoidBottomPadding: false,
      isEmbedded: true,
      title: 'Account Details',
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.asset(AppAssets.cybersourceLogo, height: 60),
              ),
            ),
          ),
          Expanded(child: _layout(context, widget.vm)),
          if (widget.isEditable)
            ButtonPrimary(
              text: 'Submit',
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
        'regBusNo': regBusNo,
        'businessName': businessName,
        'email': email,
      };

      var config = jsonEncode(result);

      account = LinkedAccount(
        deleted: false,
        enabled: true,
        hasQRCode: true,
        isQRCodeEnabled: true,
        imageURI: AppAssets.cybersourceLogo,
        providerName: 'CRDB',
        linkedAccountType: LinkedAccountType.payment,
        providerType: ProviderType.cRDB,
        config: config,
      );

      vm!.setAccount(account);
      vm!.runUpsert(context);
      var resultStatus = vm?.routeName != null
          ? vm!.setVerificationStatus(context, VerificationStatus.verified)
          : VerificationStatus.failed;
      if (vm?.routeName != null &&
          resultStatus == VerificationStatus.verified) {
        Navigator.pop(context);
        Navigator.popAndPushNamed(context, vm!.routeName!);
      } else {
        Navigator.pop(context);
        Navigator.pop(context);
      }
    }
  }

  Padding _layout(BuildContext context, LinkedAccountVM? vm) {
    var formFields = <Widget>[
      StringFormField(
        useOutlineStyling: true,
        enabled: widget.isEditable,
        hintText: 'Merchant ID',
        focusNode: focusNode1,
        nextFocusNode: focusNode2,
        key: const Key('merchantId'),
        initialValue: merchantId ?? 'Test1234',
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
