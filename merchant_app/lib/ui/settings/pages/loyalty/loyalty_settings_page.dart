// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/app_settings/app_settings_state.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/decimal_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/yes_no_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/common/view_models/store_collection_viewmodel.dart';

class LoyaltySettingsPage extends StatefulWidget {
  static const String route = 'settings/loyalty';

  const LoyaltySettingsPage({Key? key}) : super(key: key);

  @override
  State<LoyaltySettingsPage> createState() => _LoyaltySettingsPageState();
}

class _LoyaltySettingsPageState extends State<LoyaltySettingsPage> {
  GlobalKey<FormState>? formKey;

  @override
  void initState() {
    formKey = GlobalKey();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, LoyaltyVM>(
      converter: (store) => LoyaltyVM.fromStore(store),
      builder: (ctx, vm) => scaffold(context, vm),
    );
  }

  AppSimpleAppScaffold scaffold(context, LoyaltyVM vm) => AppSimpleAppScaffold(
    title: 'Loyalty Settings',
    actions: <Widget>[
      Builder(
        builder: (ctx) =>
            IconButton(icon: const Icon(Icons.save), onPressed: () {}),
      ),
    ],
    body: ListView(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      children: <Widget>[
        YesNoFormField(
          labelText: 'Enabled',
          initialValue: vm.item!.enabled ?? false,
          onSaved: (value) {
            vm.item!.enabled = value;
            if (mounted) setState(() {});
          },
        ),
        const CommonDivider(),
        Visibility(
          visible: vm.item!.enabled!,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: DecimalFormField(
              hintText: '0.01% of the purchase value',
              key: const Key('percentage'),
              labelText: 'Percentage Of Value',
              onSaveValue: (value) {},
              onFieldSubmitted: (value) {},
            ),
          ),
        ),
      ],
    ),
  );
}

class LoyaltyVM extends StoreItemViewModel<LoyaltySetting, AppSettingsState> {
  LoyaltyVM.fromStore(Store<AppState> store) : super.fromStore(store);

  @override
  loadFromStore(Store<AppState> store, {BuildContext? context}) {
    this.store = store;
    state = store.state.appSettingsState;

    isLoading = state!.isLoading;
    hasError = state!.hasError;
    errorMessage = state!.errorMessage;

    item = state!.loyaltySettings;
  }
}
