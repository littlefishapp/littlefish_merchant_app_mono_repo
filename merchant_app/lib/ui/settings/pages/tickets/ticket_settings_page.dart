// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/app_settings/app_settings_actions.dart';
import 'package:littlefish_merchant/ui/settings/view_models/view_models.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/yes_no_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/common/presentaion/components/long_text.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';

class TicketSettingsPage extends StatefulWidget {
  static const String route = 'settings/ticket';

  const TicketSettingsPage({Key? key}) : super(key: key);

  @override
  State<TicketSettingsPage> createState() => _TicketSettingsPageState();
}

class _TicketSettingsPageState extends State<TicketSettingsPage> {
  GlobalKey<FormState>? formKey;

  @override
  void initState() {
    formKey = GlobalKey();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, TicketSettingsViewModel>(
      onInit: (store) {
        store.dispatch(initializeTicketSettings(refresh: false));
      },
      converter: (Store store) =>
          TicketSettingsViewModel.fromStore(store as Store<AppState>),
      builder: (BuildContext context, TicketSettingsViewModel vm) {
        final isTablet = EnvironmentProvider.instance.isLargeDisplay ?? false;
        final showSideNav =
            isTablet ||
            (AppVariables.store!.state.enableSideNavDrawer ?? false);
        return AppScaffold(
          title: 'Parked Cart Preferences',
          enableProfileAction: !showSideNav,
          hasDrawer: false,
          displayNavDrawer: false,
          body: vm.isLoading!
              ? const AppProgressIndicator()
              : _body(context, vm),
        );
      },
    );
  }

  Column _body(context, TicketSettingsViewModel vm) => Column(
    children: <Widget>[
      YesNoFormField(
        labelText: 'Allowed',
        initialValue: vm.allowTickets ?? true,
        onSaved: (bool? value) {
          setState(() {
            vm.allowTickets = value;
            vm.setValue(value!, context);
          });
        },
      ),
      const CommonDivider(),
      Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: const LongText(
          'Enabling parked carts allows you to create, save and update carts before closing a sale',
        ),
      ),
    ],
  );
}
