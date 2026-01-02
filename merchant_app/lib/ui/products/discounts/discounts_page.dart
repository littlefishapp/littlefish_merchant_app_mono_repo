import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/footer_buttons_icon_primary.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/list_detail_view.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/discounts/discounts_actions.dart';
import 'package:littlefish_merchant/ui/products/discounts/pages/discount_page.dart';
import 'package:littlefish_merchant/ui/products/discounts/view_models/discount_collection_vm.dart';
import 'package:littlefish_merchant/ui/products/discounts/widgets/discounts_list.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/decorated_text.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';

class DiscountsPage extends StatefulWidget {
  static const String route = 'business/discounts';

  const DiscountsPage({Key? key}) : super(key: key);

  @override
  State<DiscountsPage> createState() => _DiscountsPageState();
}

class _DiscountsPageState extends State<DiscountsPage> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, DiscountsVM>(
      // onInit: (store) => store.dispatch(getDiscounts(refresh: false)),
      converter: (store) => DiscountsVM.fromStore(store),
      builder: (ctx, vm) => EnvironmentProvider.instance.isLargeDisplay!
          ? scaffoldTablet(context, vm)
          : scaffoldMobile(context, vm),
    );
  }

  AppScaffold scaffoldMobile(context, DiscountsVM vm) => AppScaffold(
    title: 'Discounts',
    hasDrawer: vm.store!.state.enableSideNavDrawer!,
    displayNavDrawer: vm.store!.state.enableSideNavDrawer!,
    actions: <Widget>[
      IconButton(
        icon: const Icon(Icons.refresh),
        onPressed: () =>
            StoreProvider.of<AppState>(context).dispatch(vm.onRefresh()),
      ),
    ],
    body: vm.isLoading!
        ? const AppProgressIndicator()
        : mobileLayout(context, vm),
  );

  Widget scaffoldTablet(context, DiscountsVM vm) {
    return ListDetailView(
      listWidget: AppScaffold(
        title: 'Discounts',
        hasDrawer: true,
        displayNavDrawer: true,
        displayNavBar: false,
        persistentFooterButtons: [addAndRefresh(context, vm)],
        body: vm.isLoading!
            ? const AppProgressIndicator()
            : const DiscountsList(),
      ),
      detailWidget: vm.selectedItem != null && !vm.selectedItem!.isNew!
          ? const DiscountPage(isEmbedded: true)
          : const AppScaffold(
              enableProfileAction: false,
              displayBackNavigation: false,
              body: Center(
                child: DecoratedText(
                  'Select Discount',
                  alignment: Alignment.center,
                  fontSize: 24,
                ),
              ),
            ),
    );
  }

  Widget mobileLayout(context, DiscountsVM vm) =>
      vm.isLoading! ? const AppProgressIndicator() : const DiscountsList();

  Widget addAndRefresh(BuildContext context, DiscountsVM vm) {
    return FooterButtonsIconPrimary(
      primaryButtonText: 'Add Dsicount',
      onPrimaryButtonPressed: (_) async {
        StoreProvider.of<AppState>(
          context,
        ).dispatch(createDiscount(context: context));
      },
      secondaryButtonIcon: Icons.refresh,
      onSecondaryButtonPressed: (context) async {
        vm.onRefresh();
      },
    );
  }
}
