// removed ignore: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_secondary.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/list_detail_view.dart';
import 'package:redux/redux.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/suppliers/supplier_actions.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/decorated_text.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/ui/suppliers/supplier_page.dart';
import 'package:littlefish_merchant/ui/suppliers/view_models/view_models.dart';
import 'package:littlefish_merchant/ui/suppliers/widgets/supplier_list.dart';

import '../../app/app.dart';

class SuppliersPage extends StatelessWidget {
  static const String route = 'business/suppliers';

  const SuppliersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SuppliersVM>(
      onInit: (store) => store.dispatch(getSuppliers(refresh: false)),
      converter: (Store store) =>
          SuppliersVM.fromStore(store as Store<AppState>),
      builder: (BuildContext context, SuppliersVM vm) =>
          EnvironmentProvider.instance.isLargeDisplay!
          ? scaffoldLandscape(context, vm)
          : scaffold(context, vm),
    );
  }

  Widget scaffoldLandscape(context, SuppliersVM vm) {
    return ListDetailView(
      listWidget: AppScaffold(
        title: 'Suppliers',
        enableProfileAction: false,
        persistentFooterButtons: [
          footerButtonsIconPrimary(
            primaryButtonText: 'Add Supplier',
            secondaryButtonIcon: Icons.refresh,
            onPrimaryButtonPressed: (BuildContext context) {
              StoreProvider.of<AppState>(
                context,
              ).dispatch(createSupplier(context));
            },
            onSecondaryButtonPressed: (p0) {
              vm.onRefresh();
            },
          ),
        ],
        body: !vm.isLoading!
            ? suppliersList(context: context, vm: vm)
            : const AppProgressIndicator(),
      ),
      detailWidget: vm.selectedItem != null && !(vm.isNew ?? false)
          ? SupplierPage(
              embedded: true,
              supplier: vm.selectedItem,
              parentContext: context,
            )
          : const AppScaffold(
              enableProfileAction: false,
              displayBackNavigation: false,
              body: Center(
                child: DecoratedText(
                  'Select Supplier',
                  alignment: Alignment.center,
                  fontSize: 24,
                ),
              ),
            ),
    );
  }

  AppScaffold scaffold(BuildContext context, SuppliersVM vm) => AppScaffold(
    title: 'Suppliers',
    hasDrawer: AppVariables.store!.state.enableSideNavDrawer!,
    displayNavDrawer: AppVariables.store!.state.enableSideNavDrawer!,
    actions: <Widget>[
      IconButton(
        icon: const Icon(Icons.refresh),
        onPressed: () {
          vm.onRefresh();
        },
      ),
    ],
    body: !vm.isLoading!
        ? suppliersList(context: context, vm: vm)
        : const AppProgressIndicator(),
  );

  SupplierList suppliersList({
    required context,
    required SuppliersVM vm,
    bool canAddNew = false,
  }) {
    return SupplierList(
      parentContext: context,
      vm: vm,
      canAddNew: false,
      onTap: (supplier) {
        StoreProvider.of<AppState>(
          context,
        ).dispatch(editSupplier(context, supplier!));
      },
    );
  }

  Widget footerButtonsIconPrimary({
    required String primaryButtonText,
    required IconData secondaryButtonIcon,
    required Function(BuildContext)? onPrimaryButtonPressed,
    required Function(BuildContext)? onSecondaryButtonPressed,
    final bool allSecondaryControls = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 40,
          child: ButtonSecondary(
            radius: 0.0,
            text: '',
            icon: secondaryButtonIcon,
            onTap: onSecondaryButtonPressed,
          ),
        ),
        const SizedBox(width: 6),
        if (allSecondaryControls)
          Expanded(
            flex: 10,
            child: ButtonSecondary(
              text: primaryButtonText,
              widgetOnBrandedSurface: false,
              onTap: onPrimaryButtonPressed,
            ),
          )
        else
          Expanded(
            flex: 10,
            child: ButtonPrimary(
              text: primaryButtonText,
              widgetOnBrandedSurface: false,
              onTap: onPrimaryButtonPressed,
            ),
          ),
      ],
    );
  }
}
