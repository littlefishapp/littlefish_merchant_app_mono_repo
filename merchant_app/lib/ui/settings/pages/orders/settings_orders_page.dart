// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/services/modal_service.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_text.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/settings/orders/order_setting.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/models/shared/form_view_model.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/app_settings/app_settings_actions.dart';
import 'package:littlefish_merchant/ui/settings/view_models/view_models.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/string_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/yes_no_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';

class SettingsOrdersPage extends StatefulWidget {
  static const String route = '/setting-orders';

  const SettingsOrdersPage({Key? key}) : super(key: key);

  @override
  State<SettingsOrdersPage> createState() => _SettingsOrdersPageState();
}

class _SettingsOrdersPageState extends State<SettingsOrdersPage> {
  GlobalKey<FormState> formkey = GlobalKey();

  SettingsOrderViewModel? _vm;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SettingsOrderViewModel?>(
      onInit: (store) => store.dispatch(getOrderSetttings(refresh: false)),
      converter: (Store<AppState> store) {
        _vm = SettingsOrderViewModel.fromStore(
          store,
          form: _vm?.form ?? FormManager(formkey),
        );

        return _vm;
      },
      builder: (BuildContext context, SettingsOrderViewModel? vm) =>
          AppSimpleAppScaffold(
            title: 'Ticket Settings',
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => vm!.onRefresh(),
              ),
            ],
            body: Container(
              child: vm!.isLoading!
                  ? const AppProgressIndicator()
                  : form(context, vm),
            ),
          ),
    );
  }

  Form form(context, SettingsOrderViewModel vm) => Form(
    key: vm.form!.key,
    child: Column(
      children: <Widget>[
        SizedBox(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: YesNoFormField(
              labelText: 'Enabled',
              initialValue: vm.item!.enabled ?? false,
              onSaved: (value) {
                setState(() {
                  vm.item!.enabled = value;
                });
              },
            ),
          ),
        ),
        const CommonDivider(height: 0.5),
        SizedBox(
          child: Row(
            children: <Widget>[
              ButtonText(
                icon: Icons.add,
                text: 'Add Item',
                expand: true,
                layoutVertically: true,
                onTap: (_) {
                  vm.addItem(OrderSettingItem.create(''));
                },
              ),
            ],
          ),
        ),
        const CommonDivider(height: 0.5),
        Expanded(child: itemList(context, vm)),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: saveButton(context, vm),
        ),
      ],
    ),
  );

  ListView itemList(context, SettingsOrderViewModel vm) => ListView.builder(
    itemBuilder: (BuildContext context, int index) {
      var v = vm.item!.items![index];

      return Slidable(
        endActionPane: ActionPane(
          extentRatio: .25,
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (ctx) async {
                var result = await confirmDelete(context);

                if (result == true) {
                  vm.removeItem(v);
                }
              },
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        key: Key(v.id!),
        // actionPane: SlidableDrawerActionPane(),
        // actionExtentRatio: 0.25,
        // secondaryActions: [
        //   IconSlideAction(
        //     color: Colors.red,
        //     icon: Icons.delete,
        //     onTap: () async {
        //       var result = await confirmDelete(context);

        //       if (result == true) {
        //         vm.removeItem(v);
        //       }
        //     },
        //   ),
        // ],
        child: ListTile(
          tileColor: Theme.of(context).colorScheme.background,
          title: StringFormField(
            hintText: 'i.e. Table Number 3',
            key: Key(v.id!),
            focusNode: vm.form!.setFocusNode(v.id),
            nextFocusNode: FocusNode(),
            initialValue: v.name,
            labelText: 'Name',
            isRequired: true,
            onSaveValue: (value) {
              setState(() {
                vm.item!.items![index].name = value;
              });
            },
            onFieldSubmitted: (value) {
              setState(() {
                vm.item!.items![index].name = value;
              });
            },
          ),
        ),
      );
    },
    itemCount: vm.item?.items?.length,
  );

  Future<bool?> confirmDelete(BuildContext context) async {
    return await getIt<ModalService>().showActionModal(
      context: context,
      title: 'Delete Item?',
      description: 'Are you sure you want to delete this item?',
    );
  }

  ButtonPrimary saveButton(context, SettingsOrderViewModel vm) => ButtonPrimary(
    buttonColor: Theme.of(context).colorScheme.primary,
    text: 'save',
    onTap: (context) {
      try {
        if (vm.form!.key!.currentState!.validate()) {
          vm.form!.key!.currentState!.save();
          vm.onAdd(vm.item, context);
          Navigator.of(context).pop();
        }
      } catch (e) {
        showMessageDialog(context, e.toString(), LittleFishIcons.error);
      }
    },
  );
}
