// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux_dev_tools/flutter_redux_dev_tools.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';

// Project imports:
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';

class ReduxPage extends StatelessWidget {
  final Store<AppState> store;

  const ReduxPage({Key? key, required this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppSimpleAppScaffold(
      title: 'Timeline',
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: ReduxDevTools<AppState>(store as DevToolsStore<AppState>),
      ),
    );
  }
}
