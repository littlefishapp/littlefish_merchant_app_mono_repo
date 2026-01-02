// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/products/product_modifier.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/product/product_actions.dart';
import 'package:littlefish_merchant/ui/products/modifiers/pages/product_modifier_page.dart';
import 'package:littlefish_merchant/ui/products/modifiers/view_models/modifier_collection_vm.dart';
import 'package:littlefish_merchant/common/presentaion/components/filter_add_bar.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/auto_complete_text_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/common/presentaion/components/decorated_text.dart';
import 'package:littlefish_merchant/common/presentaion/components/long_text.dart';
import 'package:littlefish_merchant/common/presentaion/components/list_leading_tile.dart';
import 'package:littlefish_merchant/common/presentaion/components/new_list_tile.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';

class ProductModifiersPage extends StatefulWidget {
  static const String route = 'products/modifiers';

  const ProductModifiersPage({Key? key}) : super(key: key);

  @override
  State<ProductModifiersPage> createState() => _ProductModifiersPageState();
}

class _ProductModifiersPageState extends State<ProductModifiersPage> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ModifiersViewModel>(
      converter: (Store store) {
        return ModifiersViewModel.fromStore(store as Store<AppState>);
      },
      builder: (BuildContext ctx, ModifiersViewModel vm) => AppScaffold(
        enableProfileAction:
            !(EnvironmentProvider.instance.isLargeDisplay ?? false),
        title: 'Modifiers',
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              vm.selectedItem = null;
              vm.onRefresh();
            },
          ),
        ],
        body: vm.isLoading!
            ? const AppProgressIndicator()
            : EnvironmentProvider.instance.isLargeDisplay!
            ? tabletLayout(context, vm)
            : mobileLayout(context, vm),
      ),
    );
  }

  Widget tabletLayout(context, ModifiersViewModel value) => value.isLoading!
      ? const AppProgressIndicator()
      : Row(
          children: <Widget>[
            Expanded(child: modifierList(context, value)),
            const VerticalDivider(width: 0.5),
            Expanded(
              child: value.selectedItem == null || value.isNew!
                  ? const Center(
                      child: DecoratedText(
                        'Select Modifier',
                        alignment: Alignment.center,
                        fontSize: 24,
                      ),
                    )
                  : ProductModifierPage(
                      isEmbedded: true,
                      parentContext: context,
                    ),
            ),
          ],
        );

  StatelessWidget mobileLayout(context, ModifiersViewModel value) =>
      value.isLoading!
      ? const AppProgressIndicator()
      : Container(child: modifierList(context, value));

  GlobalKey<AutoCompleteTextFieldState<ProductModifier>>? filterKey;

  Column modifierList(context, ModifiersViewModel value) => Column(
    children: <Widget>[
      FilterAddBar(
        filterKey: filterKey,
        itemSorter: (dynamic a, dynamic b) {
          return a.displayName
              .substring(0, 1)
              .toLowerCase()
              .compareTo(b.displayName.substring(0, 1).toLowerCase());
        },
        suggestions: value.items,
        itemBuilder: (BuildContext context, ProductModifier suggestion) =>
            modifierTile(context, suggestion, value),
        itemFilter: (dynamic suggestion, query) => (suggestion.displayName)
            .toLowerCase()
            .contains(query.toLowerCase()),
        itemSubmitted: (ProductModifier data) {},
      ),
      Expanded(
        child: ListView.separated(
          physics: const BouncingScrollPhysics(),
          separatorBuilder: (BuildContext context, int index) =>
              const CommonDivider(),
          itemBuilder: (BuildContext context, int index) => index == 0
              ? NewItemTile(
                  title: 'New Modifier',
                  onTap: () => value.store!.dispatch(createModifier(context)),
                )
              : modifierTile(context, value.items![index - 1], value),
          itemCount: (value.items?.length ?? 0) + 1,
        ),
      ),
    ],
  );

  ListTile modifierTile(context, ProductModifier item, ModifiersViewModel vm) =>
      ListTile(
        tileColor: Theme.of(context).colorScheme.background,
        dense: !EnvironmentProvider.instance.isLargeDisplay!,
        leading: ListLeadingTextTile(text: '${item.modifiers?.length ?? 0}'),
        subtitle: LongText('Required Selection : ${item.maxSelection}'),
        title: Text('${item.displayName}'),
        selected: vm.selectedItem == item,
        onTap: () {
          vm.store!.dispatch(editModifer(context, item));
        },
      );
}
