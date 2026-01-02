// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';

class EventsLogPage extends StatelessWidget {
  final List<String> logs;

  const EventsLogPage({Key? key, required this.logs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppSimpleAppScaffold(title: 'Events Log', body: eventLog(context));
  }

  ListView eventLog(context) => ListView.separated(
    itemBuilder: (BuildContext context, int index) => ListTile(
      tileColor: Theme.of(context).colorScheme.background,
      dense: true,
      title: Text(logs[index]),
    ),
    itemCount: logs.length,
    separatorBuilder: (BuildContext context, int index) => const Divider(),
  );
}
