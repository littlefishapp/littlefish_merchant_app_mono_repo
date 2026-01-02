// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_secondary.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/footer_buttons_secondary_primary.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:redux/redux.dart';
import 'package:littlefish_merchant/models/staff/employee.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/business/employees/forms/employee_details_form.dart';
import 'package:littlefish_merchant/ui/business/employees/view_models.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_tabbed_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_tabbar.dart';

import '../../../../common/presentaion/pages/scaffolds/app_scaffold.dart';

class EmployeePage extends StatefulWidget {
  static const String route = '/employee';

  final bool embedded;
  final BuildContext? parentContext;
  final Employee? employee;

  const EmployeePage({
    Key? key,
    this.embedded = false,
    this.employee,
    this.parentContext,
  }) : super(key: key);

  @override
  State<EmployeePage> createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  GlobalKey<FormState>? formKey;
  bool isLargeDisplay = false;
  bool _isDirty = false;

  @override
  void initState() {
    formKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isLargeDisplay = EnvironmentProvider.instance.isLargeDisplay ?? false;
    return StoreConnector<AppState, EmployeeVM>(
      converter: (Store<AppState> store) =>
          EmployeeVM.fromStore(store)..key = formKey,
      builder: (BuildContext ctx, EmployeeVM vm) {
        Widget scaffoldWidget = scaffold(
          context: context,
          vm: vm,
          isTablet: isLargeDisplay,
        );
        if (isLargeDisplay) {
          final screenWidth = MediaQuery.of(context).size.width;
          const maxMobileWidth = 414.0;
          final constrainedWidth = (screenWidth * 0.3).clamp(
            300.0,
            maxMobileWidth,
          );

          scaffoldWidget = Center(
            // Centers horizontally in the dialog
            child: SizedBox(width: constrainedWidth, child: scaffoldWidget),
          );
        }
        return scaffoldWidget;
      },
    );
  }

  Widget scaffold({
    required BuildContext context,
    required EmployeeVM vm,
    bool isTablet = false,
  }) {
    return AppScaffold(
      enableProfileAction: isLargeDisplay ? false : true,
      displayNavBar: false,
      displayBackNavigation: isTablet ? false : true,
      title: vm.item == null || vm.item!.isNew!
          ? 'New Employee'
          : vm.item!.displayName,
      persistentFooterButtons: [footerControl(vm: vm, isTablet: isTablet)],
      body: vm.isLoading! ? const AppProgressIndicator() : form(context, vm),
    );
  }

  layout(context, EmployeeVM vm) {
    return AppTabBar(
      reverse: true,
      tabs: [TabBarItem(content: form(context, vm), text: 'Details')],
    );
  }

  Widget form(BuildContext context, EmployeeVM vm) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Builder(
          builder: (ctx) {
            return EmployeeDetailsForm(
              employee: vm.item,
              formKey: vm.key,
              onSubmit: (employee) {
                if (vm.key?.currentState?.validate() ?? false) {
                  vm.key!.currentState!.save();
                  vm.onAdd(vm.item, context);
                }
              },
              onValidityChanged: (value) {
                if (mounted) {
                  setState(() {
                    _isDirty = value;
                  });
                }
              },
            );
          },
        ),
      ),
    );
  }

  Widget footerControl({bool isTablet = false, required EmployeeVM vm}) {
    return FooterButtonsSecondaryPrimary(
      primaryButtonText: 'Save',
      secondaryButtonText: 'Cancel',
      onPrimaryButtonPressed: (context) {
        if (vm.key?.currentState?.validate() ?? false) {
          try {
            vm.key!.currentState!.save();
          } on Exception catch (e) {
            debugPrint('#### Error saving form: $e');
          }
          vm.onAdd(vm.item, context);
        }
      },
      onSecondaryButtonPressed: (context) {
        Navigator.of(context).pop();
      },
      primaryButtonDisabled: !_isDirty,
    );
  }
}
