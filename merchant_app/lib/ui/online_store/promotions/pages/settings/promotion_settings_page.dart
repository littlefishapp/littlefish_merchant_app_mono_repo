// remove ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/online_store/viewmodels/manage_store_vm.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';
import '../../../../../features/ecommerce_shared/models/store/broadcast.dart';
import '../../../../../features/ecommerce_shared/models/store/promotion.dart';
import '../../../../../common/presentaion/components/dialogs/common_dialogs.dart';
import '../../../../../common/presentaion/components/common_divider.dart';
import 'audience_select_page.dart';
import 'comms_select_page.dart';

class PromotionSettingsPage extends StatefulWidget {
  final dynamic item;

  const PromotionSettingsPage({Key? key, this.item}) : super(key: key);

  @override
  State<PromotionSettingsPage> createState() => _PromotionSettingsPageState();
}

class _PromotionSettingsPageState extends State<PromotionSettingsPage> {
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
        return AppSimpleAppScaffold(
          title: 'Post Details',
          footerActions: <Widget>[
            if (vm.isLoading == false)
              ButtonBar(
                buttonHeight: 48,
                buttonMinWidth: MediaQuery.of(context).size.width * 0.95,
                children: <Widget>[
                  ElevatedButton(
                    // TODO(lampian): fix
                    // color: Theme.of(context).colorScheme.secondary,
                    child: const Text('Save'),
                    onPressed: () async {
                      try {
                        vm.isLoading = true;
                        _rebuild();

                        if (item is Broadcast) {
                          await vm.createBroadcast(item);
                        } else if (item is Promotion) {
                          await vm.createPromotion(item);
                        }
                        Navigator.of(context).pop();
                        showMessageDialog(context, 'Success', Icons.thumb_up);
                        vm.isLoading = false;

                        _rebuild();
                      } catch (e) {
                        vm.isLoading = false;
                        showMessageDialog(
                          context,
                          (e as dynamic).message,
                          LittleFishIcons.error,
                        );
                        _rebuild();
                      }
                    },
                  ),
                ],
              ),
          ],
          body: SafeArea(
            child: Column(
              children: [
                if (vm.isLoading == true) const LinearProgressIndicator(),
                ListTile(
                  tileColor: Theme.of(context).colorScheme.background,
                  title: const Text('Audience'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      item.audience == null ||
                              item.audience.audienceType == null
                          ? Text(
                              'None'.toUpperCase(),
                              style: const TextStyle(color: Colors.grey),
                            )
                          : Text(
                              item.audience.audienceType
                                  .toString()
                                  .split('.')
                                  .last
                                  .toUpperCase(),
                              style: const TextStyle(color: Colors.green),
                            ),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_forward_ios, size: 16),
                    ],
                  ),
                  onTap: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => AudienceSelectPage(item: item),
                      ),
                    );
                    _rebuild();
                  },
                ),
                const CommonDivider(),
                const SizedBox(height: 4),
                ListTile(
                  tileColor: Theme.of(context).colorScheme.background,
                  title: const Text('Communication Type'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item.commStream.options.toUpperCase(),
                        style: TextStyle(
                          color: item.commStream.valid
                              ? Colors.green
                              : Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_forward_ios, size: 16),
                    ],
                  ),
                  onTap: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => CommsSelectPage(item: item),
                      ),
                    );

                    _rebuild();
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

  // validatePromo() {
  //   if(item.)
  // }

  _rebuild() {
    if (mounted) {
      setState(() {});
    } else {
      setState(() {});
    }
  }
}
