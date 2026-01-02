import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/product/product_actions.dart';
import 'package:littlefish_merchant/ui/products/combos/pages/product_combo_page.dart';
import 'package:littlefish_merchant/ui/products/combos/view_models/combo_collection_vm.dart';
import 'package:littlefish_merchant/ui/products/combos/widgets/product_combo_list.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/decorated_text.dart';

class ProductCombosPage extends StatefulWidget {
  static const String route = 'item/combos';

  const ProductCombosPage({Key? key}) : super(key: key);

  @override
  State<ProductCombosPage> createState() => _ProductCombosPageState();
}

class _ProductCombosPageState extends State<ProductCombosPage> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CombosViewModel>(
      converter: (store) => CombosViewModel.fromStore(store),
      builder: (ctx, vm) => EnvironmentProvider.instance.isLargeDisplay!
          ? scaffoldLandscape(context, vm)
          : scaffoldMobile(context, vm),
    );
  }

  AppScaffold scaffoldLandscape(context, CombosViewModel vm) {
    return AppScaffold(
      enableProfileAction: false,
      title: 'Combos',
      hasDrawer: vm.store!.state.enableSideNavDrawer!,
      displayNavDrawer: vm.store!.state.enableSideNavDrawer!,
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () => vm.store!.dispatch(initializeCombos(refresh: true)),
        ),
      ],
      body: Row(
        children: <Widget>[
          const Expanded(flex: 4, child: ProductComboList()),
          const VerticalDivider(width: 0.5),
          Expanded(
            flex: 4,
            child: vm.selectedItem != null && !vm.selectedItem!.isNew!
                ? ProductComboPage(
                    isEmbedded: true,
                    parentContext: context,
                    onRemoved: () {
                      if (mounted) setState(() {});
                    },
                  )
                : const Center(
                    child: DecoratedText(
                      'Select Combo',
                      alignment: Alignment.center,
                      fontSize: 24,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  AppScaffold scaffoldMobile(context, CombosViewModel vm) => AppScaffold(
    title: 'Combos',
    hasDrawer: vm.store!.state.enableSideNavDrawer!,
    displayNavDrawer: vm.store!.state.enableSideNavDrawer!,
    actions: <Widget>[
      IconButton(
        icon: const Icon(Icons.refresh),
        onPressed: () => vm.store!.dispatch(initializeCombos(refresh: true)),
      ),
    ],
    body: const ProductComboList(),
  );
}
