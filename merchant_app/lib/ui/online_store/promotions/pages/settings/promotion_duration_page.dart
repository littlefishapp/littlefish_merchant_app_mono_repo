import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/online_store/viewmodels/manage_store_vm.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';

import '../../../../../features/ecommerce_shared/models/store/promotion.dart';
import '../../../../../common/presentaion/components/long_text.dart';

class PromotionDurationPage extends StatefulWidget {
  final Promotion? item;

  const PromotionDurationPage({Key? key, required this.item}) : super(key: key);

  @override
  State<PromotionDurationPage> createState() => _PromotionDurationPageState();
}

class _PromotionDurationPageState extends State<PromotionDurationPage> {
  Promotion? item;
  @override
  void initState() {
    item = widget.item;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ManageStoreVM>(
      converter: (store) => ManageStoreVM.fromStore(store),
      builder: (ctx, vm) {
        if (item!.duration == null) item!.duration = 7;

        return AppSimpleAppScaffold(
          title: 'Promotion Duration',
          footerActions: <Widget>[
            ButtonBar(
              buttonHeight: 48,
              buttonMinWidth: MediaQuery.of(context).size.width * 0.95,
              children: <Widget>[
                ElevatedButton(
                  // TODO(lampian): fix
                  // color: Theme.of(context).colorScheme.secondary,
                  child: const Text('Save'),
                  onPressed: () async {
                    Navigator.of(context).pop(item);
                  },
                ),
              ],
            ),
          ],
          body: SafeArea(
            child: ListTile(
              tileColor: Theme.of(context).colorScheme.background,
              title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Text('Duration'),
                  const SizedBox(height: 4),
                  const LongText('How long will this promotion run for'),
                  Slider(
                    onChanged: (value) {
                      item!.duration = value.toInt();

                      _rebuild();
                    },
                    value: item!.duration?.toDouble() ?? 7,
                    min: 1,
                    max: 14,
                    divisions: 14,
                  ),
                  LongText(
                    '${item?.duration ?? 7} ${"Days"}',
                    fontSize: null,
                    textColor: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _rebuild() {
    if (mounted) {
      setState(() {});
    } else {
      setState(() {});
    }
  }
}
