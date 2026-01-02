// Flutter imports:
// remove ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/services/modal_service.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:uuid/uuid.dart';

// Project imports:
import 'package:littlefish_merchant/ui/online_store/tools.dart';
import 'package:littlefish_merchant/ui/online_store/viewmodels/manage_store_vm.dart';

import '../../../../common/presentaion/components/cards/card_neutral.dart';
import '../../../../common/presentaion/components/custom_app_bar.dart';
import '../../../../common/presentaion/components/icons/delete_icon.dart';
import '../../../../features/ecommerce_shared/models/checkout/checkout_order.dart';
import '../../../../features/ecommerce_shared/models/shared/form_view_model.dart';
import '../../../../common/presentaion/components/dialogs/common_dialogs.dart';
import '../../../../common/presentaion/components/form_fields/string_form_field.dart';
import '../../../../common/presentaion/components/long_text.dart';
import '../../../../common/presentaion/components/app_progress_indicator.dart';

class OrderStatusScreen extends StatefulWidget {
  final ManageStoreVM vm;
  final OrderStatus? item;
  final bool isNew;
  const OrderStatusScreen({
    Key? key,
    required this.vm,
    this.item,
    this.isNew = true,
  }) : super(key: key);

  @override
  State<OrderStatusScreen> createState() => _OrderStatusScreenState();
}

class _OrderStatusScreenState extends State<OrderStatusScreen> {
  late ManageStoreVM _vm;

  final expandedMargin = const EdgeInsets.only(
    top: 4,
    bottom: 4,
    left: 16,
    right: 12,
  );

  final formKey = GlobalKey<FormState>();
  OrderStatus? item;

  @override
  void initState() {
    _vm = widget.vm;
    if (item == null) {
      if (widget.item != null) {
        item = widget.item;
      } else {
        item = OrderStatus(
          color: _vm.item!.storePreferences!.theme!.primaryColor,
          deleted: false,
          enabled: true,
          businessId: _vm.item!.businessId,
          id: const Uuid().v4(),
          isSystemStatus: false,
        );
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (widget.isNew == false)
            IconButton(
              icon: const DeleteIcon(),
              onPressed: () async {
                var result = await getIt<ModalService>().showActionModal(
                  context: context,
                  title: 'Delete Status',
                  description: 'Are you sure you want to delete this status?',
                  acceptText: 'Delete',
                  cancelText: 'Cancel',
                );

                if (result == true) _vm.deleteStatus(context, item);
              },
            ),
        ],
        title: null,
      ),
      persistentFooterButtons: <Widget>[
        ButtonBar(
          buttonHeight: 48,
          buttonMinWidth: MediaQuery.of(context).size.width * 0.95,
          children: <Widget>[
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () async {
                if (formKey.currentState?.validate() ?? false) {
                  formKey.currentState!.save();
                  if (mounted) {
                    setState(() {
                      _vm.isLoading = true;
                    });
                  } else {
                    setState(() {
                      _vm.isLoading = true;
                    });
                  }

                  _vm.upsertStatus(context, item);
                }
              },
            ),
          ],
        ),
      ],
      body: SafeArea(
        child: _vm.isLoading!
            ? const AppProgressIndicator()
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: <Widget>[Container(child: form(context))],
                ),
              ),
      ),
    );
  }

  Form form(context) {
    final BasicFormModel formModel = BasicFormModel(formKey);

    var formFields = <Widget>[
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: const Text('Order Status', style: TextStyle(fontSize: 24)),
          ),
          CardNeutral(
            child: ListTile(
              tileColor: Theme.of(context).colorScheme.background,
              title: const Text('Status Color'),
              subtitle: const LongText('A color to help identify this status'),
              trailing: CircleAvatar(
                backgroundColor: HexColor(item!.color!),
                child: const Icon(Icons.timer),
              ),
              onTap: () {
                showPopupDialog(
                  height: 400,
                  context: context,
                  content: BlockPicker(
                    pickerColor: HexColor(item!.color!),
                    onColorChanged: (color) {
                      setState(() {
                        item!.color = color.value.toRadixString(16);
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                );
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: StringFormField(
                    hintText: 'Ready for Collection',
                    key: const Key('name'),
                    labelText: 'Name',
                    focusNode: formModel.setFocusNode('name'),
                    initialValue: item!.displayName,
                    onFieldSubmitted: (value) {
                      item!.displayName = value;
                    },
                    inputAction: TextInputAction.next,
                    isRequired: true,
                    onSaveValue: (value) {
                      item!.displayName = value;
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: StringFormField(
                    hintText: 'Currently in packing',
                    key: const Key('description'),
                    labelText: 'Description',
                    focusNode: formModel.setFocusNode('description'),
                    initialValue: item!.description,
                    onFieldSubmitted: (value) {
                      item!.description = value;
                    },
                    inputAction: TextInputAction.next,
                    isRequired: false,
                    onSaveValue: (value) {
                      item!.description = value;
                    },
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    ];

    return Form(
      key: formModel.formKey,
      child: MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: formFields,
        ),
      ),
    );
  }
}
