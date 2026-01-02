import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/online_store/viewmodels/manage_store_vm.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';

import '../../../../../features/ecommerce_shared/models/store/promotion.dart';
import '../../../../../common/presentaion/components/common_divider.dart';

class CommsSelectPage extends StatefulWidget {
  final dynamic item;

  const CommsSelectPage({Key? key, required this.item}) : super(key: key);

  @override
  State<CommsSelectPage> createState() => _CommsSelectPageState();
}

class _CommsSelectPageState extends State<CommsSelectPage> {
  dynamic item;
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
        item.audience ??= Audience();

        return AppSimpleAppScaffold(
          title: 'Communication Type',
          body: SafeArea(
            child: Column(
              children: [
                CheckboxListTile(
                  title: const Text('Email'),
                  value: item.commStream.email,
                  onChanged: (val) {
                    if (mounted) {
                      setState(() {
                        item.commStream.email = val;
                      });
                    }
                  },
                ),
                const SizedBox(height: 4),
                const CommonDivider(),
                CheckboxListTile(
                  title: const Text('SMS'),
                  value: item.commStream.sms,
                  onChanged: (val) {
                    if (mounted) {
                      setState(() {
                        item.commStream.sms = val;
                      });
                    }
                  },
                ),
                const CommonDivider(),
                const SizedBox(height: 4),
                CheckboxListTile(
                  title: const Text('Push Notification'),
                  value: item.commStream.push,
                  onChanged: (val) {
                    if (mounted) {
                      setState(() {
                        item.commStream.push = val;
                      });
                    }
                  },
                ),
                const CommonDivider(),
              ],
            ),
          ),
        );
      },
    );
  }
}
