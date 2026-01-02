// Flutter imports:
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/models/assets/app_assets.dart';

// Package imports:
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/redux/billing/billing_actions.dart';

import '../../components/buttons/button_primary.dart';
import '../../components/custom_app_bar.dart';

class BillingNotEnabledScreen extends StatefulWidget {
  final bool isModal;
  final bool showSkip;
  final String? targetRoute;
  final bool skipNavigatesToRoute;

  const BillingNotEnabledScreen({
    Key? key,
    this.showSkip = false,
    this.isModal = false,
    this.skipNavigatesToRoute = false,
    this.targetRoute,
  }) : super(key: key);

  @override
  State<BillingNotEnabledScreen> createState() =>
      _BillingNotEnabledScreenState();
}

class _BillingNotEnabledScreenState extends State<BillingNotEnabledScreen> {
  final String playStoreURL =
      'https://play.google.com/store/apps/details?id=${AppVariables.store!.state.appSettingsState.packageName!}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: [goToPlayStore()],
      appBar: CustomAppBar(
        leading: AppVariables.store!.state.billingState.isLoading == false
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  if (widget.skipNavigatesToRoute) {
                    AppVariables.store!.dispatch(
                      SetShowBillingPageAction(false),
                    );
                    Navigator.of(
                      context,
                    ).pushNamed(widget.targetRoute!, arguments: 'from_upgrade');
                  } else {
                    Navigator.of(context).pop();
                  }
                },
              )
            : const SizedBox.shrink(),
        centerTitle: false,
        title: const Text(
          'Premium Feature',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            const SizedBox(height: 20),
            SizedBox(
              height: 320,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Image.asset(AppAssets.growMoney),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              child: const Text(
                'Billing is not enabled/supported on your device. Add your details so you can take your business to the next level.',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container goToPlayStore() => Container(
    margin: const EdgeInsets.symmetric(horizontal: 12),
    child: ButtonPrimary(
      text: 'Go to PlayStore',
      onTap: (ctx) => _launchURL(playStoreURL),
    ),
  );

  _launchURL(String url) async {
    final launchUri = Uri.parse(url);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $url';
    }
  }
}
