// remove ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/online_store/promotions/pages/settings/customer_select_page.dart';
import 'package:littlefish_merchant/ui/online_store/viewmodels/manage_store_vm.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';
import '../../../../../features/ecommerce_shared/models/store/promotion.dart';
import '../../../../../common/presentaion/components/dialogs/common_dialogs.dart';
import '../../../../../common/presentaion/components/common_divider.dart';
import 'topic_select_page.dart';

class AudienceSelectPage extends StatefulWidget {
  final dynamic item;

  const AudienceSelectPage({Key? key, required this.item}) : super(key: key);
  @override
  State<AudienceSelectPage> createState() => _AudienceSelectPageState();
}

class _AudienceSelectPageState extends State<AudienceSelectPage> {
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
          title: 'Choose Your Audience',
          body: SafeArea(
            child: Column(
              children: [
                Visibility(
                  visible: false,
                  child: ListTile(
                    tileColor: Theme.of(context).colorScheme.background,
                    title: const Text('Specific Customers'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () async {
                      var res = await showPopupDialog(
                        context: context,
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        content: CustomerSelectPage(item: item),
                      );
                      // var res = await Navigator.of(context).push(
                      //   MaterialPageRoute(
                      //     builder: (ctx) => CustomerSelectPage(
                      //       item: item,
                      //     ),
                      //   ),
                      // );

                      if (res != null) {
                        res.audience.audienceType = AudienceType.specific;
                        Navigator.pop(context, res);
                      }
                    },
                  ),
                ),
                const SizedBox(height: 4),
                const CommonDivider(),
                ListTile(
                  tileColor: Theme.of(context).colorScheme.background,
                  title: const Text('User Groups'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    showPopupDialog(
                      context: context,
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      content: TopicSelectPage(item: item),
                    );
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (ctx) => TopicSelectPage(item: item),
                    //   ),
                    // );
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
