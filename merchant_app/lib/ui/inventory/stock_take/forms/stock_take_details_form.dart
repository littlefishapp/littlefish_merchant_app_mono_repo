// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/stock/stock_run.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/string_form_field.dart';

class StockTakeDetailsForm extends StatelessWidget {
  final StockRun item;

  const StockTakeDetailsForm({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return form(context);
  }

  Column form(context) {
    var store = StoreProvider.of<AppState>(context);

    var user = store.state.userProfile;

    return Column(
      children: <Widget>[
        Visibility(
          visible: !(item.isNew ?? false),
          child: StringFormField(
            enabled: false,
            isRequired: false,
            hintText: 'Name',
            key: const Key('name'),
            labelText: 'Name',
            onSaveValue: (value) {},
            initialValue: item.displayName,
          ),
        ),
        Visibility(
          visible: !(item.isNew ?? false),
          child: StringFormField(
            enabled: false,
            isRequired: false,
            suffixIcon: Icons.confirmation_number,
            hintText: 'Run Number',
            key: const Key('number'),
            labelText: 'Run Number',
            onSaveValue: (value) {},
            initialValue: item.runNumber.toString(),
          ),
        ),
        StringFormField(
          enabled: false,
          isRequired: false,
          suffixIcon: Icons.person,
          hintText: 'Captured By',
          key: const Key('capturedBy'),
          labelText: 'Captured By',
          onSaveValue: (value) {},
          initialValue: item.capturerName ?? user!.displayName,
        ),
        StringFormField(
          hintText: 'Captured On',
          key: const Key('capturedOn'),
          labelText: 'Captured On',
          enabled: false,
          suffixIcon: Icons.date_range,
          isRequired: false,
          onSaveValue: (value) {},
          initialValue: TextFormatter.toShortDate(
            dateTime: item.dateCreated ?? DateTime.now().toUtc(),
            format: 'yyyy/MM/dd',
          ),
        ),
      ],
    );
  }
}
