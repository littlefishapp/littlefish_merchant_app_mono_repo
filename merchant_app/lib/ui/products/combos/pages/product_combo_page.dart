// removed ignore: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:littlefish_merchant/models/shared/form_view_model.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/products/combos/forms/product_combo_form.dart';
import 'package:littlefish_merchant/ui/products/combos/view_models/combo_item_vm.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';

import '../../../../common/presentaion/pages/scaffolds/app_scaffold.dart';

class ProductComboPage extends StatefulWidget {
  final bool isEmbedded;

  final Function? onRemoved;

  final BuildContext? parentContext;

  const ProductComboPage({
    Key? key,
    this.isEmbedded = false,
    this.onRemoved,
    this.parentContext,
  }) : super(key: key);

  @override
  State<ProductComboPage> createState() => _ProductComboPageState();
}

class _ProductComboPageState extends State<ProductComboPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ComboViewModel>(
      converter: (Store store) =>
          ComboViewModel.fromStore(store as Store<AppState>)
            ..key = formKey
            ..form = FormManager(formKey),
      builder: (BuildContext ctx, ComboViewModel vm) =>
          scaffold(widget.parentContext ?? context, vm),
    );
  }

  Widget scaffold(context, ComboViewModel vm) {
    return AppScaffold(
      displayBackNavigation: true,
      actions: <Widget>[
        Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              vm.onAdd(vm.item, context);
              Navigator.of(context).pop();
            },
          ),
        ),
      ],
      body: layout(context, vm),
      title: vm.item?.displayName ?? 'New Combo',
    );
  }

  Container layout(context, ComboViewModel vm) => Container(
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
    child: vm.isLoading!
        ? const AppProgressIndicator()
        : ProductComboForm(vm: vm),
  );
}
