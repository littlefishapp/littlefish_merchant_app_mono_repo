import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/list_detail_view.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/product/product_actions.dart';
import 'package:littlefish_merchant/ui/products/categories/widgets/product_categories_new.dart';
import 'package:littlefish_merchant/ui/products/categories/widgets/product_category_page.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/decorated_text.dart';
import '../../../../common/presentaion/components/buttons/footer_buttons_icon_primary.dart';
import '../view_models/category_collection_vm.dart';

class ProductCategoriesPage extends StatefulWidget {
  static const route = 'item/categories';

  final bool showBackButton;

  const ProductCategoriesPage({Key? key, this.showBackButton = false})
    : super(key: key);

  @override
  State<ProductCategoriesPage> createState() => _ProductCategoriesPageState();
}

class _ProductCategoriesPageState extends State<ProductCategoriesPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CategoriesViewModel>(
      converter: (store) => CategoriesViewModel.fromStore(store),
      builder: (ctx, vm) => EnvironmentProvider.instance.isLargeDisplay!
          ? scaffoldLandscape(ctx, vm)
          : scaffoldMobile(ctx, vm),
    );
  }

  Widget scaffoldLandscape(context, CategoriesViewModel vm) {
    return ListDetailView(
      listWidget: AppScaffold(
        enableProfileAction: false,
        title: 'Categories',
        hasDrawer: true,
        displayNavDrawer: true,
        displayNavBar: false,
        body: ProductCategoriesNew(
          onTap: (item) {
            vm.selectedItem = item;
            vm.store?.dispatch(CategorySelectAction(item));
            setState(() {});
          },
        ),
        persistentFooterButtons: [addCategoryRefresh(context, vm)],
      ),
      detailWidget:
          vm.selectedItem != null && (vm.selectedItem?.isNew ?? false) == false
          ? ProductCategoryPage(
              isEmbedded: true,
              parentContext: context,
              vmParent: vm,
              onCategoryUpdate: () {}, // keep empty as is for now,
            )
          : const AppScaffold(
              enableProfileAction: false,
              displayBackNavigation: false,
              body: Center(
                child: DecoratedText(
                  'Select Category',
                  alignment: Alignment.center,
                  fontSize: 24,
                ),
              ),
            ),
    );
  }

  scaffoldMobile(context, CategoriesViewModel vm) => AppScaffold(
    title: 'Categories',
    enableProfileAction: false,
    hasDrawer: vm.store!.state.enableSideNavDrawer!,
    displayNavDrawer: vm.store!.state.enableSideNavDrawer!,
    body: categoriesContext(context, vm),
    persistentFooterButtons: [addCategoryRefresh(context, vm)],
  );

  Widget addCategoryRefresh(BuildContext context, CategoriesViewModel vm) {
    return FooterButtonsIconPrimary(
      primaryButtonText: 'Add Category',
      onPrimaryButtonPressed: (_) async {
        vm.store!.dispatch(createCategory(context));
      },
      secondaryButtonIcon: Icons.refresh,
      onSecondaryButtonPressed: (context) async {
        vm.store!.dispatch(getProducts(refresh: true));
        vm.store!.dispatch(initializeCategories(refresh: true));
      },
    );
  }

  categoriesContext(context, CategoriesViewModel vm) => Column(
    mainAxisSize: MainAxisSize.max,
    children: [
      Expanded(
        child: SingleChildScrollView(
          child: ProductCategoriesNew(vm: vm, parentContext: context),
        ),
      ),
    ],
  );
}
