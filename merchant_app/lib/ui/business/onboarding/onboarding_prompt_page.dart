// remove ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/models/assets/app_assets.dart';
import 'package:littlefish_merchant/models/security/verification.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/settings/pages/accounts/providers/cybersource/cybersource_linked_account_page.dart';
import 'package:littlefish_merchant/ui/settings/pages/accounts/linked_account_vm.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:webview_flutter/webview_flutter.dart';

class OnboardingPromptpage extends StatefulWidget {
  const OnboardingPromptpage({Key? key, this.routeName}) : super(key: key);

  final String? routeName;

  @override
  State<OnboardingPromptpage> createState() => _OnboardingPromptpageState();
}

class _OnboardingPromptpageState extends State<OnboardingPromptpage> {
  late WebViewController _controller;

  @override
  void initState() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, LinkedAccountVM>(
      converter: (store) => LinkedAccountVM.fromStore(store),
      builder: (context, LinkedAccountVM vm) => scaffold(context, vm),
    );
  }

  Widget scaffold(context, LinkedAccountVM vm) {
    vm.routeName = widget.routeName;

    var onboardingUrl =
        vm.store?.state.environmentState.environmentConfig?.onboardingUrl ??
        'https://red-meadow-0763de90f.2.azurestaticapps.net';
    _controller.loadRequest(Uri.parse(onboardingUrl));

    return AppScaffold(
      displayAppBar: true,
      title: 'Onboarding',
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 320,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Image.asset(AppAssets.verificationPng),
              ),
            ),
            const Text(
              'You have not been onboarded and/or verified as a merchant with '
              'CRDB yet, please click the button below to get started with the '
              'onboarding process.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(
              height: 120,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ButtonPrimary(
                    text: 'Get Onboarded',
                    onTap: (context) async {
                      await showPopupDialog(
                        context: context,
                        content: Scaffold(
                          resizeToAvoidBottomInset: false,
                          appBar: PreferredSize(
                            preferredSize: const Size.fromHeight(100),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(Icons.close),
                                ),
                                Text(
                                  'Onboarding',
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.secondary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(width: 50),
                              ],
                            ),
                          ),
                          body: WebViewWidget(controller: _controller),
                        ),
                      );

                      //launch("https://online.crdbbank.co.tz/apply/merchant/form");
                      if (vm
                              .store
                              ?.state
                              .businessState
                              .verificationStatus
                              ?.status !=
                          VerificationStatus.inProgress) {
                        vm.setVerificationStatus(
                          context,
                          VerificationStatus.inProgress,
                        );
                      }
                    },
                  ),
                  ButtonPrimary(
                    textColor: Theme.of(context).primaryColor,
                    buttonColor: Colors.white,
                    text: 'Simulate Verfification',
                    onTap: (context) => showPopupDialog(
                      context: context,
                      content: CyberSourceLinkedAccountPage(vm),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
