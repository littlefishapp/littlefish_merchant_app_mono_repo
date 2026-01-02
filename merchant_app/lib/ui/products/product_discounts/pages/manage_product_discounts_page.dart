// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';

// Project imports:
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/discounts/product_discounts_actions.dart';
import 'package:littlefish_merchant/ui/products/product_discounts/view_models/product_discount_vm.dart';
import 'package:littlefish_merchant/ui/products/product_discounts/widgets/product_discounts_list.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';

import '../../../../app/theme/applied_system/applied_text_icon.dart';

class ManageProductDiscountsPage extends StatefulWidget {
  static const String route = ' /product-discounts';

  const ManageProductDiscountsPage({Key? key}) : super(key: key);

  @override
  State<ManageProductDiscountsPage> createState() =>
      _ManageProductDiscountsPageState();
}

class _ManageProductDiscountsPageState
    extends State<ManageProductDiscountsPage> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ProductDiscountVM>(
      onInit: (store) {
        store.dispatch(getProductDiscounts(refresh: true));
      },
      converter: (store) => ProductDiscountVM.fromStore(store),
      builder: (ctx, vm) {
        if (vm.productDiscounts == null) {
          vm.store!.dispatch(getProductDiscounts(refresh: true));
        }
        return scaffold(context, vm);
      },
    );
  }

  scaffold(context, ProductDiscountVM vm) => AppScaffold(
    title: 'Discounts',
    actions: <Widget>[
      IconButton(
        icon: Icon(
          Icons.refresh,
          color: Theme.of(context).extension<AppliedTextIcon>()?.inversePrimary,
        ),
        onPressed: () {
          vm.store!.dispatch(vm.onRefresh!());
          if (mounted) setState(() {});
        },
      ),
    ],
    body: vm.isLoading! ? const AppProgressIndicator() : layout(context, vm),
  );

  layout(context, ProductDiscountVM vm) => const ProductDiscountsList();
}
