import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/online_store/viewmodels/manage_store_vm.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';
import '../../../../features/ecommerce_shared/models/store/promotion.dart';
import 'manage_promotion_list.dart';

class ManagePromotionsScreen extends StatefulWidget {
  const ManagePromotionsScreen({Key? key}) : super(key: key);

  @override
  State<ManagePromotionsScreen> createState() => _ManagePromotionsScreenState();
}

class _ManagePromotionsScreenState extends State<ManagePromotionsScreen> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ManageStoreVM>(
      converter: (store) => ManageStoreVM.fromStore(store),
      builder: (context, vm) {
        return AppSimpleAppScaffold(
          title: 'Promotions',
          // actions: [
          //   IconButton(
          //     icon: Icon(Icons.close),
          //     onPressed: () => Navigator.of(context).pop(),
          //   ),
          // ],
          body: FutureBuilder<List<Promotion>>(
            future: vm.getPromotionsByStoreId(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const LinearProgressIndicator();
              }

              return ManagePromotionList(promotions: snapshot.data);
            },
          ),
        );
      },
    );
  }
}
