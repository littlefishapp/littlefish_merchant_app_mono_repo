import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/footer_buttons_icon_primary.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/list_detail_view.dart';
// ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/business/business_actions.dart';
import 'package:littlefish_merchant/ui/business/employees/pages/employee_page.dart';
import 'package:littlefish_merchant/ui/business/employees/view_models.dart';
import 'package:littlefish_merchant/ui/business/employees/widgets/employee_list.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/decorated_text.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';

class EmployeesPage extends StatefulWidget {
  static const String route = 'business/employees';

  const EmployeesPage({Key? key}) : super(key: key);

  @override
  State<EmployeesPage> createState() => _EmployeesPageState();
}

class _EmployeesPageState extends State<EmployeesPage> {
  bool enabled = false;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, EmployeeListVM>(
      onInit: (store) => store.dispatch(getEmployees()),
      converter: (Store store) =>
          EmployeeListVM.fromStore(store as Store<AppState>),
      builder: (BuildContext ctx, EmployeeListVM vm) {
        return EnvironmentProvider.instance.isLargeDisplay!
            ? scaffoldLandscape(context, vm)
            : scaffoldMobile(context, vm);
      },
    );
  }

  Widget scaffoldLandscape(context, EmployeeListVM vm) {
    return ListDetailView(
      listWidget: AppScaffold(
        enableProfileAction: false,
        title: 'Employees',
        persistentFooterButtons: [
          FooterButtonsIconPrimary(
            primaryButtonText: 'Add New Employee',
            secondaryButtonIcon: Icons.refresh,
            onPrimaryButtonPressed: (BuildContext ctx) {
              vm.store?.dispatch(createEmployee(context));
            },
            onSecondaryButtonPressed: (context) {
              vm.onRefresh();
            },
          ),
        ],
        body: !vm.isLoading!
            ? employeeList(context, vm)
            : const AppProgressIndicator(),
      ),
      detailWidget: vm.selectedItem != null && !(vm.isNew ?? false)
          ? EmployeePage(
              embedded: true,
              employee: vm.selectedItem,
              parentContext: context,
            )
          : const AppScaffold(
              enableProfileAction: false,
              body: Center(
                child: DecoratedText(
                  'Select Employee',
                  alignment: Alignment.center,
                  fontSize: 24,
                ),
              ),
            ),
    );
  }

  AppScaffold scaffoldMobile(BuildContext context, EmployeeListVM vm) {
    return AppScaffold(
      title: 'Employees',
      persistentFooterButtons: [
        FooterButtonsIconPrimary(
          primaryButtonText: 'Add New Employee',
          secondaryButtonIcon: Icons.refresh,
          onPrimaryButtonPressed: (BuildContext ctx) {
            vm.store?.dispatch(createEmployee(context));
          },
          onSecondaryButtonPressed: (context) {
            vm.onRefresh();
          },
        ),
      ],
      body: !vm.isLoading!
          ? employeeList(context, vm)
          : const AppProgressIndicator(),
    );
  }

  EmployeeList employeeList(context, vm) {
    return EmployeeList(
      vm: vm,
      parentContext: context,
      items: vm.items,
      selectedItem: vm.selectedItem,
      onTap: (employee) {
        vm.onSetSelected(employee);
        if (EnvironmentProvider.instance.isLargeDisplay!) {
        } else {
          Navigator.of(
            context,
          ).pushNamed(EmployeePage.route, arguments: employee);
        }
      },
    );
  }
}
