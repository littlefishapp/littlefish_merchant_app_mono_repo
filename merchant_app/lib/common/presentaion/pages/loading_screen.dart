// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/long_text.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('### LoadingScreen');
    return const AppSimpleAppScaffold(
      title: 'Loading',
      displayAppBar: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          AppProgressIndicator(isCentered: true),
          SizedBox(height: 16.0),
          LongText('loading for a moment...'),
        ],
      ),
    );
  }
}
