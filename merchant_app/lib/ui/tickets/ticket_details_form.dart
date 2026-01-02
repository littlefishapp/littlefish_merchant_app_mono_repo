// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';

// Project imports:
import 'package:littlefish_merchant/models/customers/customer.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_cart_item.dart';
import 'package:littlefish_merchant/models/sales/tickets/ticket.dart';
import 'package:littlefish_merchant/models/shared/form_view_model.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/ui/customers/pages/customer_select_page.dart';
import 'package:littlefish_merchant/ui/products/products/pages/product_quantity_adjustment_page.dart';
import 'package:littlefish_merchant/ui/products/products/widgets/products_list.dart';
import 'package:littlefish_merchant/common/presentaion/components/filter_add_bar.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/auto_complete_text_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/string_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/common/presentaion/components/text_tag.dart';
import 'package:littlefish_merchant/common/presentaion/components/list_leading_tile.dart';
import 'package:littlefish_merchant/common/presentaion/components/new_list_tile.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/ui/tickets/view_models/ticket_item_vm.dart';

import '../../common/presentaion/components/buttons/button_primary.dart';

class TicketDetailsForm extends StatefulWidget {
  final Ticket? item;
  final bool isEmbedded;
  final BuildContext? parentContext;
  final List<CheckoutCartItem>? cartItems;

  const TicketDetailsForm({
    Key? key,
    this.item,
    this.cartItems,
    this.isEmbedded = true,
    this.parentContext,
  }) : super(key: key);

  @override
  State<TicketDetailsForm> createState() => _TicketDetailsFormState();
}

class _TicketDetailsFormState extends State<TicketDetailsForm> {
  Ticket? item;
  GlobalKey<FormState>? detailsKey;
  GlobalKey<AutoCompleteTextFieldState<CheckoutCartItem>>? filterKey;

  @override
  void initState() {
    detailsKey = GlobalKey();
    filterKey = GlobalKey();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, TicketItemVM>(
      converter: (store) =>
          TicketItemVM.fromStore(store)..form = FormManager(detailsKey),
      builder: (ctx, TicketItemVM vm) {
        if (widget.item != null) vm.item = widget.item;
        return AppSimpleAppScaffold(
          isEmbedded: widget.isEmbedded,
          resizeToAvoidBottomPadding: true,
          title: 'Park Sale',
          footerActions: <Widget>[
            ButtonPrimary(
              text: 'Save',
              upperCase: false,
              onTap: (context) {
                if (widget.cartItems != null && widget.cartItems!.isNotEmpty) {
                  vm.item!.items = widget.cartItems;
                }

                vm.onAdd(vm.item, context);
              },
            ),
          ],
          body: Container(
            padding: widget.isEmbedded
                ? const EdgeInsets.symmetric(horizontal: 8)
                : null,
            child: Column(
              children: <Widget>[
                const CommonDivider(),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: vm.isLoading!
                        ? const AppProgressIndicator()
                        : form(context, vm),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  ListTile customerCard(BuildContext context, TicketItemVM vm) => ListTile(
    tileColor: Theme.of(context).extension<AppliedSurface>()?.primary,
    contentPadding: const EdgeInsets.symmetric(),
    onTap: () {
      selectCustomer(context, vm);
    },
    trailing: const Icon(Icons.search),
    title: Text(
      (vm.item?.customerId == null
          ? 'Select Customer'
          : vm.item?.customerName!)!,
    ),
    subtitle: null,
  );

  selectCustomer(BuildContext context, TicketItemVM vm) async {
    if (EnvironmentProvider.instance.isLargeDisplay!) {
      await showPopupDialog(
        context: context,
        content: CustomerSelectPage(
          canAddNew: true,
          onSelected: (BuildContext context, Customer customer) {
            vm.setCustomer(customer);
          },
          isDialog: true,
        ),
      );
    } else {
      showPopupDialog(
        context: context,
        content: CustomerSelectPage(
          onSelected: (BuildContext ctx, Customer customer) {
            vm.setCustomer(customer);
          },
        ),
      ).then((r) {
        if (mounted) setState(() {});
      });
    }
  }

  Form form(context, TicketItemVM vm) {
    return Form(
      key: vm.form!.key,
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          const SizedBox(height: 24),
          StringFormField(
            useOutlineStyling: true,
            enabled: true,
            isRequired: true,
            suffixIcon: Icons.person,
            maxLength: 32,
            hintText: 'Reference',
            key: const Key('reference'),
            labelText: 'Reference',
            onSaveValue: (value) {
              vm.item!.reference = value;
              vm.item!.name = value;
              vm.item!.displayName = value;
            },
            onFieldSubmitted: (value) {
              vm.item!.reference = value;
              vm.item!.name = value;
              vm.item!.displayName = value;
            },
            initialValue: vm.item?.reference,
          ),
          const SizedBox(height: 16),
          StringFormField(
            useOutlineStyling: true,
            enabled: true,
            isRequired: false,
            maxLines: 5,
            suffixIcon: Icons.note,
            hintText: 'Notes',
            key: const Key('notes'),
            labelText: 'Notes',
            onSaveValue: (value) {
              vm.item!.notes = value;
            },
            onFieldSubmitted: (value) {
              vm.item!.notes = value;
            },
            initialValue: vm.item?.notes,
          ),
        ],
      ),
    );
  }

  Future<void> addItem(context, StockProduct product, TicketItemVM vm) async {
    await showPopupDialog(
      defaultPadding: false,
      context: context,
      content: ProductQuantityAdjustmentPage(
        productId: product.id,
        imageUri: product.imageUri,
        displayName: product.displayName ?? '',
        unitType: product.unitType,
        initialValue: product.quantity,
        category: vm.store!.state.productState
            .getCategory(categoryId: product.categoryId)
            ?.displayName,
        callback: (diff, reason) {
          if (diff >= 0) {
            vm.addCartItem(product, product.regularVariance, diff, context);
            Navigator.pop(context);
          }
        },
      ),
    );
  }

  FilterAddBar<CheckoutCartItem> filterHeader(
    context,
    TicketItemVM vm,
  ) => FilterAddBar(
    // onAdd: EnvironmentProvider.instance.isLargeDisplay
    //     ? null
    //     : ((vm.item.isNew ?? false) ? () => searchItem(context, vm) : null),
    filterKey: filterKey,
    itemSorter: (dynamic a, dynamic b) {
      return a.displayName
          .substring(0, 1)
          .toLowerCase()
          .compareTo(b.displayName.substring(0, 1).toLowerCase());
    },
    suggestions: vm.item!.items,
    itemBuilder: (BuildContext context, CheckoutCartItem suggestion) =>
        ticketItemTile(context, suggestion, vm),
    itemSubmitted: (CheckoutCartItem data) {
      if ((vm.item!.isNew ?? false)) {
        editItem(context, data, vm);
      }
    },
    itemFilter: (CheckoutCartItem suggestion, query) =>
        (suggestion.description!.toLowerCase().startsWith(query.toLowerCase())),
  );

  ListView itemList(context, TicketItemVM vm) => ListView.separated(
    shrinkWrap: true,
    physics: const BouncingScrollPhysics(),
    itemCount: (vm.item!.isNew ?? false)
        ? (vm.item!.items!.length) + 1
        : vm.item!.items!.length,
    itemBuilder: (BuildContext ctx, int index) => (vm.item!.isNew ?? false)
        ? index == 0
              ? NewItemTile(
                  title: 'Add Item',
                  onTap: () {
                    showPopupDialog(
                      context: context,
                      content: ProductsList(
                        onTap: (item) {
                          addItem(context, item, vm);
                        },
                        canAddNew: false,
                      ),
                    );
                  },
                )
              : (vm.item!.isNew ?? false)
              ? dismissableItem(context, vm.item!.items![index - 1], vm)
              : ticketItemTile(context, vm.item!.items![index], vm)
        : (vm.item!.isNew ?? false)
        ? dismissableItem(context, vm.item!.items![index], vm)
        : ticketItemTile(context, vm.item!.items![index], vm),
    separatorBuilder: (BuildContext context, int index) =>
        const CommonDivider(),
  );

  Slidable dismissableItem(context, CheckoutCartItem item, TicketItemVM vm) =>
      Slidable(
        key: Key(item.varianceId ?? item.productId!),
        endActionPane: ActionPane(
          extentRatio: .25,
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (ctx) async {
                var result = await confirmDismissal(context, item);

                if (result == true) {
                  vm.removeItem(item);
                }
              },
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: ticketItemTile(context, item, vm),
      );

  ListTile ticketItemTile(
    context,
    CheckoutCartItem item,
    TicketItemVM vm,
  ) => ListTile(
    tileColor: Theme.of(context).extension<AppliedSurface>()?.primary,
    dense: !EnvironmentProvider.instance.isLargeDisplay!,
    title: Text('${item.description}'),
    leading: ListLeadingTextTile(text: '${item.quantity}'),
    trailing: TextTag(
      displayText: TextFormatter.toStringCurrency(item.value, currencyCode: ''),
    ),
    onTap: (vm.item!.isNew ?? false) ? () => editItem(context, item, vm) : null,
  );

  Future<void> editItem(context, CheckoutCartItem item, TicketItemVM vm) async {
    var product = vm.stockProducts!.firstWhereOrNull(
      (x) => x.id == item.productId,
    );
    if (product != null) {
      await showPopupDialog(
        context: context,
        content: ProductQuantityAdjustmentPage(
          productId: product.id,
          imageUri: product.imageUri,
          displayName: product.displayName ?? '',
          unitType: product.unitType,
          initialValue: item.quantity.toDouble(),
          category: vm.store!.state.productState
              .getCategory(categoryId: product.categoryId)
              ?.displayName,
          callback: (diff, reason) {
            if (diff >= 0) {
              item.quantity = diff;
            }
          },
        ),
      );
    }
  }
}
