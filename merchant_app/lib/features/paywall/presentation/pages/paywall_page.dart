import 'package:flutter/material.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';

class PaywallPage extends StatelessWidget {
  const PaywallPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Paywall',
      displayBackNavigation: true,
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    return Center(child: Text('Paywall terms and conditions'));
  }
}
