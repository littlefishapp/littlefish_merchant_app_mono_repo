// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:quiver/strings.dart';

// Project imports:
import 'package:littlefish_merchant/models/store/business_profile.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/settings/view_models/view_models.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/currency_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/numeric_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/yes_no_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';

import '../../../../common/presentaion/pages/scaffolds/app_scaffold.dart';

class StoreCreditSettingsPage extends StatefulWidget {
  static const String route = 'business/credit-settings';

  const StoreCreditSettingsPage({Key? key}) : super(key: key);

  @override
  State<StoreCreditSettingsPage> createState() =>
      _StoreCreditSettingsPageState();
}

class _StoreCreditSettingsPageState extends State<StoreCreditSettingsPage> {
  StoreCreditSettings? storeCreditSettings;

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final isTablet = EnvironmentProvider.instance.isLargeDisplay ?? false;
    return StoreConnector<AppState, StoreCreditVM>(
      converter: (store) => StoreCreditVM.fromStore(store),
      builder: (ctx, vm) {
        storeCreditSettings ??=
            vm.currentSettingsState ??
            StoreCreditSettings(
              businessId: vm.store!.state.businessId,
              creditLimit: 0,
              enabled: false,
              interestRate: 0,
              repaymentPeriod: '',
              enableInterest: false,
            );

        return AppScaffold(
          floatAction: () => scaffoldFloatingAction(vm),
          title: 'Store Credit Settings',
          enableProfileAction: !isTablet,
          body: scaffoldBody(vm),
        );
      },
    );
  }

  Widget scaffoldBody(StoreCreditVM vm) {
    return vm.isLoading!
        ? const AppProgressIndicator()
        : Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                YesNoFormField(
                  labelText: 'Enable Credit',
                  onSaved: (value) {
                    storeCreditSettings!.enabled = value;
                    if (mounted) setState(() {});
                  },
                  initialValue: storeCreditSettings!.enabled ?? false,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  height: 120,
                  child: CurrencyFormField(
                    enabled: storeCreditSettings!.enabled,
                    key: const Key('creditLimit'),
                    hintText:
                        'What is the max amount of credit you will provide',
                    labelText: 'Credit Limit',
                    initialValue: storeCreditSettings?.creditLimit,
                    onFieldSubmitted: (val) {
                      storeCreditSettings!.creditLimit = val;
                    },
                    onSaveValue: (val) {
                      storeCreditSettings!.creditLimit = val;
                    },
                    isRequired: true,
                  ),
                ),
                YesNoFormField(
                  labelText: 'Enable Interest',
                  onSaved: (value) {
                    storeCreditSettings!.enableInterest = value;
                    if (mounted) setState(() {});
                  },
                  initialValue: storeCreditSettings!.enableInterest ?? false,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: NumericFormField(
                    enabled: storeCreditSettings?.enableInterest ?? false,
                    hintText: '5',
                    key: const Key('intrPerc'),
                    labelText: 'Interest Percentage',
                    initialValue: storeCreditSettings?.interestRate?.toInt(),
                    validator: (value) {
                      if (value == null) return null;
                      if (value > 100) {
                        return 'Amount cannot be greater than 100';
                      } else if (value <= 0) {
                        return 'Amount must be greater than 0';
                      } else {
                        return null;
                      }
                    },
                    onSaveValue: (value) {
                      storeCreditSettings!.interestRate = value.toDouble();
                    },
                    onFieldSubmitted: (value) {
                      storeCreditSettings!.interestRate = value.toDouble();
                    },
                    isRequired: storeCreditSettings?.enableInterest ?? false,
                  ),
                ),
              ],
            ),
          );
  }

  Widget scaffoldFloatingAction(StoreCreditVM vm) {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).primaryColor,
      child: const Icon(Icons.save),
      onPressed: () {
        var valid = validateForm();

        if (valid) {
          if (storeCreditSettings!.enabled!) {
            vm.saveCredit(storeCreditSettings, context);
          } else {
            vm.disableCredit(storeCreditSettings, context);
          }
        }

        // }
      },
    );
  }

  bool validateForm() {
    formKey.currentState?.validate();
    formKey.currentState!.save();

    if (storeCreditSettings!.enabled! &&
        storeCreditSettings!.creditLimit == 0) {
      return false;
    }

    // TODO(lampian): fix replayment period after ui is added
    storeCreditSettings!.repaymentPeriod = '3';

    if (storeCreditSettings!.enableInterest! &&
        isBlank(storeCreditSettings!.repaymentPeriod)) {
      return false;
    }

    return true;
  }
}
