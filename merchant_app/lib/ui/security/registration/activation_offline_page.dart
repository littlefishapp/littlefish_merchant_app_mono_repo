// project imports
import 'package:flutter/cupertino.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/custom_route.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/ui/security/login/landing_page.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';
import 'package:littlefish_merchant/app/theme/ui_state_data.dart';

class ActivationOfflinePage extends StatefulWidget {
  // information for the form
  final String? errorMessage;

  const ActivationOfflinePage({Key? key, this.errorMessage}) : super(key: key);

  @override
  State<ActivationOfflinePage> createState() => _ActivationOfflinePageState();
}

class _ActivationOfflinePageState extends State<ActivationOfflinePage> {
  @override
  Widget build(BuildContext context) {
    return AppSimpleAppScaffold(
      title: 'Getting Started',
      displayAppBar: false,
      centreTitle: false,
      footerActions: [
        ButtonPrimary(
          text: 'Go Back',
          onTap: (context) {
            Navigator.of(context).push(
              CustomRoute(
                builder: (BuildContext context) {
                  return const LandingPage();
                },
              ),
            );
          },
        ),
      ],
      body: Padding(padding: const EdgeInsets.all(16), child: layout(context)),
    );
  }

  SingleChildScrollView layout(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 56),
          Visibility(
            visible: widget.errorMessage != null,
            child: context.paragraphMedium(
              'Could not complete your activation, ${widget.errorMessage}',
            ),
          ),
          Visibility(
            visible: widget.errorMessage == null,
            child: context.paragraphMedium(
              'These services are currently unavailable.',
            ),
          ),
          context.paragraphMedium(
            'Please try again later or contact support at ${AppVariables.store!.state.clientSupportEmail} or ${AppVariables.store!.state.clientSupportMobileNumber}.',
          ),
        ],
      ),
    );
  }

  Container logo() => Container(
    margin: const EdgeInsets.only(bottom: 20),
    alignment: Alignment.center,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          alignment: Alignment.center,
          height: 100,
          child: Image.asset(UIStateData().appLogo, fit: BoxFit.fitHeight),
        ),
      ],
    ),
  );
}
