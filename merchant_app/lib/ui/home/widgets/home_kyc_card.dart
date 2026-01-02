import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/models/assets/app_assets.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/settings/pages/accounts/linked_account_vm.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common/presentaion/components/cards/card_neutral.dart';
import '../../../models/settings/accounts/linked_account.dart';

class HomeKYCCard extends StatefulWidget {
  const HomeKYCCard({Key? key}) : super(key: key);

  @override
  State<HomeKYCCard> createState() => _HomeKYCCardState();
}

class _HomeKYCCardState extends State<HomeKYCCard> {
  bool _hasLaunched = false;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, LinkedAccountVM>(
      converter: (store) => LinkedAccountVM.fromStore(store),
      builder: (context, LinkedAccountVM vm) => body(context, vm),
    );
  }

  Widget body(context, LinkedAccountVM vm) => CardNeutral(
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          SizedBox(
            height: 180,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Image.asset(AppAssets.verificationPng),
            ),
          ),
          ButtonPrimary(
            text: 'Launch KYC',
            onTap: (ctx) async {
              _launchURL(vm.store!.state.environmentSettings!.onboardingUrl!);

              await Future.delayed(const Duration(seconds: 1));
              // await showPopupDialog(
              //   context: context,
              //   content: Scaffold(
              //     resizeToAvoidBottomInset: false,
              //     body: WebView(
              //       initialUrl: vm
              //           .store!.state.environmentSettings!.onboardingUrl,
              //       javascriptMode: JavascriptMode.unrestricted,
              //       allowsInlineMediaPlayback: true,
              //       onWebViewCreated:
              //           (WebViewController webViewController) {
              //         // _controller.complete(webViewController);
              //         // webViewController.loadHtmlString(widget.htmlContent);
              //       },
              //       backgroundColor: Colors.white,
              //       onProgress: (int progress) {
              //         debugPrint('WebView is loading (progress : $progress%)');
              //       },
              //       javascriptChannels: <JavascriptChannel>{
              //         // _toasterJavascriptChannel(context),
              //       },
              //       navigationDelegate: (NavigationRequest request) {
              //         // if (request.url
              //         //     .startsWith('http://localhost:8082/TestHarness/simulator.html')) {
              //         //   Navigator.of(context).pop(true);
              //         //   return NavigationDecision.prevent;
              //         // }
              //         // debugPrint('allowing navigation to $request');
              //         debugPrint('Page started loading: ${request.url}}');
              //         var req = request;
              //         return NavigationDecision.navigate;
              //       },
              //       onPageStarted: (String url) {
              //         debugPrint('Page started loading: $url');
              //       },
              //       onPageFinished: (String url) {
              //         // if (url.startsWith('https://mobile-dev.sybrin.com/onboarding/'))
              //         // Navigator.of(context).pop(true);
              //         // debugPrint('Page finished loading: $url');
              //       },
              //       gestureNavigationEnabled: true,
              //     ),
              //   ),
              // );
              //launch("https://online.crdbbank.co.tz/apply/merchant/form");
              // if (AppVariables.store!.state.businessState
              //         .verificationStatus?.status !=
              //     VerificationStatus.inProgress) {
              // try {
              //   var currentStatus = AppVariables
              //       .store!.state.businessState.verificationStatus;

              //   if (currentStatus == null) {
              //     currentStatus = Verification();
              //   }

              //   currentStatus.verificationDate = DateTime.now();
              //   currentStatus.status = VerificationStatus.inProgress;

              //   vm.store!.dispatch(
              //     setBusinessVerificationStatus(
              //       context ?? ctx,
              //       currentStatus,
              //       // completer: snackBarCompleter(ctx, "Account Verified!"),
              //     ),
              //   );
              //   if (mounted) setState(() {});
              //   return currentStatus.status;
              // } catch (e) {
              //   showMessageDialog(
              //       context ?? ctx,
              //       'Something went wrong when updating verification status',
              //       LittleFishIcons.error);

              //   reportCheckedError(e, trace: StackTrace.current);

              //   return VerificationStatus.failed;
              // }
              // }
              _hasLaunched = true;
              setState(() {});
            },
          ),
          // SizedBox(height: 2),
          if (_hasLaunched == true)
            ButtonPrimary(
              buttonColor: Theme.of(context).colorScheme.secondary,
              // disabled: true,
              text: 'Verify Credentials',
              onTap: (ctx) async {
                showProgress(context: context);
                await Future.delayed(const Duration(seconds: 2));

                Navigator.of(context).pop();
                _save(context, vm);
              },
            ),
        ],
      ),
    ),
  );

  _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  _save(context, LinkedAccountVM vm) {
    Map<String, String?> result = {
      'merchantId': 'Test1234',
      'regBusNo': 'Test1234',
      'businessName': 'GeneralDealers',
      'email': 'generaldealers@gmail.com',
    };

    var config = jsonEncode(result);

    var account = LinkedAccount(
      deleted: false,
      enabled: true,
      hasQRCode: true,
      isQRCodeEnabled: true,
      imageURI: AppAssets.id2Png,
      providerName: 'Know Your Customer',
      linkedAccountType: LinkedAccountType.payment,
      providerType: ProviderType.cRDB,
      config: config,
    );

    vm.setAccount(account);
    vm.runUpsert(context);
    // var resultStatus =
    //     vm.setVerificationStatus(context, VerificationStatus.verified);
    // : VerificationStatus.failed;
    // if (vm.routeName != null && resultStatus == VerificationStatus.verified) {
    //   Navigator.pop(context);
    //   Navigator.popAndPushNamed(context, vm.routeName!);
    // } else {
    // }
    // Navigator.pop(context);
  }
}
