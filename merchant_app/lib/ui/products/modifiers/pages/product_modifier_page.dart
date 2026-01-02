// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/shared/form_view_model.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/products/modifiers/forms/product_modifier_form.dart';
import 'package:littlefish_merchant/ui/products/modifiers/view_models/modifier_item_vm.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';

class ProductModifierPage extends StatefulWidget {
  final bool isEmbedded;

  final BuildContext? parentContext;
  const ProductModifierPage({
    Key? key,
    this.isEmbedded = false,
    this.parentContext,
  }) : super(key: key);

  @override
  State<ProductModifierPage> createState() => _ProductModifierPageState();
}

class _ProductModifierPageState extends State<ProductModifierPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ModifierViewModel>(
      converter: (Store store) {
        return ModifierViewModel.fromStore(store as Store<AppState>)
          ..key = formKey
          ..form = FormManager(formKey);
      },
      builder: (BuildContext ctx, ModifierViewModel vm) =>
          scaffold(widget.parentContext ?? context, vm),
    );
  }

  AppSimpleAppScaffold scaffold(context, ModifierViewModel vm) =>
      AppSimpleAppScaffold(
        actions: <Widget>[
          Builder(
            builder: (ctx) => IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                vm.onAdd(vm.item, context);
              },
            ),
          ),
        ],
        isEmbedded: widget.isEmbedded,
        body: vm.isLoading!
            ? const AppProgressIndicator()
            : layout(context, vm),
        title: vm.item!.displayName ?? 'New Modifier',
      );

  Container layout(context, ModifierViewModel vm) => Container(
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
    child: vm.isLoading!
        ? const AppProgressIndicator()
        : ProductModifierForm(vm: vm),
  );
}
